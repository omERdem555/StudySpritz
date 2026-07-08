class AppStatistics {
  final int totalBooks;
  final int completedBooks;
  final int favoriteBooks;

  final int totalReadingTime;

  final int totalWordsRead;
  final int totalPagesRead;

  final int totalSessions;

  final int todayReadingTime;
  final int weekReadingTime;
  final int monthReadingTime;

  final int currentStreak;
  final int longestStreak;

  final int averageDailyReadingTime;

  final DateTime lastReadingDate;

  const AppStatistics({
    required this.totalBooks,
    required this.completedBooks,
    required this.favoriteBooks,
    required this.totalReadingTime,
    required this.totalWordsRead,
    required this.totalPagesRead,
    required this.totalSessions,
    required this.todayReadingTime,
    required this.weekReadingTime,
    required this.monthReadingTime,
    required this.currentStreak,
    required this.longestStreak,
    required this.averageDailyReadingTime,
    required this.lastReadingDate,
  });

  factory AppStatistics.empty() {
    return AppStatistics(
      totalBooks: 0,
      completedBooks: 0,
      favoriteBooks: 0,
      totalReadingTime: 0,
      totalWordsRead: 0,
      totalPagesRead: 0,
      totalSessions: 0,
      todayReadingTime: 0,
      weekReadingTime: 0,
      monthReadingTime: 0,
      currentStreak: 0,
      longestStreak: 0,
      averageDailyReadingTime: 0,
      lastReadingDate: DateTime.now(),
    );
  }

  AppStatistics copyWith({
    int? totalBooks,
    int? completedBooks,
    int? favoriteBooks,
    int? totalReadingTime,
    int? totalWordsRead,
    int? totalPagesRead,
    int? totalSessions,
    int? todayReadingTime,
    int? weekReadingTime,
    int? monthReadingTime,
    int? currentStreak,
    int? longestStreak,
    int? averageDailyReadingTime,
    DateTime? lastReadingDate,
  }) {
    return AppStatistics(
      totalBooks: totalBooks ?? this.totalBooks,
      completedBooks: completedBooks ?? this.completedBooks,
      favoriteBooks: favoriteBooks ?? this.favoriteBooks,
      totalReadingTime: totalReadingTime ?? this.totalReadingTime,
      totalWordsRead: totalWordsRead ?? this.totalWordsRead,
      totalPagesRead: totalPagesRead ?? this.totalPagesRead,
      totalSessions: totalSessions ?? this.totalSessions,
      todayReadingTime: todayReadingTime ?? this.todayReadingTime,
      weekReadingTime: weekReadingTime ?? this.weekReadingTime,
      monthReadingTime: monthReadingTime ?? this.monthReadingTime,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      averageDailyReadingTime:
          averageDailyReadingTime ?? this.averageDailyReadingTime,
      lastReadingDate: lastReadingDate ?? this.lastReadingDate,
    );
  }
}