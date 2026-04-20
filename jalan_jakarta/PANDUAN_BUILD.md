# 📱 JalanJakarta — Panduan Lengkap Build & Upload ke App Store

## Struktur Proyek

```
jalan_jakarta/
├── lib/
│   ├── main.dart                 ← Entry point + navigasi utama
│   ├── theme/
│   │   └── app_theme.dart        ← Warna, font, desain sistem
│   ├── models/
│   │   └── models.dart           ← Place, Category, Review, Booking, User
│   ├── services/
│   │   ├── data_service.dart     ← Data dummy 10 tempat Jakarta
│   │   └── app_state.dart        ← State management (Provider)
│   ├── widgets/
│   │   └── widgets.dart          ← PlaceCard, CategoryChip, EventCard, dll
│   └── screens/
│       ├── home_screen.dart      ← Halaman utama + discovery
│       ├── place_detail_screen.dart ← Detail + booking sheet
│       ├── map_screen.dart       ← Google Maps + marker
│       ├── search_screen.dart    ← Pencarian live
│       └── other_screens.dart    ← Events, Saved, Profile
├── ios_Info.plist                ← Salin ke ios/Runner/Info.plist
└── pubspec.yaml                  ← Dependencies
```

---

## LANGKAH 1 — Siapkan Mac & Tools

```bash
# 1. Install Flutter (jika belum)
# Download dari https://flutter.dev/docs/get-started/install/macos

# 2. Verifikasi instalasi
flutter doctor

# 3. Pastikan Xcode terinstall (dari App Store, gratis)
xcode-select --install

# 4. Install CocoaPods
sudo gem install cocoapods
```

---

## LANGKAH 2 — Setup Proyek

```bash
# 1. Buat folder proyek Flutter baru
flutter create jalan_jakarta
cd jalan_jakarta

# 2. Hapus file default dan ganti dengan file dari paket ini:
#    Salin semua file dari download ke folder yang sesuai

# 3. Salin ios_Info.plist ke lokasi yang benar
cp ios_Info.plist ios/Runner/Info.plist

# 4. Install dependencies
flutter pub get

# 5. Masuk ke folder ios dan install pods
cd ios
pod install
cd ..
```

---

## LANGKAH 3 — Setup Google Maps API Key

```bash
# 1. Buka https://console.cloud.google.com
# 2. Buat project baru: "JalanJakarta"
# 3. Aktifkan APIs:
#    - Maps SDK for iOS
#    - Places API
#    - Geocoding API

# 4. Buat API Key, lalu tambahkan di:
#    ios/Runner/AppDelegate.swift
```

Edit file `ios/Runner/AppDelegate.swift`:
```swift
import UIKit
import Flutter
import GoogleMaps  // ← Tambahkan ini

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("MASUKKAN_API_KEY_KAMU_DI_SINI")  // ← Tambahkan ini
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

---

## LANGKAH 4 — Jalankan di Simulator / iPhone

```bash
# Cek device yang tersedia
flutter devices

# Jalankan di simulator iPhone
flutter run

# Atau jalankan di iPhone fisik (hubungkan via USB dulu)
flutter run -d [device-id]

# Build release untuk testing
flutter build ios --release
```

---

## LANGKAH 5 — Setup Apple Developer Account

```
1. Daftar di https://developer.apple.com
   - Individual: $99/tahun
   - Organization: $99/tahun

2. Buat App ID di Certificates, IDs & Profiles:
   - Bundle ID: com.namaanda.jalanjakarta
   - Aktifkan: Push Notifications, Maps

3. Buat Provisioning Profile (Distribution)

4. Setup di Xcode:
   - Buka ios/Runner.xcworkspace (BUKAN .xcodeproj!)
   - General → Bundle Identifier: com.namaanda.jalanjakarta
   - Signing & Capabilities → Team: pilih tim kamu
   - Centang "Automatically manage signing"
```

---

## LANGKAH 6 — Konfigurasi untuk App Store

Edit `pubspec.yaml`:
```yaml
version: 1.0.0+1  # Format: versi_publik+build_number
```

Edit `ios/Runner/Info.plist` — pastikan ada:
```xml
<key>CFBundleDisplayName</key>
<string>JalanJakarta</string>
```

---

## LANGKAH 7 — Build & Upload ke App Store

```bash
# 1. Build IPA
flutter build ipa

# File IPA ada di: build/ios/ipa/jalan_jakarta.ipa

# 2. Upload via Xcode (cara termudah):
open build/ios/archive/Runner.xcarchive
# Klik "Distribute App" → App Store Connect → Upload

# Atau via command line:
xcrun altool --upload-app \
  --type ios \
  --file "build/ios/ipa/jalan_jakarta.ipa" \
  --username "apple_id_kamu@email.com" \
  --password "app-specific-password"
```

---

## LANGKAH 8 — Submit ke App Store Review

```
1. Buka https://appstoreconnect.apple.com
2. My Apps → Klik "+" → New App
3. Isi:
   - Name: JalanJakarta
   - Primary Language: Indonesian
   - Bundle ID: com.namaanda.jalanjakarta
   - SKU: jalanjakarta001

4. Upload screenshots (wajib):
   - iPhone 6.7" (iPhone 15 Pro Max)
   - iPhone 6.5" (iPhone 14 Plus)
   - iPad 12.9" (opsional)

5. Isi deskripsi dalam Bahasa Indonesia & Inggris
6. Category: Travel atau Lifestyle
7. Rating: 4+ (konten aman)
8. Submit for Review

⏱ Review Apple: 1-3 hari kerja
```

---

## Fitur yang Sudah Ada (v1.0)

| Fitur | Status |
|-------|--------|
| Halaman utama + discovery | ✅ |
| Filter per kategori (7 kategori) | ✅ |
| Pencarian live | ✅ |
| Detail tempat + foto | ✅ |
| Sistem reservasi / booking | ✅ |
| Ulasan & rating | ✅ |
| Peta Google Maps | ✅ |
| Daftar event Jakarta | ✅ |
| Simpan tempat favorit | ✅ |
| Manajemen reservasi | ✅ |
| Halaman profil | ✅ |

---

## Langkah Selanjutnya (v2.0)

- [ ] Backend API (Node.js / Laravel)
- [ ] Login Google / Apple ID
- [ ] Push Notification (event baru, promo)
- [ ] Pembayaran in-app (Midtrans / GoPay)
- [ ] Ulasan dengan foto
- [ ] Fitur berbagi ke WhatsApp / Instagram
- [ ] Dark mode
- [ ] Bahasa Inggris (multi-language)

---

## Butuh Bantuan?

Tanya saya untuk:
- Menambah lebih banyak data tempat
- Integrasi backend real
- Setup notifikasi push
- Desain icon & splash screen
- Optimasi performa
