import '../models/book.dart';

class BookRepository {
  Future<void> addBook(Book book)
  async {}

  Future<void> updateBook(Book book)
  async {}

  Future<void> deleteBook(String bookId)
  async {}

  Future<Book?> getBook(String bookId)
  async {
    return null;
  }

  Future<List<Book>> getAllBooks()
  async {
    return [];
  }
}