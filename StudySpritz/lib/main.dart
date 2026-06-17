import 'package:flutter/material.dart';
import 'core/parsers/parser_factory.dart';
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

  await runFileToTextTest(repo);

  runApp(const MyApp());
}

Future<void> runFileToTextTest(BookRepository repo) async {
  final file = await FileService.pickFile();

  if (file == null || file.path == null) {
    print("NO FILE SELECTED");
    return;
  }

  print("SELECTED FILE: ${file.name}");
  print("PATH: ${file.path}");

  final parser = ParserFactory.getParser(file.path!);
  final text = await parser.extract(file.path!);

  print("=== EXTRACTED TEXT START ===");
  print(text);
  print("=== EXTRACTED TEXT END ===");

  final book = Book(
    bookId: DateTime.now().millisecondsSinceEpoch.toString(),
    bookName: file.name,
    filePath: file.path!,
    fileType: file.extension ?? "",
    pageCount: 0,
    wordCount: text.length,
    pageNumber: 0,
    wordIndex: 0,
    isFavorite: false,
    isCompleted: false,
    addedAt: DateTime.now(),
    lastOpenedAt: DateTime.now(),
    completedAt: null,
  );

  await repo.addBook(book);

  print("BOOK SAVED");
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