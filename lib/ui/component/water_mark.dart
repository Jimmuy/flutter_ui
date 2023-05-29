import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math' as math;

///水印绘制控件
class WaterMark extends StatelessWidget {
  ///水印的文本
  final String? text;

  ///水印的样式
  final TextStyle? style;

  ///水印横向间距
  final double hSpace;

  ///水印纵向间距
  final double vSpace;

  ///四角的弧度
  final Radius? topLeft;
  final Radius? topRight;
  final Radius? bottomRight;
  final Radius? bottomLeft;

  /// 水印旋转角度，不设置默认旋转对角线角度
  final double? rotation;

  ///背景颜色
  final Color? backgroundColor;

  ///true先绘制child再绘制水印,false先绘制水印在绘制child
  final bool isForeground;
  final Widget? child;

  const WaterMark({
    Key? key,
    this.text,
    this.style,
    this.hSpace: 10.0,
    this.vSpace: 10.0,
    this.topLeft,
    this.topRight,
    this.bottomRight,
    this.bottomLeft,
    this.backgroundColor,
    this.child,
    this.isForeground: true,
    this.rotation,
  }) : super(key: key);

  WaterMark.corners({
    Key? key,
    this.text,
    this.style,
    this.hSpace: 10.0,
    this.vSpace: 10.0,
    this.backgroundColor,
    this.child,
    this.isForeground: true,
    this.rotation,
    Radius radius = Radius.zero,
  })  : topLeft = radius,
        topRight = radius,
        bottomRight = radius,
        bottomLeft = radius,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return _WaterMarkRenderObject(
      text: text,
      style: style,
      hSpace: hSpace,
      vSpace: vSpace,
      topLeft: topLeft,
      topRight: topRight,
      bottomRight: bottomRight,
      bottomLeft: bottomLeft,
      backgroundColor: backgroundColor,
      isForeground: isForeground,
      child: child,
    );
  }
}

class _WaterMarkRenderObject extends SingleChildRenderObjectWidget {
  final String? text;
  final TextStyle? style;
  final double? hSpace;
  final double? vSpace;
  final Radius? topLeft;
  final Radius? topRight;
  final Radius? bottomRight;
  final Radius? bottomLeft;
  final Color? backgroundColor;
  final bool? isForeground;
  final double? rotation;

  _WaterMarkRenderObject({
    this.text,
    this.style,
    this.hSpace,
    this.vSpace,
    this.topLeft,
    this.topRight,
    this.bottomRight,
    this.bottomLeft,
    this.backgroundColor,
    this.isForeground,
    this.rotation,
    Widget? child,
  }) : super(child: child);

  @override
  RenderObject createRenderObject(BuildContext context) => _WaterMarkRender(
        text: text,
        style: style,
        hSpace: hSpace,
        vSpace: vSpace,
        topLeft: topLeft,
        topRight: topRight,
        bottomRight: bottomRight,
        bottomLeft: bottomLeft,
        backgroundColor: backgroundColor,
        isForeground: isForeground,
        rotation: rotation,
      );

  @override
  void updateRenderObject(BuildContext context, _WaterMarkRender renderObject) {
    renderObject
      ..style = style
      ..text = text
      ..hSpace = hSpace
      ..vSpace = vSpace
      ..backgroundColor = backgroundColor
      ..rotation = this.rotation
      ..setCorners(
        topLeft: topLeft,
        topRight: topRight,
        bottomRight: bottomRight,
        bottomLeft: bottomLeft,
      );
  }
}

class _WaterMarkRender extends RenderProxyBox {
  String? _text;
  TextStyle _style;
  double _hSpace;
  double _vSpace;
  Color? _backgroundColor;

  Radius? _topLeft;
  Radius? _topRight;
  Radius? _bottomRight;
  Radius? _bottomLeft;

  ///true先绘制child再绘制水印,false先绘制水印在绘制child
  bool? isForeground;

  double? _rotation;

  _WaterMarkRender({
    this.isForeground: true,
    double? rotation,
    String? text,
    TextStyle? style,
    double? hSpace,
    double? vSpace,
    Color? backgroundColor,
    Radius? topLeft = Radius.zero,
    Radius? topRight = Radius.zero,
    Radius? bottomRight = Radius.zero,
    Radius? bottomLeft = Radius.zero,
    RenderBox? child,
  })  : _vSpace = vSpace ?? 10.0,
        _text = text,
        _style = style ?? const TextStyle(fontSize: 14.0, color: Colors.grey),
        _hSpace = hSpace ?? 10.0,
        _backgroundColor = backgroundColor,
        _topLeft = topLeft,
        _topRight = topRight,
        _bottomRight = bottomRight,
        _bottomLeft = bottomLeft,
        _rotation = rotation,
        super(child);

