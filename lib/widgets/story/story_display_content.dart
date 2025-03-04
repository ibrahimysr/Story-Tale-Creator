import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:liquid_swipe/liquid_swipe.dart';

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
    final paragraphs = story.split('\n\n').where((p) => p.trim().isNotEmpty).toList();
    return paragraphs;
  }

  List<Color> _generatePageColors() {
    // AppBar'da olduğu gibi renkleri ayarla
    final List<Color> colors = [];
    
    if (widget.colorPalette.isEmpty || widget.colorPalette.length < 2) {
      // Eğer palet yoksa, dominant rengin çeşitlemelerini kullan
      Color baseColor = widget.dominantColor;
      
      for (int i = 0; i < _pages.length; i++) {
        // AppBar'da olduğu gibi gradyan için iki renk kullan
        colors.add(baseColor);
      }
    } else {
      // Paletteki renkleri dönüşümlü olarak kullan
      for (int i = 0; i < _pages.length; i++) {
        // Sayfaların renklerini palette'den al
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
      fullTransitionValue: 500, // Adjust for swipe sensitivity
      enableLoop: false,
      enableSideReveal: true,
      liquidController: widget.liquidController,
      ignoreUserGestureWhileAnimating: true,
      slideIconWidget: Icon(
        Icons.arrow_back_ios,
        color: widget.textColor.withOpacity(0.5),
        size: 20,
      ),
      positionSlideIcon: 0.8,
      waveType: WaveType.liquidReveal,
      onPageChangeCallback: widget.onPageChanged,
      currentUpdateTypeCallback: (updateType) {
        // Optional callback for update type (manual, auto, etc)
      },
    );
  }

  List<Widget> _buildPages() {
    return List.generate(_pages.length, (index) {
      // Add a cover page as the first item if needed
      if (index == 0 && widget.image != null) {
        return _buildCoverPage(index);
      }
      
      // Regular content pages
      return _buildContentPage(index);
    });
  }

  Widget _buildCoverPage(int index) {
    return Container(
      color: _pageColors[index],
      child: Stack(
        children: [
          // Background gradients or designs - AppBar'la aynı gradient mantığını kullan
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: widget.colorPalette.length >= 2
                    ? [
                        widget.colorPalette[0],
                        widget.colorPalette[1],
                      ]
                    : [
                        _pageColors[index],
                        _pageColors[index].withOpacity(0.7),
                      ],
              ),
            ),
          ),
          
          // Content
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Story image
                if (widget.image != null) ...[
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 15,
                          spreadRadius: 5,
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
                  const SizedBox(height: 40),
                ],
                
                // Title
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
                
                const SizedBox(height: 20),
                
                // Swipe instruction
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.swipe,
                        color: widget.textColor.withOpacity(0.8),
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Okumak için kaydırın',
                        style: TextStyle(
                          color: widget.textColor.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Decorative elements
          Positioned(
            bottom: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _pageColors[index].withOpacity(0.3),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentPage(int index) {
    // Check if we should use a closing page
    bool isLastPage = index == _pages.length - 1;
    
    return Container(
      color: _pageColors[index],
      child: Stack(
        children: [
          // Background gradient - AppBar gibi gradient kullan
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: widget.colorPalette.length >= 2
                    ? [
                        widget.colorPalette[0],
                        widget.colorPalette[1],
                      ]
                    : [
                        _pageColors[index],
                        _pageColors[index].withOpacity(0.7),
                      ],
              ),
            ),
          ),
          
          // Decorative circles
          Positioned(
            top: -80,
            right: -80,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
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
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          
          // Content container
          Container(
            margin: const EdgeInsets.fromLTRB(20, 80, 20, 80),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: isLastPage ? _buildLastPageContent() : _buildRegularPageContent(index),
          ),
          
          // Her sayfada resim olsun
          if (widget.image != null && !isLastPage) ...[
            Positioned(
              top: 20,
              right: 20,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(
                    widget.image!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
          
          // Page number
          Positioned(
            bottom: 50,
            right: 50,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  color: widget.textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Son sayfada resim ekle
        if (widget.image != null) ...[
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(60),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: Image.memory(
                widget.image!,
                fit: BoxFit.cover,
              ),
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
          'Hikaye Sonu',
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
            label: Text(widget.isLoading ? 'Kaydediliyor...' : 'Kütüphaneme Kaydet'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.2),
              foregroundColor: widget.textColor,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ],
    );
  }
}