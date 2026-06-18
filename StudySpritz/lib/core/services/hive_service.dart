import 'package:hive_flutter/hive_flutter.dart';
import '../constants/box_names.dart';
import '../../models/book.dart';
import '../../models/bookmark.dart';
import '../../models/highlight.dart';
import '../../models/app_settings.dart';
import '../../models/reading_statistics.dart';

// ADAPTER IMPORTLARI (BUNU EKLEMEZSEN KIRMIZI OLUR)
import 'package:studyspritz/adapters/book_adapter.dart';
import 'package:studyspritz/adapters/bookmark_adapter.dart';
import 'package:studyspritz/adapters/app_settings_adapter.dart';
import 'package:studyspritz/adapters/reading_statistics_adapter.dart';

class HiveService {
  static late Box<Book> booksBox;
  static late Box<Bookmark> bookmarksBox;
  static late Box<AppSettings> settingsBox;
  static late Box<ReadingStatistics> statisticsBox;

  static Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(BookAdapter());
    Hive.registerAdapter(BookmarkAdapter());
    Hive.registerAdapter(AppSettingsAdapter());
    Hive.registerAdapter(ReadingStatisticsAdapter());

    booksBox = await Hive.openBox<Book>(BoxNames.booksBox);
    bookmarksBox = await Hive.openBox<Bookmark>(BoxNames.bookmarksBox);
    settingsBox = await Hive.openBox<AppSettings>(BoxNames.appSettingsBox);
    statisticsBox = await Hive.openBox<ReadingStatistics>(
      BoxNames.readingStatisticsBox,
    );
  }
}