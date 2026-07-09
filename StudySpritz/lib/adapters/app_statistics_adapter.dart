import 'package:hive/hive.dart';

import '../core/extensions/hive_date_extensions.dart';
import '../models/app_statistics.dart';

class AppStatisticsAdapter extends TypeAdapter<AppStatistics> {
  @override
  final int typeId = 6;

  @override
  AppStatistics read(BinaryReader reader) {
    return AppStatistics(
      totalBooks: reader.readInt(),
      completedBooks: reader.readInt(),
      favoriteBooks: reader.readInt(),
      totalReadingTime: reader.readInt(),
      totalWordsRead: reader.readInt(),
      totalPagesRead: reader.readInt(),
      totalSessions: reader.readInt(),
      todayReadingTime: reader.readInt(),
      weekReadingTime: reader.readInt(),
      monthReadingTime: reader.readInt(),
      currentStreak: reader.readInt(),
      longestStreak: reader.readInt(),
      averageDailyReadingTime: reader.readInt(),
      lastReadingDate: reader.readDateTimeSafe(),
    );
  }

  @override
  void write(BinaryWriter writer, AppStatistics obj) {
    writer.writeInt(obj.totalBooks);
    writer.writeInt(obj.completedBooks);
    writer.writeInt(obj.favoriteBooks);
    writer.writeInt(obj.totalReadingTime);
    writer.writeInt(obj.totalWordsRead);
    writer.writeInt(obj.totalPagesRead);
    writer.writeInt(obj.totalSessions);
    writer.writeInt(obj.todayReadingTime);
    writer.writeInt(obj.weekReadingTime);
    writer.writeInt(obj.monthReadingTime);
    writer.writeInt(obj.currentStreak);
    writer.writeInt(obj.longestStreak);
    writer.writeInt(obj.averageDailyReadingTime);
    writer.writeDateTimeSafe(obj.lastReadingDate);
  }
}