  set text(String? value) {
    if (this._text != value) {
      _text = value;
      markNeedsPaint();
    }
  }

  set rotation(double? value) {
    if (_rotation != value) {
      _rotation = value;
      markNeedsPaint();
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (isForeground!) {
      super.paint(context, offset);
    }
    _onDraw(context, offset);
    if (!isForeground!) {
      super.paint(context, offset);
    }
  }

  void _onDraw(PaintingContext context, Offset offset) {
    final canvas = context.canvas;
    if (_backgroundColor != null) {
      _drawBackground(canvas, offset);
    }

    if (_text != null && _text!.length > 0) {
      canvas.save();
      canvas.translate(offset.dx, offset.dy);

      ///根据背景切割画布，防止绘制内容外溢
      canvas.clipRRect(RRect.fromRectAndCorners(
        Rect.fromLTWH(
          0.0,
          0.0,
          size.width,
          size.height,
        ),
        topLeft: _topLeft!,
        topRight: _topRight!,
        bottomRight: _bottomRight!,
        bottomLeft: _bottomLeft!,
      ));
      _drawText(canvas);
      canvas.restore();
    }
  }

  ///绘制签名文本
  void _drawText(Canvas canvas) {
    final painter = TextPainter(
      maxLines: 1,
      ellipsis: '',
      text: TextSpan(text: _text, style: _style),
      textDirection: TextDirection.ltr,
    );
    painter.layout();

    ///计算对角线的长度，将文字绘制在边长为对角线的矩形中
    final dimension = math.sqrt((size.width * size.width + size.height * size.height));

    final offset = Offset((size.width - dimension) / 2.0, (size.height - dimension) / 2.0);

    final cx = dimension / 2.0;
    canvas.save();

    ///画布移动到中心点，逆时针旋转对角线的夹角
    canvas.translate(offset.dx + cx, offset.dy + cx);

    final rotation = this._rotation;
    if (rotation != null) {
      canvas.rotate(rotation * math.pi / 180);
    } else {
      canvas.rotate(-math.atan2(size.height, size.width));
    }

    ///画布移动到左上角
    canvas.translate(-cx, -cx);
    final textSize = painter.size;
    double top = 0.0;
    while (top < dimension) {
      double left = 0.0;
      while (left < dimension) {
        painter.paint(canvas, Offset(left, top));
        left += textSize.width + _hSpace;
      }
      top += textSize.height + _vSpace;
    }
    canvas.restore();
  }

  ///绘制背景
  void _drawBackground(Canvas canvas, Offset offset) {
    canvas.save();
    canvas.translate(offset.dx, offset.dy);
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(
          0.0,
          0.0,
          size.width,
          size.height,
        ),
        topLeft: _topLeft!,
        topRight: _topRight!,
        bottomRight: _bottomRight!,
        bottomLeft: _bottomLeft!,
      ),
      Paint()
        ..color = _backgroundColor!
        ..style = PaintingStyle.fill,
    );
    canvas.restore();
  }

  set style(TextStyle? value) {
    if (value != null && value == _style) {
      _style = value;
      markNeedsPaint();
    }
  }

  set hSpace(double? value) {
    if (value != null && value == _hSpace) {
      _hSpace = value;
      markNeedsPaint();
    }
  }

  set vSpace(double? value) {
    if (value != null && value != _vSpace) {
      _vSpace = value;
      markNeedsPaint();
    }
  }

  set backgroundColor(Color? value) {
    if (value != _backgroundColor) {
      _backgroundColor = value;
      markNeedsPaint();
    }
  }

  void setCorners({
    Radius? topLeft = Radius.zero,
    Radius? topRight = Radius.zero,
    Radius? bottomRight = Radius.zero,
    Radius? bottomLeft = Radius.zero,
  }) {
    bool invalidate = false;
    if (topLeft != _topLeft) {
      _topLeft = topLeft;
      invalidate = true;
    }
    if (topRight != _topRight) {
      _topRight = topRight;
      invalidate = true;
    }
    if (bottomRight != _bottomRight) {
      _bottomRight = bottomRight;
      invalidate = true;
    }
    if (bottomLeft != _bottomLeft) {
      _bottomLeft = bottomLeft;
      invalidate = true;
    }
    if (invalidate) {
      markNeedsPaint();
    }
  }
}
