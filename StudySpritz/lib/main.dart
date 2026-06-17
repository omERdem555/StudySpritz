import 'package:flutter/material.dart';
import 'core/reading_engine/progress_calculator.dart';
import 'core/reading_engine/reader_state.dart';
import 'core/reading_engine/pagination_engine.dart';
import 'core/reading_engine/reader_engine.dart';
import 'core/reading/reading_engine.dart';
import 'core/parsers/parser_factory.dart';
import 'core/services/file_validation_service.dart';
import 'core/services/book_creation_service.dart';
import 'core/parsers/pdf_parser_service.dart';
import 'core/services/hive_service.dart';
import 'core/services/file_service.dart';
import 'repositories/statistics_repository.dart';
import 'repositories/bookmark_repository.dart';
import 'repositories/settings_repository.dart';
import 'repositories/book_repository.dart';
import 'models/reading_statistics.dart';
import 'models/app_settings.dart';
import 'models/bookmark.dart';
import 'models/book.dart';
import 'core/router/app_router.dart';

import 'features/reader/reader_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();
  runApp(const MaterialApp(
    home: ReaderScreen(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter.router,
      title: 'StudySpritz',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}