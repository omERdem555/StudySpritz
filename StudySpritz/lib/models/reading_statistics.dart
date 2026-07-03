class ReadingStatistics {
  final String bookId;
  final int totalReadingTime;
  final int sessionCount;
  final int lastSessionDuration;
  final double averageWpm;
  final double peakWpm;
  final int totalWordsRead;
  final int totalPagesRead;
  final DateTime firstReadAt;
  final DateTime lastReadAt;

  const ReadingStatistics({
    required this.bookId,
    required this.totalReadingTime,
    required this.sessionCount,
    required this.lastSessionDuration,
    required this.averageWpm,
    required this.peakWpm,
    required this.totalWordsRead,
    required this.totalPagesRead,
    required this.firstReadAt,
    required this.lastReadAt,
  });

  ReadingStatistics copyWith({
    int? totalReadingTime,
    int? sessionCount,
    int? lastSessionDuration,
    double? averageWpm,
    double? peakWpm,
    int? totalWordsRead,
    int? totalPagesRead,
    DateTime? firstReadAt,
    DateTime? lastReadAt,
  }) {
    return ReadingStatistics(
      bookId: bookId,
      totalReadingTime: totalReadingTime ?? this.totalReadingTime,
      sessionCount: sessionCount ?? this.sessionCount,
      lastSessionDuration: lastSessionDuration ?? this.lastSessionDuration,
      averageWpm: averageWpm ?? this.averageWpm,
      peakWpm: peakWpm ?? this.peakWpm,
      totalWordsRead: totalWordsRead ?? this.totalWordsRead,
      totalPagesRead: totalPagesRead ?? this.totalPagesRead,
      firstReadAt: firstReadAt ?? this.firstReadAt,
      lastReadAt: lastReadAt ?? this.lastReadAt,
    );
  }
}