// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui' show lerpDouble;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

/// An iOS-style switch.
///
/// Used to toggle the on/off state of a single setting.
///

class YMSwitchController with ControllerMixin<_YMSwitchState> {
  void setSwitchState(bool switchState) {
    state?._setSwitchState(switchState);
  }
}

///无状态管理的switch
class YMFakeSwitch extends StatelessWidget {
  final bool value;

  final ValueChanged<bool> onChanged;

  /// switch的宽度
  final double? width;

  /// switch的高度
  final double? height;

  final Color? activeColor;

  final DragStartBehavior dragStartBehavior;

  final TickerProvider vsync;

  const YMFakeSwitch({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.vsync,
    this.width,
    this.height,
    this.activeColor,
    this.dragStartBehavior: DragStartBehavior.start,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BoxConstraints? constraints = width == null || height == null ? null : BoxConstraints.tightFor(width: width, height: height);
    return Opacity(
      opacity: onChanged == null ? _kCupertinoSwitchDisabledOpacity : 1.0,
      child: _YmSwitchRenderObjectWidget(
          value: value,
          activeColor: CupertinoDynamicColor.resolve(
            activeColor ?? const Color(0xFFFF5E34),
            context,
          ),
          onChanged: (v) {
            onChanged(v);
          },
          vsync: vsync,
          dragStartBehavior: dragStartBehavior,
          constraints: constraints),
    );
  }
}

///有状态管理的switch
class YMSwitch extends StatefulWidget {
  /// The [value] parameter must not be null.
  /// The [dragStartBehavior] parameter defaults to [DragStartBehavior.start] and must not be null.
  const YMSwitch({
    Key? key,
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.controller,
    this.dragStartBehavior = DragStartBehavior.start,
    this.width = defaultSwitchWidth,
    this.height = defaultSwitchHeight,
  }) : super(key: key);

  final YMSwitchController? controller;

  final bool value;

  final ValueChanged<bool>? onChanged;

  /// switch的宽度
  final double width;

  /// switch的高度
  final double height;

  final Color? activeColor;

  final DragStartBehavior dragStartBehavior;

  @override
  _YMSwitchState createState() => _YMSwitchState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(FlagProperty('value', value: value, ifTrue: 'on', ifFalse: 'off', showName: true));
    properties.add(ObjectFlagProperty<ValueChanged<bool>>('onChanged', onChanged, ifNull: 'disabled'));
  }
}

class _YMSwitchState extends State<YMSwitch> with TickerProviderStateMixin {
  ///默认开关的状态
  bool _switchOn = false;

  @override
  void initState() {
    super.initState();
    _switchOn = widget.value;
    widget.controller?.attach(this);
  }

