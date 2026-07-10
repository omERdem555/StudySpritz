import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb; 
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'dart:io' as io; 
import 'dart:typed_data'; 

import '../settings/settings_screen.dart';
import 'reader_fast_screen.dart';
import '../../../core/reading_engine/pagination_engine.dart'; // PaginationEngine import edildi
import '../../../core/reading_engine/reader_engine.dart';
import '../../../core/parsers/parser_factory.dart';
import '../../../core/state/settings_state.dart';
import '../../../repositories/book_repository.dart';
import '../../../repositories/statistics_repository.dart';
import '../../../repositories/reading_goal_repository.dart';
import '../../../models/reading_goal.dart'; 
import '../../../models/app_settings.dart';
import '../../../models/bookmark.dart';
import '../../../models/book.dart';
import '../../../repositories/bookmark_repository.dart';
import '../statistics/reading_statistics_screen.dart';

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

    final words = text
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .toList();

    settings =
        context.read<SettingsState>().settings ??
        AppSettings.defaults();

    final calculatedPageCount =
        PaginationEngine.createPages(
          words,
          settings.fontSize,
        ).length;

    if (book.wordCount != words.length ||
        book.pageCount != calculatedPageCount) {
      final updatedBook = book.copyWith(
        wordCount: words.length,
        pageCount: calculatedPageCount,
      );

      await repo.updateBook(updatedBook);
      loadedBook = updatedBook;
    } else {
      loadedBook = book;
    }

    engine = ReaderEngine(
      words: words,
      fontSize: settings.fontSize,
      initialWordIndex: startWord ?? loadedBook!.wordIndex,
    );

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
    if (engine == null || loadedBook == null) return; 
    final repo = BookRepository();
    final currentWord = engine!.state.wordIndex;
    final currentPage = engine!.state.pageIndex;
    final isFinished = currentWord >= engine!.words.length - 1;

    await repo.saveReadingSession(
      bookId: bookId,
      wordIndex: currentWord,
      pageIndex: currentPage,
    );

    final updatedBook = loadedBook!.copyWith(
      wordIndex: currentWord,
      pageNumber: currentPage,
      isCompleted: isFinished ? true : loadedBook!.isCompleted,
      completedAt: isFinished ? DateTime.now() : loadedBook!.completedAt,
    );
    
    await repo.updateBook(updatedBook);
    loadedBook = updatedBook; 
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

    final durationSeconds =
        DateTime.now().difference(sessionStartedAt!).inSeconds;

    final wordsRead =
        (engine!.state.wordIndex - startWordIndex).abs();

    final pagesRead =
        (engine!.state.pageIndex - startPageIndex).abs();

    if (durationSeconds < 5) return;

    final repository = StatisticsRepository();

    await repository.updateSession(
      bookId: bookId,
      sessionDurationSeconds: durationSeconds,
      wordsRead: wordsRead,
      pagesRead: pagesRead,
    );

    final goalRepository = ReadingGoalRepository();

    final goal = await goalRepository.getTodayGoal();

    if (goal == null) return;

    bool completedNow = false;

    switch (goal.goalType) {
      case GoalType.minutes:
        completedNow = await goalRepository.updateProgress(
          (durationSeconds / 60).floor(),
        );
        break;

      case GoalType.pages:
        completedNow = await goalRepository.updateProgress(
          pagesRead,
        );
        break;

      case GoalType.words:
        completedNow = await goalRepository.updateProgress(
          wordsRead,
        );
        break;
    }

    if (!mounted || !completedNow) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
        content: Row(
          children: [
            Icon(
              Icons.celebration,
              color: Colors.white,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                "🎉 Tebrikler! Bugünkü okuma hedefini tamamladın.",
              ),
            ),
          ],
        ),
      ),
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

    final int pageStartWordIndex = PaginationEngine.getFirstWordIndexForPage(
      engine!.state.pageIndex, 
      engine!.fontSize
    );

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
            IconButton(
              icon: const Icon(Icons.bar_chart),
              tooltip: "İstatistikler",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ReadingStatisticsScreen(
                      bookId: bookId,
                    ),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              tooltip: "Ayarlar",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SettingsScreen(),
                  ),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            TweenAnimationBuilder<double>(
              duration: Duration(
                milliseconds: 350 ~/ currentSettings.animationSpeed,
              ),
              curve: Curves.easeOutCubic,
              tween: Tween<double>(
                end: engine!.progress,
              ),
              builder: (context, value, child) {
                return LinearProgressIndicator(
                  value: value,
                );
              },
            ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: Duration(
                    milliseconds: 350 ~/ currentSettings.animationSpeed,
                  ),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  transitionBuilder: (child, animation) {
                    final offsetAnimation = Tween<Offset>(
                      begin: const Offset(0.08, 0),
                      end: Offset.zero,
                    ).animate(animation);

                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      ),
                    );
                  },
                  child: Padding(
                    key: ValueKey(engine!.state.pageIndex),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                    child: SingleChildScrollView(
                      child: Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: List.generate(pageWords.length, (index) {
                          final globalIndex = pageStartWordIndex + index;
                          final isHighlighted =
                              globalIndex == engine!.state.wordIndex;

                          final baseColor = _getHighlightColor(
                            currentSettings.rsvpHighlightColor,
                          );

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                engine!.jumpToWord(globalIndex);
                              });
                              _sync();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 2,
                                vertical: 1,
                              ),
                              decoration: BoxDecoration(
                                color: isHighlighted
                                    ? baseColor.withOpacity(0.4)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                pageWords[index],
                                style: TextStyle(
                                  fontSize:
                                      currentSettings.fontSize.toDouble(),
                                  height: 1.5,
                                  letterSpacing: 0.3,
                                  fontWeight: isHighlighted
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: isHighlighted
                                      ? _getHighlightColor(
                                          currentSettings
                                              .rsvpHighlightColor,
                                          isDark: Theme.of(context)
                                                  .brightness ==
                                              Brightness.dark,
                                        )
                                      : null,
                                ),
                              ),
                            ),
                          );
                        }),
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
                      icon: const Icon(Icons.bookmark_add, size: 30),
                      onPressed: _addBookmark,
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

  // EKSİK OLAN YARDIMCI METOD EKLENDİ
  Color _getHighlightColor(String colorName, {bool isDark = false}) {
    switch (colorName) {
      case 'yellow':
        return isDark ? Colors.amber.shade700 : Colors.amber.shade300;
      case 'green':
        return isDark ? Colors.green.shade600 : Colors.green.shade300;
      case 'red':
        return isDark ? Colors.red.shade600 : Colors.red.shade300;
      case 'blue':
      default:
        return isDark ? Colors.blue.shade600 : Colors.blue.shade300;
    }
  }
}