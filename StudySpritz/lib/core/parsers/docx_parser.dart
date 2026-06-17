import 'dart:io';
import 'package:archive/archive.dart';
import 'base_parser.dart';

class DocxParser implements BaseParser {
  @override
  Future<String> extract(String path) async {
    final bytes = File(path).readAsBytesSync();
    final archive = ZipDecoder().decodeBytes(bytes);

    final documentXml = archive.files
        .firstWhere((f) => f.name == 'word/document.xml')
        .content as List<int>;

    return String.fromCharCodes(documentXml);
  }
}