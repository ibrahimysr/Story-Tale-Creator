import 'package:flutter/material.dart';

class EmptyView extends StatelessWidget {
  final bool isSearching;

  const EmptyView({super.key, required this.isSearching});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSearching ? Icons.search_off : Icons.explore_off,
            color: Colors.amber[100],
            size: 60,
          ),
          const SizedBox(height: 16),
          Text(
            isSearching
                ? 'Aradığınız kriterlere uygun hikaye bulunamadı'
                : 'Henüz hikaye paylaşılmamış',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          if (!isSearching)
            const Text(
              'İlk hikayeyi siz paylaşın!',
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