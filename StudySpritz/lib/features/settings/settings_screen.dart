import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/state/settings_state.dart';

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
    final state = context.watch<SettingsState>();

    if (state.loading || state.settings == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final settings = state.settings!;

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("Theme"),

          DropdownButton<String>(
            value: settings.themeMode,
            items: const [
              DropdownMenuItem(value: "light", child: Text("Light")),
              DropdownMenuItem(value: "dark", child: Text("Dark")),
              DropdownMenuItem(value: "system", child: Text("System")),
            ],
            onChanged: (v) {
              if (v == null) return;
              state.setTheme(v);
            },
          ),

          const SizedBox(height: 20),

          const Text("Font Size"),
          Slider(
            value: settings.fontSize.toDouble(),
            min: 12,
            max: 28,
            divisions: 16,
            label: settings.fontSize.toString(),
            onChanged: (v) => state.setFontSize(v.toInt()),
          ),

          const SizedBox(height: 20),

          const Text("WPM"),
          Slider(
            value: settings.wpmSpeed.toDouble(),
            min: 100,
            max: 600,
            divisions: 50,
            label: settings.wpmSpeed.toString(),
            onChanged: (v) => state.setWpm(v.toInt()),
          ),
        ],
      ),
    );
  }
}