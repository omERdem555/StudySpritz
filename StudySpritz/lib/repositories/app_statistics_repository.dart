import 'package:hive/hive.dart';

import '../core/services/hive_service.dart';
import '../models/app_statistics.dart';

class AppStatisticsRepository {
  static const String statisticsKey = 'global';

  Box<AppStatistics> get _box => HiveService.appStatisticsBox;

  Future<AppStatistics> get() async {
    return _box.get(statisticsKey) ?? AppStatistics.empty();
  }

  Future<void> save(AppStatistics statistics) async {
    await _box.put(statisticsKey, statistics);
  }

  Future<void> reset() async {
    await _box.put(statisticsKey, AppStatistics.empty());
  }
}