import 'package:hive/hive.dart';
import '../models/highlight.dart';

class HighlightAdapter extends TypeAdapter<Highlight> {
  @override
  final int typeId = 5;

  @override
  Highlight read(BinaryReader reader) {
    return Highlight(
      id: reader.readString(),
      bookId: reader.readString(),
      startIndex: reader.readInt(),
      endIndex: reader.readInt(),
      type: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, Highlight obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.bookId);
    writer.writeInt(obj.startIndex);
    writer.writeInt(obj.endIndex);
    writer.writeString(obj.type);
  }
}