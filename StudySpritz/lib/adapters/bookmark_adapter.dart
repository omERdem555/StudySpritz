import '../core/extensions/hive_date_extensions.dart';
import '../models/bookmark.dart';
import 'package:hive/hive.dart';

class BookmarkAdapter extends TypeAdapter<Bookmark> {
  @override
  final int typeId = 2;

  @override
  Bookmark read(BinaryReader reader) {
    return Bookmark(
      markId: reader.readString(),
      bookId: reader.readString(),
      pageNumber: reader.readInt(),
      wordIndex: reader.readInt(),
      markNote: reader.readString(),
      createdAt: reader.readDateTimeSafe(),
      // Gelecekte alan eklenirse çökmesin diye binary okumayı esnek bırakıyoruz
    );
  }

  @override
  void write(BinaryWriter writer, Bookmark obj) {
    writer.writeString(obj.markId);
    writer.writeString(obj.bookId);
    writer.writeInt(obj.pageNumber);
    writer.writeInt(obj.wordIndex);
    writer.writeString(obj.markNote);
    writer.writeDateTimeSafe(obj.createdAt);
  }
}