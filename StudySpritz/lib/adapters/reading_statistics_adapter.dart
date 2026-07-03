import 'package:hive/hive.dart';
import '../core/extensions/hive_date_extensions.dart';
import '../models/reading_statistics.dart';

class ReadingStatisticsAdapter extends TypeAdapter<ReadingStatistics> {
  @override
  final int typeId = 4;

  @override
  ReadingStatistics read(BinaryReader reader) {
    return ReadingStatistics(
      bookId: reader.readString(),
      totalReadingTime: reader.readInt(),
      sessionCount: reader.readInt(),
      lastSessionDuration: reader.readInt(),
      averageWpm: reader.readDouble(),
      peakWpm: reader.readDouble(),
      totalWordsRead: reader.readInt(),
      totalPagesRead: reader.readInt(),
      firstReadAt: reader.readDateTimeSafe(),
      lastReadAt: reader.readDateTimeSafe(),
    );
  }

  @override
  void write(BinaryWriter writer, ReadingStatistics obj) {
    writer.writeString(obj.bookId);
    writer.writeInt(obj.totalReadingTime);
    writer.writeInt(obj.sessionCount);
    writer.writeInt(obj.lastSessionDuration);
    writer.writeDouble(obj.averageWpm);
    writer.writeDouble(obj.peakWpm);
    writer.writeInt(obj.totalWordsRead);
    writer.writeInt(obj.totalPagesRead);
    writer.writeDateTimeSafe(obj.firstReadAt);
    writer.writeDateTimeSafe(obj.lastReadAt);
  }
}