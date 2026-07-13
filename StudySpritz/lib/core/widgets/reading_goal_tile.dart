import 'package:flutter/material.dart';

import '../../models/reading_goal_history.dart';
import '../../models/reading_goal.dart';

class ReadingGoalTile extends StatelessWidget {
  final ReadingGoalHistory history;

  const ReadingGoalTile({
    super.key,
    required this.history,
  });

  String _goalType() {
    switch (history.goalType) {
      case GoalType.minutes:
        return "Dakika";
      case GoalType.pages:
        return "Sayfa";
      case GoalType.words:
        return "Kelime";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 6,
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              history.isCompleted
                  ? Colors.green
                  : Colors.orange,
          child: Icon(
            history.isCompleted
                ? Icons.check
                : Icons.schedule,
            color: Colors.white,
          ),
        ),
        title: Text(
          "${history.currentValue}/${history.targetValue} ${_goalType()}",
        ),
        subtitle: Text(
          "${history.createdAt.day}.${history.createdAt.month}.${history.createdAt.year}",
        ),
        trailing: history.isCompleted
            ? const Icon(
                Icons.emoji_events,
                color: Colors.amber,
              )
            : null,
      ),
    );
  }
}