import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../l10n/app_localizations.dart';

import '../../core/services/hive_service.dart';
import '../../models/reading_goal.dart';
import '../../repositories/reading_goal_repository.dart';

class ReadingGoalsCard extends StatelessWidget {
  const ReadingGoalsCard({super.key});

  String _goalName(
    BuildContext context,
    GoalType type,
  ) {
    final l10n = AppLocalizations.of(context)!;

    switch (type) {
      case GoalType.minutes:
        return l10n.minuteShort;

      case GoalType.pages:
        return l10n.page;

      case GoalType.words:
        return l10n.words;
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
    final l10n = AppLocalizations.of(context)!;
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
                          ? l10n.newGoal
                          : l10n.editGoal,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    DropdownButtonFormField<GoalType>(
                      value: selectedType,
                      decoration: InputDecoration(
                        labelText: l10n.goalType,
                      ),
                      items: GoalType.values.map((e) {
                        return DropdownMenuItem(
                          value: e,
                          child: Text(_goalName(context, e)),
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
                      decoration: InputDecoration(
                        labelText: l10n.goal,
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
                        child: Text(l10n.save),
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

                  Text(
                    AppLocalizations.of(context)!.todayGoal,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    AppLocalizations.of(context)!.noGoalCreated,
                  ),

                  const SizedBox(height: 18),

                  FilledButton.icon(
                    onPressed: () =>
                        _showGoalDialog(context),
                    icon: const Icon(Icons.add),
                    label: Text(AppLocalizations.of(context)!.createGoal),
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

                    Text(
                      AppLocalizations.of(context)!.todayGoal,
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
                  "${goal.currentValue} / ${goal.targetValue} ${_goalName(context, goal.goalType)}",
                  style:
                      const TextStyle(fontSize: 15),
                ),

                if (goal.isCompleted) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        AppLocalizations.of(context)!.goalCompletedLabel,
                      ),
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