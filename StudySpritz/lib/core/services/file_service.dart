import 'package:file_picker/file_picker.dart';

class FileService {
  static Future<PlatformFile?> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'txt', 'docx'],
    );

    if (result == null || result.files.isEmpty) {
      return null;
    }

    return result.files.first;
  }
}