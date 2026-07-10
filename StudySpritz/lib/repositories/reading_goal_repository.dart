import 'package:uuid/uuid.dart';

import '../core/services/hive_service.dart';
import '../models/reading_goal.dart';

class ReadingGoalRepository {
  static const String todayGoalKey = 'today_goal';

  Future<ReadingGoal?> getTodayGoal() async {
    return HiveService.readingGoalsBox.get(todayGoalKey);
  }

  Future<void> createGoal({
    required GoalType goalType,
    required int targetValue,
  }) async {
    final goal = ReadingGoal(
      goalId: const Uuid().v4(),
      goalType: goalType,
      targetValue: targetValue,
      currentValue: 0,
      isCompleted: false,
      createdAt: DateTime.now(),
      completedAt: null,
    );

    await HiveService.readingGoalsBox.put(
      todayGoalKey,
      goal,
    );
  }

  Future<void> updateProgress(int value) async {
    final goal = await getTodayGoal();

    if (goal == null) return;

    if (goal.isCompleted) return;

    final progress = goal.currentValue + value;

    final completed = progress >= goal.targetValue;

    await HiveService.readingGoalsBox.put(
      todayGoalKey,
      goal.copyWith(
        currentValue: progress,
        isCompleted: completed,
        completedAt: completed ? DateTime.now() : null,
      ),
    );
  }

  Future<void> resetForNextDay() async {
    await HiveService.readingGoalsBox.delete(todayGoalKey);
  }

  Future<void> deleteGoal() async {
    await HiveService.readingGoalsBox.delete(todayGoalKey);
  }
}