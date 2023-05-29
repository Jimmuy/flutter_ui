import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

class BoxDashDecoration extends StatelessWidget {
  final Widget child;
  final Radius? radius;
  final Color? color;

  ///虚线的长
  final double? dashWidth;

  ///虚线的间隔
  final double? dashGap;

  ///虚线的宽
  final double? width;

  const BoxDashDecoration({
    Key? key,
    required this.child,
    this.radius,
    this.color,
    this.dashWidth,
    this.dashGap,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      child: child,
      painter: _BoxDashPainter(
        radius: radius,
        color: color,
        dashWidth: dashWidth,
        dashGap: dashGap,
        width: width,
      ),
    );
  }
}

class _BoxDashPainter extends CustomPainter {
  final Radius? radius;
  final Color? color;
  final double? dashWidth;
  final double? dashGap;
  final double? width;

  _BoxDashPainter({
    this.radius,
    this.color,
    this.dashWidth,
    this.dashGap,
    this.width,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = dashPath(
        Path()
          ..addRRect(RRect.fromRectAndRadius(
            Rect.fromLTWH(
              0.0,
              0.0,
              size.width,
              size.height,
            ),
            radius ?? Radius.circular(4.0),
          )),
        dashArray: CircularIntervalList<double>([dashWidth ?? 4.0, dashGap ?? 4.0]));
    canvas.drawPath(
        path,
        Paint()
          ..color = this.color ?? const Color(0xFF808080)
          ..strokeWidth = width ?? 0.5
          ..style = PaintingStyle.stroke);
  }

  @override
  bool shouldRepaint(_BoxDashPainter oldDelegate) =>
      this.width != oldDelegate.width ||
      this.dashWidth != oldDelegate.dashWidth ||
      this.color != oldDelegate.color ||
      this.radius != oldDelegate.radius ||
      this.dashGap != oldDelegate.dashGap;
}
