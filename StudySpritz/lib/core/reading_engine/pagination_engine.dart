class PaginationEngine {
  /// Font boyutuna göre bir sayfaya sığabilecek tahmini kelime sayısını hesaplar
  static int _getWordsPerPage(int fontSize) {
    // Büyük fontlarda sayfa başına daha az kelime düşer (Ters orantı)
    if (fontSize <= 14) return 180;
    if (fontSize <= 18) return 140;
    if (fontSize <= 22) return 100;
    if (fontSize <= 26) return 75;
    return 50; 
  }

  /// Tüm kelimeleri font boyutuna göre dinamik olarak sayfalara böler
  static List<String> createPages(List<String> words, int fontSize) {
    if (words.isEmpty) return [];
    
    final List<String> generatedPages = [];
    final int wordsPerPage = _getWordsPerPage(fontSize);
    
    for (int i = 0; i < words.length; i += wordsPerPage) {
      final end = (i + wordsPerPage < words.length) ? i + wordsPerPage : words.length;
      final pageContent = words.sublist(i, end).join(" ");
      generatedPages.add(pageContent);
    }
    
    return generatedPages;
  }

  /// Canlı okunan kelime indeksinin (wordIndex) hangi sayfa numarasına (pageIndex) ait olduğunu bulur
  static int getPageIndexForWord(List<String> words, int wordIndex, int fontSize) {
    if (words.isEmpty) return 0;
    final int wordsPerPage = _getWordsPerPage(fontSize);
    return (wordIndex / wordsPerPage).floor().clamp(0, (words.length / wordsPerPage).ceil() - 1);
  }

  /// Belirli bir sayfa indeksinin ilk kelimesinin global kelime indeksini döner
  static int getFirstWordIndexForPage(int pageIndex, int fontSize) {
    final int wordsPerPage = _getWordsPerPage(fontSize);
    return pageIndex * wordsPerPage;
  }
}