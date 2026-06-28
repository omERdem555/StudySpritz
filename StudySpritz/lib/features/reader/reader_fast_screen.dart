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

  int wpm = 200;

  @override
  void initState() {
    super.initState();
    _loadBook();
    _loadWpm();
  }

  void _loadWpm() {
    final settings = context.read<SettingsState>().settings;
    wpm = settings?.wpmSpeed ?? 200;
  }

  void _start() {
    if (words.isEmpty) return;

    timer?.cancel();

    final intervalMs = (60000 / wpm).round();

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

  void _increaseWpm() {
    setState(() {
      wpm += 10;
    });

    if (isPlaying) {
      _start();
    }
  }

  void _decreaseWpm() {
    setState(() {
      if (wpm > 20) wpm -= 10;
    });

    if (isPlaying) {
      _start();
    }
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
    final safeIndex = index.clamp(0, words.isEmpty ? 0 : words.length - 1);
    final word = words.isEmpty ? "-" : words[safeIndex];

    final progress = words.isEmpty ? 0.0 : index / words.length;
    final remaining = words.isEmpty ? 0 : (words.length - index);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Fast Reader"),
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LinearProgressIndicator(value: progress),

          const SizedBox(height: 10),

          Text(
            "%${(progress * 100).toStringAsFixed(1)}",
          ),

          const SizedBox(height: 30),

          Center(
            child: Text(
              word,
              style: const TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 20),

          Text("Kalan kelime: $remaining"),

          const SizedBox(height: 20),

          Text(
            "WPM: $wpm",
            style: const TextStyle(fontSize: 18),
          ),

          const SizedBox(height: 30),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: _decreaseWpm,
              ),

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

              IconButton(
                icon: const Icon(Icons.add),
                onPressed: _increaseWpm,
              ),
            ],
          ),
        ],
      ),
    );
  }
}