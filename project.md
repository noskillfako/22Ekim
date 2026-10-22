Proje Adı: HabitChain & Wellness Tracker (Alışkanlık ve Yaşam Takip Uygulaması)

1. Proje Özeti

Kullanıcıların günlük yeni pozitif alışkanlıklar kazanmasını (kitap okuma, su içme, spor, sağlıklı beslenme vb.), zararlı alışkanlıkları bırakmasını (sigara, alkol) ve "zinciri kırma" (streak) metodolojisi ile bu alışkanlıkları sürdürülebilir hale getirmesini sağlayan oyunlaştırılmış (gamified) bir mobil/web uygulamasıdır.

2. Proje Amacı

Mikro alışkanlıklar yoluyla kişisel gelişimi desteklemek, akıllı saat entegrasyonu ve finansal/kalori bazlı geri bildirimlerle somut veriler sunmak ve rozet/seri (streak) sistemiyle kullanıcı motivasyonunu en üst düzeyde tutmaktır.

3. Alışkanlık Kategorileri ve Veri Modelleri

Uygulamada her alışkanlık türü kendine özgü dinamik veri giriş alanlarına ve hesaplama mantığına sahiptir:

A. Pozitif Alışkanlıklar & Spor

Kitap Okuma:

Giriş Verileri: Kitap Adı, Kitap Türü, Toplam Sayfa Sayısı, Günlük Okunan Sayfa Miktarı.

Çıktı/Takip: Kitap bitirme yüzdesi, toplam okunan sayfa ve bitirilen kitap sayacı.

Yüzme:

Giriş Verileri: Süre (dakika).

Akıllı Saat Entegrasyonu: Saat bağlıysa yakılan kalori otomatik çekilir; bağlı değilse süreye göre tahmini hesaplanır veya manuel girilir.

Fitness & Diğer Spor Faaliyetleri (Bisiklet, Yoga, Pilates vb.):

Giriş Verileri: Süre (dakika), Spor Türü.

Akıllı Saat Entegrasyonu: Saate bağlı aktif kalori takibi.

Koşu:

Giriş Verileri: Mesafe (km), Süre (dakika).

Akıllı Saat Entegrasyonu: Saate bağlı yakılan kalori ve tempo (pace) verisi.

Zeka Oyunları (Satranç, Sudoku, Bulmaca vb.):

Giriş Verileri: Oyun Türü, Süre (dakika).

Su İçme:

Giriş Verileri: İçilen Miktar (Litre veya ml bazında hızlı ekleme).

Sağlıklı Beslenme:

Giriş Verileri: Öğün kalorisi (kcal), Ortalama bir standart/sağlıksız öğün kalorisi referansı.

Hesaplama: Ortalama Öğün Kalorisi - Alınan Sağlıklı Öğün Kalorisi = Günlük Kalori Tasarrufu (Eksik Alınan Kalori).

B. Zararlı Alışkanlıkları Bırakma

Sigarayı Bırakma:

Başlangıç Verisi (Onboarding/Ayarlar): Günlük normalde içilen dal sayısı, 1 paket sigara fiyatı.

Günlük Giriş/Takip: Bugün kaç dal içilmedi (veya içildiyse düşülerek hesaplama).

Hesaplama: İçilmeyen dal sayısına göre Kâr Edilen Tutar (TL) ve kazanılan yaşam süresi.

Alkolü Bırakma:

Başlangıç Verisi: Haftalık/Günlük ortalama tüketim miktarı ve ortalama birim maliyeti (TL).

Günlük Giriş/Takip: Tüketilmeyen miktar/gün.

Hesaplama: Kâr Edilen Tutar (TL) ve alınmayan boş kalori miktarı.

4. Kullanıcı Akışı ve Sayfa Tasarımları (UI/UX Mimarisi)

Başlangıç: Kayıt ve Onboarding (Hesap Açma) Sayfası

Veri Girişi: Kullanıcı adı, e-posta, şifre, Yaş ve Cinsiyet.

