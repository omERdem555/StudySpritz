import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/state/settings_state.dart';
import '../../features/goals/reading_goal_history_screen.dart';
import '../../repositories/reading_goal_repository.dart';

import '../../l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<SettingsState>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = context.watch<SettingsState>();

    if (state.loading || state.settings == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final settings = state.settings!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 20),

          Text(l10n.language),
          DropdownButton<String>(
            value: settings.language,
            items: [
              DropdownMenuItem(
                value: "en",
                child: Text(l10n.english),
              ),
              DropdownMenuItem(
                value: "tr",
                child: Text(l10n.turkish),
              ),
            ],
            onChanged: (v) {
              if (v == null) return;
              state.setLanguage(v);
            },
          ),

          const SizedBox(height: 20),

          Text(l10n.animationSpeed),
          Slider(
            value: settings.animationSpeed.toDouble(),
            min: 1,
            max: 5,
            divisions: 4,
            label: settings.animationSpeed.toString(),
            onChanged: (v) {
              state.setAnimationSpeed(v.toInt());
            },
          ),

          const SizedBox(height: 20),

          Text(l10n.highlightColor),
          DropdownButton<String>(
            value: settings.rsvpHighlightColor,
            items: [
              DropdownMenuItem(value: "yellow", child: Text(l10n.yellow)),
              DropdownMenuItem(value: "green", child: Text(l10n.green)),
              DropdownMenuItem(value: "blue", child: Text(l10n.blue)),
              DropdownMenuItem(value: "red", child: Text(l10n.red)),
            ],
            onChanged: (v) {
              if (v == null) return;
              state.setRsvpColor(v);
            },
          ),
          Text(l10n.theme),

          DropdownButton<String>(
            value: settings.themeMode,
            items: [
              DropdownMenuItem(value: "light", child: Text(l10n.light)),
              DropdownMenuItem(value: "dark", child: Text(l10n.dark)),
              DropdownMenuItem(value: "system", child: Text(l10n.system)),
            ],
            onChanged: (v) {
              if (v == null) return;
              state.setTheme(v);
            },
          ),

          const SizedBox(height: 20),

          Text(l10n.fontSize),
          Slider(
            value: settings.fontSize.toDouble(),
            min: 12,
            max: 28,
            divisions: 16,
            label: settings.fontSize.toString(),
            onChanged: (v) => state.setFontSize(v.toInt()),
          ),

          const SizedBox(height: 20),

          Text(l10n.wpm),
          Slider(
            value: settings.wpmSpeed.toDouble(),
            min: 100,
            max: 600,
            divisions: 50,
            label: settings.wpmSpeed.toString(),
            onChanged: (v) => state.setWpm(v.toInt()),
          ),

          const SizedBox(height: 30),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.history),
            title: Text(l10n.readingGoalHistory),
            subtitle: Text(
              l10n.readingGoalHistorySubtitle,
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ReadingGoalHistoryScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}