import 'package:flutter/material.dart';

class ReadingStatisticsScreen extends StatelessWidget {
  final String bookId;

  const ReadingStatisticsScreen({
    super.key,
    required this.bookId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Okuma İstatistikleri"),
      ),
      body: Center(
        child: Text(
          "Book ID:\n$bookId",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}