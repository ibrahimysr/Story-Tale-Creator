import 'package:flutter/material.dart';
import 'package:masal/core/extension/locazition_extension.dart';
import 'package:masal/core/theme/space_theme.dart';
import 'package:masal/viewmodels/story_discover_viewmodel.dart';

class ErrorView extends StatelessWidget {
  final StoryDiscoverViewModel viewModel;

  const ErrorView({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
   if (viewModel.context == null) {
          viewModel.updateContext(context); 
        }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red[300],
            size: 60,
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              viewModel.errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: viewModel.loadStories,
            style: ElevatedButton.styleFrom(
              backgroundColor: SpaceTheme.accentBlue,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child:  Text(
              context.localizations.tryAgain,
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}