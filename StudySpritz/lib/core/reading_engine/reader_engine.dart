import 'reader_state.dart';
import 'pagination_engine.dart';

class ReaderEngine {
  final List<String> words;
  final int wordsPerPage;
  final int wpm;

  late final List<String> pages;

  ReaderState state;

  double get progress {
    if (words.isEmpty) return 0.0;
    return state.wordIndex / words.length;
  }

  ReaderEngine({
    required this.words,
    required this.wordsPerPage,
    required this.wpm,
  }) : state = ReaderState(wordIndex: 0, pageIndex: 0) {
    pages = PaginationEngine.createPages(words, wordsPerPage);
  }

  String get currentPageText {
    if (state.pageIndex < 0 || state.pageIndex >= pages.length) {
      return "";
    }
    return pages[state.pageIndex];
  }

  void nextWord() {
    if (state.wordIndex < words.length - 1) {
      state = state.copyWith(wordIndex: state.wordIndex + 1);
      _syncPage();
    }
  }

  void previousWord() {
    if (state.wordIndex > 0) {
      state = state.copyWith(wordIndex: state.wordIndex - 1);
      _syncPage();
    }
  }

  void jumpTo(int wordIndex) {
  if (wordIndex < 0 || wordIndex >= words.length) return;

  state = state.copyWith(
    wordIndex: wordIndex,
    pageIndex: wordIndex ~/ wordsPerPage,
  );
}

  void _syncPage() {
    final newPage = state.wordIndex ~/ wordsPerPage;
    state = state.copyWith(pageIndex: newPage);
  }
}