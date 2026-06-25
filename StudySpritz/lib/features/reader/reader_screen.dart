import 'package:flutter/material.dart';

import '../../core/reading_engine/reader_engine.dart';
import '../../core/parsers/parser_factory.dart';
import '../../repositories/book_repository.dart';
import '../../repositories/statistics_repository.dart'; 
import '../../core/state/settings_state.dart';

import '../../models/app_settings.dart';
import '../../models/bookmark.dart';
import '../../repositories/bookmark_repository.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import 'package:provider/provider.dart';

class ReaderScreen extends StatefulWidget {
  final dynamic extra;

  const ReaderScreen({
    super.key,
    required this.extra,
  });

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  ReaderEngine? engine;
  bool loading = true;

  DateTime? sessionStartedAt;

  int startWordIndex = 0;
  int startPageIndex = 0;

  late AppSettings settings;

  String get bookId =>
      widget.extra["bookId"] as String;


  @override
  void initState() {
    super.initState();
    _loadBook();
  }

  Future<void> _loadBook() async {
    final repo = BookRepository();

    final startWord = widget.extra["wordIndex"] as int?;
    final startPage = widget.extra["pageIndex"] as int?;

    final book = await repo.getBook(bookId);

    if (book == null) {
      setState(() => loading = false);
      return;
    }

    await repo.markAsOpened(book.bookId);
    
    final file = File(book.filePath);

    if (!await file.exists()) {
      if (!mounted) return;

      await showDialog(
        context: context,
        builder: (_) {
          return const AlertDialog(
            title: Text("File Not Found"),
            content: Text(
              "The original file cannot be found on this device.",
            ),
          );
        },
      );

      if (!mounted) return;

      Navigator.pop(context);

      return;
    }

    final parser = ParserFactory.getParser(book.filePath);
    final text = await parser.extract(book.filePath);

    final words = text.split(RegExp(r'\s+'));

    settings = context.read<SettingsState>().settings ?? AppSettings.defaults();


    engine = ReaderEngine(
      words: words,
      wordsPerPage: 200,
      wpm: settings.wpmSpeed, // SADECE RENDER SPEED
    );

    if (startWord != null) {
      engine!.jumpTo(startWord);
    } else {
      engine!.jumpTo(book.wordIndex);
    }

  startWordIndex = engine!.state.wordIndex;
  startPageIndex = engine!.state.pageIndex;

  sessionStartedAt = DateTime.now();

    setState(() => loading = false);
  }

  Future<void> _sync() async {
    if (engine == null) return;

    final repo = BookRepository();

    final currentWord = engine!.state.wordIndex;

    final isFinished =
        engine!.state.wordIndex >= engine!.words.length - 1;

    await repo.saveReadingSession(
      bookId: bookId,
      wordIndex: currentWord,
      pageIndex: engine!.state.pageIndex,
    );

    if (isFinished) {
      final book = await repo.getBook(bookId);
      if (book != null && !book.isCompleted) {
        await repo.updateBook(
          book.copyWith(
            isCompleted: true,
            completedAt: DateTime.now(),
          )
        );
      }
    }
  }

  Future<void> _next() async {
    if (engine == null) return;

    setState(() {
      engine!.jumpTo(
        engine!.state.wordIndex + engine!.wordsPerPage,
      );
    });

    await Future.delayed(
      Duration(milliseconds: 250 ~/ settings.animationSpeed,)
    );

    await _sync();
  }

  Future<void> _prev() async {
    if (engine == null) return;


    setState(() {
      engine!.jumpTo(
        engine!.state.wordIndex - engine!.wordsPerPage,
      );
    });

    await Future.delayed(
      Duration(milliseconds: 250 ~/ settings.animationSpeed,)
    );

    await _sync();
  }

  Future<void> _addBookmark() async {
    if (engine == null) return;

    final noteController = TextEditingController();

    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Bookmark"),
          content: TextField(
            controller: noteController,
            decoration: const InputDecoration(
              hintText: "Optional note...",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, noteController.text);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );

    if (result == null) return;

    final repo = BookmarkRepository();

    final bookmark = Bookmark(
      markId: const Uuid().v4(),
      bookId: bookId,
      pageNumber: engine!.state.pageIndex,
      wordIndex: engine!.state.wordIndex,
      markNote: result,
      createdAt: DateTime.now(),
    );

    await repo.addBookmark(bookmark);
  }

  Future<void> _saveStatistics() async {
    if (engine == null) return;
    if (sessionStartedAt == null) return;

    final durationSeconds =
        DateTime.now()
            .difference(sessionStartedAt!)
            .inSeconds;

    final wordsRead =
        (engine!.state.wordIndex -
                startWordIndex)
            .abs();

    final pagesRead =
        (engine!.state.pageIndex -
                startPageIndex)
            .abs();

    if (durationSeconds < 10) return;

    final repository =
        StatisticsRepository();

    await repository.updateSession(
      bookId: bookId,
      sessionDurationSeconds: durationSeconds,
      wordsRead: wordsRead < 0 ? 0 : wordsRead,
      pagesRead: pagesRead < 0 ? 0 : pagesRead,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _sync();
      await _saveStatistics();
    });

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (engine == null) {
      return const Scaffold(
        body: Center(child: Text("Book not found")),
      );
    }

    final progress =
        engine!.state.wordIndex / engine!.words.length;

    return WillPopScope(
      onWillPop: () async {
        await _sync();
        await _saveStatistics();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Reader"),
          actions: [
            IconButton(
              icon: const Icon(Icons.bookmark_add),
              onPressed: _addBookmark,
            ),
          ],
        ),
        body: Column(
          children: [
            LinearProgressIndicator(value: progress),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Text(
                    engine!.currentPageText,
                    style: TextStyle(
                      fontSize: settings.fontSize.toDouble(),
                      height: 1.7,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _prev,
                    child: const Text("Prev"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final repo = BookRepository();
                      final book = await repo.getBook(bookId);

                      if (book != null) {
                        await repo.updateBook(
                        book.copyWith(
                          isCompleted: true,
                          completedAt: DateTime.now(),
                        )
                        );
                      }
                    },
                    child: const Text("Done"),
                  ),
                  ElevatedButton(
                    onPressed: _next,
                    child: const Text("Next"),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}