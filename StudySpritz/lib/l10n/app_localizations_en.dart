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

  @override
  String get readingGoalHistory => 'Reading Goal History';

  @override
  String get readingGoalHistorySubtitle =>
      'View completed and previous daily goals';

  @override
  String get english => 'English';

  @override
  String get turkish => 'Turkish';

  @override
  String get yellow => 'Yellow';

  @override
  String get green => 'Green';

  @override
  String get blue => 'Blue';

  @override
  String get red => 'Red';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get system => 'System';

  @override
  String get book => 'Book';

  @override
  String get unknownBook => 'Unknown Book';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get recentBooks => 'Recently Read';

  @override
  String get emptyLibrary => 'Library is empty';

  @override
  String get favoriteBooks => 'Favorites';

  @override
  String get noFavorites => 'No favorite books yet';

  @override
  String get statistics => 'Statistics';

  @override
  String get favorite => 'Favorite';

  @override
  String get completed => 'Completed';

  @override
  String get session => 'Session';

  @override
  String get duration => 'Duration';

  @override
  String get words => 'Words';

  @override
  String get averageWpm => 'Avg WPM';

  @override
  String get peakWpm => 'Peak WPM';

  @override
  String get addBook => 'Add Book';

  @override
  String get deleteBook => 'Delete Book';

  @override
  String deleteBookMessage(Object bookName) {
    return '\"$bookName\" will be removed from your library together with all progress. Are you sure?';
  }

  @override
  String bookDeleted(Object bookName) {
    return '\"$bookName\" deleted successfully.';
  }

  @override
  String bookAdded(Object bookName) {
    return '\"$bookName\" added to library.';
  }

  @override
  String bookAddError(Object error) {
    return 'Error while adding book: $error';
  }

  @override
  String get reader => 'Reader';

  @override
  String get fileNotFound => 'File Not Found';

  @override
  String get fileNotFoundMessage =>
      'The original book file is not available on this device.';

  @override
  String get bookLoadFailed => 'Failed to load book.';

  @override
  String get addBookmark => 'Add Bookmark';

  @override
  String get optionalNote => 'Optional note...';

  @override
  String get save => 'Save';

  @override
  String get bookmarkSaved => 'Bookmark saved.';

  @override
  String get goalCompleted =>
      '🎉 Congratulations! You completed today\'s reading goal.';
}
