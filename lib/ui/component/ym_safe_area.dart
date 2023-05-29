import 'dart:math' as math;

import 'package:flutter/material.dart' hide SafeArea;
import 'package:flutter/rendering.dart';

class YmSafeArea extends StatelessWidget {
  /// Creates a widget that avoids operating system interfaces.
  ///
  /// The [left], [top], [right], [bottom], and [minimum] arguments must not be
  /// null.
  const YmSafeArea({
    Key? key,
    this.left = true,
    this.top = true,
    this.right = true,
    this.bottom = true,
    this.minimum = EdgeInsets.zero,
    this.maintainBottomViewPadding = false,
    required this.child,
  }) : super(key: key);

  const YmSafeArea.only({
    Key? key,
    this.left: false,
    this.top: false,
    this.right: false,
    this.bottom: false,
    this.minimum: EdgeInsets.zero,
    this.maintainBottomViewPadding: false,
    required this.child,
  });

  const YmSafeArea.symmetric({
    bool vertical: true,
    bool horizontal: true,
    this.minimum: EdgeInsets.zero,
    this.maintainBottomViewPadding: false,
    required this.child,
  })  : this.left = horizontal,
        this.top = vertical,
        this.right = horizontal,
        this.bottom = vertical;

  /// Whether to avoid system intrusions on the left.
  final bool left;

  /// Whether to avoid system intrusions at the top of the screen, typically the
  /// system status bar.
  final bool top;

  /// Whether to avoid system intrusions on the right.
  final bool right;

  /// Whether to avoid system intrusions on the bottom side of the screen.
  final bool bottom;

  /// This minimum padding to apply.
  ///
  /// The greater of the minimum insets and the media padding will be applied.
  final EdgeInsets minimum;

  /// Specifies whether the [YMSafeArea] should maintain the [viewPadding] instead
  /// of the [padding] when consumed by the [viewInsets] of the current
  /// context's [MediaQuery], defaults to false.
  ///
  /// For example, if there is an onscreen keyboard displayed above the
  /// SafeArea, the padding can be maintained below the obstruction rather than
  /// being consumed. This can be helpful in cases where your layout contains
  /// flexible widgets, which could visibly move when opening a software
  /// keyboard due to the change in the padding value. Setting this to true will
  /// avoid the UI shift.
  final bool maintainBottomViewPadding;

  /// The widget below this widget in the tree.
  ///
  /// The padding on the [MediaQuery] for the [child] will be suitably adjusted
  /// to zero out any sides that were avoided by this widget.
  ///
  /// {@macro flutter.widgets.child}
  final Widget child;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMediaQuery(context));
    final MediaQueryData? data = MediaQuery.maybeOf(context);
    EdgeInsets? padding = data?.padding;
    // Bottom padding has been consumed - i.e. by the keyboard
    if (data?.padding.bottom == 0.0 && data?.viewInsets.bottom != 0.0 && maintainBottomViewPadding)
      padding = padding?.copyWith(bottom: data?.viewPadding.bottom);

    return Padding(
      padding: EdgeInsets.only(
        left: math.max(left ? padding?.left ?? 0 : 0.0, minimum.left),
        top: math.max(top ? padding?.top ?? 0 : 0.0, minimum.top),
        right: math.max(right ? padding?.right ?? 0 : 0.0, minimum.right),
        bottom: math.max(bottom ? padding?.bottom ?? 0 : 0.0, minimum.bottom),
      ),
      child: MediaQuery.removePadding(
        context: context,
        removeLeft: left,
        removeTop: top,
        removeRight: right,
        removeBottom: bottom,
        child: child,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(FlagProperty('left', value: left, ifTrue: 'avoid left padding'));
    properties.add(FlagProperty('top', value: left, ifTrue: 'avoid top padding'));
    properties.add(FlagProperty('right', value: left, ifTrue: 'avoid right padding'));
    properties.add(FlagProperty('bottom', value: left, ifTrue: 'avoid bottom padding'));
  }
}