Otomatik Avatar Atama: Kullanıcının girdiği yaş ve cinsiyet parametrelerine göre sistem tarafından dinamik ve uygun bir varsayılan Avatar atanır.

1. Sayfa: Ana Sayfa (Alışkanlıklarım ve Streak Ekranı)

Üst Bar (Header):

Sağ üst köşede Genel "+" (Artı) Butonu: Tıklandığında yeni alışkanlık ekleme modal penceresini açar.

Yeni Alışkanlık Ekleme Modalı:

Üst kısımda Arama Çubuğu (Search Bar).

Kullanıcının henüz listesinde olmayan alışkanlıkları filtreleyip tek tıkla ana sayfasına eklemesini sağlar.

Alışkanlık Kartları Listesi:

Her kartta alışkanlığa uygun özel animasyonlu/resimli görsel, alışkanlık adı ve güncel Streak (Seri) Sayısı (🔥 ikonu ile) yer alır.

Kart İçi "+" Butonu: Her alışkanlık kartının üzerinde bulunan bu butona tıklandığında, o alışkanlığın türüne özel Veri Giriş Modalı açılır (Örn: Kitap ise sayfa sayısı, koşu ise km soran form).

Alışkanlık Silme Etkileşimi (Long Press):

Kullanıcı ana sayfadaki bir alışkanlık kartının üzerine basılı tutup 3 saniye beklediğinde kart titrer/seçilir ve üzerinde Kırmızı "Sil" Butonu belirir. Tıklandığında alışkanlık listeden kaldırılır.

2. Sayfa: Görsel Takvim ve Renkli Zincir Takibi

Takvim Görünümü: Aylık ve haftalık olarak gezilebilen interaktif takvim.

Dinamik Renkli Çember Sistemi:

Alışkanlıkların tamamlandığı günler takvimde renkli çember içine alınır.

Her alışkanlığın kendine has bir rengi vardır (Örn: Yüzme = Mavi, Koşu = Yeşil, Kitap = Sarı).

Kombinasyon Mantığı: Eğer aynı gün içinde birden fazla spesifik alışkanlık yapıldıysa (Örn: Yüzme + Koşu aynı gün yapıldıysa), o günün çemberi bu kombinasyona özel tanımlanmış bir renge (Örn: Turkuaz/Mor veya Çift Halkalı Gradyan) dönüşür.

Bir güne tıklandığında o gün yapılan tüm aktivitelerin özeti alt kısımda listelenir.

3. Sayfa: Akıllı Saat Bağlantısı ve Analitik Grafikler

Cihaz Eşleştirme Alanı: Akıllı saat (Apple Watch, WearOS, Xiaomi Mi Band vb. / HealthKit & Google Fit simülasyonu veya API bağlantısı) bağlama/durum kontrol ekranı.

Kalori ve Efor Grafikleri:

Saat bağlandığında aktifleşen dinamik grafik alanı (Bar veya Çizgi Grafik).

Filtreleme: Haftalık ve Aylık görünüm sekmeleri.

Spor aktivitelerinden (yüzme, koşu, fitness) gelen saat verileriyle toplam yakılan kaloriyi, aktif dakikaları ve trendleri görselleştirir.

4. Sayfa: Profil, Rozetler ve Ayarlar

Profil Özeti:

Hesap açılışında yaş ve cinsiyete göre atanan Kullanıcı Avatarı, kullanıcı bilgileri ve genel seviye/toplam streak istatistikleri.

Oyunlaştırma ve Rozet (Badge) Sistemi:

Avatarın hemen altında kazanılan son/öne çıkan rozetlerin özeti.

Rozetler Modal Penceresi: Tıklandığında açılan bu pencerede tüm alışkanlık türlerine özel rozetler sıralanır (Kazanılanlar parlak, kazanılmayanlar kilitli/gri).

