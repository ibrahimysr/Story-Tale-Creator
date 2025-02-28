import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import '../model/story/story_display_model.dart';
import '../repository/story_display_repository.dart';

class StoryDisplayViewModel extends ChangeNotifier {
  final StoryDisplayRepository _repository;
  bool _isLoading = false;
  String? _errorMessage;
  PaletteGenerator? _palette;
  Color _dominantColor = Colors.black;
  Color _textColor = Colors.white;
  List<Color> _colorPalette = [];

  StoryDisplayViewModel({StoryDisplayRepository? repository})
      : _repository = repository ?? StoryDisplayRepository();

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Color get dominantColor => _dominantColor;
  Color get textColor => _textColor;
  List<Color> get colorPalette => _colorPalette;

  // Rengin parlaklığını kontrol eden yardımcı fonksiyon
  bool _isColorLight(Color color) {
    return color.computeLuminance() > 0.5;
  }

  // Kontrast renk seçen yardımcı fonksiyon
  Color _getContrastingTextColor(Color backgroundColor) {
    return _isColorLight(backgroundColor) 
        ? Colors.black.withValues(alpha:0.8)
        : Colors.white;
  }

  // Renk paletinden en iyi rengi seçen yardımcı fonksiyon
  Color _getBestColor(List<PaletteColor?> colors) {
    // Null olmayan renkleri filtrele
    final validColors = colors.where((c) => c != null).map((c) => c!).toList();
    if (validColors.isEmpty) return Colors.black;

    // Önce vibrant renkleri dene
    final vibrantColors = validColors.where((c) => 
      c.color.computeLuminance() > 0.2 && 
      c.color.computeLuminance() < 0.8
    ).toList();

    if (vibrantColors.isNotEmpty) {
      return vibrantColors.first.color;
    }

    // Vibrant renk bulunamazsa en iyi kontrastı veren rengi seç
    return validColors.first.color;
  }

  Future<void> generatePaletteFromImage(Uint8List imageData) async {
    try {
      final imageProvider = MemoryImage(imageData);
      _palette = await PaletteGenerator.fromImageProvider(
        imageProvider,
        size: const Size(200, 200), // Performans için küçük boyut
        maximumColorCount: 8, // Daha fazla renk seçeneği
      );
      
      if (_palette != null) {
        // En iyi arka plan rengini seç
        final colors = [
          _palette!.dominantColor,
          _palette!.vibrantColor,
          _palette!.mutedColor,
          _palette!.darkVibrantColor,
          _palette!.darkMutedColor,
        ];
        
        _dominantColor = _getBestColor(colors);
        _textColor = _getContrastingTextColor(_dominantColor);
        
        // Renk paletini oluştur
        final paletteColors = [
          _palette!.dominantColor?.color,
          _palette!.vibrantColor?.color,
          _palette!.mutedColor?.color,
          _palette!.darkVibrantColor?.color,
          _palette!.darkMutedColor?.color,
        ].where((color) => color != null).map((color) => color!).toList();

        // Renkleri parlaklığa göre sırala
        paletteColors.sort((a, b) => 
          b.computeLuminance().compareTo(a.computeLuminance())
        );

        _colorPalette = paletteColors;

        if (_colorPalette.isEmpty) {
          _colorPalette = [_dominantColor];
        }
      }
      
      notifyListeners();
    } catch (e) {
      log('Renk paleti oluşturulurken hata: $e');
    }
  }

  // Hikayeyi kaydetme
  Future<void> saveStory(StoryDisplayModel story) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _repository.saveStory(story);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // Hata mesajını temizleme
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
} 