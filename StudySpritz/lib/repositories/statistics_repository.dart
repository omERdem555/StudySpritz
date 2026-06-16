import 'package:hive/hive.dart';
import '../models/reading_statistics.dart';
import '../core/services/hive_service.dart';

class StatisticsRepository {
  Box<ReadingStatistics> get _box => HiveService.statisticsBox;

  Future<void> saveStatistics(ReadingStatistics statistics) async {
    await _box.put(statistics.bookId, statistics);
  }

  Future<ReadingStatistics?> getStatistics(String bookId) async {
    return _box.get(bookId);
  }

  Future<void> deleteStatistics(String bookId) async {
    await _box.delete(bookId);
  }
}