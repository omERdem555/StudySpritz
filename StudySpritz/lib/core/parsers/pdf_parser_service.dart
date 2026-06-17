import 'dart:io';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PdfParserService {
  Future<String> extractText(String path) async {
    final file = File(path);
    final bytes = await file.readAsBytes();

    final document = PdfDocument(inputBytes: bytes);
    final extractor = PdfTextExtractor(document);

    final text = extractor.extractText();

    document.dispose();

    return text;
  }
}