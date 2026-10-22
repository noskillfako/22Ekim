Const
1) ne işe yarar: İçine giren değerleri derleme zamanında tek bir yere yazılarak değişmez olarak üretir
2) Nedene kullanılır:Bir widget const olarak tanımlanırsa setState olduğunda flutter bu widgeti yeniden üretmez CPU ve pil tasarrufu sağlar

final
1) ne işe yarar: Çalışma başladığında değeri bir kez atanan ve sonrasında referansı asla değiştirilmeyen değişkenler
*const ve final farkı: const derlenirken bilinmek zorunda(const pi=3.14), final ise çalışma anında belirlenebilir (final saat=Datetime.now())---Model sınıflarında alanlar her zaman final olmalıdır.-----*

late 
1) ne işe yarar: Değişen tanımlandığı anda değil , ilk kullanıldığında veya inisState anında başlayacağı zaman kullanılır

required
1) ne işe yarar: İsimlendirilmiş parametre o parametreyi(değişkeni) alan fonksiyonda mutlaka verilmek zorundadır

@override
1) ne işe yarar: alt sınıfın üst sınıftan devraldığı metodu ezdiğini belirtir
2) faydası: eğer üst metod adını yanlış yazarsanız (örnek builds yazarsanız) derleyici @override sayesinde anında hata olarak yakalar.

Null-aware operatörleri (? ?? !)
?. - place?.title-> Eğer place null ise hata vermez direk null olarak döner
?? - if null : final id =state.userId ?? 10;->Sol taraf null ise sağdaki (hardcode olan değer) otomatik olarak atanır.
! (null / force): final id =state.userId ! ->Bu kod derleyiciye "bana güven bu değer o anda kesinlikle null değil" der. Eğer null gelir ise uygulama anında çöker.(ÇOK DİKKATLİ KULLANILMALI)

Spread operatörü(...)
1) ne işe yarar: bir listenin elemanları tek tek çıkarıp bulunduğu üst listenin içine ekler. Column veListView içinde dinamik kart dizini kullanmak için en temiz yöntemdir.
...listeAdi.map((p)=> _buildCard(p))

initState()
1) Ne zaman çalışır: Widget ağaca fiziksel olarak ilk başlandığında yalnızca 1 kere çalışır
2) Ne yapar: ScrollController başlatmaları ve ilk api istekleri burda kurulur.
Kural: İçinde doğrudan BuildContext ile Navigator çağrılmaz çünkü widget ağaca tam oturmamıştır

didChangeDependencies()
Ne zaman çalışır: initState()'ten hemen sonra ve widget dinlendiği bir (örnek: Theme.of(context) ) değiştiğinde otomatik tetiklenir.
Ne yapar: Build Context güvenli bir şekilde erişerek tema ve ya ekran boyutu bağımlılıkları ile ilgili ilk yüklemeler burada yapılır.

build(BuildContext context)
Ne zaman çalışır:Sayfa ilk açıldığında ,setState() çağrıldığında veya üst widget yeni bir inşa ağaç boyama geldiğinde saniyesinde defalarca çalışır
Kural.build() metodu tamamen saf olmalıdır.Asla içinde setState() api isteği ya da controller başaltma yapılmamalıdır.Sadece UI döndürülmelidir.

dispose()
Ne zaman çalışır:widget hafızadan atılmadan hemen önce son bir kez çalışır 
Ne yapılır _controller.dispose() stream dinleyicilerini iptallalerini burda yapılır. super.dispose()'un mutlaka son satırda çalıştırılması gerekir

setState((){})
1- Arka planda ne yapar State'in bağlı olduğu StatefulElement nesnesine "ben değiştim build et" sinyali yollar
2- nerde kullanılır: Sayfa genelini çizdirmez.Sadece onu dinleyen küçük ValueListenableBuilder'a sinyal gönderilir.

ValueNotifier<T>
1- Arka planda ne iş yapar:ChangeNotifier sınıfından türer.Belleğinde tek bir nesne referansı tutar(T_value)
2- Tetikleme Değer atandığında (set value(T value)), eğer yeni değere eski değere eşit değilse (_value!=newValue), kayıtlı olan fonksiyonu çağrılır.(addListener(() {}))

