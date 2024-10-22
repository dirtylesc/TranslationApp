import 'package:flutter/material.dart';

class EllipseWidget extends StatelessWidget {
  final Size size;
  final Color color;
  final double left;
  final double top;

  const EllipseWidget(
      {super.key,
      required this.size,
      required this.color,
      required this.left,
      required this.top});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: size,
      painter: _EllipsePainter(color: color, left: left, top: top),
    );
  }
}

class _EllipsePainter extends CustomPainter {
  final Color color;
  final double left;
  final double top;

  _EllipsePainter({required this.color, required this.left, required this.top});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final rect = Rect.fromLTWH(left, top, size.width, size.height);
    canvas.drawOval(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
