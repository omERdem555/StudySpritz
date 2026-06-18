import 'package:flutter/foundation.dart';
import '../../models/app_settings.dart';
import '../../repositories/settings_repository.dart';

class SettingsState extends ChangeNotifier {
  final SettingsRepository _repo = SettingsRepository();

  AppSettings? _settings;
  AppSettings? get settings => _settings;

  bool _loading = false;
  bool get loading => _loading;

  Future<void> load() async {
    _loading = true;
    notifyListeners();

    _settings = await _repo.getSettings();

    // ilk açılış default fix
    _settings ??= AppSettings(
      themeMode: "system",
      language: "en",
      wpmSpeed: 250,
      animationSpeed: 1,
      fontSize: 18,
      rsvpHighlightColor: "yellow",
    );

    await _repo.saveSettings(_settings!);

    _loading = false;
    notifyListeners();
  }

  Future<void> update(AppSettings newSettings) async {
    _settings = newSettings;
    notifyListeners();

    await _repo.saveSettings(_settings!);
  }

  Future<void> setTheme(String theme) async {
    if (_settings == null) return;

    await update(_settings!.copyWith(themeMode: theme));
  }

  Future<void> setFontSize(int size) async {
    if (_settings == null) return;

    await update(_settings!.copyWith(fontSize: size));
  }

  Future<void> setWpm(int wpm) async {
    if (_settings == null) return;

    await update(_settings!.copyWith(wpmSpeed: wpm));
  }

  Future<void> setLanguage(String lang) async {
    if (_settings == null) return;

    await update(_settings!.copyWith(language: lang));
  }

  Future<void> setAnimationSpeed(int speed) async {
    if (_settings == null) return;

    await update(_settings!.copyWith(animationSpeed: speed));
  }

  Future<void> setRsvpColor(String color) async {
    if (_settings == null) return;

    await update(_settings!.copyWith(rsvpHighlightColor: color));
  }
}