import 'dart:io';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'base_parser.dart';

class PdfParser implements BaseParser {
  @override
  Future<String> extract(String path) async {
    final file = File(path);
    final bytes = await file.readAsBytes();

    final document = PdfDocument(inputBytes: bytes);
    final extractor = PdfTextExtractor(document);

    final text = extractor.extractText();

    document.dispose();

    return text;
  }
}