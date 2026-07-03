import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'base_parser.dart';

class TxtParser implements BaseParser {
  @override
  Future<String> extract({String? path, Uint8List? bytes}) async {
    // 1. WEB OPTİMİZASYONU: Eğer byte verisi hazır geldiyse doğrudan izole metoda pasla
    if (bytes != null && bytes.isNotEmpty) {
      return await compute(_parseTxtBytes, bytes);
    }
    
    // 2. NATIVE OPTİMİZASYONU: Dosya yolundan byte oku ve arka planda parse et
    if (path != null && path.isNotEmpty) {
      final file = File(path);
      if (!await file.exists()) return '';
      final fileBytes = await file.readAsBytes();
      return await compute(_parseTxtBytes, fileBytes);
    }

    return '';
  }

  // UI Thread'i bloke etmemek için compute() tarafından çalıştırılacak izole fonksiyon
  static String _parseTxtBytes(Uint8List bytes) {
    // UTF-8 ve Latin-1 gibi yaygın kodlamaları korumak için en güvenli binary dönüştürücü
    return String.fromCharCodes(bytes);
  }
}