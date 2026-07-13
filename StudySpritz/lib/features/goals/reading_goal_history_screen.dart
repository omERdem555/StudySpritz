import 'package:flutter/material.dart';

import '../../core/services/hive_service.dart';
import '../../models/reading_goal_history.dart';
import '../../core/widgets/reading_goal_tile.dart';

class ReadingGoalHistoryScreen extends StatelessWidget {
  const ReadingGoalHistoryScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<ReadingGoalHistory> history =
        HiveService.readingGoalHistoryBox.values.toList()
          ..sort(
            (a, b) => b.createdAt.compareTo(a.createdAt),
          );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Reading Goal History"),
      ),
      body: history.isEmpty
          ? const Center(
              child: Text(
                "No history yet.",
              ),
            )
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                return ReadingGoalTile(
                  history: history[index],
                );
              },
            ),
    );
  }
}