InheritedWidget
1) ne yapar. Widget ağacından alttakita childların,aradaki onlarca widgeti baypas ederek üst widgetin verisine(state'ine) doğrudan erişmesini sağlayan soyut bir wigdettir

Material 3 Tasarım Dili Renk Algoritması ve Temalar

primary:Ana marka rengi
onPrimary:Ana rengin üstüne yazılacak yazı rengi(okunabilirlk açısından)
primaryContainer:Ana rengin yumuşak pastel arkaplan tonu
onPrimaryContainer:Ana rengin yumuşak pastel arkaplan tonunun üstüne yazılacak yazı (okunabilirlk açısından)
surface:Sayfa arka plan tuvali
onSurface:Sayfa üstündeki ana metin rengi
outlineVariant:İnce sınır ve ayrım çizgilerinin rengi

ThemeMode.system
color:Colors.black.withOpacity(186)//Kesinlikle 1-255 sayıları arasında bir değer girilmelidir
(bu kullanım güncelde istenmiyor)

color:Colors.blakc.withValues(alpha: 186/255)// double sayı olarak girilmelidir(güncel ve doğru yöntem)

Arayüz Düzen ve Liste bileşenleri 

Expanded ve Flexible
Expanded:Kalan bol alanın TAMAMINI kaplamaya zorlar
Flexible:Kalan boş alanı paylaştırır.(flex:1,flex:2)
Flex: yanyana iki expande varsa birine flex2 diğerine flex1 verir bu sayedeekran boyutunu otomatik ayarlar

Stack ve Positioned
Ne yapar: Widgetları z ekseninde üstüste bindirir.
Positioned:Yalnızca bir Stack içinde çalışır
top:10,right:10 vererek bir resmin sağ üst köşesine bildirim rozeti eklemenizi sağlar

ListView.builder.
Klasik ListView(children:[...],) içindeki örnek vermek gerekirse 10.000 elemanın tamamını daha sayfa açılmadan belleğe yükler ve doğal olarak tleefon donar.
ListView.builder ise Geri Dönüşümlü Görünüm alanı mantığını kullanarak ekranda sadece o an eğer 5 kart görünecek ise sadece 5 kartı ram belleğe yükler.Kullanıcı aşağıya kaydıkça yukarıda kalanlar bellekten düşürülüp altta kalanalr belleğe taze olarak yeni olarak üretilir.

shinkWrap: true
Bir listView başka bir dikey kaydırıcının(singleChildScrollView) içine konursa Vertical viewport hatası verir shinkWrap true verilerek bu çözülebilir ancak: ListView'un sonsuza kayma (sonsuz scroll) özelliği kaybolur
**Sadece 3 5 elemanınız varsa bunun kullanmalısınız**

Inkwellve GestureDetector
GestureDetector:Tıklama çift tıklama sürükleme olaylarını yakalar ama GÖRSEL HİÇ BİR TEPKİ VERMEZ.
Inkwell: tıklandığı an parmağın altından dışa doğru yayılan bir su dalgası efekti verir 

Önemli Kural: Inkwell'in arkasında mutlaka bir material widget olmak zorundadır.Aksi taktirde su dalgası arkadaş tuvali göremediği için hiçbir şekilde görünmez

Form Mimarisi

GlobalKey<FormState>

Widget içindeki Form düğümüne doğrudan dışarıdan erişilemiyor bu yüzden Widgetin en üstüne koyduğumuz globalKey değişkeni sayesinde formun Validate durumunu ve içindeki değerleri dışarıdan okuyoruz

_formKey.currentState?.validate() cağrıldığında o formun altındaki tüm TextFromFiled validator bloklarını sırayla çalıştırır 

validator: (String ? value)

fonksiyonda bir hata bulursa geriye String olarak hata metni döndürür
Bu metin otomatik olarak kırmızı renkte ve inputun altında belirir
Eğer veri geçerliyse null döner Flutter için bu alanda hata yok demektir Null gelmesi 

Animasyon Motoru
AnimatedContainer:Genişlik yükseklik padding margin border renk ve gölge oynatır
AnimatedOpacity:Görünürlüğü 0.0 ila 1.0 arasında yumuşakça soldurur
AnimatedScale:Widget merkezinden dışarıya doğru büyütüp küçülür 
AnimatedAlign:Kutunun içinde sağdan soldan yukarıdan aşağıya karşı konumunu değiştirir

Curves 
İvmelenme Karakterleri

Curves.linear.Sabit hız (robotik hareketler)
Curves.easeInout:Yavaş Başlar ortada hızlanır yavaşça durur
Curves.bounceOut:Hedefe çarptığında top gibi 2 3 kez yaylanarak seker
Curves.elasticInOut: lastik gibi ileri geri titreyerek yerine oturur

Gorouter 

//shellrouterda değişiklik menüde olur alt menü kalan bölümler ise gorouter olarak geçer

context.go('/profile'): Route Yönlendirmesidir.Rota tablosunda hiyerarşiyi takip eder sayfayı temizleyebilir

context.push('/profil/5') Stack yönlendirmesidir.Kullanıcı nereden gelirse gelsin mevcut sayfanın tepesine yeni bir katman ekler ve dönüş sayfası için bir geri ok butonu ekler

context.pop() sayfanın en üstteki yığınını kapatır.

state.pathParameters['id']: Gorouter içinde tanımladığınız /:id yapılarına erişmek için kullanılır 

/profil?user=berat
state.url.queryParameters['user']:Opsiyonelik filtreleme ya da arama zamanlarında kullanılır.

Cihaz içi Yerel depolama mimarileri 

SharadPreferences:
Küçük kullanıcı ayarları 
Düşük
Okuma yazma hızları. Okuma hızı orta/yazma hızı yavaş

FlutterSecureStorage:
Şifre token vb. saklamak için
En yüksek güvence
Orta hız

Hive/Isar:
Yüksek Performanslı nesne
Orta(isteğe bağlı şifreleme açılabilir)
Aşırı hızlı 



