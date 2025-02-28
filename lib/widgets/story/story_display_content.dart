import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:math' as math;

class StoryDisplayContent extends StatefulWidget {
  final String story;
  final String title;
  final Uint8List? image;
  final VoidCallback onSave;
  final bool isLoading;
  final bool showSaveButton;
  final Color textColor;

  const StoryDisplayContent({
    Key? key,
    required this.story,
    required this.title,
    this.image,
    required this.onSave,
    required this.isLoading,
    required this.showSaveButton,
    required this.textColor,
  }) : super(key: key);

  @override
  State<StoryDisplayContent> createState() => _StoryDisplayContentState();
}

class _StoryDisplayContentState extends State<StoryDisplayContent> with SingleTickerProviderStateMixin {
  late final PageController _pageController;
  late final AnimationController _animationController;
  late final List<String> _pages;
  int _currentPage = 0;
  double _dragPosition = 0;

  @override
  void initState() {
    super.initState();
    _pages = _splitIntoPages(widget.story);
    _pageController = PageController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  List<String> _splitIntoPages(String story) {
    final paragraphs = story.split('\n\n').where((p) => p.trim().isNotEmpty).toList();
    return paragraphs;
  }

  void _onPageTurning(double position) {
    setState(() {
      _dragPosition = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        final position = details.primaryDelta! / MediaQuery.of(context).size.width;
        _onPageTurning(position);
      },
      onHorizontalDragEnd: (details) {
        final velocity = details.primaryVelocity ?? 0;
        if (velocity < -300 && _currentPage < _pages.length - 1) {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCubic,
          );
        } else if (velocity > 300 && _currentPage > 0) {
          _pageController.previousPage(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCubic,
          );
        }
      },
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(_dragPosition * math.pi),
                alignment: _dragPosition < 0 ? Alignment.centerRight : Alignment.centerLeft,
                child: _buildPage(index),
              );
            },
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_currentPage > 0)
                  _buildNavigationButton(
                    icon: Icons.arrow_back_ios,
                    onPressed: () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeOutCubic,
                      );
                    },
                  ),
                const SizedBox(width: 20),
                Text(
                  '${_currentPage + 1}/${_pages.length}',
                  style: TextStyle(
                    color: widget.textColor.withOpacity(0.8),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 20),
                if (_currentPage < _pages.length - 1)
                  _buildNavigationButton(
                    icon: Icons.arrow_forward_ios,
                    onPressed: () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeOutCubic,
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(int index) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          if (widget.image != null) ...[
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.memory(
                  widget.image!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Text(
                _pages[index],
                style: TextStyle(
                  color: widget.textColor,
                  fontSize: 18,
                  height: 1.6,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: Icon(icon, color: widget.textColor),
        onPressed: onPressed,
      ),
    );
  }
}

class PageFlipPhysics extends ScrollPhysics {
  const PageFlipPhysics({ScrollPhysics? parent}) : super(parent: parent);

  @override
  PageFlipPhysics applyTo(ScrollPhysics? ancestor) {
    return PageFlipPhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring => const SpringDescription(
        mass: 50,
        stiffness: 100,
        damping: 1,
      );

  @override
  double getPage(ScrollMetrics position) {
    return position.pixels / position.viewportDimension;
  }

  @override
  double getPixels(ScrollMetrics position, double page) {
    return page * position.viewportDimension;
  }

  @override
  double getTargetPixels(ScrollMetrics position, double velocity, double suggestedPixels) {
    return suggestedPixels;
  }

  @override
  Simulation? createBallisticSimulation(ScrollMetrics position, double velocity) {
    if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent) ||
        (velocity >= 0.0 && position.pixels >= position.maxScrollExtent)) {
      return null;
    }

    final page = (position.pixels / position.viewportDimension).round();
    final target = position.viewportDimension * page;

    if (target == position.pixels) {
      return null;
    }

    return ScrollSpringSimulation(
      spring,
      position.pixels,
      target,
      velocity,
      tolerance: tolerance,
    );
  }
} 