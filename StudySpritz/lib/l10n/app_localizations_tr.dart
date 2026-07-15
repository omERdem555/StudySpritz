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
  String get home => 'Ana Sayfa';

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

  @override
  String get readingGoalHistory => 'Okuma Hedefi Geçmişi';

  @override
  String get readingGoalHistorySubtitle =>
      'Tamamlanan ve önceki günlük hedefleri görüntüle';

  @override
  String get english => 'İngilizce';

  @override
  String get turkish => 'Türkçe';

  @override
  String get yellow => 'Sarı';

  @override
  String get green => 'Yeşil';

  @override
  String get blue => 'Mavi';

  @override
  String get red => 'Kırmızı';

  @override
  String get light => 'Açık';

  @override
  String get dark => 'Koyu';

  @override
  String get system => 'Sistem';

  @override
  String get book => 'Kitap';

  @override
  String get unknownBook => 'Bilinmeyen Kitap';

  @override
  String get dashboard => 'Ana Sayfa';

  @override
  String get recentBooks => 'Son Okunanlar';

  @override
  String get emptyLibrary => 'Kütüphane boş';

  @override
  String get favoriteBooks => 'Favoriler';

  @override
  String get noFavorites => 'Henüz favori yok';

  @override
  String get statistics => 'İstatistikler';

  @override
  String get favorite => 'Favori';

  @override
  String get completed => 'Tamamlanan';

  @override
  String get session => 'Oturum';

  @override
  String get duration => 'Süre';

  @override
  String get words => 'Kelime';

  @override
  String get averageWpm => 'Ort. WPM';

  @override
  String get peakWpm => 'Maks. WPM';

  @override
  String get addBook => 'Yeni Kitap Ekle';

  @override
  String get deleteBook => 'Kitabı Sil';

  @override
  String deleteBookMessage(Object bookName) {
    return '\"$bookName\" kütüphanenizden ve tüm ilerleme geçmişinizden silinecektir. Emin misiniz?';
  }

  @override
  String bookDeleted(Object bookName) {
    return '\"$bookName\" başarıyla silindi.';
  }

  @override
  String bookAdded(Object bookName) {
    return '\"$bookName\" kütüphaneye eklendi.';
  }

  @override
  String bookAddError(Object error) {
    return 'Kitap eklenirken hata oluştu: $error';
  }

  @override
  String get reader => 'Okuyucu';

  @override
  String get fileNotFound => 'Dosya Bulunamadı';

  @override
  String get fileNotFoundMessage =>
      'Orijinal kitap dosyası bu cihazda mevcut değil.';

  @override
  String get bookLoadFailed => 'Kitap yüklenemedi.';

  @override
  String get addBookmark => 'Yer İmi Ekle';

  @override
  String get optionalNote => 'İsteğe bağlı not...';

  @override
  String get save => 'Kaydet';

  @override
  String get bookmarkSaved => 'Yer imi kaydedildi.';

  @override
  String get goalCompleted =>
      '🎉 Tebrikler! Bugünkü okuma hedefini tamamladın.';

  @override
  String get remainingWords => 'Kalan Kelime';

  @override
  String get remainingTime => 'Bitmesine Kalan Süre';

  @override
  String get hourShort => 'sa';

  @override
  String get minuteShort => 'dk';

  @override
  String get secondShort => 'sn';

  @override
  String get library => 'Kütüphane';

  @override
  String get searchBooks => 'Kitaplarda ara...';

  @override
  String libraryDeleteMessage(Object bookName) {
    return '\"$bookName\" silinsin mi? Bu işlem geri alınamaz.';
  }

  @override
  String get favorites => 'Favoriler';

  @override
  String get readingStatistics => 'Okuma İstatistikleri';

  @override
  String get bookInformation => 'Kitap Bilgileri';

  @override
  String get bookNotFound => 'Kitap bulunamadı.';

  @override
  String get noReadingStatistics =>
      'Henüz bu kitap için herhangi bir okuma istatistiği oluşmadı.';

  @override
  String get file => 'Dosya';

  @override
  String get addedDate => 'Eklenme';

  @override
  String get lastOpened => 'Son Açılış';

  @override
  String get totalPages => 'Toplam Sayfa';

  @override
  String get totalWords => 'Toplam Kelime';

  @override
  String get progress => 'İlerleme';

  @override
  String get totalReadingTime => 'Toplam Okuma Süresi';

  @override
  String get totalWordsRead => 'Toplam Kelime Okundu';

  @override
  String get totalPagesRead => 'Toplam Sayfa Okundu';

  @override
  String get totalSessions => 'Toplam Oturum';

  @override
  String get averageSpeed => 'Ortalama Hız';

  @override
  String get peakSpeed => 'En Yüksek Hız';

  @override
  String get firstRead => 'İlk Okuma';

  @override
  String get lastRead => 'Son Okuma';

  @override
  String get noReadingGoalHistory => 'Henüz okuma hedefi geçmişi bulunmuyor.';
}
