import 'package:flutter/material.dart';
import 'core/services/hive_service.dart';
import 'repositories/book_repository.dart';
import 'models/book.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveService.init();

  final repo = BookRepository();
  final books = await repo.getAllBooks();

  print("AFTER RESTART: ${books.length}");
  print("BOOK: ${books.first.bookName}");

  runApp(const MyApp());
}

Future<void> runPersistenceTests(BookRepository repo) async {
  print("=== PERSISTENCE TEST START ===");

  await repo.deleteBook("persist-test");

  final before = await repo.getAllBooks();
  print("BEFORE: ${before.length}");

  final book = Book(
    bookId: "persist-test",
    bookName: "Persistence Test",
    filePath: "",
    fileType: "txt",
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

  await repo.addBook(book);

  final mid = await repo.getAllBooks();
  print("AFTER ADD: ${mid.length}");

  print("=== RESTART APP NOW ===");
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