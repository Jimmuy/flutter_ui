// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// @dart = 2.8

import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// A yunMou design checkbox.
class YMCheckbox extends StatefulWidget {
  const YMCheckbox({
    Key key,
    @required this.value,
    this.tristate = false,
    @required this.onChanged,
    this.mouseCursor,
    this.activeColor,
    this.checkColor,
    this.focusColor,
    this.width = 15,
    this.hoverColor,
    this.visualDensity,
    this.focusNode,
    this.autofocus = false,
  })  : assert(tristate != null),
        assert(tristate || value != null),
        assert(autofocus != null),
        super(key: key);

  /// Whether this checkbox is checked.
  ///
  /// This property must not be null.
  final bool value;

  /// ```dart
  /// Checkbox(
  ///   value: _throwShotAway,
  ///   onChanged: (bool newValue) {
  ///     setState(() {
  ///       _throwShotAway = newValue;
  ///     });
  ///   },
  /// )
  /// ```
  final ValueChanged<bool> onChanged;

  final MouseCursor mouseCursor;
  final Color activeColor;

  final Color checkColor;

  final bool tristate;

  final VisualDensity visualDensity;

  /// The color for the checkbox's [Material] when it has the input focus.
  final Color focusColor;

  /// The color for the checkbox's [Material] when a pointer is hovering over it.
  final Color hoverColor;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode focusNode;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  final double width;

  @override
  _YMCheckboxState createState() => _YMCheckboxState();
}

class _YMCheckboxState extends State<YMCheckbox> with TickerProviderStateMixin {
  bool get enabled => widget.onChanged != null;
  Map<Type, Action<Intent>> _actionMap;

