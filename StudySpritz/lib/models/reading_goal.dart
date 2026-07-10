import 'package:flutter/foundation.dart';

enum GoalType {
  minutes,
  pages,
  words,
}

@immutable
class ReadingGoal {
  final String goalId;

  final GoalType goalType;

  final int targetValue;

  final int currentValue;

  final bool isCompleted;

  final DateTime createdAt;

  final DateTime? completedAt;

  const ReadingGoal({
    required this.goalId,
    required this.goalType,
    required this.targetValue,
    required this.currentValue,
    required this.isCompleted,
    required this.createdAt,
    this.completedAt,
  });

  factory ReadingGoal.empty() {
    return ReadingGoal(
      goalId: '',
      goalType: GoalType.minutes,
      targetValue: 20,
      currentValue: 0,
      isCompleted: false,
      createdAt: DateTime.now(),
      completedAt: null,
    );
  }

  double get progress {
    if (targetValue == 0) return 0;
    return (currentValue / targetValue).clamp(0.0, 1.0);
  }

  ReadingGoal copyWith({
    String? goalId,
    GoalType? goalType,
    int? targetValue,
    int? currentValue,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return ReadingGoal(
      goalId: goalId ?? this.goalId,
      goalType: goalType ?? this.goalType,
      targetValue: targetValue ?? this.targetValue,
      currentValue: currentValue ?? this.currentValue,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}