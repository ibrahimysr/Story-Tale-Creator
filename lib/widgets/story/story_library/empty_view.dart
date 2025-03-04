import 'package:flutter/material.dart';
import 'package:masal/core/extension/context_extension.dart';

class EmptyView extends StatelessWidget {
  const EmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.book,
            color: Colors.amber[100],
            size: 60,
          ),
          SizedBox(height: context.getDynamicHeight(2)),
          const Text(
            'Henüz kaydedilmiş hikayeniz yok',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Yeni bir hikaye oluşturun ve kaydedin!',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}