Örnek Rozet Kuralı: Toplam Okunan Kitap Sayısı >= 100 olduğunda Altın Renkte "Kütüphaneci" Rozeti kazanılır (Bronz -> Gümüş -> Altın kademeleri).

Diğer Örnekler: Su kurbağası (100L su), Maratoncu (100km koşu), Tasarruf Uzmanı (Sigaradan 5.000 TL kâr) vb.

Ayarlar Menüsü:

Bildirim tercihleri, karanlık/aydınlık mod, sigara/alkol birim fiyat güncell# Alışkanlık Takibi (Habit Tracker)

## 1. Proje Özeti

Kullanıcıların günlük yeni pozitif alışkanlıklar kazanmasını (kitap okuma, su içme, spor) ve zinciri kırmadan devam ettirmesini sağlayan uygulama.

## 2. Proje Amacı

Mikro alışkanlıklar yoluyla kişisel gelişimi desteklemek ve motivasyon serisi (streak) sistemiyle devamlılık sağlamak.

## 3. Tahmini Ekran ve Sayfa Sayısı

3-5 Ekran (Günlük Alışkanlıklar Listesi, Alışkanlık Ekle/Düzenle, Zinciri Kırma (Streak) Takvim Görünümü, Başarı Rozetleri & Analiz)

## 4. Temel Özellikler

- Günlük tek dokunuşla tamamlama kontrolü\n- Aktif zincir (kaç gündür aralıksız yapılıyor) sayacı\n- Haftalık ve aylık tamamlama yüzdesi ızgarası (GitHub katkı grafiği tarzı)\n- Kişiselleştirilebilir hatırlatma bildirimleri

## 5. Hedef Kitle

Genel kullanıcılar, öğrenciler veya ilgili alan profesyonelleri.

---

## 6. Öğrenci Çalışma ve Detay Alanı

> Not: Bu alandaki detaylar projeyi üstlenen öğrenci tarafından doldurulacaktır.

### 6.1. Kullanılacak Teknolojiler & Kütüphaneler

- Frontend: *(Öğrenci belirleyecek - örn: HTML5, CSS3/Tailwind, JavaScript)*

- Backend / Veri Depolama: *(Öğrenci belirleyecek - örn: LocalStorage, Supabase, Firebase, Node.js)*

- Ek Kütüphaneler / API'ler: *(Öğrenci belirleyecek)*

### 6.2. Sayfa Hiyerarşisi ve Akış Planı

- [ ] Sayfa 1:

- [ ] Sayfa 2:

- [ ] Sayfa 3:

- [ ] Sayfa 4:

### 6.3. Veri Modeli ve Bileşen Tasarımı

*(Kullanılacak veri yapıları, nesneler veya veritabanı tabloları buraya yazılacaktır)*

### 6.4. Proje Takvimi ve Teslim Aşamaları

- Aşama 1 (Tasarım & Wireframe):

- Aşama 2 (Temel Fonksiyonlar & Arayüz):

- Aşama 3 (Test & İyileştirme):

- Aşama 4 (Final Teslim):

### 6.5. Notlar & Karşılaşılan Zorluklar

(Geliştirme esnasında eklenen notlar ve çözüm yolları)emeleri, Hesaptan Çıkış Yap (Logout) ve hesap yönetimi işlemleri.

5. Teknik Gereksinimler ve Etkileşim Notları (Antigravity Ajanları İçin)

Durum Yönetimi (State Management): Alışkanlık verileri, günlük girişler, streak hesaplamaları, finansal kârlar ve rozet kilit kontrolleri merkezi bir state yapısında (veya veritabanında) anlık olarak senkronize edilmelidir.

Mikro Animasyonlar: 3 saniye basılı tutma (long-press timer) geri bildirimi, alışkanlık kartlarındaki ikon animasyonları ve takvimdeki renk geçişleri akıcı olmalıdır.

Modülerlik: Yeni bir alışkanlık türü veya yeni bir rozet kuralı eklendiğinde veri şeması kolayca genişletilebilir (scalable) olmalıdır.