  @override
  void didUpdateWidget(YMSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    _switchOn = widget.value;
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.detach();
      widget.controller?.attach(this);
    }
  }

  void _setSwitchState(bool state) {
    setState(() {
      _switchOn = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = widget.width;
    final height = widget.height;
    BoxConstraints? constraints = BoxConstraints.tightFor(width: width, height: height);
    return Opacity(
      opacity: widget.onChanged == null ? _kCupertinoSwitchDisabledOpacity : 1.0,
      child: _YmSwitchRenderObjectWidget(
          value: _switchOn,
          activeColor: CupertinoDynamicColor.resolve(
            widget.activeColor ?? const Color(0xFFFF5E34),
            context,
          ),
          onChanged: (v) {
            widget.onChanged!(v);
            setState(() {
              _switchOn = v;
            });
          },
          vsync: this,
          dragStartBehavior: widget.dragStartBehavior,
          constraints: constraints),
    );
  }
}

class _YmSwitchRenderObjectWidget extends LeafRenderObjectWidget {
  _YmSwitchRenderObjectWidget({
    Key? key,
    this.value,
    this.activeColor,
    this.onChanged,
    this.vsync,
    this.dragStartBehavior = DragStartBehavior.start,
    this.radius,
    this.constraints,
  }) : super(key: key);

  final double? radius;
  final bool? value;
  final Color? activeColor;
  final ValueChanged<bool>? onChanged;
  final TickerProvider? vsync;
  final DragStartBehavior dragStartBehavior;
  final BoxConstraints? constraints;

  @override
  _RenderCupertinoSwitch createRenderObject(BuildContext context) {
    return _RenderCupertinoSwitch(
        value: value!,
        activeColor: activeColor!,
        trackColor: CupertinoDynamicColor.resolve(CupertinoColors.secondarySystemFill, context),
        onChanged: onChanged,
        textDirection: Directionality.maybeOf(context) ?? TextDirection.ltr,
        vsync: vsync!,
        constraints: constraints,
        dragStartBehavior: dragStartBehavior,
        painter: YMThumbPainter(radius: radius));
  }

  @override
  void updateRenderObject(BuildContext context, _RenderCupertinoSwitch renderObject) {
    renderObject
      ..value = value!
      ..activeColor = activeColor!
      ..trackColor = CupertinoDynamicColor.resolve(CupertinoColors.secondarySystemFill, context)
      ..onChanged = onChanged
      ..textDirection = Directionality.maybeOf(context) ?? TextDirection.ltr
      ..vsync = vsync!
      ..dragStartBehavior = dragStartBehavior;
  }
}

const double defaultSwitchWidth = 50.0;
const double defaultSwitchHeight = 30.0;

// Opacity of a disabled switch, as eye-balled from iOS Simulator on Mac.
const double _kCupertinoSwitchDisabledOpacity = 0.5;

const Duration _kReactionDuration = Duration(milliseconds: 300);
const Duration _kToggleDuration = Duration(milliseconds: 200);

class _RenderCupertinoSwitch extends RenderConstrainedBox {
  _RenderCupertinoSwitch({
    required bool value,
    required Color activeColor,
    required Color trackColor,
    ValueChanged<bool>? onChanged,
    required TextDirection textDirection,
    required TickerProvider vsync,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    required YMThumbPainter painter,
    BoxConstraints? constraints,
  })  : _value = value,
        _activeColor = activeColor,
        _trackColor = trackColor,
        _onChanged = onChanged,
        _textDirection = textDirection,
        _vsync = vsync,
        _painter = painter,
        super(additionalConstraints: constraints ?? BoxConstraints.tightFor(width: defaultSwitchWidth, height: defaultSwitchHeight)) {
    _tap = TapGestureRecognizer()
      ..onTapDown = _handleTapDown
      ..onTap = _handleTap
      ..onTapUp = _handleTapUp
      ..onTapCancel = _handleTapCancel;
    _drag = HorizontalDragGestureRecognizer()
      ..onStart = _handleDragStart
      ..onUpdate = _handleDragUpdate
      ..onEnd = _handleDragEnd
      ..dragStartBehavior = dragStartBehavior;
    _positionController = AnimationController(
      duration: _kToggleDuration,
      value: value ? 1.0 : 0.0,
      vsync: vsync,
    );
    _position = CurvedAnimation(
      parent: _positionController,
      curve: Curves.linear,
    )
      ..addListener(markNeedsPaint)
      ..addStatusListener(_handlePositionStateChanged);

    _reactionController = AnimationController(
      duration: _kReactionDuration,
      vsync: vsync,
    );
    _reaction = CurvedAnimation(
      parent: _reactionController,
      curve: Curves.ease,
    )..addListener(markNeedsPaint);
  }

  YMThumbPainter _painter;
  late AnimationController _positionController;
  late CurvedAnimation _position;

  late AnimationController _reactionController;
  late Animation<double> _reaction;

  bool get value => _value;
  bool _value;

  double horizontalSwitchInset = 2;
  double verticalSwitchInset = 2;

  set value(bool value) {
    if (value == _value) return;
    _value = value;
    markNeedsSemanticsUpdate();
    _position
      ..curve = Curves.ease
      ..reverseCurve = Curves.ease.flipped;
    if (value)
      _positionController.forward();
    else
      _positionController.reverse();
  }

  TickerProvider get vsync => _vsync;
  TickerProvider _vsync;

  set vsync(TickerProvider value) {
    if (value == _vsync) return;
    _vsync = value;
    _positionController.resync(vsync);
    _reactionController.resync(vsync);
  }

  Color get activeColor => _activeColor;
  Color _activeColor;

  set activeColor(Color value) {
    if (value == _activeColor) return;
    _activeColor = value;
    markNeedsPaint();
  }

  Color get trackColor => _trackColor;
  Color _trackColor;

  set trackColor(Color value) {
    if (value == _trackColor) return;
    _trackColor = value;
    markNeedsPaint();
  }

  ValueChanged<bool>? get onChanged => _onChanged;
  ValueChanged<bool>? _onChanged;

  set onChanged(ValueChanged<bool>? value) {
    if (value == _onChanged) return;
    final bool wasInteractive = isInteractive;
    _onChanged = value;
    if (wasInteractive != isInteractive) {
      markNeedsPaint();
      markNeedsSemanticsUpdate();
    }
  }

  TextDirection get textDirection => _textDirection;
  TextDirection _textDirection;

  set textDirection(TextDirection value) {
    if (_textDirection == value) return;
    _textDirection = value;
    markNeedsPaint();
  }

  DragStartBehavior get dragStartBehavior => _drag.dragStartBehavior;

  set dragStartBehavior(DragStartBehavior value) {
    if (_drag.dragStartBehavior == value) return;
    _drag.dragStartBehavior = value;
  }

  bool get isInteractive => onChanged != null;

  late TapGestureRecognizer _tap;
  late HorizontalDragGestureRecognizer _drag;

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    if (value)
      _positionController.forward();
    else
      _positionController.reverse();
    if (isInteractive) {
      switch (_reactionController.status) {
        case AnimationStatus.forward:
          _reactionController.forward();
          break;
        case AnimationStatus.reverse:
          _reactionController.reverse();
          break;
        case AnimationStatus.dismissed:
        case AnimationStatus.completed:
          // nothing to do
          break;
      }
    }
  }

  @override
  void detach() {
    _positionController.stop();
    _reactionController.stop();
    super.detach();
  }

  ///拖动回调，这个时候switch展示的状态已经变化了，需要改变_value
  void _handlePositionStateChanged(AnimationStatus status) {
    if (isInteractive) {
      if (status == AnimationStatus.completed && !_value) {
        onChanged!(_value = true);
      } else if (status == AnimationStatus.dismissed && _value) {
        onChanged!(_value = false);
      }
    }
  }

  void _handleTapDown(TapDownDetails details) {
    if (isInteractive) _reactionController.forward();
  }

  ///点击回调，这个时候switch展示的状态没有变化，不需要改变_value
  void _handleTap() {
    if (isInteractive) {
      onChanged!(!_value);
      _emitVibration();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (isInteractive) _reactionController.reverse();
  }

  void _handleTapCancel() {
    if (isInteractive) _reactionController.reverse();
  }

  void _handleDragStart(DragStartDetails details) {
    if (isInteractive) {
      _reactionController.forward();
      _emitVibration();
    }
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (isInteractive) {
      _position
        ..curve = Curves.linear
        ..reverseCurve = null;
      final double delta = details.primaryDelta! / (size.width - horizontalSwitchInset * 2);
      switch (textDirection) {
        case TextDirection.rtl:
          _positionController.value -= delta;
          break;
        case TextDirection.ltr:
          _positionController.value += delta;
          break;
      }
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_position.value >= 0.5)
      _positionController.forward();
    else
      _positionController.reverse();
    _reactionController.reverse();
  }

  void _emitVibration() {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        HapticFeedback.lightImpact();
        break;
      default:
        break;
    }
  }

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    assert(debugHandleEvent(event, entry));
    if (event is PointerDownEvent && isInteractive) {
      _drag.addPointer(event);
      _tap.addPointer(event);
    }
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);

    if (isInteractive) config.onTap = _handleTap;

    config.isEnabled = isInteractive;
    config.isToggled = _value;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final Canvas canvas = context.canvas;

    final double currentValue = _position.value;
    final double currentReactionValue = _reaction.value;

    late double visualPosition;
    switch (textDirection) {
      case TextDirection.rtl:
        visualPosition = 1.0 - currentValue;
        break;
      case TextDirection.ltr:
        visualPosition = currentValue;
        break;
    }

    final Paint paint = Paint()..color = Color.lerp(trackColor, activeColor, currentValue)!;

    ///外矩形边框
    final Rect trackRect = Rect.fromLTWH(
      offset.dx,
      offset.dy,
      size.width,
      size.height,
    );

    ///外圆角矩形边框
    final RRect trackRRect = RRect.fromRectAndRadius(trackRect, Radius.circular(size.height / 2.0));
    canvas.drawRRect(trackRRect, paint);

    final radius = (size.height - verticalSwitchInset * 2) / 2.0;
    final double currentThumbExtension = YMThumbPainter.extension * currentReactionValue;

    final double thumbLeft = lerpDouble(
      trackRect.left + horizontalSwitchInset,
      trackRect.right - radius * 2 - horizontalSwitchInset - currentThumbExtension,
      visualPosition,
    )!;

    final double thumbRight = lerpDouble(
      trackRect.left + radius * 2 + horizontalSwitchInset + currentThumbExtension,
      trackRect.right - horizontalSwitchInset,
      visualPosition,
    )!;

    final double thumbCenterY = offset.dy + size.height / 2.0;
    final Rect thumbBounds = Rect.fromLTRB(
      thumbLeft,
      thumbCenterY - radius,
      thumbRight,
      thumbCenterY + radius,
    );

    context.pushClipRRect(needsCompositing, Offset.zero, thumbBounds, trackRRect, (PaintingContext innerContext, Offset offset) {
      _painter.paint(innerContext.canvas, thumbBounds);
    });
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder description) {
    super.debugFillProperties(description);
    description.add(FlagProperty('value', value: value, ifTrue: 'checked', ifFalse: 'unchecked', showName: true));
    description.add(
        FlagProperty('isInteractive', value: isInteractive, ifTrue: 'enabled', ifFalse: 'disabled', showName: true, defaultValue: true));
  }
}

