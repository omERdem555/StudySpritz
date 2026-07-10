import 'package:hive_flutter/hive_flutter.dart';
import 'dart:typed_data';
import '../../models/book.dart';
import '../../models/bookmark.dart';
import '../../models/app_settings.dart';
import '../../models/reading_statistics.dart';
import '../../models/highlight.dart';
import '../../models/app_statistics.dart';
import '../../models/reading_goal.dart';

import '../../adapters/reading_goal_adapter.dart';
import '../../adapters/book_adapter.dart';
import '../../adapters/bookmark_adapter.dart';
import '../../adapters/app_settings_adapter.dart';
import '../../adapters/reading_statistics_adapter.dart';
import '../../adapters/highlight_adapter.dart';
import '../../adapters/app_statistics_adapter.dart';

class HiveService {
  static const int _currentSchemaVersion = 2;
  static const String _metaBoxName = 'app_metadata';
  static const String _schemaVersionKey = 'schema_version';

  static late Box<Book> booksBox;
  static late Box<Uint8List> booksBytesBox; // Adlandırma repository ile eşitlendi
  static late Box<Bookmark> bookmarksBox;
  static late Box<AppSettings> settingsBox;
  static late Box<ReadingStatistics> statisticsBox;
  static late Box<AppStatistics> appStatisticsBox;
  static late Box<Highlight> highlightsBox;
  static late Box<ReadingGoal> readingGoalsBox;

  static Future<void> init() async {
    await Hive.initFlutter();

    // 1. ADAPTÖRLERİN KAYDEDİLMESİ
    Hive.registerAdapter(BookAdapter());
    Hive.registerAdapter(BookmarkAdapter());
    Hive.registerAdapter(AppSettingsAdapter());
    Hive.registerAdapter(ReadingStatisticsAdapter());
    Hive.registerAdapter(AppStatisticsAdapter());
    Hive.registerAdapter(HighlightAdapter());
    Hive.registerAdapter(ReadingGoalAdapter());

    // 2. KUTULARIN AÇILMASI
    booksBox = await Hive.openBox<Book>('books');
    booksBytesBox = await Hive.openBox<Uint8List>('books_bytes'); // Burası eklendi
    bookmarksBox = await Hive.openBox<Bookmark>('bookmarks');
    settingsBox = await Hive.openBox<AppSettings>('settings');
    statisticsBox = await Hive.openBox<ReadingStatistics>('statistics');
    appStatisticsBox = await Hive.openBox<AppStatistics>('app_statistics');
    highlightsBox = await Hive.openBox<Highlight>('highlights');
    readingGoalsBox = await Hive.openBox<ReadingGoal>('reading_goals');

    // 3. ŞEMA VERSİYON & MİGRASYON KONTROLÜ
    final metaBox = await Hive.openBox(_metaBoxName);
    final int oldVersion = metaBox.get(_schemaVersionKey, defaultValue: 0);

    if (oldVersion < _currentSchemaVersion) {
      await _performMigration(oldVersion, _currentSchemaVersion);
      await metaBox.put(_schemaVersionKey, _currentSchemaVersion);
    }
  }

  static Future<void> _performMigration(int fromVersion, int toVersion) async {
    if (fromVersion < 1) {
      // İlk kurulum veya şema hazırlığı
    }
  }

  static Future<void> clearAllData() async {
    await booksBox.clear();
    await booksBytesBox.clear();
    await bookmarksBox.clear();
    await settingsBox.clear();
    await statisticsBox.clear();
    await appStatisticsBox.clear();
    await highlightsBox.clear();
    await readingGoalsBox.clear();
  }
}