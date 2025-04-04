import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:masal/core/theme/space_theme.dart';
import 'package:masal/views/subscription/subscription_view.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:printing/printing.dart';
import '../model/story/story_display_model.dart';
import '../repository/story_display_repository.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class StoryDisplayViewModel extends ChangeNotifier {
  final StoryDisplayRepository _repository;
  bool _isLoading = false;
  bool _isLoadingPdf = false;
  String? _errorMessage;
  PaletteGenerator? _palette;
  Color _dominantColor = Colors.black;
  Color _textColor = Colors.white;
  List<Color> _colorPalette = [];

  StoryDisplayViewModel({StoryDisplayRepository? repository})
      : _repository = repository ?? StoryDisplayRepository();

  bool get isLoading => _isLoading;
  bool get isLoadingPdf => _isLoadingPdf;
  String? get errorMessage => _errorMessage;
  Color get dominantColor => _dominantColor;
  Color get textColor => _textColor;
  List<Color> get colorPalette => _colorPalette;

  bool _isColorLight(Color color) {
    return color.computeLuminance() > 0.5;
  }

  Color _getContrastingTextColor(Color backgroundColor) {
    return _isColorLight(backgroundColor)
        ? Colors.black.withValues(alpha: 0.8)
        : Colors.white;
  }

  Color _getBestColor(List<PaletteColor?> colors) {
    final validColors = colors.where((c) => c != null).map((c) => c!).toList();
    if (validColors.isEmpty) return Colors.black;

    final vibrantColors = validColors
        .where((c) =>
            c.color.computeLuminance() > 0.2 &&
            c.color.computeLuminance() < 0.8)
        .toList();

    if (vibrantColors.isNotEmpty) {
      return vibrantColors.first.color;
    }

    return validColors.first.color;
  }

  Future<void> generatePaletteFromImage(Uint8List imageData) async {
    try {
      final imageProvider = MemoryImage(imageData);
      _palette = await PaletteGenerator.fromImageProvider(
        imageProvider,
        size: const Size(200, 200),
        maximumColorCount: 8,
      );

      if (_palette != null) {
        final colors = [
          _palette!.dominantColor,
          _palette!.vibrantColor,
          _palette!.mutedColor,
          _palette!.darkVibrantColor,
          _palette!.darkMutedColor,
        ];

        _dominantColor = _getBestColor(colors);
        _textColor = _getContrastingTextColor(_dominantColor);

        final paletteColors = [
          _palette!.dominantColor?.color,
          _palette!.vibrantColor?.color,
          _palette!.mutedColor?.color,
          _palette!.darkVibrantColor?.color,
          _palette!.darkMutedColor?.color,
        ].where((color) => color != null).map((color) => color!).toList();

        paletteColors.sort(
            (a, b) => b.computeLuminance().compareTo(a.computeLuminance()));

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

  Future<bool> saveStory(StoryDisplayModel story,
      {BuildContext? context}) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final success = await _repository.saveStory(story, context: context);

      _isLoading = false;
      notifyListeners();

      return success;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<bool> reportStory({
    required String storyTitle,
    required String storyContent,
    required String reason,
    BuildContext? context,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final success = await _repository.reportStory(
        storyTitle: storyTitle,
        storyContent: storyContent,
        reason: reason,
        context: context,
      );

      _isLoading = false;
      notifyListeners();

      return success;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<Uint8List> generateStoryPdf({
    required String title,
    required String story,
    Uint8List? image,
  }) async {
    final pdf = pw.Document();

    final font = await PdfGoogleFonts.openSansRegular();
    final titleFont = await PdfGoogleFonts.playfairDisplayBold();

    final paragraphs =
        story.split('\n\n').where((p) => p.trim().isNotEmpty).toList();

    final primaryDark = PdfColor.fromInt(0xFF1A0B2E);
    final primaryLight = PdfColor.fromInt(0xFF2C1854);
    final accentGold = PdfColor.fromInt(0xFFFFD700);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(base: font, bold: titleFont),
        build: (pw.Context context) {
          return pw.Container(
            width: double.infinity,
            height: double.infinity,
            decoration: pw.BoxDecoration(
              gradient: pw.LinearGradient(
                colors: [primaryDark, primaryLight],
                begin: pw.Alignment.topLeft,
                end: pw.Alignment.bottomRight,
              ),
            ),
            child: pw.Center(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text(
                    title,
                    style: pw.TextStyle(
                      font: titleFont,
                      fontSize: 36,
                      color: accentGold,
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                  if (image != null)
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 40),
                      child: pw.Center(
                        child: pw.Container(
                          width: 350,
                          height: 350,
                          decoration: pw.BoxDecoration(
                            borderRadius: pw.BorderRadius.circular(20),
                            image: pw.DecorationImage(
                              image: pw.MemoryImage(image),
                              fit: pw.BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );

    for (var i = 0; i < paragraphs.length; i += 2) {
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          theme: pw.ThemeData.withFont(base: font, bold: titleFont),
          build: (pw.Context context) {
            return pw.Container(
              width: double.infinity,
              height: double.infinity,
              decoration: pw.BoxDecoration(
                gradient: pw.LinearGradient(
                  colors: [primaryLight, primaryDark],
                  begin: pw.Alignment.topLeft,
                  end: pw.Alignment.bottomRight,
                ),
              ),
              child: pw.Padding(
                padding: const pw.EdgeInsets.all(40),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    if (image != null)
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(bottom: 20),
                        child: pw.Center(
                          child: pw.Container(
                            width: 250,
                            height: 250,
                            decoration: pw.BoxDecoration(
                              borderRadius: pw.BorderRadius.circular(15),
                              image: pw.DecorationImage(
                                image: pw.MemoryImage(image),
                                fit: pw.BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),
                    pw.Text(
                      paragraphs[i],
                      style: pw.TextStyle(
                        font: font,
                        fontSize: 16,
                        lineSpacing: 1.5,
                        color: accentGold,
                      ),
                      textAlign: pw.TextAlign.justify,
                    ),
                    pw.SizedBox(height: 20),
                    if (i + 1 < paragraphs.length)
                      pw.Text(
                        paragraphs[i + 1],
                        style: pw.TextStyle(
                          font: font,
                          fontSize: 16,
                          lineSpacing: 1.5,
                          color: accentGold,
                        ),
                        textAlign: pw.TextAlign.justify,
                      ),
                    pw.Spacer(),
                    pw.Align(
                      alignment: pw.Alignment.centerRight,
                      child: pw.Text(
                        'Sayfa ${i ~/ 2} / ${(paragraphs.length + 1) ~/ 2 + 1}',
                        style: pw.TextStyle(
                            font: font, fontSize: 10, color: accentGold),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }

    return pdf.save();
  }

  Future<void> exportToPdf({
    required String title,
    required String story,
    Uint8List? image,
    required BuildContext context,
    required dynamic viewModel,
  }) async {
    try {
      _isLoadingPdf = true;
      notifyListeners();

      final isSubscribed = await _repository.isUserSubscribed();
      if (!isSubscribed) {
        if (context.mounted) {
          _showSubscriptionDialog(context);
        }
        _isLoadingPdf = false;
        notifyListeners();
        return;
      }

      final pdfBytes = await generateStoryPdf(
        title: title,
        story: story,
        image: image,
      );

      await Printing.sharePdf(
        bytes: pdfBytes,
        filename: '$title.pdf',
      );

      _isLoadingPdf = false;
      notifyListeners();
    } catch (e) {
      _isLoadingPdf = false;
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  void _showSubscriptionDialog(BuildContext context) {
    Theme.of(context);
    final accentColor = SpaceTheme.accentPurple;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            width: 300,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.deepPurple.shade800,
                  Colors.deepPurple.shade600,
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 15,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.lock_outline_rounded,
                  color: Colors.white,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  'Abonelik Gerekli',
                  style: SpaceTheme.titleStyle.copyWith(
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'PDF indirmek için premium abone olmanız gerekiyor.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white.withValues(alpha: 0.7),
                      ),
                      child: const Text(
                        'İptal',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PremiumPurchaseView()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 3,
                      ),
                      child: const Text(
                        'Abone Ol',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
