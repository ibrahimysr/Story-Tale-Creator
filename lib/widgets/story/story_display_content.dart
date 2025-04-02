import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:masal/core/extension/context_extension.dart';
import 'package:masal/core/extension/locazition_extension.dart';

class StoryDisplayContent extends StatefulWidget {
  final String story;
  final String title;
  final Uint8List? image;
  final VoidCallback onSave;
  final bool isLoading;
  final bool showSaveButton;
  final Color textColor;
  final Color dominantColor;
  final List<Color> colorPalette;
  final LiquidController liquidController;
  final Function(int) onPageChanged;

  const StoryDisplayContent({
    super.key,
    required this.story,
    required this.title,
    this.image,
    required this.onSave,
    required this.isLoading,
    required this.showSaveButton,
    required this.textColor,
    required this.liquidController,
    required this.dominantColor,
    required this.colorPalette,
    required this.onPageChanged,
  });

  @override
  State<StoryDisplayContent> createState() => _StoryDisplayContentState();
}

class _StoryDisplayContentState extends State<StoryDisplayContent> {
  late final List<String> _pages;
  late final List<Color> _pageColors;

  @override
  void initState() {
    super.initState();
    _pages = _splitIntoPages(widget.story);
    _pageColors = _generatePageColors();
  }

  List<String> _splitIntoPages(String story) {
    final paragraphs =
        story.split('\n\n').where((p) => p.trim().isNotEmpty).toList();
    return paragraphs;
  }

  List<Color> _generatePageColors() {
    final List<Color> colors = [];

    if (widget.colorPalette.isEmpty || widget.colorPalette.length < 2) {
      Color baseColor = widget.dominantColor;

      for (int i = 0; i < _pages.length; i++) {
        colors.add(baseColor);
      }
    } else {
      for (int i = 0; i < _pages.length; i++) {
        int colorIndex = i % widget.colorPalette.length;
        colors.add(widget.colorPalette[colorIndex]);
      }
    }

    return colors;
  }

  @override
  Widget build(BuildContext context) {
    return LiquidSwipe(
      pages: _buildPages(),
      fullTransitionValue: 800,
      enableLoop: false,
      enableSideReveal: true,
      liquidController: widget.liquidController,
      ignoreUserGestureWhileAnimating: true,
      slideIconWidget: Icon(
        Icons.arrow_back_ios,
        color: widget.textColor.withValues(alpha: 0.5),
        size: 20,
      ),
      positionSlideIcon: 0.8,
      waveType: WaveType.liquidReveal,
      onPageChangeCallback: widget.onPageChanged,
      currentUpdateTypeCallback: (updateType) {},
    );
  }

  List<Widget> _buildPages() {
    return List.generate(_pages.length, (index) {
      if (index == 0 && widget.image != null) {
        return _buildCoverPage(index);
      }
      return _buildContentPage(index);
    });
  }

  Widget _buildCoverPage(int index) {
    return Container(
      color: _pageColors[index],
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: widget.colorPalette.length >= 2
                    ? [widget.colorPalette[0], widget.colorPalette[1]]
                    : [
                        _pageColors[index],
                        _pageColors[index].withValues(alpha: 0.7)
                      ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.image != null) ...[
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 15,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.memory(widget.image!, fit: BoxFit.cover),
                    ),
                  ),
                  SizedBox(height: context.getDynamicHeight(5)),
                ],
                Text(
                  widget.title,
                  style: TextStyle(
                    color: widget.textColor,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: context.getDynamicHeight(2)),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: context.lowValue * 1.5,
                      vertical: context.lowValue * 0.8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.swipe,
                        color: widget.textColor.withValues(alpha: 0.8),
                        size: 18,
                      ),
                      SizedBox(width: context.getDynamicWidth(3)),
                      Text(
                        context.localizations.swipeToRead,
                        style: TextStyle(
                          color: widget.textColor.withValues(alpha: 0.8),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _pageColors[index].withValues(alpha: 0.3),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentPage(int index) {
    bool isLastPage = index == _pages.length - 1;

    return Container(
      color: _pageColors[index],
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: widget.colorPalette.length >= 2
                    ? [widget.colorPalette[0], widget.colorPalette[1]]
                    : [
                        _pageColors[index],
                        _pageColors[index].withValues(alpha: 0.7)
                      ],
              ),
            ),
          ),
          Positioned(
            top: -80,
            right: -80,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
          ),
          Positioned(
            bottom: -40,
            left: -40,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),
          isLastPage
              ? Container(
                  margin: const EdgeInsets.fromLTRB(20, 80, 20, 80),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: _buildLastPageContent())
              : Container(
                  margin: const EdgeInsets.fromLTRB(20, 80, 20, 80),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: _buildRegularPageContent(index),
                ),
          if (widget.image != null && !isLastPage) ...[
            Positioned(
              top: 20,
              right: 20,
              child: Container(
                width: context.getDynamicWidth(35),
                height: context.getDynamicHeight(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(widget.image!, fit: BoxFit.cover),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRegularPageContent(int index) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.image != null) const SizedBox(height: 60),
          Text(
            _pages[index],
            style: TextStyle(
              color: widget.textColor,
              fontSize: 17,
              height: 1.7,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLastPageContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (widget.image != null) ...[
            Container(
              width: context.getDynamicWidth(50),
              height: context.getDynamicHeight(30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: Image.memory(widget.image!, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 24),
          ],
          const Icon(
            Icons.auto_stories,
            size: 60,
            color: Colors.white70,
          ),
          const SizedBox(height: 24),
          Text(
            context.localizations.storyEnd,
            style: TextStyle(
              color: widget.textColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          if (widget.showSaveButton) ...[
            ElevatedButton.icon(
              onPressed: widget.isLoading ? null : widget.onSave,
              icon: widget.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.save),
              label: Text(
                  widget.isLoading ? context.localizations.saving :  context.localizations.saveToLibrary),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                foregroundColor: widget.textColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
