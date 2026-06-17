class ReadingEngine {
  static const int wordsPerPage = 250;

  List<String> toWords(String text) {
    return text
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim()
        .split(' ');
  }

  int getPageCount(List<String> words) {
    return (words.length / wordsPerPage).ceil();
  }

  List<String> getPage(List<String> words, int page) {
    final start = page * wordsPerPage;
    final end = (start + wordsPerPage).clamp(0, words.length);

    return words.sublist(start, end);
  }

  double getProgress(int currentWordIndex, int totalWords) {
    if (totalWords == 0) return 0;
    return currentWordIndex / totalWords;
  }
}