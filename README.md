# 📚 StudySpritz

**StudySpritz**, Flutter ile geliştirilen çevrimdışı (offline-first) çalışan bir hızlı okuma ve dijital kitap okuma uygulamasıdır.

Uygulama; PDF, DOCX ve TXT dosyalarını okuyabilir, kitapları yerel olarak saklayabilir, normal okuma ile RSVP (Rapid Serial Visual Presentation) hızlı okuma modları arasında geçiş yapabilir ve kullanıcıya ayrıntılı okuma istatistikleri sunar.

Bu proje gerçek bir kullanıcı ihtiyacından yola çıkılarak geliştirilmiştir. Amaç; dijital kitap okuma deneyimini daha hızlı, daha verimli ve tamamen çevrimdışı hale getirmektir.

---

# ✨ Özellikler

## 📖 Kitap Yönetimi

* PDF desteği
* DOCX desteği
* TXT desteği
* Yerel dosya seçme
* Kitap ekleme
* Kitap silme
* Kitap arama
* Favorilere ekleme
* Son okunan kitaplar

---

## 📚 Okuma Deneyimi

### Normal Okuma

* Sayfalı okuma
* Okuma ilerleğini kaydetme
* Son kalınan yerden devam etme
* Sayfa bazlı ilerleme

### RSVP (Hızlı Okuma)

* Kelime kelime gösterim
* Ayarlanabilir WPM
* Oynat
* Duraklat
* Devam et
* Başa dön
* Hız artırma
* Hız azaltma

---

## 🔖 Yer İşaretleri

* Yer imi ekleme
* Not ekleme
* Yer imlerine gitme
* Yer imi silme
* Yer imi arama

---

## 🎯 Günlük Okuma Hedefleri

* Dakika hedefi
* Sayfa hedefi
* Kelime hedefi
* Günlük ilerleme
* Hedef tamamlama
* Hedef geçmişi

---

## 📊 İstatistikler

### Kitap Bazlı

* Toplam okuma süresi
* Toplam okunan kelime
* Toplam okunan sayfa
* Ortalama okuma hızı
* Maksimum okuma hızı
* İlk okuma tarihi
* Son okuma tarihi
* Oturum sayısı

### Uygulama Bazlı

* Toplam kitap
* Favori kitap
* Tamamlanan kitap
* Genel istatistikler

---

## ⚙️ Ayarlar

* Açık tema
* Koyu tema
* Sistem teması
* Yazı boyutu
* RSVP hızı
* Animasyon hızı
* RSVP vurgu rengi
* Türkçe desteği
* İngilizce desteği

---

# 🏗 Kullanılan Teknolojiler

## Framework

* Flutter

## Dil

* Dart

## Yerel Veritabanı

* Hive

## Durum Yönetimi

* ValueListenableBuilder
* Repository Pattern

## Yönlendirme

* GoRouter

## Dosya İşleme

* PDF Parser
* DOCX Parser
* TXT Parser

## Localization

* Flutter l10n

---

# 🏛 Mimari

Proje katmanlı mimari kullanılarak geliştirilmiştir.

```
UI

↓

Screens

↓

Widgets

↓

Repositories

↓

Hive Services

↓

Models

↓

Hive Database
```

Repository Pattern sayesinde veri erişimi ile kullanıcı arayüzü birbirinden ayrılmıştır.

---

# 📦 Desteklenen Dosya Türleri

* PDF
* DOCX
* TXT

---

# 📱 Platform

* Android ✅

(İstenildiğinde iOS desteği de eklenebilir.)

---

# 🎯 Projenin Amacı

StudySpritz'in amacı;

* kitap okuma sürecini hızlandırmak,
* okuma alışkanlığını takip etmek,
* kullanıcıya ayrıntılı istatistikler sunmak,
* tamamen çevrimdışı çalışan bir kitap okuma deneyimi oluşturmaktır.

---

# 🚀 Gelecekte Eklenebilecek Özellikler

* EPUB desteği
* Senkronizasyon
* Bulut yedekleme
* Çoklu cihaz desteği
* AI destekli özet oluşturma
* AI destekli soru-cevap sistemi
* AI destekli çalışma modu
* Not kategorileri
* Kitap etiketleme
* Okuma listeleri

---

# 👨‍💻 Geliştirici

**Ömer Erdem**

Bilgisayar Mühendisliği öğrencisi

Bu proje Flutter, Hive ve modern mobil uygulama mimarisi kullanılarak uçtan uca geliştirilmiştir.

---

# 📄 Lisans

Bu proje yalnızca eğitim ve portföy amacıyla geliştirilmiştir.
