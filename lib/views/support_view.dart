import 'package:flutter/material.dart';
import 'package:masal/core/extension/context_extension.dart';
import 'package:masal/core/theme/space_theme.dart';
import 'package:masal/core/theme/widgets/starry_background.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportView extends StatefulWidget {
  const SupportView({super.key});

  @override
  State<SupportView> createState() => _SupportViewState();
}

class _SupportViewState extends State<SupportView> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendSupportEmail(String message) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'ibrahimyasar2701@gmail.com',
      queryParameters: {
        'subject': 'Uzay Macerası - Destek Talebi',
        'body': 'Merhaba,\n\nMesajım: $message\n\nSaygılarımla,\n[Kullanıcı Adı/E-posta]',
      },
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      if(mounted){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'E-posta uygulaması açılamadı!',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red.withValues(alpha:0.8),
        ),
      );
    }}
  }

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
                              Icons.support_agent,
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
                              'Destek Al',
                              style: SpaceTheme.titleStyle.copyWith(
                                fontSize: 32,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: context.getDynamicHeight(2)),
                            Text(
                              'Soruların mı var? Bize mesaj gönder, uzay ekibimiz sana yardımcı olsun!',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha:0.8),
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: context.getDynamicHeight(3)),
                            TextField(
                              controller: _messageController,
                              maxLines: 5,
                              decoration: InputDecoration(
                                labelText: 'Mesajın',
                                labelStyle: TextStyle(color: Colors.white.withValues(alpha:0.8)),
                                hintText: 'Sorunu veya talebini yaz...',
                                hintStyle: TextStyle(color: Colors.white.withValues(alpha:0.6)),
                                prefixIcon: Icon(
                                  Icons.message_outlined,
                                  color: SpaceTheme.accentPurple,
                                ),
                                filled: true,
                                fillColor: SpaceTheme.primaryDark.withValues(alpha:0.3),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                      color: SpaceTheme.accentPurple.withValues(alpha:0.5)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                      color: SpaceTheme.accentPurple, width: 2),
                                ),
                              ),
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(height: context.getDynamicHeight(3)),
                            ElevatedButton(
                              onPressed: () {
                                if (_messageController.text.isNotEmpty) {
                                  _sendSupportEmail(_messageController.text);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Lütfen bir mesaj gir!',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.red.withValues(alpha:0.8),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: SpaceTheme.accentPurple,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 15),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25)),
                                elevation: 5,
                              ),
                              child: Text(
                                'Mesaj Gönder',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: context.getDynamicHeight(2)),
                            TextButton(
                              onPressed: () => Navigator.pop(context),
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