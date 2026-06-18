import 'package:hive/hive.dart';

import '../models/book.dart';
import '../core/services/hive_service.dart';
import '../models/bookmark.dart';

class BookRepository {
  Box<Book> get _box => HiveService.booksBox;

  Future<void> addBook(Book book) async {
    await _box.put(book.bookId, book);
  }

  Future<void> updateBook(Book book) async {
    await _box.put(book.bookId, book);
  }

  Future<void> deleteBook(String bookId) async {
    final relatedBookmarks = HiveService.bookmarksBox.values
        .where((b) => b.bookId == bookId)
        .toList();

    for (final bookmark in relatedBookmarks) {
      await HiveService.bookmarksBox.delete(
        bookmark.markId,
      );
    }

    await _box.delete(bookId);
  }

  Future<Book?> getBook(String bookId) async {
    return _box.get(bookId);
  }

  Future<List<Book>> getAllBooks() async {
    return _box.values.toList();
  }

  Future<void> updateProgress(
    String bookId,
    int wordIndex,
    int pageIndex,
  ) async {
    final book = _box.get(bookId);
    if (book == null) return;

    final updated = book.copyWith(
      wordIndex: wordIndex,
      pageNumber: pageIndex,
      lastOpenedAt: DateTime.now(),
    );

    await _box.put(bookId, updated);
  }

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

  Future<void> markAsOpened(String bookId) async {
    final book = _box.get(bookId);
    if (book == null) return;

    final updated = book.copyWith(
      lastOpenedAt: DateTime.now(),
    );

    await _box.put(bookId, updated);
  }

  Future<void> addBookmark(String bookId, Bookmark bookmark) async {
    await HiveService.bookmarksBox.put(bookmark.markId, bookmark);
  }

  Future<void> removeBookmark(String bookmarkId) async {
    await HiveService.bookmarksBox.delete(bookmarkId);
  }

  Future<List<Bookmark>> getBookmarks(String bookId) async {
    return HiveService.bookmarksBox.values
        .where((b) => b.bookId == bookId)
        .toList();
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