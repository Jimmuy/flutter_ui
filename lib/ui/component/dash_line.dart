import 'package:flutter/material.dart';

class DashLine extends StatelessWidget {
  final Color color;
  final double dashWidth;
  final double gapWidth;
  final double strokeWidth;

  const DashLine({
    Key? key,
    this.color: Colors.red,
    this.dashWidth: 6.0,
    this.gapWidth: 4.0,
    this.strokeWidth: 1.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        height: strokeWidth,
        child: CustomPaint(
          size: Size.infinite,
          painter: _DashLinePainter(color, dashWidth, gapWidth),
        ),
      );
}

class _DashLinePainter extends CustomPainter {
  final Color color;
  final double dashWidth;
  final double gapWidth;

  _DashLinePainter(this.color, this.dashWidth, this.gapWidth);

  @override
  void paint(Canvas canvas, Size size) {
    double x = 0;
    final painter = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.height
      ..color = this.color;

    while (x < size.width) {
      canvas.drawLine(Offset(x, 0), Offset(x + dashWidth, 0), painter);
      x += dashWidth + gapWidth;
    }
  }

  @override
  bool shouldRepaint(_DashLinePainter oldDelegate) =>
      color != oldDelegate.color || dashWidth != oldDelegate.dashWidth || gapWidth != oldDelegate.gapWidth;
}
