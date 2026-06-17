import 'dart:io';

class FileValidationService {
  static Future<bool> exists(String path) async {
    return File(path).exists();
  }

  static bool isSupported(String path) {
    return path.endsWith('.pdf') ||
        path.endsWith('.txt') ||
        path.endsWith('.docx');
  }

  static Future<bool> isReadable(String path) async {
    try {
      await File(path).openRead().first;
      return true;
    } catch (_) {
      return false;
    }
  }
}