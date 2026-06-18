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
          const SizedBox(height: 20),

          const Text("Language"),
          DropdownButton<String>(
            value: settings.language,
            items: const [
              DropdownMenuItem(value: "en", child: Text("English")),
              DropdownMenuItem(value: "tr", child: Text("Türkçe")),
            ],
            onChanged: (v) {
              if (v == null) return;
              state.setLanguage(v);
            },
          ),

          const SizedBox(height: 20),

          const Text("Animation Speed"),
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

          const Text("RSVP Highlight Color"),
          DropdownButton<String>(
            value: settings.rsvpHighlightColor,
            items: const [
              DropdownMenuItem(value: "yellow", child: Text("Yellow")),
              DropdownMenuItem(value: "green", child: Text("Green")),
              DropdownMenuItem(value: "blue", child: Text("Blue")),
              DropdownMenuItem(value: "red", child: Text("Red")),
            ],
            onChanged: (v) {
              if (v == null) return;
              state.setRsvpColor(v);
            },
          ),
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