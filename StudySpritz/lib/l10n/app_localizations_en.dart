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
  String get home => 'Home';

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

  @override
  String get remainingWords => 'Remaining Words';

  @override
  String get remainingTime => 'Remaining Time';

  @override
  String get hourShort => 'hr';

  @override
  String get minuteShort => 'min';

  @override
  String get secondShort => 'sec';

  @override
  String get library => 'Library';

  @override
  String get searchBooks => 'Search books...';

  @override
  String libraryDeleteMessage(Object bookName) {
    return 'Delete \"$bookName\"? This action cannot be undone.';
  }

  @override
  String get favorites => 'Favorites';

  @override
  String get readingStatistics => 'Reading Statistics';

  @override
  String get bookInformation => 'Book Information';

  @override
  String get bookNotFound => 'Book not found.';

  @override
  String get noReadingStatistics =>
      'No reading statistics are available for this book yet.';

  @override
  String get file => 'File';

  @override
  String get addedDate => 'Added';

  @override
  String get lastOpened => 'Last Opened';

  @override
  String get totalPages => 'Total Pages';

  @override
  String get totalWords => 'Total Words';

  @override
  String get progress => 'Progress';

  @override
  String get totalReadingTime => 'Total Reading Time';

  @override
  String get totalWordsRead => 'Total Words Read';

  @override
  String get totalPagesRead => 'Total Pages Read';

  @override
  String get totalSessions => 'Total Sessions';

  @override
  String get averageSpeed => 'Average Speed';

  @override
  String get peakSpeed => 'Peak Speed';

  @override
  String get firstRead => 'First Read';

  @override
  String get lastRead => 'Last Read';

  @override
  String get noReadingGoalHistory => 'No reading goal history yet.';

  @override
  String get todayGoal => 'Today\'s Goal';

  @override
  String get newGoal => 'New Goal';

  @override
  String get editGoal => 'Edit Goal';

  @override
  String get goalType => 'Goal Type';

  @override
  String get goal => 'Goal';

  @override
  String get createGoal => 'Create Goal';

  @override
  String get goalCompletedLabel => 'Goal completed';

  @override
  String get minutes => 'Minutes';

  @override
  String get pages => 'Pages';

  @override
  String get noGoalCreated => 'No goal has been created yet.';
}
