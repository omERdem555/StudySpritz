import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../core/services/hive_service.dart';
import '../../models/reading_goal.dart';
import '../../repositories/reading_goal_repository.dart';

class ReadingGoalsCard extends StatelessWidget {
  const ReadingGoalsCard({super.key});

  String _goalName(GoalType type) {
    switch (type) {
      case GoalType.minutes:
        return "Dakika";
      case GoalType.pages:
        return "Sayfa";
      case GoalType.words:
        return "Kelime";
    }
  }

  IconData _goalIcon(GoalType type) {
    switch (type) {
      case GoalType.minutes:
        return Icons.schedule;
      case GoalType.pages:
        return Icons.menu_book;
      case GoalType.words:
        return Icons.text_fields;
    }
  }

  Future<void> _showGoalDialog(
    BuildContext context, {
    ReadingGoal? currentGoal,
  }) async {
    GoalType selectedType =
        currentGoal?.goalType ?? GoalType.minutes;

    final controller = TextEditingController(
      text: currentGoal?.targetValue.toString() ?? "20",
    );

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.60,
          child: StatefulBuilder(
            builder: (context, setState) {
              return Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                ),
                child: Column(
                  children: [
                    Text(
                      currentGoal == null
                          ? "Yeni Hedef"
                          : "Hedefi Düzenle",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    DropdownButtonFormField<GoalType>(
                      value: selectedType,
                      decoration: const InputDecoration(
                        labelText: "Hedef Türü",
                      ),
                      items: GoalType.values.map((e) {
                        return DropdownMenuItem(
                          value: e,
                          child: Text(_goalName(e)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() {
                          selectedType = value;
                        });
                      },
                    ),

                    const SizedBox(height: 18),

                    TextField(
                      controller: controller,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Hedef",
                      ),
                    ),

                    const Spacer(),

                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () async {
                          final target =
                              int.tryParse(controller.text);

                          if (target == null || target <= 0) {
                            return;
                          }

                          final repo = ReadingGoalRepository();

                          await repo.deleteGoal();

                          await repo.createGoal(
                            goalType: selectedType,
                            targetValue: target,
                          );

                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        },
                        child: const Text("Kaydet"),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable:
          HiveService.readingGoalsBox.listenable(),
      builder: (context, box, _) {

        final ReadingGoal? goal =
            box.get(ReadingGoalRepository.todayGoalKey);

        if (goal == null) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  const Text(
                    "Bugünkü Hedef",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    "Henüz hedef oluşturulmadı.",
                  ),

                  const SizedBox(height: 18),

                  FilledButton.icon(
                    onPressed: () =>
                        _showGoalDialog(context),
                    icon: const Icon(Icons.add),
                    label: const Text("Hedef Oluştur"),
                  ),
                ],
              ),
            ),
          );
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [

                Row(
                  children: [

                    Icon(_goalIcon(goal.goalType)),

                    const SizedBox(width: 8),

                    const Text(
                      "Bugünkü Hedef",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const Spacer(),

                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () =>
                          _showGoalDialog(
                            context,
                            currentGoal: goal,
                          ),
                    ),

                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        await ReadingGoalRepository()
                            .deleteGoal();
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                LinearProgressIndicator(
                  value: goal.progress,
                ),

                const SizedBox(height: 12),

                Text(
                  "${goal.currentValue} / ${goal.targetValue} ${_goalName(goal.goalType)}",
                  style:
                      const TextStyle(fontSize: 15),
                ),

                if (goal.isCompleted) ...[
                  const SizedBox(height: 12),
                  const Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                      SizedBox(width: 8),
                      Text("Hedef tamamlandı"),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}