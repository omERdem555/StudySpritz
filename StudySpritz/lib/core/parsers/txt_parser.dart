import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'base_parser.dart';

class TxtParser implements BaseParser {
  @override
  Future<String> extract({String? path, Uint8List? bytes}) async {
    // 1. WEB OPTİMİZASYONU: Eğer byte verisi hazır geldiyse doğrudan izole metoda pasla
    if (bytes != null && bytes.isNotEmpty) {
      return await compute(_parseTxtBytes, bytes);
    }
    
    // 2. NATIVE OPTİMİZASYONU: Web'de değilsek ve dosya yolu varsa byte oku ve arka planda parse et
    if (!kIsWeb && path != null && path.isNotEmpty) {
      final file = File(path);
      if (!await file.exists()) return '';
      final fileBytes = await file.readAsBytes();
      return await compute(_parseTxtBytes, fileBytes);
    }

    return '';
  }

  // UI Thread'i bloke etmemek için compute() tarafından çalıştırılacak izole fonksiyon
  static String _parseTxtBytes(Uint8List bytes) {
    try {
      // UTF-8 kodlamasını güvenli şekilde çözer, bozuk karakterlerde çökmez (allowMalformed)
      return utf8.decode(bytes, allowMalformed: true);
    } catch (e) {
      // Eğer dosya Latin-1 veya farklı bir kodlamaysa char codes yapısına geri çekil
      return String.fromCharCodes(bytes);
    }
  }
}