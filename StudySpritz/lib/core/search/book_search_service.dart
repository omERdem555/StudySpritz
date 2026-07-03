import '../../models/book.dart';

class BookSearchService {
  static List<Book> filter(List<Book> books, String query) {
    final q = query.trim().toLowerCase();

    if (q.isEmpty) return books;

    return books.where((b) => b.bookName.toLowerCase().contains(q)).toList();
  }
}