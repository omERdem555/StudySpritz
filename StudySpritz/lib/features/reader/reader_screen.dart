import 'package:flutter/material.dart';

import '../../core/reading_engine/reader_engine.dart';
import '../../core/parsers/parser_factory.dart';
import '../../repositories/book_repository.dart';

import '../../models/bookmark.dart';
import '../../repositories/bookmark_repository.dart';
import 'package:uuid/uuid.dart';

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

  String get bookId => widget.extra["bookId"] as String;

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

    final parser = ParserFactory.getParser(book.filePath);
    final text = await parser.extract(book.filePath);

    final words = text.split(RegExp(r'\s+'));

    engine = ReaderEngine(
      words: words,
      wordsPerPage: 200,
    );

    if (startWord != null) {
      engine!.jumpTo(startWord);
    } else {
      engine!.jumpTo(book.wordIndex);
    }

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
          book.copyWith(isCompleted: true),
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

    await _sync();
  }

  Future<void> _prev() async {
    if (engine == null) return;

    setState(() {
      engine!.jumpTo(
        engine!.state.wordIndex - engine!.wordsPerPage,
      );
    });

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

  @override
  void dispose() {
    _sync();
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

    return Scaffold(
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
                  style: const TextStyle(
                    fontSize: 18,
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
                        book.copyWith(isCompleted: true),
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
    );
  }
}