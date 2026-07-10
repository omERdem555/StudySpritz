import 'package:uuid/uuid.dart';

import '../core/services/hive_service.dart';
import '../models/reading_goal.dart';

class ReadingGoalRepository {
  static const String todayGoalKey = 'today_goal';

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }

  Future<void> validateTodayGoal() async {
    final ReadingGoal? goal =
        HiveService.readingGoalsBox.get(todayGoalKey);

    if (goal == null) return;

    if (_isSameDay(goal.createdAt, DateTime.now())) {
      return;
    }

    await deleteGoal();
  }

  Future<ReadingGoal?> getTodayGoal() async {
    await validateTodayGoal();

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

  Future<bool> updateProgress(int value) async {
    final goal = await getTodayGoal();

    if (goal == null) return false;

    if (goal.isCompleted) return false;

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

    return completed;
  }
  Future<void> resetForNextDay() async {
    await HiveService.readingGoalsBox.delete(todayGoalKey);
  }

  Future<void> deleteGoal() async {
    await HiveService.readingGoalsBox.delete(todayGoalKey);
  }
}