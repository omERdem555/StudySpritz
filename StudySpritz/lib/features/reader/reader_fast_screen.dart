import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/state/settings_state.dart';
import '../../core/parsers/parser_factory.dart';
import '../../models/book.dart';
import '../../repositories/book_repository.dart';

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

  late final BookRepository _repo;

  @override
  void initState() {
    super.initState();
    _repo = BookRepository();
    _loadBook();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final settings = context.watch<SettingsState>().settings;
    if (settings != null) {
      wpm = settings.wpmSpeed;
    }
  }

  // =========================
  // OTURUM RESTORE
  // =========================
  Future<void> _loadBook() async {
    final file = File(widget.book.filePath);

    if (!await file.exists()) {
      if (!mounted) return;

      setState(() => words = []);
      return;
    }

    final parser = ParserFactory.getParser(widget.book.filePath);
    // Web ve Native uyumlu, isimlendirilmiş parametre kullanımı
    final text = await parser.extract(
      path: widget.book.filePath,
      bytes: widget.book.bytes,
    );

    words = text.split(RegExp(r'\s+'));

    final lastIndex = await _repo.getLastWordIndex(widget.book.bookId);

    if (mounted) {
      setState(() {
        index = lastIndex.clamp(0, words.length - 1);
      });
    }
  }

  // =========================
  // AUTO SAVE CORE
  // =========================
  Future<void> _autoSave() async {
    if (words.isEmpty) return;

    await _repo.saveReadingSession(
      bookId: widget.book.bookId,
      wordIndex: index,
      pageIndex: index, // fast mode = word-based page
    );
  }

  void _start() {
    if (words.isEmpty) return;

    timer?.cancel();

    _scheduleTick();
    setState(() => isPlaying = true);
  }

  void _scheduleTick() {
    final intervalMs = (60000 / wpm).round();

    timer = Timer.periodic(
      Duration(milliseconds: intervalMs),
      (_) async {
        if (index >= words.length - 1) {
          await _autoSave();
          _pause();
          return;
        }

        setState(() => index++);

        // auto persist
        if (index % 5 == 0) {
          _autoSave();
        }

        _applyOrpDelay(words[index]);
      },
    );
  }

  void _applyOrpDelay(String word) {
    if (word.endsWith('.') ||
        word.endsWith('!') ||
        word.endsWith('?')) {
      _pause();
      Future.delayed(const Duration(milliseconds: 120), _start);
    }
  }

  void _pause() {
    timer?.cancel();
    setState(() => isPlaying = false);

    _autoSave();
  }

  void _reset() async {
    timer?.cancel();

    setState(() {
      index = 0;
      isPlaying = false;
    });

    await _repo.resetProgress(widget.book.bookId);
  }

  void _increaseWpm() {
    setState(() => wpm += 10);

    if (isPlaying) {
      _pause();
      _start();
    }
  }

  void _decreaseWpm() {
    setState(() {
      if (wpm > 20) wpm -= 10;
    });

    if (isPlaying) {
      _pause();
      _start();
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    _autoSave();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final safeIndex =
        index.clamp(0, words.isEmpty ? 0 : words.length - 1);

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

          const SizedBox(height: 8),

          Text("%${(progress * 100).toStringAsFixed(1)}"),
          Text("Kalan: $remaining"),
          Text("WPM: $wpm"),

          const SizedBox(height: 40),

          Expanded(
            child: Center(
              child: Text(
                word,
                style: const TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

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