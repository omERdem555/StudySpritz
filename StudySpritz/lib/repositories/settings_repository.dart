import 'package:hive/hive.dart';
import '../core/services/hive_service.dart';
import '../models/app_settings.dart';

class SettingsRepository {
  Box<AppSettings> get _box => HiveService.settingsBox;

  static const String _key = "app_settings";

  AppSettings getSettings() {
    final box = HiveService.settingsBox;

    final raw = box.get(_key);
    if (raw == null) {
      final defaults = AppSettings.defaults();
      box.put(_key, defaults);
      return defaults;
    }

    return raw;
  }

  Future<void> updateSettings(AppSettings settings) async {
    await HiveService.settingsBox.put(_key, settings);
  }

  Future<void> saveSettings(AppSettings settings) async {
    await _box.put(_key, settings);
  }

  Future<void> initIfEmpty() async {
    final existing = _box.get(_key);

    if (existing == null) {
      await _box.put(
        _key,
        AppSettings(
          themeMode: "system",
          language: "tr",
          wpmSpeed: 300,
          animationSpeed: 1,
          fontSize: 18,
          rsvpHighlightColor: "blue",
        ),
      );
    }
  }
}