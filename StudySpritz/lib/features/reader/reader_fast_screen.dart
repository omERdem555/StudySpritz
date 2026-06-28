import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/state/settings_state.dart';
import '../../core/parsers/parser_factory.dart';
import '../../models/book.dart';

class ReaderFastScreen extends StatefulWidget {
  final Book book;

  const ReaderFastScreen({
    super.key,
    required this.book,
  });

  @override
  State<ReaderFastScreen> createState() => _ReaderFastScreenState();
}

class _ReaderFastScreenState extends State<ReaderFastScreen> {
  List<String> words = [];
  int index = 0;

  Timer? timer;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _loadBook();
  }

  void _start() {
    if (words.isEmpty) return;

    final settings = context.read<SettingsState>().settings;
    final wpm = settings?.wpmSpeed ?? 200;

    final intervalMs = (60000 / wpm).round();

    timer?.cancel();

    timer = Timer.periodic(
      Duration(milliseconds: intervalMs),
      (_) {
        if (index >= words.length - 1) {
          _pause();
          return;
        }

        setState(() {
          index++;
        });
      },
    );

    setState(() => isPlaying = true);
  }

  void _pause() {
    timer?.cancel();
    setState(() => isPlaying = false);
  }

  void _reset() {
    timer?.cancel();
    setState(() {
      index = 0;
      isPlaying = false;
    });
  }

  Future<void> _loadBook() async {
    final file = File(widget.book.filePath);

    if (!await file.exists()) {
      if (!mounted) return;

      setState(() {
        words = [];
      });

      return;
    }

    final parser = ParserFactory.getParser(widget.book.filePath);

    final text = await parser.extract(widget.book.filePath);

    words = text.split(RegExp(r'\s+'));

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final word =
      (words.isEmpty || index >= words.length)
          ? "-"
          : words[index];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Fast Reader"),
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              word,
              style: const TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 40),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _reset,
              ),

              IconButton(
                icon: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 40,
                ),
                onPressed: isPlaying ? _pause : _start,
              ),
            ],
          ),

          const SizedBox(height: 20),

          Text(
            "${index + 1} / ${words.length}",
          ),
        ],
      ),
    );
  }
}