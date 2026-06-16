import 'package:flutter/material.dart';
import 'core/services/hive_service.dart';
import 'repositories/book_repository.dart';
import 'models/book.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveService.init();

  final repo = BookRepository();

  // 🔹 CLEAN START (önemli)
  final allBefore = await repo.getAllBooks();
  print("START COUNT: ${allBefore.length}");

  // 🔹 DELETE
  await repo.deleteBook("test");

  // 🔹 READ AGAIN
  final afterDelete = await repo.getAllBooks();
  print("AFTER DELETE: ${afterDelete.length}");

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