import 'package:hive/hive.dart';
import '../models/bookmark.dart';
import '../core/services/hive_service.dart';

class BookmarkRepository {
  Box<Bookmark> get _box => HiveService.bookmarksBox;

  Future<void> addBookmark(Bookmark bookmark) async {
    await _box.put(bookmark.markId, bookmark);
  }

  Future<void> deleteBookmark(String markId) async {
    await _box.delete(markId);
  }

  Future<Bookmark?> getBookmark(String markId) async {
    return _box.get(markId);
  }

  Future<List<Bookmark>> getBookmarksByBook(String bookId) async {
    return _box.values
        .where((b) => b.bookId == bookId)
        .toList();
  }
}