import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'base_parser.dart';

class PdfParser implements BaseParser {
  @override
  Future<String> extract({String? path, Uint8List? bytes}) async {
    // 1. WEB & HAZIR BYTE OPTİMİZASYONU
    if (bytes != null && bytes.isNotEmpty) {
      return await compute(_parsePdfBytes, bytes);
    }

    // 2. NATIVE OPTİMİZASYONU
    if (!kIsWeb && path != null && path.isNotEmpty) {
      final file = File(path);
      if (!await file.exists()) return '';
      final fileBytes = await file.readAsBytes();
      return await compute(_parsePdfBytes, fileBytes);
    }

    return '';
  }

  // UI Thread'i kilitlemeden tamamen arka planda (Isolate) çalışan ayıklama motoru
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