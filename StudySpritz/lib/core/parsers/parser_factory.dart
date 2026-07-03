import 'base_parser.dart';
import 'pdf_parser.dart';
import 'txt_parser.dart';
import 'docx_parser.dart';

class ParserFactory {
  /// Dosya adına veya uzantısına göre doğru parser motorunu seçer
  static BaseParser getParser(String fileName) {
    final lower = fileName.toLowerCase();

    if (lower.endsWith('.pdf')) return PdfParser();
    if (lower.endsWith('.txt')) return TxtParser();
    if (lower.endsWith('.docx')) return DocxParser(); // Yol haritasındaki eksik alan bağlandı
    throw UnsupportedError("Unsupported file type: $fileName");
  }
}