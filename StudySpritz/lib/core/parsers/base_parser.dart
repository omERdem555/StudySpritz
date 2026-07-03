import 'dart:typed_data';

abstract class BaseParser {
  /// Platform bağımsız çalışabilmesi için hem [path] hem de [bytes] kabul eder.
  /// Büyük dosyalar arka planda (Isolate) ayrıştırılacağı için metotlar izole parametrelerle beslenir.
  Future<String> extract({String? path, Uint8List? bytes});
}