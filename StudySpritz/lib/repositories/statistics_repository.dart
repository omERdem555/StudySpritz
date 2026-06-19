import 'package:hive/hive.dart';

import '../core/services/hive_service.dart';
import '../models/app_settings.dart';

class SettingsRepository {
  static const String _key = "app_settings";

  Box<AppSettings> get _box => HiveService.settingsBox;

  AppSettings getSettings() {
    final existing = _box.get(_key);

    if (existing != null) {
      return existing;
    }

    final defaults = AppSettings.defaults();

    _box.put(_key, defaults);

    return defaults;
  }

  Future<void> saveSettings(
    AppSettings settings,
  ) async {
    await _box.put(_key, settings);
  }

  Future<void> initIfEmpty() async {
    if (_box.get(_key) != null) return;

    await _box.put(
      _key,
      AppSettings.defaults(),
    );
  }
}