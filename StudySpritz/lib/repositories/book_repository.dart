import 'dart:typed_data';
import 'package:hive/hive.dart';
import '../models/book.dart';
import '../../core/services/hive_service.dart';

class BookRepository {
  Box<Book> get _box => HiveService.booksBox;
  
  // Kutunun ismi HiveService tarafındaki isimle senkronize edildi
  Box<Uint8List> get _bytesBox => HiveService.booksBytesBox; 

  /// Kitap eklerken metadata kutusuna künyeyi, varsa Web byte kutusuna veriyi yazar.
  Future<void> addBook(Book book, {Uint8List? fileBytes}) async {
    await _box.put(book.bookId, book);
    if (fileBytes != null && fileBytes.isNotEmpty) {
      await _bytesBox.put(book.bookId, fileBytes);
    }
  }

  Future<void> updateBook(Book book) async {
    await _box.put(book.bookId, book);
  }

  /// Web byte kutusundan kitabın ham içeriğini dinamik çağırır (Sadece okuma ekranı açılınca yüklenir)
  Future<Uint8List?> getBookBytes(String bookId) async {
    return _bytesBox.get(bookId);
  }

  Future<void> deleteBook(String bookId) async {
    // 1. İlişkili bookmark'ları temizle
    final relatedBookmarks = HiveService.bookmarksBox.values
        .where((b) => b.bookId == bookId)
        .toList();

    for (final bookmark in relatedBookmarks) {
      await HiveService.bookmarksBox.delete(bookmark.markId);
    }

    // 2. Varsa Web byte verisini sil
    await _bytesBox.delete(bookId);

    // 3. Kitap künyesini sil
    await _box.delete(bookId);
  }

  Future<Book?> getBook(String bookId) async {
    return _box.get(bookId);
  }

  /// RAM dostu hafif listeleme
  Future<List<Book>> getAllBooks() async {
    return _box.values.toList();
  }

  /// Çift yönlü ilerleme kaydı metodu
  Future<void> saveReadingSession({
    required String bookId,
    required int wordIndex,
    required int pageIndex,
  }) async {
    final book = _box.get(bookId);
    if (book == null) return;

    final updated = book.copyWith(
      wordIndex: wordIndex,
      pageNumber: pageIndex,
      lastOpenedAt: DateTime.now(),
    );

    await _box.put(bookId, updated);
  }

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
}