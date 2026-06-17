import 'package:flutter/material.dart';

import '../../core/reading_engine/reader_engine.dart';
import '../../core/parsers/parser_factory.dart';
import '../../repositories/book_repository.dart';

class ReaderScreen extends StatefulWidget {
  final String bookId;

  const ReaderScreen({super.key, required this.bookId});

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

    // SESSION RESTORE
    engine!.jumpTo(book.wordIndex);

    setState(() => loading = false);
  }

  Future<void> _sync() async {
    if (engine == null) return;

    await BookRepository().saveReadingSession(
      bookId: widget.bookId,
      wordIndex: engine!.state.wordIndex,
      pageIndex: engine!.state.pageIndex,
    );
  }

  Future<void> _next() async {
    if (engine == null) return;

    setState(() {
      engine!.jumpTo(
        engine!.state.wordIndex + engine!.wordsPerPage,
      );
    });

    await _sync();
  }

  Future<void> _prev() async {
    if (engine == null) return;

    setState(() {
      engine!.jumpTo(
        engine!.state.wordIndex - engine!.wordsPerPage,
      );
    });

    await _sync();
  }

  @override
  void dispose() {
    _sync();
    super.dispose();
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
        body: Center(child: Text("Book not found")),
      );
    }

    final progress =
        engine!.state.wordIndex / engine!.words.length;

    return Scaffold(
      appBar: AppBar(title: const Text("Reader")),
      body: Column(
        children: [
          LinearProgressIndicator(value: progress),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Text(
                  engine!.currentPageText,
                  style: const TextStyle(
                    fontSize: 18,
                    height: 1.7,
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _prev,
                  child: const Text("Prev"),
                ),
                ElevatedButton(
                  onPressed: _next,
                  child: const Text("Next"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}