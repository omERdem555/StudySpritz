import 'package:flutter/material.dart';
import '../../core/reading_engine/reader_engine.dart';

class ReaderScreen extends StatefulWidget {
  const ReaderScreen({super.key});

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  late ReaderEngine engine;

  @override
  void initState() {
    super.initState();

    engine = ReaderEngine(
      words: "Bu bir test metni okuma motoru".split(" "),
      wordsPerPage: 2,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("PAGE: ${engine.state.pageIndex}"),
            Text("WORD: ${engine.state.wordIndex}"),
            Text("PROGRESS: ${engine.progress}"),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  engine.nextWord();
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