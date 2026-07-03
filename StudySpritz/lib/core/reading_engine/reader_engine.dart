import 'reader_state.dart';
import 'pagination_engine.dart';

class ReaderEngine {
  final List<String> words;
  final int fontSize;

  late final List<String> pages;
  ReaderState state;

  double get progress {
    if (words.isEmpty) return 0.0;
    return (state.wordIndex / words.length).clamp(0.0, 1.0);
  }

  ReaderEngine({
    required this.words,
    required this.fontSize,
    required int initialWordIndex,
  }) : state = ReaderState(wordIndex: 0, pageIndex: 0) {
    // Sayfaları yazı boyutuna göre dinamik oluştur
    pages = PaginationEngine.createPages(words, fontSize);
    // İlk konuma zıpla
    jumpToWord(initialWordIndex);
  }

  String get currentPageText {
    if (state.pageIndex < 0 || state.pageIndex >= pages.length) {
      return "";
    }
    return pages[state.pageIndex];
  }

  /// Belirli bir kelime indeksine tam senkronize şekilde zıplar
  void jumpToWord(int wordIndex) {
    if (words.isEmpty) return;
    final safeWordIndex = wordIndex.clamp(0, words.length - 1);
    final targetPage = PaginationEngine.getPageIndexForWord(words, safeWordIndex, fontSize);

    state = ReaderState(
      wordIndex: safeWordIndex,
      pageIndex: targetPage,
    );
  }

  /// Belirli bir sayfa numarasına zıplar (Sayfa butonları veya bookmark için)
  void jumpToPage(int pageIndex) {
    if (pages.isEmpty) return;
    final safePageIndex = pageIndex.clamp(0, pages.length - 1);
    final firstWordOfPage = PaginationEngine.getFirstWordIndexForPage(safePageIndex, fontSize);

    state = ReaderState(
      wordIndex: firstWordOfPage.clamp(0, words.length - 1),
      pageIndex: safePageIndex,
    );
  }

  /// Bir sonraki sayfaya geçer
  void nextPage() {
    if (state.pageIndex < pages.length - 1) {
      jumpToPage(state.pageIndex + 1);
    }
  }

  /// Bir önceki sayfaya geçer
  void previousPage() {
    if (state.pageIndex > 0) {
      jumpToPage(state.pageIndex - 1);
    }
  }
}