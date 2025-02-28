import 'package:flutter/material.dart';
import 'dart:typed_data';
import '../../core/theme/space_theme.dart';

class StoryDisplayContent extends StatelessWidget {
  final String story;
  final String title;
  final Uint8List? image;
  final VoidCallback onSave;
  final bool isLoading;
  final bool showSaveButton;

  const StoryDisplayContent({
    Key? key,
    required this.story,
    required this.title,
    this.image,
    required this.onSave,
    required this.isLoading,
    this.showSaveButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (image != null)
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: SpaceTheme.accentPurple.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image.memory(
                    image!,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            if (showSaveButton)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: SpaceTheme.accentPurple.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      color: Colors.amber[100],
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Hikayeniz Hazır!',
                      style: TextStyle(
                        color: Colors.amber[100],
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              story,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                height: 1.6,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 