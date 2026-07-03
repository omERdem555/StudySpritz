import 'package:hive/hive.dart';
import '../core/services/hive_service.dart';
import '../models/app_settings.dart';

class SettingsRepository {
  Box<AppSettings> get _box => HiveService.settingsBox;
  static const String _key = "app_settings";

  AppSettings getSettings() {
    final raw = _box.get(_key);
    if (raw == null) {
      final defaults = AppSettings.defaults();
      _box.put(_key, defaults);
      return defaults;
    }
    return raw;
  }

  Future<void> updateSettings(AppSettings settings) async {
    await _box.put(_key, settings);
  }

  Future<void> saveSettings(AppSettings settings) async {
    await _box.put(_key, settings);
  }

  Future<void> initIfEmpty() async {
    final existing = _box.get(_key);
    if (existing == null) {
      // Çelişki giderildi, tek merkezden varsayılan değerler çekiliyor
      await _box.put(_key, AppSettings.defaults());
    }
  }
}