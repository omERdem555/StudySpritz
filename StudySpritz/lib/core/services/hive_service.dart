import 'package:hive_flutter/hive_flutter.dart';
import '../constants/box_names.dart';

// ADAPTER IMPORTLARI (BUNU EKLEMEZSEN KIRMIZI OLUR)
import 'package:studyspritz/adapters/book_adapter.dart';
import 'package:studyspritz/adapters/bookmark_adapter.dart';
import 'package:studyspritz/adapters/app_settings_adapter.dart';
import 'package:studyspritz/adapters/reading_statistics_adapter.dart';

class HiveService {
static Future<void> init() async {
  await Hive.initFlutter();

  Hive.registerAdapter(BookAdapter());
  Hive.registerAdapter(BookmarkAdapter());
  Hive.registerAdapter(AppSettingsAdapter());
  Hive.registerAdapter(ReadingStatisticsAdapter());

  print("Hive initialized");
  print("Adapters registered");
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