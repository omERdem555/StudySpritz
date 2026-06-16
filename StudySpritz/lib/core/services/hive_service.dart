import 'package:hive_flutter/hive_flutter.dart';
import '../constants/box_names.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();
  }

  static Future<Box> openBooksBox() =>
      Hive.openBox(BoxNames.booksBox);

  static Future<Box> openBookmarksBox() =>
      Hive.openBox(BoxNames.bookmarksBox);

  static Future<Box> openSettingsBox() =>
      Hive.openBox(BoxNames.appSettingsBox);

  static Future<Box> openStatisticsBox() =>
      Hive.openBox(BoxNames.readingStatisticsBox);
}