  @override
  void initState() {
    super.initState();
    _actionMap = <Type, Action<Intent>>{
      ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: _actionHandler),
    };
  }

  void _actionHandler(ActivateIntent intent) {
    if (widget.onChanged != null) {
      switch (widget.value) {
        case false:
          widget.onChanged(true);
          break;
        case true:
          widget.onChanged(widget.tristate ? null : false);
          break;
        default: // case null:
          widget.onChanged(false);
          break;
      }
    }
    final RenderObject renderObject = context.findRenderObject();
    renderObject.sendSemanticsEvent(const TapSemanticEvent());
  }

  bool _focused = false;

  void _handleFocusHighlightChanged(bool focused) {
    if (focused != _focused) {
      setState(() {
        _focused = focused;
      });
    }
  }

  bool _hovering = false;

  void _handleHoverChanged(bool hovering) {
    if (hovering != _hovering) {
      setState(() {
        _hovering = hovering;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    final ThemeData themeData = Theme.of(context);
    Size size = const Size(kRadialReactionRadius, kRadialReactionRadius);
    size += (widget.visualDensity ?? themeData.visualDensity).baseSizeAdjustment;
    final BoxConstraints additionalConstraints = BoxConstraints.tight(size);
    final MouseCursor effectiveMouseCursor = MaterialStateProperty.resolveAs<MouseCursor>(
      widget.mouseCursor ?? MaterialStateMouseCursor.clickable,
      <MaterialState>{
        if (!enabled) MaterialState.disabled,
        if (_hovering) MaterialState.hovered,
        if (_focused) MaterialState.focused,
        if (widget.tristate || widget.value) MaterialState.selected,
      },
    );

    return FocusableActionDetector(
      actions: _actionMap,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      enabled: enabled,
      onShowFocusHighlight: _handleFocusHighlightChanged,
      onShowHoverHighlight: _handleHoverChanged,
      mouseCursor: effectiveMouseCursor,
      child: Builder(
        builder: (BuildContext context) {
          return _CheckboxRenderObjectWidget(
            value: widget.value,
            tristate: widget.tristate,
            activeColor: widget.activeColor ?? themeData.toggleableActiveColor,
            checkColor: widget.checkColor ?? const Color(0xFFFFFFFF),
            inactiveColor: enabled ? themeData.unselectedWidgetColor : themeData.disabledColor,
            focusColor: widget.focusColor ?? themeData.focusColor,
            hoverColor: widget.hoverColor ?? themeData.hoverColor,
            onChanged: widget.onChanged,
            additionalConstraints: additionalConstraints,
            vsync: this,
            hasFocus: _focused,
            hovering: _hovering,
            width: widget.width,
          );
        },
      ),
    );
  }
}

class _CheckboxRenderObjectWidget extends LeafRenderObjectWidget {
  const _CheckboxRenderObjectWidget({
    Key key,
    @required this.value,
    @required this.tristate,
    @required this.activeColor,
    @required this.checkColor,
    @required this.inactiveColor,
    @required this.focusColor,
    @required this.hoverColor,
    @required this.onChanged,
    @required this.vsync,
    @required this.additionalConstraints,
    @required this.hasFocus,
    @required this.hovering,
    @required this.width,
  })  : assert(tristate != null),
        assert(tristate || value != null),
        assert(activeColor != null),
        assert(inactiveColor != null),
        assert(vsync != null),
        super(key: key);

  final bool value;
  final bool tristate;
  final bool hasFocus;
  final bool hovering;
  final Color activeColor;
  final Color checkColor;
  final Color inactiveColor;
  final Color focusColor;
  final Color hoverColor;
  final ValueChanged<bool> onChanged;
  final TickerProvider vsync;
  final BoxConstraints additionalConstraints;
  final double width;

  @override
  _RenderCheckbox createRenderObject(BuildContext context) => _RenderCheckbox(
        value: value,
        tristate: tristate,
        activeColor: activeColor,
        checkColor: checkColor,
        inactiveColor: inactiveColor,
        focusColor: focusColor,
        hoverColor: hoverColor,
        onChanged: onChanged,
        vsync: vsync,
        additionalConstraints: additionalConstraints,
        hasFocus: hasFocus,
        hovering: hovering,
        width: width,
      );

  @override
  void updateRenderObject(BuildContext context, _RenderCheckbox renderObject) {
    renderObject
      // The `tristate` must be changed before `value` due to the assertion at
      // the beginning of `set value`.
      ..tristate = tristate
      ..value = value
      ..activeColor = activeColor
      ..checkColor = checkColor
      ..inactiveColor = inactiveColor
      ..focusColor = focusColor
      ..hoverColor = hoverColor
      ..onChanged = onChanged
      ..additionalConstraints = additionalConstraints
      ..vsync = vsync
      ..hasFocus = hasFocus
      ..hovering = hovering;
  }
}

const Radius _kEdgeRadius = Radius.circular(2.0);
const double _kStrokeWidth = 1.0;

class _RenderCheckbox extends RenderToggleable {
  double _kEdgeSize;

  _RenderCheckbox({
    bool value,
    bool tristate,
    Color activeColor,
    this.checkColor,
    Color inactiveColor,
    Color focusColor,
    Color hoverColor,
    BoxConstraints additionalConstraints,
    ValueChanged<bool> onChanged,
    bool hasFocus,
    double width,
    bool hovering,
    @required TickerProvider vsync,
  })  : _oldValue = value,
        super(
          value: value,
          tristate: tristate,
          activeColor: activeColor,
          inactiveColor: inactiveColor,
          focusColor: focusColor,
          hoverColor: hoverColor,
          onChanged: onChanged,
          additionalConstraints: additionalConstraints,
          vsync: vsync,
          hasFocus: hasFocus,
          hovering: hovering,
        ) {
    this._kEdgeSize = width;
  }

  bool _oldValue;
  Color checkColor;

  @override
  set value(bool newValue) {
    if (newValue == value) return;
    _oldValue = value;
    super.value = newValue;
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);
    config.isChecked = value == true;
  }

  // The square outer bounds of the checkbox at t, with the specified origin.
  // At t == 0.0, the outer rect's size is _kEdgeSize (Checkbox.width)
  // At t == 0.5, .. is _kEdgeSize - _kStrokeWidth
  // At t == 1.0, .. is _kEdgeSize
  RRect _outerRectAt(Offset origin, double t) {
    final double inset = 1.0 - (t - 0.5).abs() * 2.0;
    final double size = _kEdgeSize - inset * _kStrokeWidth;
    final Rect rect = Rect.fromLTWH(origin.dx + inset, origin.dy + inset, size, size);
    return RRect.fromRectAndRadius(rect, _kEdgeRadius);
  }

  // The checkbox's border color if value == false, or its fill color when
  // value == true or null.
  Color _colorAt(double t) {
    // As t goes from 0.0 to 0.25, animate from the inactiveColor to activeColor.
    return onChanged == null ? inactiveColor : (t >= 0.25 ? activeColor : Color.lerp(inactiveColor, activeColor, t * 4.0));
  }

  // White stroke used to paint the check and dash.
  Paint _createStrokePaint() {
    return Paint()
      ..color = checkColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = _kStrokeWidth;
  }

  void _drawBorder(Canvas canvas, RRect outer, double t, Paint paint) {
    assert(t >= 0.0 && t <= 0.5);
    final double size = outer.width;
    // As t goes from 0.0 to 1.0, gradually fill the outer RRect.
    final RRect inner = outer.deflate(math.min(size / 2.0, _kStrokeWidth + size * t));
    canvas.drawDRRect(outer, inner, paint);
  }

  void _drawCheck(Canvas canvas, Offset origin, double t, Paint paint) {
    assert(t >= 0.0 && t <= 1.0);
    // As t goes from 0.0 to 1.0, animate the two check mark strokes from the
    // short side to the long side.
    final Path path = Path();
    Offset start = Offset(_kEdgeSize * 0.15, _kEdgeSize * 0.45);
    Offset mid = Offset(_kEdgeSize * 0.4, _kEdgeSize * 0.7);
    Offset end = Offset(_kEdgeSize * 0.85, _kEdgeSize * 0.25);
    if (t < 0.5) {
      final double strokeT = t * 2.0;
      final Offset drawMid = Offset.lerp(start, mid, strokeT);
      path.moveTo(origin.dx + start.dx, origin.dy + start.dy);
      path.lineTo(origin.dx + drawMid.dx, origin.dy + drawMid.dy);
    } else {
      final double strokeT = (t - 0.5) * 2.0;
      final Offset drawEnd = Offset.lerp(mid, end, strokeT);
      path.moveTo(origin.dx + start.dx, origin.dy + start.dy);
      path.lineTo(origin.dx + mid.dx, origin.dy + mid.dy);
      path.lineTo(origin.dx + drawEnd.dx, origin.dy + drawEnd.dy);
    }
    canvas.drawPath(path, paint);
  }

  void _drawDash(Canvas canvas, Offset origin, double t, Paint paint) {
    assert(t >= 0.0 && t <= 1.0);
    // As t goes from 0.0 to 1.0, animate the horizontal line from the
    // mid point outwards.
    Offset start = Offset(_kEdgeSize * 0.2, _kEdgeSize * 0.5);
    Offset mid = Offset(_kEdgeSize * 0.5, _kEdgeSize * 0.5);
    Offset end = Offset(_kEdgeSize * 0.8, _kEdgeSize * 0.5);
    final Offset drawStart = Offset.lerp(start, mid, 1.0 - t);
    final Offset drawEnd = Offset.lerp(mid, end, t);
    canvas.drawLine(origin + drawStart, origin + drawEnd, paint);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final Canvas canvas = context.canvas;
    paintRadialReaction(canvas, offset, size.center(Offset.zero));

    final Paint strokePaint = _createStrokePaint();
    final Offset origin = offset + (size / 2.0 - Size.square(_kEdgeSize) / 2.0 as Offset);
    final AnimationStatus status = position.status;
    final double tNormalized =
        status == AnimationStatus.forward || status == AnimationStatus.completed ? position.value : 1.0 - position.value;

    // Four cases: false to null, false to true, null to false, true to false
    if (_oldValue == false || value == false) {
      final double t = value == false ? 1.0 - tNormalized : tNormalized;
      final RRect outer = _outerRectAt(origin, t);
      final Paint paint = Paint()..color = _colorAt(t);

      if (t <= 0.5) {
        _drawBorder(canvas, outer, t, paint);
      } else {
        canvas.drawRRect(outer, paint);

        final double tShrink = (t - 0.5) * 2.0;
        if (_oldValue == null || value == null)
          _drawDash(canvas, origin, tShrink, strokePaint);
        else
          _drawCheck(canvas, origin, tShrink, strokePaint);
      }
    } else {
      // Two cases: null to true, true to null
      final RRect outer = _outerRectAt(origin, 1.0);
      final Paint paint = Paint()..color = _colorAt(1.0);
      canvas.drawRRect(outer, paint);

      if (tNormalized <= 0.5) {
        final double tShrink = 1.0 - tNormalized * 2.0;
        if (_oldValue == true)
          _drawCheck(canvas, origin, tShrink, strokePaint);
        else
          _drawDash(canvas, origin, tShrink, strokePaint);
      } else {
        final double tExpand = (tNormalized - 0.5) * 2.0;
        if (value == true)
          _drawCheck(canvas, origin, tExpand, strokePaint);
        else
          _drawDash(canvas, origin, tExpand, strokePaint);
      }
    }
  }
}