const Color _kThumbBorderColor = Color(0x0A000000);

const List<BoxShadow> _kSliderBoxShadows = <BoxShadow>[
  BoxShadow(
    color: Color(0x26000000),
    offset: Offset(0, 3),
    blurRadius: 8.0,
  ),
  BoxShadow(
    color: Color(0x29000000),
    offset: Offset(0, 1),
    blurRadius: 1.0,
  ),
  BoxShadow(
    color: Color(0x1A000000),
    offset: Offset(0, 3),
    blurRadius: 1.0,
  ),
];

/// Paints an iOS-style slider thumb or switch thumb.

class YMThumbPainter {
  YMThumbPainter({
    this.color = CupertinoColors.white,
    this.shadows = _kSliderBoxShadows,
    required this.radius,
  });

  /// The color of the interior of the thumb.
  final Color color;

  /// The list of [BoxShadow] to paint below the thumb.
  ///
  /// Must not be null.
  final List<BoxShadow> shadows;

  /// Half the default diameter of the thumb.
  final double? radius;

  /// The default amount the thumb should be extended horizontally when pressed.
  static const double extension = 7.0;

  /// Paints the thumb onto the given canvas in the given rectangle.
  ///
  /// Consider using [radius] and [extension] when deciding how large a
  /// rectangle to use for the thumb.
  void paint(Canvas canvas, Rect rect) {
    final RRect rrect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(rect.shortestSide / 2.0),
    );

    for (BoxShadow shadow in shadows) canvas.drawRRect(rrect.shift(shadow.offset), shadow.toPaint());

    canvas.drawRRect(
      rrect.inflate(0.5),
      Paint()..color = _kThumbBorderColor,
    );
    canvas.drawRRect(rrect, Paint()..color = color);
  }
}

mixin ControllerMixin<T extends State> {
  T? _state;

  attach(T state) {
    this._state = state;
  }

  detach() {
    this._state = null;
  }

  T? get state => _state;
}
