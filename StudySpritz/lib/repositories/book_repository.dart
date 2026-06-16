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
}