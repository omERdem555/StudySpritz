import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb; 
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'dart:io' as io; 
import 'dart:typed_data'; 

import '../settings/settings_screen.dart';
import 'reader_fast_screen.dart';
import '../../../core/reading_engine/reader_engine.dart';
import '../../../core/parsers/parser_factory.dart';
import '../../../repositories/book_repository.dart';
import '../../../repositories/statistics_repository.dart'; 
import '../../../core/state/settings_state.dart';
import '../../../models/app_settings.dart';
import '../../../models/bookmark.dart';
import '../../../models/book.dart';
import '../../../repositories/bookmark_repository.dart';
import '../../../core/reading_engine/pagination_engine.dart'; // PaginationEngine import edildi

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
  Book? loadedBook;
  bool loading = true;
  DateTime? sessionStartedAt;

  int startWordIndex = 0;
  int startPageIndex = 0;
  late AppSettings settings;

  String get bookId => widget.extra["bookId"] as String;

  @override
  void initState() {
    super.initState();
    _loadBook();
  }

  Future<void> _loadBook() async {
    final repo = BookRepository();
    final startWord = widget.extra["wordIndex"] as int?;

    final book = await repo.getBook(bookId);
    if (book == null) {
      setState(() => loading = false);
      return;
    }

    await repo.markAsOpened(book.bookId);
    
    Uint8List? bookBytes;
    
    if (!kIsWeb) {
      final file = io.File(book.filePath);
      if (!await file.exists()) {
        if (!mounted) return;
        await _showFileNotFoundDialog();
        if (mounted) Navigator.pop(context);
        return;
      }
    } else {
      bookBytes = await repo.getBookBytes(book.bookId);
    }

    final parser = ParserFactory.getParser(book.filePath);
    final text = await parser.extract(
      path: book.filePath,
      bytes: bookBytes,
    );

    final words = text.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    settings = context.read<SettingsState>().settings ?? AppSettings.defaults();

    engine = ReaderEngine(
      words: words,
      fontSize: settings.fontSize,
      initialWordIndex: startWord ?? book.wordIndex,
    );

    loadedBook = book;
    startWordIndex = engine!.state.wordIndex;
    startPageIndex = engine!.state.pageIndex;
    sessionStartedAt = DateTime.now();

    setState(() => loading = false);
  }

  Future<void> _showFileNotFoundDialog() {
    return showDialog(
      context: context,
      builder: (_) => const AlertDialog(
        title: Text("Dosya Bulunamadı"),
        content: Text("Orijinal kitap dosyası bu cihazda mevcut değil."),
      ),
    );
  }

  Future<void> _sync() async {
    if (engine == null) return;
    final repo = BookRepository();
    final currentWord = engine!.state.wordIndex;
    final isFinished = currentWord >= engine!.words.length - 1;

    await repo.saveReadingSession(
      bookId: bookId,
      wordIndex: currentWord,
      pageIndex: engine!.state.pageIndex,
    );

    if (isFinished && loadedBook != null) {
      if (!loadedBook!.isCompleted) {
        await repo.updateBook(
          loadedBook!.copyWith(
            isCompleted: true,
            completedAt: DateTime.now(),
          )
        );
      }
    }
  }

  void _next() {
    if (engine == null) return;
    setState(() {
      engine!.nextPage();
    });
    _sync();
  }

  void _prev() {
    if (engine == null) return;
    setState(() {
      engine!.previousPage();
    });
    _sync();
  }

  Future<void> _addBookmark() async {
    if (engine == null) return;
    final noteController = TextEditingController();

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Yer İmi Ekle"),
        content: TextField(
          controller: noteController,
          decoration: const InputDecoration(hintText: "İsteğe bağlı not..."),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("İptal")),
          TextButton(
            onPressed: () => Navigator.pop(context, noteController.text),
            child: const Text("Kaydet"),
          ),
        ],
      ),
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
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Yer imi kaydedildi")));
  }

  Future<void> _saveStatistics() async {
    if (engine == null || sessionStartedAt == null) return;

    final durationSeconds = DateTime.now().difference(sessionStartedAt!).inSeconds;
    final wordsRead = (engine!.state.wordIndex - startWordIndex).abs();
    final pagesRead = (engine!.state.pageIndex - startPageIndex).abs();

    if (durationSeconds < 5) return;

    final repository = StatisticsRepository();
    await repository.updateSession(
      bookId: bookId,
      sessionDurationSeconds: durationSeconds,
      wordsRead: wordsRead,
      pagesRead: pagesRead,
    );
  }

  Future<void> _navigateToFastReader() async {
    if (loadedBook == null || engine == null) return;
    
    await _sync();

    if (!mounted) return;
    final updatedWordIndex = await Navigator.push<int>(
      context,
      MaterialPageRoute(
        builder: (_) => ReaderFastScreen(
          book: loadedBook!,
          words: engine!.words,
          initialWordIndex: engine!.state.wordIndex,
        ),
      ),
    );

    if (updatedWordIndex != null && mounted) {
      setState(() {
        engine!.jumpToWord(updatedWordIndex);
      });
      _sync(); 
    }
  }

  @override
  void dispose() {
    _sync();
    _saveStatistics();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (engine == null) {
      return const Scaffold(body: Center(child: Text("Kitap yüklenemedi.")));
    }

    final currentSettings = context.watch<SettingsState>().settings ?? AppSettings.defaults();
    if (currentSettings.fontSize != engine!.fontSize) {
      final lastWord = engine!.state.wordIndex;
      engine = ReaderEngine(
        words: engine!.words,
        fontSize: currentSettings.fontSize,
        initialWordIndex: lastWord,
      );
    }

    // Sayfanın ilk kelimesinin global kelime indeksini hesaplıyoruz
    final int pageStartWordIndex = PaginationEngine.getFirstWordIndexForPage(
      engine!.state.pageIndex, 
      engine!.fontSize
    );

    // Sayfa metnini kelimelerine ayırıyoruz
    final List<String> pageWords = engine!.currentPageText.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        await _sync();
        await _saveStatistics();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(loadedBook?.bookName ?? "Okuyucu"),
          actions: [
            IconButton(icon: const Icon(Icons.bookmark_add), onPressed: _addBookmark),
          ],
        ),
        body: Column(
          children: [
            LinearProgressIndicator(value: engine!.progress),
            Expanded(
              child: Padding(
                key: ValueKey(engine!.state.pageIndex),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 6.0, 
                    runSpacing: 4.0, 
                    children: List.generate(pageWords.length, (index) {
                      final int globalIndex = pageStartWordIndex + index;
                      final bool isHighlighted = globalIndex == engine!.state.wordIndex;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            engine!.jumpToWord(globalIndex);
                          });
                          _sync();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                          decoration: BoxDecoration(
                            color: isHighlighted 
                                ? Colors.amber.withOpacity(0.4) 
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            pageWords[index],
                            style: TextStyle(
                              fontSize: currentSettings.fontSize.toDouble(),
                              height: 1.5,
                              letterSpacing: 0.3,
                              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                              color: isHighlighted ? Colors.amber.shade900 : null,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.flash_on, size: 32, color: Colors.amber),
                      onPressed: _navigateToFastReader,
                    ),
                    ElevatedButton(
                      onPressed: _prev,
                      child: const Icon(Icons.arrow_back_ios, size: 16),
                    ),
                    Text(
                      "${engine!.state.pageIndex + 1} / ${engine!.pages.length}",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    ElevatedButton(
                      onPressed: _next,
                      child: const Icon(Icons.arrow_forward_ios, size: 16),
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings, size: 30),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SettingsScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}