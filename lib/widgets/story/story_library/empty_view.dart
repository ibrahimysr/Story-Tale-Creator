import 'package:flutter/material.dart';
import 'package:masal/core/extension/context_extension.dart';
import 'package:masal/core/extension/locazition_extension.dart';

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
           Text(
            context.localizations.noSavedStories,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
           Text(
            context.localizations.createNewStory,
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