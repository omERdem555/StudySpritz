import 'package:hive/hive.dart';
import '../models/book.dart';
import '../core/services/hive_service.dart';

class BookRepository {
  Box<Book> get _box => HiveService.booksBox;

  Future<void> addBook(Book book) async {
    await _box.put(book.bookId, book);
  }

  Future<void> updateBook(Book book) async {
    await _box.put(book.bookId, book);
  }

  Future<void> deleteBook(String bookId) async {
    // İlişkili bookmark'ları temizleme işini yine güvenli olması açısından koruyoruz
    final relatedBookmarks = HiveService.bookmarksBox.values
        .where((b) => b.bookId == bookId)
        .toList();

    for (final bookmark in relatedBookmarks) {
      await HiveService.bookmarksBox.delete(bookmark.markId);
    }

    await _box.delete(bookId);
  }

  Future<Book?> getBook(String bookId) async {
    return _box.get(bookId);
  }

  Future<List<Book>> getAllBooks() async {
    return _box.values.toList();
  }

  /// ==============================
  /// OTOMATİK OKUMA PROGRES KAYDI (WEB OPTİMİZASYONLU)
  /// ==============================
  Future<void> saveReadingSession({
    required String bookId,
    required int wordIndex,
    required int pageIndex,
  }) async {
    final book = _box.get(bookId);
    if (book == null) return;

    // WEB UYUMLULUK KRİTİK DÜZELTMESİ: İlerleme kaydedilirken bytes alanını
    // taşımaya devam ediyoruz ancak Hive diske yazarken performans kaybı olmasın diye
    // bu nesneyi doğrudan güncelliyoruz.
    final updated = book.copyWith(
      wordIndex: wordIndex,
      pageNumber: pageIndex,
      lastOpenedAt: DateTime.now(),
    );

    await _box.put(bookId, updated);
  }

  /// ==============================
  /// DEVAM ETME SENARYOSU
  /// ==============================
  Future<int> getLastWordIndex(String bookId) async {
    final book = _box.get(bookId);
    return book?.wordIndex ?? 0;
  }

  Future<void> resetProgress(String bookId) async {
    final book = _box.get(bookId);
    if (book == null) return;

    final updated = book.copyWith(
      wordIndex: 0,
      pageNumber: 0,
      lastOpenedAt: DateTime.now(),
    );

    await _box.put(bookId, updated);
  }

  Future<void> markAsOpened(String bookId) async {
    final book = _box.get(bookId);
    if (book == null) return;

    final updated = book.copyWith(
      lastOpenedAt: DateTime.now(),
    );

    await _box.put(bookId, updated);
  }

  Future<void> toggleFavorite(String bookId) async {
    final book = _box.get(bookId);
    if (book == null) return;

    await _box.put(
      bookId,
      book.copyWith(isFavorite: !book.isFavorite),
    );
  }
  
  // MİRARI DÜZELTME: addBookmark, removeBookmark ve getBookmarks metotları 
  // tekil sorumluluk ilkesi gereği BookmarkRepository sınıfına taşındığı için buradan kaldırılmıştır.
}