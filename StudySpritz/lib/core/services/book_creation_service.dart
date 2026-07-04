import 'package:flutter/foundation.dart';
import '../../models/book.dart';
import '../../repositories/book_repository.dart';
import 'file_service.dart';
import 'file_validation_service.dart';

class BookCreationService {
  static Future<Book?> createBook() async {
    final file = await FileService.pickFile();
    if (file == null) return null;

    final String generatedId = DateTime.now().millisecondsSinceEpoch.toString();
    final repo = BookRepository();

    if (kIsWeb) {
      if (file.bytes == null) return null;

      final book = Book(
        bookId: generatedId,
        bookName: file.name,
        filePath: '', // Web platformunda yerel path olmaz
        fileType: file.extension ?? '',
        pageCount: 0,
        wordCount: 0,
        pageNumber: 0,
        wordIndex: 0,
        isFavorite: false,
        isCompleted: false,
        addedAt: DateTime.now(),
        lastOpenedAt: DateTime.now(),
        completedAt: null,
      );

      // Web performansı için byte'ları parametre olarak ayırıp gönderiyoruz
      await repo.addBook(book, fileBytes: file.bytes);
      return book;
    } else {
      final path = file.path;
      if (path == null) return null;

      // Native platform doğrulamaları
      if (!await FileValidationService.exists(path)) return null;
      if (!FileValidationService.isSupported(path)) return null;

      final book = Book(
        bookId: generatedId,
        bookName: file.name,
        filePath: path, 
        fileType: file.extension ?? '',
        pageCount: 0,
        wordCount: 0,
        pageNumber: 0,
        wordIndex: 0,
        isFavorite: false,
        isCompleted: false,
        addedAt: DateTime.now(),
        lastOpenedAt: DateTime.now(),
        completedAt: null,
      );

      // Native cihazlarda dosya yerel disktedir, byte yazmaya gerek yoktur
      await repo.addBook(book);
      return book;
    }
  }
}