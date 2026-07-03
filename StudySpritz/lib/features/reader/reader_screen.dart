import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';

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
    
    // Web platformu desteği için byte denetimi ekledik (Daha önce çöküyordu)
    if (book.bytes == null || book.bytes!.isEmpty) {
      final file = File(book.filePath);
      if (!await file.exists()) {
        if (!mounted) return;
        await _showFileNotFoundDialog();
        if (mounted) Navigator.pop(context);
        return;
      }
    }

    final parser = ParserFactory.getParser(book.filePath);
    final text = await parser.extract(
      path: book.filePath,
      bytes: book.bytes,
    );

    final words = text.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    settings = context.read<SettingsState>().settings ?? AppSettings.defaults();

    // Motoru yazı boyutuna duyarlı dinamik parametrelerle kuruyoruz
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

    if (durationSeconds < 5) return; // Kısa giriş çıkışları yoksay

    final repository = StatisticsRepository();
    await repository.updateSession(
      bookId: bookId,
      sessionDurationSeconds: durationSeconds,
      wordsRead: wordsRead,
      pagesRead: pagesRead,
    );
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

    // Kullanıcı ayarlardan fontu değiştirirse arayüzün dinamik olarak yeniden sayfa hesaplamasını sağlıyoruz
    final currentSettings = context.watch<SettingsState>().settings ?? AppSettings.defaults();
    if (currentSettings.fontSize != engine!.fontSize) {
      final lastWord = engine!.state.wordIndex;
      engine = ReaderEngine(
        words: engine!.words,
        fontSize: currentSettings.fontSize,
        initialWordIndex: lastWord,
      );
    }

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
                key: ValueKey(engine!.state.pageIndex), // Sayfa değiştiğinde scroll'u yukarı taşımak için unique key
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: SingleChildScrollView(
                  child: Text(
                    engine!.currentPageText,
                    style: TextStyle(
                      fontSize: currentSettings.fontSize.toDouble(),
                      height: 1.7,
                      letterSpacing: 0.3,
                    ),
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
                      onPressed: () async {
                        if (loadedBook == null) return;
                        
                        // RSVP ekranına canlı kelime indeksini vererek geçiyoruz
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

                        // RSVP'den dönen canlı kelime indeksiyle klasik okumayı anında eşle
                        if (updatedWordIndex != null && mounted) {
                          setState(() {
                            engine!.jumpToWord(updatedWordIndex);
                          });
                        }
                      },
                    ),
                    ElevatedButton.icon(
                      onPressed: _prev,
                      icon: const Icon(Icons.arrow_back_ios, size: 16),
                      label: const Text("Önceki"),
                    ),
                    Text(
                      "${engine!.state.pageIndex + 1} / ${engine!.pages.length}",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    ElevatedButton(
                      onPressed: _next,
                      child: Row(
                        children: const [
                          Text("Sonraki"),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_forward_ios, size: 16),
                        ],
                      ),
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