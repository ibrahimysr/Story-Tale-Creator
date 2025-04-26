import 'package:flutter/material.dart';
import 'package:masal/core/extension/locazition_extension.dart';

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
                ? context.localizations.noStoryFound
                : context.localizations.noStoryShared,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          if (!isSearching)
             Text(
              context.localizations.shareFirstStory,
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