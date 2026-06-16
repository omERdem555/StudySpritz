class ReadingStatistics {
  String bookId;

  int totalReadingTime;
  int sessionCount;
  int lastSessionDuration;

  double averageWpm;
  double peakWpm;

  int totalWordsRead;
  int totalPagesRead;

  DateTime firstReadAt;
  DateTime lastReadAt;

  ReadingStatistics({
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
}