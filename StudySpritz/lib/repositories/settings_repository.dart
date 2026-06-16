import 'package:hive/hive.dart';
import '../models/app_settings.dart';
import '../core/services/hive_service.dart';

class SettingsRepository {
  Box<AppSettings> get _box => HiveService.settingsBox;

  Future<AppSettings?> getSettings() async {
    return _box.get("settings");
  }

  Future<void> saveSettings(AppSettings settings) async {
    await _box.put("settings", settings);
  }
}