import 'base_parser.dart';
import 'pdf_parser.dart';
import 'txt_parser.dart';
import 'docx_parser.dart';

class ParserFactory {
  static BaseParser getParser(String path) {
    final lower = path.toLowerCase();

    if (lower.endsWith('.pdf')) return PdfParser();
    if (lower.endsWith('.txt')) return TxtParser();
    if (lower.endsWith('.docx')) return DocxParser();

    throw UnsupportedError("Unsupported file type");
  }
}