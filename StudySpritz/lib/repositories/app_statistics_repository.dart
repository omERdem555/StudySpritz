import '../core/services/hive_service.dart';
import '../models/app_statistics.dart';
import '../models/book.dart';
import '../models/reading_statistics.dart';

class AppStatisticsRepository {
  static const String statisticsKey = 'global';

  Future<AppStatistics> get() async {
    final List<Book> books = HiveService.booksBox.values.toList();

    final List<ReadingStatistics> statistics =
        HiveService.statisticsBox.values.toList();

    final int totalBooks = books.length;

    final int favoriteBooks =
        books.where((book) => book.isFavorite).length;

    final int completedBooks =
        books.where((book) => book.isCompleted).length;

    final int totalReadingTime = statistics.fold(
      0,
      (sum, item) => sum + item.totalReadingTime,
    );

    final int totalWordsRead = statistics.fold(
      0,
      (sum, item) => sum + item.totalWordsRead,
    );

    final int totalPagesRead = statistics.fold(
      0,
      (sum, item) => sum + item.totalPagesRead,
    );

    final int totalSessions = statistics.fold(
      0,
      (sum, item) => sum + item.sessionCount,
    );

    return AppStatistics(
      totalBooks: totalBooks,
      completedBooks: completedBooks,
      favoriteBooks: favoriteBooks,

      totalReadingTime: totalReadingTime,
      totalWordsRead: totalWordsRead,
      totalPagesRead: totalPagesRead,
      totalSessions: totalSessions,

      // Faz 3-4'te gerçek hesaplanacak
      todayReadingTime: 0,
      weekReadingTime: 0,
      monthReadingTime: 0,

      currentStreak: 0,
      longestStreak: 0,

      averageDailyReadingTime: 0,

      lastReadingDate: DateTime.now(),
    );
  }

  Future<void> save(AppStatistics statistics) async {
    await HiveService.appStatisticsBox.put(
      statisticsKey,
      statistics,
    );
  }

  Future<void> reset() async {
    await HiveService.appStatisticsBox.put(
      statisticsKey,
      AppStatistics.empty(),
    );
  }
}