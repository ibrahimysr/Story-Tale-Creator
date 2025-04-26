import 'package:flutter/material.dart';
import 'package:masal/core/extension/context_extension.dart'; 
import 'package:masal/core/theme/space_theme.dart';
import 'package:masal/viewmodels/story_display_viewmodel.dart';

class ReportButton extends StatelessWidget {
  final StoryDisplayViewModel viewModel;
  final String storyTitle;
  final String storyContent;
  final VoidCallback? onReportSuccess;

  const ReportButton({
    super.key,
    required this.viewModel,
    required this.storyTitle,
    required this.storyContent,
    this.onReportSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: viewModel.colorPalette.isNotEmpty
              ? viewModel.colorPalette[0].withValues(alpha: 0.3)
              : Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          Icons.report,
          color: viewModel.textColor,
        ),
      ),
      onPressed: () => _showReportDialog(context),
    );
  }

  Future<void> _showReportDialog(BuildContext context) async {
    String reportReason = '';

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: context.paddingLowVertical * 1.5,
          decoration: BoxDecoration(
            gradient: SpaceTheme.mainGradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: SpaceTheme.accentPurple.withValues(alpha: 0.5),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'İçeriği Bildir',
                style: SpaceTheme.titleStyle.copyWith(
                  fontSize: 22,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: context.getDynamicHeight(2)),
              Padding(
                padding: context.paddingLowHorizontal * 1.3,
                child: Text(
                  'Lütfen bu içeriği neden bildirdiğinizi belirtin:',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: context.getDynamicHeight(2)),
              Container(
                margin: context.paddingLowHorizontal * 1.3,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  onChanged: (value) => reportReason = value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Rapor nedeni',
                    hintStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                    border: InputBorder.none,
                  ),
                  maxLines: 3,
                ),
              ),
              SizedBox(height: context.getDynamicHeight(3)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          SpaceTheme.primaryDark.withValues(alpha: 0.8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: context.lowValue * 2,
                        vertical: context.lowValue,
                      ),
                    ),
                    child: Text(
                      'İptal',
                      style: TextStyle(
                        color: SpaceTheme.accentBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: SpaceTheme.accentPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: context.lowValue * 2,
                        vertical: context.lowValue,
                      ),
                    ),
                    child: const Text(
                      'Gönder',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (result != true || reportReason.trim().isEmpty) return;

    try {
      if (!context.mounted) return;
    

      final success = await viewModel.reportStory(
        storyTitle: storyTitle,
        storyContent: storyContent,
        reason: reportReason,
        context: context,
      );

      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Raporunuz gönderildi. Teşekkür ederiz!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            backgroundColor: SpaceTheme.accentPurple.withValues(alpha: 0.8),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        );
        if (onReportSuccess != null) onReportSuccess!();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Rapor gönderilemedi: $e',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            backgroundColor: Colors.red.withValues(alpha: 0.8),
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        );
      }
    }
  }
}