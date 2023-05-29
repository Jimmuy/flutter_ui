import 'package:flutter/material.dart';
import 'dart:math' as math;

///弧形进度
class YMArcProgress extends StatelessWidget {
  final Widget? child;
  final double? progress;

  ///进度弧开始的弧度，注意不是角度，0.0是从0点位置开始绘制
  final double? startAngle;
  final double? width;
  final Color? progressColor;
  final Color? backgroundColor;

  const YMArcProgress({
    Key? key,
    this.child,
    this.progress,
    this.startAngle,
    this.width,
    this.progressColor,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ArcPainter(
        progress: progress,
        startAngle: startAngle,
        width: width,
        progressColor: progressColor,
        backgroundColor: backgroundColor,
      ),
      child: child,
    );
  }
}

class _ArcPainter extends CustomPainter {
  final double? progress;

  ///进度弧开始的弧度，注意不是角度，0.0是从0点位置开始绘制
  final double? startAngle;
  final double? width;
  final Color? progressColor;
  final Color? backgroundColor;

  _ArcPainter({
    this.startAngle,
    this.width,
    this.progress: 0.5,
    this.progressColor,
    this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = width ?? 8.0;
    final rect = Rect.fromLTWH(0.0, 0.0, size.width, size.height).deflate(strokeWidth / 2.0);

    ///[StrokeCap.round]会让画笔有一个直径strokeWidth的圆占位
    ///所有需要减去这个圆占位的弧度
    ///这里使用[占位圆直径和外圆周长度的比值]来近似计算出这个弧度
    final minAngle = (strokeWidth / ((rect.width) * math.pi)) * math.pi * 2.0;
    final _startAngle = math.pi * 1.5 + (startAngle ?? 0.0);
    double _sweepAngle = math.pi * progress! * 2.0;

    if(_sweepAngle < minAngle){
      _sweepAngle = minAngle;
    }else if(_sweepAngle + minAngle > math.pi * 2.0){
      _sweepAngle = math.pi * 2.0 - minAngle;
    }

    ///绘制背景弧
    if (_sweepAngle < math.pi * 2.0) {
      canvas.drawArc(
            rect,
            _startAngle + _sweepAngle,
            math.pi * (1 - progress!) * 2.0,
            false,
            Paint()
              ..color = backgroundColor ?? const Color(0xFFF2F2F2)
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth
              ..strokeCap = StrokeCap.square,
          );
    }

    ///绘制进度弧
    if (_sweepAngle > 0.0) {
      canvas.drawArc(
            rect,
            _startAngle,
            _sweepAngle,
            false,
            Paint()
              ..color = progressColor ?? const Color(0xFFFF7444)
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth
              ..strokeCap = StrokeCap.round,
          );
    }
  }

  @override
  bool shouldRepaint(_ArcPainter oldDelegate) => true;
}
