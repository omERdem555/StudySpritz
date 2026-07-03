import 'dart:typed_data';
import '../core/extensions/hive_date_extensions.dart';
import 'package:hive/hive.dart';
import '../models/book.dart';

class BookAdapter extends TypeAdapter<Book> {
  @override
  final int typeId = 1;

  @override
  Book read(BinaryReader reader) {
    return Book(
      bookId: reader.readString(),
      bookName: reader.readString(),
      filePath: reader.readString(),
      fileType: reader.readString(),
      pageCount: reader.readInt(),
      wordCount: reader.readInt(),
      pageNumber: reader.readInt(),
      wordIndex: reader.readInt(),
      isFavorite: reader.readBool(),
      isCompleted: reader.readBool(),
      addedAt: reader.readDateTimeSafe(),
      lastOpenedAt: reader.readDateTimeSafe(),
      completedAt: reader.readNullableDateTime(),
      bytes: reader.availableBytes > 0 ? reader.readByteList() as Uint8List? : null,
    );
  }

  @override
  void write(BinaryWriter writer, Book obj) {
    writer.writeString(obj.bookId);
    writer.writeString(obj.bookName);
    writer.writeString(obj.filePath);
    writer.writeString(obj.fileType);
    writer.writeInt(obj.pageCount);
    writer.writeInt(obj.wordCount);
    writer.writeInt(obj.pageNumber);
    writer.writeInt(obj.wordIndex);
    writer.writeBool(obj.isFavorite);
    writer.writeBool(obj.isCompleted);
    writer.writeDateTimeSafe(obj.addedAt);
    writer.writeDateTimeSafe(obj.lastOpenedAt);
    writer.writeNullableDateTime(obj.completedAt);
    writer.writeByteList(obj.bytes ?? Uint8List(0));
  }
}