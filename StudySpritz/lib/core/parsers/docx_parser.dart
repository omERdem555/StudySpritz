import 'dart:io';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart';
import 'base_parser.dart';
import 'package:xml/xml.dart';

class DocxParser implements BaseParser {
  @override
  Future<String> extract({String? path, Uint8List? bytes}) async {
    // 1. WEB & HAZIR BYTE OPTİMİZASYONU
    if (bytes != null && bytes.isNotEmpty) {
      return await compute(_parseDocxBytes, bytes);
    }

    // 2. NATIVE OPTİMİZASYONU
    if (!kIsWeb && path != null && path.isNotEmpty) {
      final file = File(path);
      if (!await file.exists()) return '';
      final fileBytes = await file.readAsBytes();
      return await compute(_parseDocxBytes, fileBytes);
    }

    return '';
  }

  // Arka planda çalışan DOCX / XML parser motoru
  static String _parseDocxBytes(Uint8List bytes) {
    try {
      final archive = ZipDecoder().decodeBytes(bytes);
      
      // word/document.xml dosyasını bul
      final documentFile = archive.files.firstWhere(
        (f) => f.name == 'word/document.xml',
        orElse: () => throw Exception('Invalid DOCX format'),
      );

      final documentXml = documentFile.content as List<int>;
      final xmlString = String.fromCharCodes(documentXml);

      // XML etiketlerini temizleyip sadece ham metni çıkarmak için xml kütüphanesini kullanıyoruz
      final document = XmlDocument.parse(xmlString);
      
      // w:t etiketleri Microsoft Word içindeki gerçek metin bloklarını temsil eder
      final textNodes = document.findAllElements('w:t');
      return textNodes.map((node) => node.innerText).join(' ');
    } catch (e) {
      return 'DOCX Parse Error: ${e.toString()}';
    }
  }
}