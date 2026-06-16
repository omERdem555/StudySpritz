import '../models/reading_statistics.dart';

class StatisticsRepository {
  Future<void> saveStatistics(
    ReadingStatistics statistics,
  ) async {}

  Future<ReadingStatistics?> getStatistics(
    String bookId,
  ) async {
    return null;
  }

  Future<void> deleteStatistics(
    String bookId,
  ) async {}
}