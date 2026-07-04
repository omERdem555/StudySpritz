import 'package:hive/hive.dart';
import '../models/book.dart';
import '../core/extensions/hive_date_extensions.dart';

class BookAdapter extends TypeAdapter<Book> {
  @override
  final int typeId = 1;

  @override
  Book read(BinaryReader reader) {
    // Okuma sırası tam olarak yazma sırasıyla eşleşmelidir
    final bookId = reader.readString();
    final bookName = reader.readString();
    final filePath = reader.readString();
    final fileType = reader.readString();
    final pageCount = reader.readInt();
    final wordCount = reader.readInt();
    final pageNumber = reader.readInt();
    final wordIndex = reader.readInt();
    final isFavorite = reader.readBool();
    final isCompleted = reader.readBool();
    final addedAt = reader.readDateTimeSafe();
    final lastOpenedAt = reader.readDateTimeSafe();
    final completedAt = reader.readNullableDateTime();
    
    // Eski şemadan kalan bytes alanı varsa veritabanının kaymaması için güvenli tüketim:
    if (reader.availableBytes > 0) {
      reader.readByteList();
    }

    return Book(
      bookId: bookId,
      bookName: bookName,
      filePath: filePath,
      fileType: fileType,
      pageCount: pageCount,
      wordCount: wordCount,
      pageNumber: pageNumber,
      wordIndex: wordIndex,
      isFavorite: isFavorite,
      isCompleted: isCompleted,
      addedAt: addedAt,
      lastOpenedAt: lastOpenedAt,
      completedAt: completedAt,
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
  }
}