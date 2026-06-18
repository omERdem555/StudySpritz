import 'package:flutter/foundation.dart';
import '../../models/app_settings.dart';
import '../../repositories/settings_repository.dart';

class SettingsState extends ChangeNotifier {
  final SettingsRepository _repo = SettingsRepository();

  AppSettings? _settings;
  AppSettings? get settings => _settings;

  bool _loading = false;
  bool get loading => _loading;

  bool get isReady => _settings != null;

  Future<void> load() async {
    _loading = true;
    notifyListeners();

    _settings = await _repo.getSettings();

    if (_settings == null) {
      await _repo.initIfEmpty();
      _settings = await _repo.getSettings();
    }

    _loading = false;
    notifyListeners();
  }
    
  Future<void> update(AppSettings newSettings) async {
    _settings = newSettings;
    notifyListeners();
    await _repo.updateSettings(newSettings);
  }

  AppSettings get requireSettings {
    final s = _settings;
    if (s == null) {
      throw Exception("Settings not initialized. Call load() first.");
    }
    return s;
  }

  Future<void> setTheme(String theme) async {
    final s = requireSettings;

    await update(
      AppSettings(
        themeMode: theme,
        language: s.language,
        wpmSpeed: s.wpmSpeed,
        animationSpeed: s.animationSpeed,
        fontSize: s.fontSize,
        rsvpHighlightColor: s.rsvpHighlightColor,
      ),
    );
  }

  Future<void> setFontSize(int size) async {
    final s = requireSettings;

    await update(
      AppSettings(
        themeMode: s.themeMode,
        language: s.language,
        wpmSpeed: s.wpmSpeed,
        animationSpeed: s.animationSpeed,
        fontSize: size,
        rsvpHighlightColor: s.rsvpHighlightColor,
      ),
    );
  }

  Future<void> setWpm(int wpm) async {
    final s = requireSettings;

    await update(
      AppSettings(
        themeMode: s.themeMode,
        language: s.language,
        wpmSpeed: wpm,
        animationSpeed: s.animationSpeed,
        fontSize: s.fontSize,
        rsvpHighlightColor: s.rsvpHighlightColor,
      ),
    );
  }
}