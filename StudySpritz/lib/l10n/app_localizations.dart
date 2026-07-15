import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'StudySpritz'**
  String get appName;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @fontSize.
  ///
  /// In en, this message translates to:
  /// **'Font Size'**
  String get fontSize;

  /// No description provided for @wpm.
  ///
  /// In en, this message translates to:
  /// **'WPM'**
  String get wpm;

  /// No description provided for @animationSpeed.
  ///
  /// In en, this message translates to:
  /// **'Animation Speed'**
  String get animationSpeed;

  /// No description provided for @highlightColor.
  ///
  /// In en, this message translates to:
  /// **'RSVP Highlight Color'**
  String get highlightColor;

  /// No description provided for @bookmarks.
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get bookmarks;

  /// No description provided for @allBooks.
  ///
  /// In en, this message translates to:
  /// **'All Books'**
  String get allBooks;

  /// No description provided for @searchBookmarks.
  ///
  /// In en, this message translates to:
  /// **'Search bookmarks...'**
  String get searchBookmarks;

  /// No description provided for @page.
  ///
  /// In en, this message translates to:
  /// **'Page'**
  String get page;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @deleteBookmark.
  ///
  /// In en, this message translates to:
  /// **'Delete Bookmark'**
  String get deleteBookmark;

  /// No description provided for @deleteBookmarkMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this bookmark?'**
  String get deleteBookmarkMessage;

  /// No description provided for @noBookmarks.
  ///
  /// In en, this message translates to:
  /// **'No bookmarks found.'**
  String get noBookmarks;

  /// No description provided for @readingGoalHistory.
  ///
  /// In en, this message translates to:
  /// **'Reading Goal History'**
  String get readingGoalHistory;

  /// No description provided for @readingGoalHistorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'View completed and previous daily goals'**
  String get readingGoalHistorySubtitle;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @turkish.
  ///
  /// In en, this message translates to:
  /// **'Turkish'**
  String get turkish;

  /// No description provided for @yellow.
  ///
  /// In en, this message translates to:
  /// **'Yellow'**
  String get yellow;

  /// No description provided for @green.
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get green;

  /// No description provided for @blue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get blue;

  /// No description provided for @red.
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get red;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// Book filter label
  ///
  /// In en, this message translates to:
  /// **'Book'**
  String get book;

  /// Unknown book placeholder
  ///
  /// In en, this message translates to:
  /// **'Unknown Book'**
  String get unknownBook;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @recentBooks.
  ///
  /// In en, this message translates to:
  /// **'Recently Read'**
  String get recentBooks;

  /// No description provided for @emptyLibrary.
  ///
  /// In en, this message translates to:
  /// **'Library is empty'**
  String get emptyLibrary;

  /// No description provided for @favoriteBooks.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favoriteBooks;

  /// No description provided for @noFavorites.
  ///
  /// In en, this message translates to:
  /// **'No favorite books yet'**
  String get noFavorites;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @favorite.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get favorite;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @session.
  ///
  /// In en, this message translates to:
  /// **'Session'**
  String get session;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @words.
  ///
  /// In en, this message translates to:
  /// **'Words'**
  String get words;

  /// No description provided for @averageWpm.
  ///
  /// In en, this message translates to:
  /// **'Avg WPM'**
  String get averageWpm;

  /// No description provided for @peakWpm.
  ///
  /// In en, this message translates to:
  /// **'Peak WPM'**
  String get peakWpm;

  /// No description provided for @addBook.
  ///
  /// In en, this message translates to:
  /// **'Add Book'**
  String get addBook;

  /// No description provided for @deleteBook.
  ///
  /// In en, this message translates to:
  /// **'Delete Book'**
  String get deleteBook;

  /// No description provided for @deleteBookMessage.
  ///
  /// In en, this message translates to:
  /// **'\"{bookName}\" will be removed from your library together with all progress. Are you sure?'**
  String deleteBookMessage(Object bookName);

  /// No description provided for @bookDeleted.
  ///
  /// In en, this message translates to:
  /// **'\"{bookName}\" deleted successfully.'**
  String bookDeleted(Object bookName);

  /// No description provided for @bookAdded.
  ///
  /// In en, this message translates to:
  /// **'\"{bookName}\" added to library.'**
  String bookAdded(Object bookName);

  /// No description provided for @bookAddError.
  ///
  /// In en, this message translates to:
  /// **'Error while adding book: {error}'**
  String bookAddError(Object error);

  /// No description provided for @reader.
  ///
  /// In en, this message translates to:
  /// **'Reader'**
  String get reader;

  /// No description provided for @fileNotFound.
  ///
  /// In en, this message translates to:
  /// **'File Not Found'**
  String get fileNotFound;

  /// No description provided for @fileNotFoundMessage.
  ///
  /// In en, this message translates to:
  /// **'The original book file is not available on this device.'**
  String get fileNotFoundMessage;

  /// No description provided for @bookLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load book.'**
  String get bookLoadFailed;

  /// No description provided for @addBookmark.
  ///
  /// In en, this message translates to:
  /// **'Add Bookmark'**
  String get addBookmark;

  /// No description provided for @optionalNote.
  ///
  /// In en, this message translates to:
  /// **'Optional note...'**
  String get optionalNote;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @bookmarkSaved.
  ///
  /// In en, this message translates to:
  /// **'Bookmark saved.'**
  String get bookmarkSaved;

  /// No description provided for @goalCompleted.
  ///
  /// In en, this message translates to:
  /// **'🎉 Congratulations! You completed today\'s reading goal.'**
  String get goalCompleted;

  /// No description provided for @remainingWords.
  ///
  /// In en, this message translates to:
  /// **'Remaining Words'**
  String get remainingWords;

  /// No description provided for @remainingTime.
  ///
  /// In en, this message translates to:
  /// **'Remaining Time'**
  String get remainingTime;

  /// No description provided for @hourShort.
  ///
  /// In en, this message translates to:
  /// **'hr'**
  String get hourShort;

  /// No description provided for @minuteShort.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get minuteShort;

  /// No description provided for @secondShort.
  ///
  /// In en, this message translates to:
  /// **'sec'**
  String get secondShort;

  /// No description provided for @library.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get library;

  /// No description provided for @searchBooks.
  ///
  /// In en, this message translates to:
  /// **'Search books...'**
  String get searchBooks;

  /// No description provided for @libraryDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{bookName}\"? This action cannot be undone.'**
  String libraryDeleteMessage(Object bookName);

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @readingStatistics.
  ///
  /// In en, this message translates to:
  /// **'Reading Statistics'**
  String get readingStatistics;

  /// No description provided for @bookInformation.
  ///
  /// In en, this message translates to:
  /// **'Book Information'**
  String get bookInformation;

  /// No description provided for @bookNotFound.
  ///
  /// In en, this message translates to:
  /// **'Book not found.'**
  String get bookNotFound;

  /// No description provided for @noReadingStatistics.
  ///
  /// In en, this message translates to:
  /// **'No reading statistics are available for this book yet.'**
  String get noReadingStatistics;

  /// No description provided for @file.
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get file;

  /// No description provided for @addedDate.
  ///
  /// In en, this message translates to:
  /// **'Added'**
  String get addedDate;

  /// No description provided for @lastOpened.
  ///
  /// In en, this message translates to:
  /// **'Last Opened'**
  String get lastOpened;

  /// No description provided for @totalPages.
  ///
  /// In en, this message translates to:
  /// **'Total Pages'**
  String get totalPages;

  /// No description provided for @totalWords.
  ///
  /// In en, this message translates to:
  /// **'Total Words'**
  String get totalWords;

  /// No description provided for @progress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progress;

  /// No description provided for @totalReadingTime.
  ///
  /// In en, this message translates to:
  /// **'Total Reading Time'**
  String get totalReadingTime;

  /// No description provided for @totalWordsRead.
  ///
  /// In en, this message translates to:
  /// **'Total Words Read'**
  String get totalWordsRead;

  /// No description provided for @totalPagesRead.
  ///
  /// In en, this message translates to:
  /// **'Total Pages Read'**
  String get totalPagesRead;

  /// No description provided for @totalSessions.
  ///
  /// In en, this message translates to:
  /// **'Total Sessions'**
  String get totalSessions;

  /// No description provided for @averageSpeed.
  ///
  /// In en, this message translates to:
  /// **'Average Speed'**
  String get averageSpeed;

  /// No description provided for @peakSpeed.
  ///
  /// In en, this message translates to:
  /// **'Peak Speed'**
  String get peakSpeed;

  /// No description provided for @firstRead.
  ///
  /// In en, this message translates to:
  /// **'First Read'**
  String get firstRead;

  /// No description provided for @lastRead.
  ///
  /// In en, this message translates to:
  /// **'Last Read'**
  String get lastRead;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
