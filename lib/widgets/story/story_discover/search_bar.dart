import 'package:flutter/material.dart';
import 'package:masal/core/extension/context_extension.dart';
import 'package:masal/core/theme/space_theme.dart';
import 'package:masal/viewmodels/story_discover_viewmodel.dart';
import 'package:provider/provider.dart';

class DiscoverSearchBar extends StatelessWidget {
  const DiscoverSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StoryDiscoverViewModel>(
      builder: (context, viewModel, _) {
        return Padding(
          padding: context.paddingLow * 1.5,
          child: TextField(
            onChanged: (value) => viewModel.search(value),
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Hikayelerde ara...',
              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.white.withValues(alpha: 0.6),
              ),
              filled: true,
              fillColor: SpaceTheme.accentPurple.withValues(alpha: 0.2),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
          ),
        );
      },
    );
  }
}