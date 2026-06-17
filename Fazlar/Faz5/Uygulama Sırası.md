✅ FAZ 5 — OKUMA MOTORU (başlangıç planı)

Bu fazın amacı “gösterim + ilerleme mantığı”. RSVP yok, sadece kitabı okunabilir hale getirme altyapısı.



🎯 5.1 Temel problem

Elimizde artık:
rawText (FAZ 4)

Bunu şuna çevireceğiz:
pages → navigation → progress




📦 5.2 Veri modeli genişletme (kritik)

Book içinde zaten var:
pageNumber
wordIndex
wordCount

Bunlar yeterli. Model değiştirmiyoruz.




🧠 5.3 Okuma motoru mantığı
3 katmanlı sistem:
1. Text → words
"hello world" → ["hello", "world"]

2. words → pages

Basit kural:
1 page = 250 kelime (şimdilik sabit)

3. progress tracking
pageNumber = current page
wordIndex = global index





🏗️ 5.4 Yeni servis

📁 oluştur:

lib/core/reading/reading_engine.dart
✅ READING ENGINE
class ReadingEngine {
  static const int wordsPerPage = 250;

  List<String> splitWords(String text) {
    return text
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim()
        .split(' ');
  }

  int calculatePageCount(int wordCount) {
    return (wordCount / wordsPerPage).ceil();
  }

  int getPageFromWordIndex(int wordIndex) {
    return (wordIndex / wordsPerPage).floor();
  }

  int getWordIndexFromPage(int page) {
    return page * wordsPerPage;
  }

  double calculateProgress(int wordIndex, int totalWords) {
    if (totalWords == 0) return 0;
    return wordIndex / totalWords;
  }
}




📊 5.5 NE KAZANDIK?

Şu artık mümkün:
✔ kitabın kaç sayfa olduğu
✔ yüzde kaç okunduğu
✔ nerede kaldığı
✔ sayfa geçiş sistemi






🔄 5.6 Bookmark + resume mantığı (şimdilik hazırlık)

Şu bilgi artık yeterli:
wordIndex → kaldığın yer

Uygulama açılınca:
Book içinden wordIndex alınır
oradan devam edilir
⚠️ BU FAZDA YOK
RSVP ❌
UI ❌
animasyon ❌




🎯 FAZ 5 SONUCU

Sistem artık:
PDF → TEXT → WORDS → PAGES → PROGRESS


🚀 SONRAKİ FAZ (FAZ 6)
👉 RSVP ENGINE

Burada:
kelimeler ekranda tek tek akar
hız (WPM) devreye girer
gerçek “okuma motoru” başlar