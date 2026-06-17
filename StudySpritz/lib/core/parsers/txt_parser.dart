import 'dart:io';
import 'base_parser.dart';

class TxtParser implements BaseParser {
  @override
  Future<String> extract(String path) async {
    return await File(path).readAsString();
  }
}