import 'base_parser.dart';
import 'pdf_parser.dart';
import 'txt_parser.dart';
import 'docx_parser.dart';

class ParserFactory {
  static BaseParser getParser(String filePath) {
    final ext = filePath.split('.').last.toLowerCase();

    switch (ext) {
      case 'txt':
        return TxtParser();
      case 'pdf':
        return PdfParser();
      case 'docx':
        return DocxParser();
      default:
        throw Exception("Unsupported file type: $ext");
    }
  }
}