import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';

import '../../../repositories/book_repository.dart';
import '../../../repositories/reading_goal_repository.dart';
import '../../../core/state/settings_state.dart';
import '../../../core/reading_engine/pagination_engine.dart';
import '../../../models/reading_goal.dart';
import '../../../models/app_settings.dart'; // AppSettings importu eklendi
import '../../../models/book.dart';

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
  DateTime? sessionStartedAt;

  int startWordIndex = 0;
  int startPageIndex = 0;

  late final BookRepository _repo;

  @override
  void initState() {
    super.initState();
    _repo = BookRepository();
    index = widget.initialWordIndex.clamp(
      0,
      widget.words.isEmpty ? 0 : widget.words.length - 1,
    );

    startWordIndex = index;

    startPageIndex = PaginationEngine.getPageIndexForWord(
      widget.words,
      index,
      fontSize,
    );

    sessionStartedAt = DateTime.now();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final settings = context.watch<SettingsState>().settings;
    if (settings != null) {
      wpm = settings.wpmSpeed;
      fontSize = settings.fontSize;

      startPageIndex = PaginationEngine.getPageIndexForWord(
        widget.words,
        startWordIndex,
        fontSize,
      );
    }
  }

  Future<void> _autoSave() async {
    if (widget.words.isEmpty) return;

    final calculatedPage = PaginationEngine.getPageIndexForWord(widget.words, index, fontSize);

    await _repo.saveReadingSession(
      bookId: widget.book.bookId,
      wordIndex: index,
      pageIndex: calculatedPage,
    );

    await _updateGoalProgress();
  }

  Future<void> _updateGoalProgress() async {
    final l10n = AppLocalizations.of(context)!;

    if (sessionStartedAt == null) return;

    final durationSeconds =
        DateTime.now().difference(sessionStartedAt!).inSeconds;

    if (durationSeconds < 5) return;

    final goalRepository = ReadingGoalRepository();
    final goal = await goalRepository.getTodayGoal();

    if (goal == null) return;

    bool completedNow = false;

    switch (goal.goalType) {
      case GoalType.minutes:
        completedNow = await goalRepository.updateProgress(
          (durationSeconds / 60).floor(),
        );
        break;

      case GoalType.pages:
        final currentPage = PaginationEngine.getPageIndexForWord(
          widget.words,
          index,
          fontSize,
        );

        final pagesRead =
            (currentPage - startPageIndex).abs();

        completedNow = await goalRepository.updateProgress(
          pagesRead,
        );
        break;

      case GoalType.words:
        final wordsRead =
            (index - startWordIndex).abs();

        completedNow = await goalRepository.updateProgress(
          wordsRead,
        );
        break;
    }

    startWordIndex = index;

    startPageIndex = PaginationEngine.getPageIndexForWord(
      widget.words,
      index,
      fontSize,
    );

    sessionStartedAt = DateTime.now();

    if (!mounted || !completedNow) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
        content: Row(
          children: [
            Icon(
              Icons.celebration,
              color: Colors.white,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                l10n.goalCompleted,
              )
            ),
          ],
        ),
      ),
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
    setState(() => wpm += 25); 
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
    final l10n = AppLocalizations.of(context)!;
    
    final safeIndex = index.clamp(0, widget.words.isEmpty ? 0 : widget.words.length - 1);
    final word = widget.words.isEmpty ? "-" : widget.words[safeIndex];
    final progress = widget.words.isEmpty ? 0.0 : index / widget.words.length;
    final remaining = widget.words.isEmpty ? 0 : (widget.words.length - index);
    final remainingSeconds =
        remaining == 0 ? 0 : ((remaining / wpm) * 60).ceil();

    final remainingMinutes = remainingSeconds ~/ 60;
    final remainingRemainderSeconds = remainingSeconds % 60;

    final currentSettings = context.watch<SettingsState>().settings ?? AppSettings.defaults();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    final highlightColor = _getHighlightColor(currentSettings.rsvpHighlightColor, isDark: isDarkMode);

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        timer?.cancel();
        await _autoSave();
        Navigator.pop(context, index);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.book.bookName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
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
              "${(progress * 100).toStringAsFixed(1)}%",
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            Text(
              "${l10n.remainingWords}: $remaining"
              "  |  "
              "${l10n.wpm}: $wpm"
              "\n${l10n.remainingTime}: "
              "${remainingMinutes.toString().padLeft(2, '0')} ${l10n.minuteShort} "
              "${remainingRemainderSeconds.toString().padLeft(2, '0')} ${l10n.secondShort}",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            Expanded(
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  decoration: BoxDecoration(
                    color: highlightColor.withOpacity(isDarkMode ? 0.25 : 0.20),
                    borderRadius: BorderRadius.circular(16),
                    // Hatalı 'Border.solidColor' ifadesi Border.all ile düzeltildi
                    border: Border.all(color: highlightColor.withOpacity(0.5), width: 1.5),
                  ),
                  child: Text(
                    word,
                    style: TextStyle(
                      fontSize: (fontSize + 20).toDouble(),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: isDarkMode ? Colors.white : Colors.black87,
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

  Color _getHighlightColor(String colorName, {bool isDark = false}) {
    switch (colorName) {
      case 'yellow':
        return isDark ? Colors.amber.shade700 : Colors.amber.shade300;
      case 'green':
        return isDark ? Colors.green.shade600 : Colors.green.shade300;
      case 'red':
        return isDark ? Colors.red.shade600 : Colors.red.shade300;
      case 'blue':
      default:
        return isDark ? Colors.blue.shade600 : Colors.blue.shade300;
    }
  }
}