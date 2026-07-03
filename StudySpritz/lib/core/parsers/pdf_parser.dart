import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'base_parser.dart';

class PdfParser implements BaseParser {
  @override
  Future<String> extract({String? path, Uint8List? bytes}) async {
    if (bytes != null && bytes.isNotEmpty) {
      return await compute(_parsePdfBytes, bytes);
    }

    if (path != null && path.isNotEmpty) {
      final file = File(path);
      if (!await file.exists()) return '';
      final fileBytes = await file.readAsBytes();
      return await compute(_parsePdfBytes, fileBytes);
    }

    return '';
  }

  static String _parsePdfBytes(Uint8List bytes) {
    try {
      final document = PdfDocument(inputBytes: bytes);
      final extractor = PdfTextExtractor(document);
      final text = extractor.extractText();
      document.dispose();
      return text;
    } catch (e) {
      return 'PDF Parse Error: ${e.toString()}';
    }
  }
}