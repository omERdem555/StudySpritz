import 'package:flutter/material.dart';

import '../../core/reading_engine/reader_engine.dart';
import '../../core/parsers/parser_factory.dart';
import '../../repositories/book_repository.dart';
import '../../models/book.dart';

class ReaderScreen extends StatefulWidget {
  const ReaderScreen({super.key});

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  ReaderEngine? engine;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadBook();
  }

  Future<void> _loadBook() async {
    final repo = BookRepository();
    final books = await repo.getAllBooks();

    if (books.isEmpty) {
      setState(() => loading = false);
      return;
    }

    final Book book = books.first;

    final parser = ParserFactory.getParser(book.filePath);
    final text = await parser.extract(book.filePath);

    final words = text.split(RegExp(r'\s+'));

    engine = ReaderEngine(
      words: words,
      wordsPerPage: 200,
    );

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (engine == null) {
      return const Scaffold(
        body: Center(child: Text("No book found")),
      );
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("PAGE: ${engine!.state.pageIndex}"),
            Text("WORD: ${engine!.state.wordIndex}"),
            Text("PROGRESS: ${engine!.progress}"),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  engine!.nextWord();
                });
              },
              child: const Text("NEXT WORD"),
            ),
          ],
        ),
      ),
    );
  }
}