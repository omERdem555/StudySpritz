import 'package:hive/hive.dart';

extension HiveDateRead on BinaryReader {
  DateTime readDateTimeSafe() {
    return readInt() == 1
        ? DateTime.fromMillisecondsSinceEpoch(readInt())
        : DateTime(0);
  }

  DateTime? readNullableDateTime() {
    final isNotNull = readBool();
    if (!isNotNull) return null;
    return DateTime.fromMillisecondsSinceEpoch(readInt());
  }
}

extension HiveDateWrite on BinaryWriter {
  void writeDateTimeSafe(DateTime value) {
    writeInt(1);
    writeInt(value.millisecondsSinceEpoch);
  }

  void writeNullableDateTime(DateTime? value) {
    writeBool(value != null);
    if (value != null) {
      writeInt(value.millisecondsSinceEpoch);
    }
  }
}