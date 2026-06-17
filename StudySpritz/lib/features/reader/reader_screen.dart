import 'package:flutter/material.dart';

import '../../core/reading_engine/reader_engine.dart';
import '../../core/parsers/parser_factory.dart';
import '../../repositories/book_repository.dart';

class ReaderScreen extends StatefulWidget {
  final String bookId;

  const ReaderScreen({
    super.key,
    required this.bookId,
  });

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
    final book = await repo.getBook(widget.bookId);

    if (book == null) {
      setState(() => loading = false);
      return;
    }

    await repo.markAsOpened(book.bookId);

    final parser = ParserFactory.getParser(book.filePath);
    final text = await parser.extract(book.filePath);

    final words = text.split(RegExp(r'\s+'));

    engine = ReaderEngine(
      words: words,
      wordsPerPage: 200,
    );

    engine!.jumpTo(book.wordIndex);

    setState(() {
      loading = false;
    });
  }

  Future<void> _nextPage() async {
    if (engine == null) return;

    setState(() {
      engine!.jumpTo(
        engine!.state.wordIndex + engine!.wordsPerPage,
      );
    });

    await BookRepository().updateProgress(
      widget.bookId,
      engine!.state.wordIndex,
      engine!.state.pageIndex,
    );
  }

  Future<void> _previousPage() async {
    if (engine == null) return;

    setState(() {
      engine!.jumpTo(
        engine!.state.wordIndex - engine!.wordsPerPage,
      );
    });

    await BookRepository().updateProgress(
      widget.bookId,
      engine!.state.wordIndex,
      engine!.state.pageIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (engine == null) {
      return const Scaffold(
        body: Center(
          child: Text("Book not found"),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Reader"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: engine!.progress,
            ),

            const SizedBox(height: 20),

            Text(
              "Page ${engine!.state.pageIndex + 1}",
            ),

            const SizedBox(height: 20),

            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  engine!.currentPageText,
                  style: const TextStyle(
                    fontSize: 18,
                    height: 1.6,
                  ),
                ),
              ),
            ),

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _previousPage,
                  child: const Text("Previous"),
                ),
                ElevatedButton(
                  onPressed: _nextPage,
                  child: const Text("Next"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}