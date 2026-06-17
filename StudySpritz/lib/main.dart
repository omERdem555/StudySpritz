import 'package:flutter/material.dart';
import 'core/services/file_validation_service.dart';
import 'core/services/book_creation_service.dart';
import 'core/services/hive_service.dart';
import 'core/services/file_service.dart';
import 'repositories/statistics_repository.dart';
import 'repositories/bookmark_repository.dart';
import 'repositories/settings_repository.dart';
import 'repositories/book_repository.dart';
import 'models/reading_statistics.dart';
import 'models/app_settings.dart';
import 'models/bookmark.dart';
import 'models/book.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveService.init();

  final repo = BookRepository();

  // 1. Mevcut veriyi oku
  final before = await repo.getAllBooks();
  print("BEFORE RESTART LOAD: ${before.length}");

  for (final b in before) {
    print("${b.bookName} -> ${b.filePath}");
  }

  // 2. Eğer ilk çalıştırma ise manuel test ekleme (opsiyonel)
  // Bunu sadece debug amaçlı kullan
  if (before.isEmpty) {
    final testBook = Book(
      bookId: "persist-test-1",
      bookName: "Persistence Test Book",
      filePath: "C:/test/path.pdf",
      fileType: "pdf",
      pageCount: 10,
      wordCount: 100,
      pageNumber: 0,
      wordIndex: 0,
      isFavorite: false,
      isCompleted: false,
      addedAt: DateTime.now(),
      lastOpenedAt: DateTime.now(),
      completedAt: null,
    );

    await repo.addBook(testBook);
    print("TEST BOOK CREATED");
  }

  // 3. Yeniden oku (asıl kontrol)
  final after = await repo.getAllBooks();

  print("AFTER LOAD: ${after.length}");
  for (final b in after) {
    print("BOOK: ${b.bookName} | ${b.filePath}");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(child: Text("StudySpritz Ready")),
      ),
    );
  }
}