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

  final book = await BookCreationService.createBook();

  if (book != null) {
    print("BOOK CREATED:");
    print(book.bookName);
    print(book.filePath);
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