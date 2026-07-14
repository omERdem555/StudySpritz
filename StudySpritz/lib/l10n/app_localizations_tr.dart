// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appName => 'StudySpritz';

  @override
  String get settings => 'Ayarlar';

  @override
  String get language => 'Dil';

  @override
  String get theme => 'Tema';

  @override
  String get fontSize => 'Yazı Boyutu';

  @override
  String get wpm => 'Kelime / Dakika';

  @override
  String get animationSpeed => 'Animasyon Hızı';

  @override
  String get highlightColor => 'RSVP Vurgu Rengi';

  @override
  String get bookmarks => 'Yer İşaretleri';

  @override
  String get allBooks => 'Tüm Kitaplar';

  @override
  String get searchBookmarks => 'Yer imlerinde ara...';

  @override
  String get page => 'Sayfa';

  @override
  String get delete => 'Sil';

  @override
  String get cancel => 'İptal';

  @override
  String get deleteBookmark => 'Yer İşaretini Sil';

  @override
  String get deleteBookmarkMessage =>
      'Bu yer işaretini silmek istediğinize emin misiniz?';

  @override
  String get noBookmarks => 'Yer imi bulunamadı.';
}
