import 'package:flutter/foundation.dart';

import 'reading_goal.dart';

@immutable
class ReadingGoalHistory {
  final String historyId;

  final String goalId;

  final GoalType goalType;

  final int targetValue;

  final int currentValue;

  final bool isCompleted;

  final DateTime createdAt;

  final DateTime? completedAt;

  const ReadingGoalHistory({
    required this.historyId,
    required this.goalId,
    required this.goalType,
    required this.targetValue,
    required this.currentValue,
    required this.isCompleted,
    required this.createdAt,
    required this.completedAt,
  });

  factory ReadingGoalHistory.fromGoal(
    ReadingGoal goal,
  ) {
    return ReadingGoalHistory(
      historyId:
          "${goal.goalId}_${goal.createdAt.millisecondsSinceEpoch}",
      goalId: goal.goalId,
      goalType: goal.goalType,
      targetValue: goal.targetValue,
      currentValue: goal.currentValue,
      isCompleted: goal.isCompleted,
      createdAt: goal.createdAt,
      completedAt: goal.completedAt,
    );
  }
}