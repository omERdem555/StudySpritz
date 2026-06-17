import '../../models/book.dart';
import '../../repositories/book_repository.dart';
import 'file_service.dart';
import 'file_validation_service.dart';

class BookCreationService {
  static Future<Book?> createBook() async {
    final file = await FileService.pickFile();

    if (file == null) {
      return null;
    }

    final path = file.path;

    if (path == null) {
      return null;
    }

    if (!await FileValidationService.exists(path)) {
      return null;
    }

    if (!FileValidationService.isSupported(path)) {
      return null;
    }

    final book = Book(
      bookId: DateTime.now().millisecondsSinceEpoch.toString(),
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

    final repo = BookRepository();

    await repo.addBook(book);

    return book;
  }
}