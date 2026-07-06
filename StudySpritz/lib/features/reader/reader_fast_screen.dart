import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studyspritz/models/highlight.dart';
import '../../../core/state/settings_state.dart';
import '../../../core/reading_engine/pagination_engine.dart';
import '../../../models/book.dart';
import '../../../repositories/book_repository.dart';

class ReaderFastScreen extends StatefulWidget {
  final Book book;
  final List<String> words;
  final int initialWordIndex;

  const ReaderFastScreen({
    super.key,
    required this.book,
    required this.words,
    required this.initialWordIndex,
  });

  @override
  State<ReaderFastScreen> createState() => _ReaderFastScreenState();
}

class _ReaderFastScreenState extends State<ReaderFastScreen> {
  int index = 0;
  Timer? timer;
  bool isPlaying = false;
  int wpm = 200;
  int fontSize = 16;

  late final BookRepository _repo;

  @override
  void initState() {
    super.initState();
    _repo = BookRepository();
    index = widget.initialWordIndex.clamp(0, widget.words.isEmpty ? 0 : widget.words.length - 1);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final settings = context.watch<SettingsState>().settings;
    if (settings != null) {
      wpm = settings.wpmSpeed;
      fontSize = settings.fontSize;
    }
  }

  Future<void> _autoSave() async {
    if (widget.words.isEmpty) return;

    // Gerçek dinamik sayfa indeksini hesapla (Düz mantık index eşitlemesi istatistikleri bozuyordu)
    final calculatedPage = PaginationEngine.getPageIndexForWord(widget.words, index, fontSize);

    await _repo.saveReadingSession(
      bookId: widget.book.bookId,
      wordIndex: index,
      pageIndex: calculatedPage,
    );
  }

  void _start() {
    if (widget.words.isEmpty) return;
    timer?.cancel();
    _scheduleTick();
    setState(() => isPlaying = true);
  }

  void _scheduleTick() {
    final intervalMs = (60000 / wpm).round();

    timer = Timer.periodic(
      Duration(milliseconds: intervalMs),
      (_) async {
        if (index >= widget.words.length - 1) {
          await _autoSave();
          _pause();
          return;
        }

        setState(() => index++);

        if (index % 10 == 0) {
          _autoSave();
        }

        _applyOrpDelay(widget.words[index]);
      },
    );
  }

  void _applyOrpDelay(String word) {
    if (word.endsWith('.') || word.endsWith('!') || word.endsWith('?')) {
      _pause();
      Future.delayed(const Duration(milliseconds: 150), () {
        if (mounted && isPlaying == false) _start();
      });
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
    setState(() => wpm += 25); // Daha hissedilir hız artışı
    if (isPlaying) {
      _pause();
      _start();
    }
  }

  void _decreaseWpm() {
    setState(() {
      if (wpm > 50) wpm -= 25;
    });
    if (isPlaying) {
      _pause();
      _start();
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final safeIndex = index.clamp(0, widget.words.isEmpty ? 0 : widget.words.length - 1);
    final word = widget.words.isEmpty ? "-" : widget.words[safeIndex];
    final progress = widget.words.isEmpty ? 0.0 : index / widget.words.length;
    final remaining = widget.words.isEmpty ? 0 : (widget.words.length - index);

    return WillPopScope(
      onWillPop: () async {
        timer?.cancel();
        await _autoSave();
        // Geri çıkarken Klasik Okuma ekranına güncel kelime indeksini teslim et
        Navigator.pop(context, index);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("RSVP Hızlı Okuma"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              timer?.cancel();
              await _autoSave();
              if (mounted) Navigator.pop(context, index);
            },
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LinearProgressIndicator(value: progress),
            const SizedBox(height: 12),
            Text(
              "%${(progress * 100).toStringAsFixed(1)} tamamlandı",
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            Text("Kalan Kelime: $remaining  |  WPM: $wpm", style: TextStyle(color: Colors.grey[600])),
            Expanded(
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  decoration: BoxDecoration(
                    color: //Burada highlight özelliği eklenebilir, örneğin: Colors.yellow[100],
                        Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[800]
                            : Colors.grey[200],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    word,
                    style: TextStyle(
                      fontSize: (fontSize + 20).toDouble(), // RSVP için optimize büyük font
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.refresh, size: 32),
                    onPressed: _reset,
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline, size: 32),
                    onPressed: _decreaseWpm,
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: isPlaying ? _pause : _start,
                    child: CircleAvatar(
                      radius: 36,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        size: 42,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, size: 32),
                    onPressed: _increaseWpm,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}