class PaginationEngine {
  /// Kelime listesini, yazı boyutuna göre optimize edilmiş dinamik sayfalara böler.
  /// İleride ekran boyutlarına göre de genişletilebilecek esnek altyapı sunar.
  static List<String> createPages(List<String> words, int fontSize) {
    if (words.isEmpty) return [];

    // Yazı boyutu büyüdükçe sayfa başına düşen kelime sayısını dinamik olarak azaltıyoruz.
    // Örn: FontSize 14 ise ~250 kelime, FontSize 28 ise ~125 kelime sığar.
    final int wordsPerPage = (3500 / fontSize).round().clamp(50, 400);

    final List<String> pages = [];
    for (int i = 0; i < words.length; i += wordsPerPage) {
      final end = (i + wordsPerPage < words.length) ? i + wordsPerPage : words.length;
      final pageWords = words.sublist(i, end);
      pages.add(pageWords.join(' '));
    }

    return pages;
  }

  /// Belirli bir kelime indeksinin, verilen yazı boyutuna göre hangi sayfada olduğunu hesaplar
  static int getPageIndexForWord(List<String> words, int wordIndex, int fontSize) {
    if (words.isEmpty || wordIndex <= 0) return 0;
    final int wordsPerPage = (3500 / fontSize).round().clamp(50, 400);
    final page = wordIndex ~/ wordsPerPage;
    
    // Güvenli aralık kontrolü
    final totalPages = (words.length / wordsPerPage).ceil();
    return page.clamp(0, totalPages == 0 ? 0 : totalPages - 1);
  }

  /// Belirli bir sayfa indeksinin başladığı ilk kelime indeksini döner
  static int getFirstWordIndexForPage(int pageIndex, int fontSize) {
    final int wordsPerPage = (3500 / fontSize).round().clamp(50, 400);
    return pageIndex * wordsPerPage;
  }
}