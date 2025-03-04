import 'package:flutter/material.dart';
import 'package:masal/core/theme/space_theme.dart';
import 'package:masal/views/auth/login_view.dart';

class LoginRequiredDialog extends StatelessWidget {
  const LoginRequiredDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: SpaceTheme.primaryDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: const Text(
        'Giriş Yapmanız Gerekiyor',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      content: const Text(
        'Hikaye oluşturma özelliğini kullanmak için lütfen giriş yapın veya kayıt olun.',
        style: TextStyle(color: Colors.white70),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'İptal',
            style: TextStyle(color: SpaceTheme.accentBlue),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginView()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: SpaceTheme.accentPurple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Giriş Yap',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}