class PaginationEngine {
  static List<String> createPages(
    List<String> words,
    int wordsPerPage,
  ) {
    if (wordsPerPage <= 0) return [];

    final pages = <String>[];

    for (int i = 0; i < words.length; i += wordsPerPage) {
      final end = (i + wordsPerPage < words.length)
          ? i + wordsPerPage
          : words.length;

      final pageWords = words.sublist(i, end);
      pages.add(pageWords.join(' '));
    }

    return pages;
  }
}