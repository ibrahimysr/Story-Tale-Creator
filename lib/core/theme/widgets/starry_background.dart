import 'package:flutter/material.dart';

class StarryBackground extends StatelessWidget {
  const StarryBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: StarryBackgroundPainter(),
      child: Container(),
    );
  }
}

class StarryBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    final random = DateTime.now().millisecondsSinceEpoch;

    for (var i = 0; i < 100; i++) {
      final x = (random + i * 7) % size.width;
      final y = (random + i * 11) % size.height;
      final radius = ((random + i) % 3) / 2;

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
} 