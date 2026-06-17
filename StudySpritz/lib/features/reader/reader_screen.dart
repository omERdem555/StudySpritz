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

    final createdEngine = ReaderEngine(
      words: words,
      wordsPerPage: 200,
    );

    createdEngine.state = createdEngine.state.copyWith(
      wordIndex: book.wordIndex,
      pageIndex: book.pageNumber,
    );

    setState(() {
      engine = createdEngine;
      loading = false;
    });
  }

  Future<void> _onNextWord() async {
    if (engine == null) return;

    setState(() {
      engine!.nextWord();
    });

    final repo = BookRepository();

    await repo.updateProgress(
      widget.bookId,
      engine!.state.wordIndex,
      engine!.state.pageIndex,
    );
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

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("PAGE: ${engine!.state.pageIndex}"),
            Text("WORD: ${engine!.state.wordIndex}"),
            Text("PROGRESS: ${engine!.progress}"),
            ElevatedButton(
              onPressed: _onNextWord,
              child: const Text("NEXT WORD"),
            ),
          ],
        ),
      ),
    );
  }
}