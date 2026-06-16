import '../models/bookmark.dart';

class BookmarkRepository {
  Future<void> addBookmark(Bookmark bookmark)
  async {}

  Future<void> deleteBookmark(String markId)
  async {}

  Future<Bookmark?> getBookmark(String markId)
  async {
    return null;
  }

  Future<List<Bookmark>> getBookmarksByBook(
    String bookId,
  )
  async {
    return [];
  }
}