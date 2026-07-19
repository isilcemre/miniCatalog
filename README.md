# minicatalog

## Açıklama

minicatalog, bir ürün kataloğunu listeleyip kullanıcının favori ürün ekleyebildiği, sepete ürün ekleyip satın alma işlemi yapabildiği bir Flutter mobil uygulamasıdır. Uygulama; giriş ekranı, ürün listeleme/detay, favoriler, sepet, kayıtlı adresler, kayıtlı kartlar, satın alma (checkout) ve sipariş geçmişi (Siparişlerim) ekranlarından oluşur. Ürün verileri bir API üzerinden çekilir; kayıtlı adresler, kartlar ve siparişler cihaz üzerinde (SharedPreferences) yerel olarak saklanır.

## Kullanılan Flutter Sürümü

- **Flutter:** 3.44.0 (stable channel)
- **Dart SDK:** ^3.12.0

## Çalıştırma Adımları

1. Depoyu klonlayın veya proje klasörünü indirin:
   ```bash
   git clone <repo-url>
   cd minicatalog
   ```

2. Bağımlılıkları yükleyin:
   ```bash
   flutter pub get
   ```

3. Bağlı bir cihaz veya emülatör olduğundan emin olun:
   ```bash
   flutter devices
   ```

4. Uygulamayı çalıştırın:
   ```bash
   flutter run
   ```

   Belirli bir platformda çalıştırmak isterseniz:
   ```bash
   flutter run -d chrome    # Web
   flutter run -d windows   # Windows
   flutter run -d macos     # macOS
   ```

## Kullanılan Başlıca Paketler

- `http` — API'den ürün verisi çekmek için
- `shared_preferences` — adres, kart ve sipariş verilerini cihazda saklamak için
- `cupertino_icons` — iOS tarzı ikonlar için


## Ekran Görüntüleri
<img width="1080" height="1920" alt="products" src="https://github.com/user-attachments/assets/4d8ae75a-c15b-4287-a5c2-f579061cd70a" />
<br>
<img width="1080" height="1920" alt="details" src="https://github.com/user-attachments/assets/6a67f93f-6f5b-48c6-8aa5-bbefe824e946" />
<br>
<img width="1080" height="1920" alt="profile" src="https://github.com/user-attachments/assets/450fc266-a01d-45bf-a003-cd9b9a381e89" />
<<br>
img width="1080" height="1920" alt="favorites" src="https://github.com/user-attachments/assets/e0c98fd4-546d-4033-9054-3f708ef6694a" />
<br>
<img width="1080" height="1920" alt="orders" src="https://github.com/user-attachments/assets/0504e245-2230-4762-a91a-1a63435351cb" />
<br>
<img width="1080" height="1920" alt="addresses" src="https://github.com/user-attachments/assets/6a63db99-1dba-4db8-a040-6cc99e980c16" />
<br>
<img width="1080" height="1920" alt="addCard" src="https://github.com/user-attachments/assets/3c960bbe-3d20-4ca7-afca-d302fda20322" />
<br>
<img width="1080" height="1920" alt="cart" src="https://github.com/user-attachments/assets/c0aa7700-2d85-4732-bd3e-29f7a0f4c5f6" />
<br>
<img width="1080" height="1920" alt="siparisinizAlinmistir" src="https://github.com/user-attachments/assets/b0712bb4-535b-4660-aa02-eb02b79bfa4c" />
<br>
<img width="1080" height="1920" alt="siparisinizAlinmistir" src="https://github.com/user-attachments/assets/39c8f561-fbc5-4225-a3e1-0642934aedd1" />
