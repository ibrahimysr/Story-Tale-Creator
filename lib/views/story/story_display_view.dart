import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:masal/widgets/navigation/bottom_nav_bar.dart';
import 'package:masal/widgets/report_button.dart';
import 'package:provider/provider.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import '../../core/theme/space_theme.dart';
import '../../model/story/story_display_model.dart';
import '../../viewmodels/story_display_viewmodel.dart';
import '../../widgets/story/story_display_content.dart';

class StoryDisplayView extends StatefulWidget {
  final String story;
  final String title;
  final Uint8List? image;
  final bool showSaveButton;

  const StoryDisplayView({
    super.key,
    required this.story,
    required this.title,
    this.image,
    this.showSaveButton = true,
  });

  @override
  State<StoryDisplayView> createState() => _StoryDisplayViewState();
}

class _StoryDisplayViewState extends State<StoryDisplayView> {
  late StoryDisplayViewModel viewModel;
  late LiquidController liquidController;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    viewModel = StoryDisplayViewModel();
    liquidController = LiquidController();
    if (widget.image != null) {
      viewModel.generatePaletteFromImage(widget.image!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: Consumer<StoryDisplayViewModel>(
        builder: (context, viewModel, _) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: viewModel.dominantColor,
            appBar: _buildAppBar(context, viewModel),
            body: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: viewModel.colorPalette.length >= 2
                          ? [
                              viewModel.colorPalette[0],
                              viewModel.colorPalette[1],
                            ]
                          : [
                              viewModel.dominantColor,
                              viewModel.dominantColor.withValues(alpha: 0.7),
                            ],
                    ),
                  ),
                  child: _buildBackgroundElements(viewModel),
                ),
                SafeArea(
                  child: StoryDisplayContent(
                    story: widget.story,
                    title: widget.title,
                    image: widget.image,
                    onSave: () => _saveStory(context, viewModel),
                    isLoading: viewModel.isLoading,
                    showSaveButton: widget.showSaveButton,
                    textColor: viewModel.textColor,
                    liquidController: liquidController,
                    dominantColor: viewModel.dominantColor,
                    colorPalette: viewModel.colorPalette,
                    onPageChanged: (page) {
                      setState(() {
                        currentPage = page;
                      });
                    },
                  ),
                ),
                _buildNavigationControls(viewModel),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBackgroundElements(StoryDisplayViewModel viewModel) {
    if (viewModel.colorPalette.isEmpty) return const SizedBox.shrink();

    return Stack(
      children: viewModel.colorPalette.take(3).map((color) {
        return Positioned(
          left: -50 + (viewModel.colorPalette.indexOf(color) * 100),
          top: -100 + (viewModel.colorPalette.indexOf(color) * 50),
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.3),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.2),
                  blurRadius: 50,
                  spreadRadius: 20,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNavigationControls(StoryDisplayViewModel viewModel) {
    final pages = _splitIntoPages(widget.story);

    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.arrow_back,
                color: currentPage > 0
                    ? viewModel.textColor
                    : viewModel.textColor.withValues(alpha: 0.3),
                size: 20,
              ),
            ),
            onPressed: currentPage > 0
                ? () => liquidController.jumpToPage(page: currentPage - 1)
                : null,
          ),
          Text(
            '${currentPage + 1} / ${pages.length}',
            style: TextStyle(
              color: viewModel.textColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.arrow_forward,
                color: currentPage < pages.length - 1
                    ? viewModel.textColor
                    : viewModel.textColor.withValues(alpha: 0.3),
                size: 20,
              ),
            ),
            onPressed: currentPage < pages.length - 1
                ? () => liquidController.jumpToPage(page: currentPage + 1)
                : null,
          ),
        ],
      ),
    );
  }

  List<String> _splitIntoPages(String story) {
    final paragraphs =
        story.split('\n\n').where((p) => p.trim().isNotEmpty).toList();
    return paragraphs;
  }

  PreferredSizeWidget _buildAppBar(
      BuildContext context, StoryDisplayViewModel viewModel) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => MainScreen()));
        },
      ),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        widget.title,
        style: SpaceTheme.titleStyle.copyWith(
          fontSize: 20,
          color: viewModel.textColor,
        ),
      ),
      iconTheme: IconThemeData(color: viewModel.textColor),
      actions: [
        ReportButton(
          viewModel: viewModel,
          storyTitle: widget.title,
          storyContent: widget.story,
        ),
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: viewModel.colorPalette.isNotEmpty
                  ? viewModel.colorPalette[0].withValues(alpha: 0.3)
                  : Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: viewModel.isLoadingPdf
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Icon(
                    Icons.picture_as_pdf,
                    color: viewModel.textColor,
                  ),
          ),
          onPressed: viewModel.isLoadingPdf
              ? null
              : () => viewModel.exportToPdf(
                  title: widget.title,
                  story: widget.story,
                  image: widget.image,
                  context: context,
                  viewModel: viewModel),
        ),
        if (widget.showSaveButton)
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: viewModel.colorPalette.isNotEmpty
                    ? viewModel.colorPalette[0].withValues(alpha: 0.3)
                    : Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: viewModel.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Icon(
                      Icons.save,
                      color: viewModel.textColor,
                    ),
            ),
            onPressed: viewModel.isLoading
                ? null
                : () => _saveStory(context, viewModel),
          ),
        const SizedBox(width: 8),
      ],
    );
  }

  Future<void> _saveStory(
      BuildContext context, StoryDisplayViewModel viewModel) async {
    try {
      final storyModel = StoryDisplayModel(
        story: widget.story,
        title: widget.title,
        image: widget.image,
      );
      final success = await viewModel.saveStory(storyModel, context: context);

      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Hikaye kütüphanenize kaydedildi! ✨',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: viewModel.textColor,
                  fontSize: 16,
                ),
              ),
            ),
            backgroundColor: viewModel.colorPalette.isNotEmpty
                ? viewModel.colorPalette[0].withValues(alpha: 0.8)
                : SpaceTheme.accentPurple.withValues(alpha: 0.8),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Bir hata oluştu: ${e.toString()}',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: viewModel.textColor,
                fontSize: 16,
              ),
            ),
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
