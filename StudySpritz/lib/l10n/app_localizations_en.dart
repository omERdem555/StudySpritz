// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'StudySpritz';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get fontSize => 'Font Size';

  @override
  String get wpm => 'WPM';

  @override
  String get animationSpeed => 'Animation Speed';

  @override
  String get highlightColor => 'RSVP Highlight Color';

  @override
  String get bookmarks => 'Bookmarks';

  @override
  String get allBooks => 'All Books';

  @override
  String get searchBookmarks => 'Search bookmarks...';

  @override
  String get page => 'Page';

  @override
  String get delete => 'Delete';

  @override
  String get cancel => 'Cancel';

  @override
  String get deleteBookmark => 'Delete Bookmark';

  @override
  String get deleteBookmarkMessage =>
      'Are you sure you want to delete this bookmark?';

  @override
  String get noBookmarks => 'No bookmarks found.';
}
