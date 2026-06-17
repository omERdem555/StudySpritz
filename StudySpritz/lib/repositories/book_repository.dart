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
    await _box.delete(bookId);
  }

  Future<Book?> getBook(String bookId) async {
    return _box.get(bookId);
  }

  Future<List<Book>> getAllBooks() async {
    return _box.values.toList();
  }

  Future<void> updateProgress(String bookId, int wordIndex, int pageIndex) async {
    final book = _box.get(bookId);
    if (book == null) return;

    final updated = Book(
      bookId: book.bookId,
      bookName: book.bookName,
      filePath: book.filePath,
      fileType: book.fileType,
      pageCount: book.pageCount,
      wordCount: book.wordCount,
      pageNumber: pageIndex,
      wordIndex: wordIndex,
      isFavorite: book.isFavorite,
      isCompleted: book.isCompleted,
      addedAt: book.addedAt,
      lastOpenedAt: DateTime.now(),
      completedAt: book.completedAt,
    );

    await _box.put(bookId, updated);
  }
}