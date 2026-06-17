import 'dart:io';
import 'base_parser.dart';

class TxtParser implements BaseParser {
  @override
  Future<String> extract(String path) async {
    final file = File(path);

    if (!await file.exists()) {
      throw Exception("TXT file not found");
    }

    return await file.readAsString();
  }
}