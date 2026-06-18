import '../core/services/hive_service.dart';
import '../models/app_settings.dart';

class SettingsRepository {
  static const _key = "app_settings";

  AppSettings getSettings() {
    final box = HiveService.settingsBox;

    final existing = box.get(_key);

    if (existing != null) return existing;

    final defaultSettings = AppSettings(
      themeMode: "system",
      language: "tr",
      wpmSpeed: 250,
      animationSpeed: 1,
      fontSize: 16,
      rsvpHighlightColor: "yellow",
    );

    box.put(_key, defaultSettings);
    return defaultSettings;
  }

  Future<void> update(AppSettings settings) async {
    await HiveService.settingsBox.put(_key, settings);
  }

  Future<void> updateTheme(String themeMode) async {
    final current = getSettings();
    await update(current..themeMode = themeMode);
  }

  Future<void> updateFontSize(int size) async {
    final current = getSettings();
    await update(current..fontSize = size);
  }

  Future<void> updateWpm(int wpm) async {
    final current = getSettings();
    await update(current..wpmSpeed = wpm);
  }
}