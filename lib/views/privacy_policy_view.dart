import 'package:flutter/material.dart';
import 'package:masal/core/extension/context_extension.dart';
import 'package:masal/core/theme/space_theme.dart';
import 'package:masal/core/theme/widgets/starry_background.dart';

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: SpaceTheme.mainGradient),
        child: Stack(
          children: [
            const Positioned.fill(child: StarryBackground()),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.getDynamicWidth(5),
                    vertical: context.getDynamicHeight(2),
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: Card(
                      color: SpaceTheme.primaryDark.withValues(alpha:0.8),
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.security,
                              size: 80,
                              color: SpaceTheme.accentGold,
                              shadows: [
                                Shadow(
                                  color: SpaceTheme.accentPurple,
                                  blurRadius: 15,
                                ),
                              ],
                            ),
                            SizedBox(height: context.getDynamicHeight(3)),
                            Text(
                              'Gizlilik Politikası',
                              style: SpaceTheme.titleStyle.copyWith(
                                fontSize: 32,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: context.getDynamicHeight(2)),
                            Text(
                              '''
Uzay Macerası Gizlilik Politikası
Son Güncelleme: 17.03.2025

Merhaba, yıldızlararası yolcu! Biz, Uzay Macerası Ekibi ("Galaksi Mürettebatı" ya da "Biz"), bu Platform (https://ibrahimysr.com ve mobil uygulamalarımız) ile sana eşsiz bir uzay macerası sunuyoruz. Bu Gizlilik Politikası, kişisel verilerinizi nasıl topladığımızı, kullandığımızı ve galaksi çapında koruduğumuzu açıklayan bir yıldız rehberidir.

### Verileriniz Bizimle Güvende mi?
Evet, kaptan! Kişisel verileriniz (e-posta, şifre, cihaz bilgileri gibi), uzay gemimizin en güvenli kabinlerinde saklanır. Bu verileri yalnızca Hizmetlerimizi sunmak, hesabınızı yönetmek ve galaksimizi geliştirmek için kullanıyoruz.

### Neleri Topluyoruz?
- **Kişisel Veriler**: E-posta adresin, şifren gibi seni tanımlayan bilgiler.
- **Üçüncü Taraflar**: Analitik araçlar ve hizmet sağlayıcılarla paylaşılan anonim veriler.

### Verilerinizle Ne Yapıyoruz?
- Hizmetlerimizi çalıştırmak (hesap oluşturma, silme vb.).
- Platformumuzu güvenli ve eğlenceli tutmak.
- Yasal yükümlülüklerimizi yerine getirmek (galaksi kanunları önemli!).

### Kimlerle Paylaşıyoruz?
Verilerinizi yalnızca şu durumlarda paylaşırız:
- Hizmet sağlayıcılarımız (örneğin, bulut sistemleri).
- Yasal gereklilikler (uzay polisi sorarsa).

### Haklarınız Neler?
- Verilerine erişme, düzeltme veya silme hakkı.
- İşlemeye itiraz etme veya verilerini başka bir gemiye taşıma.
- Soruların için bize ulaşma: ibrahimyasar2701@gmail.com

### Güvenlik ve Saklama
Verilerinizi yıldız tozuna dönüşmeden koruyoruz. Teknik ve organizasyonel önlemlerle güvenliğini sağlıyor, sadece gerektiği sürece saklıyoruz.

### Bize Ulaşın
Soruların varsa, galaksi iletişim kanalımız açık:
- E-posta: ibrahimyasar2701@gmail.com


Bu Politikayı kabul ederek, uzay gemimize binmiş ve kurallarımıza uymuş olursunuz. Yıldızlarla dolu bir yolculuk dileriz!
                              ''',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha:0.8),
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(height: context.getDynamicHeight(2)),
                            TextButton(
                              onPressed: () => Navigator.pushNamed(context, '/delete-account'),
                              child: Text(
                                'Geri Dön',
                                style: TextStyle(
                                  color: SpaceTheme.accentGold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}