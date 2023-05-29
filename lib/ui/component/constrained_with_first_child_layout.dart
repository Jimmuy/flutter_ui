import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

typedef OnSizeChanged = void Function(Size size);

/// 用[firstChild]约束宽高和其它child
class ConstrainedWithFirstChildLayout extends MultiChildRenderObjectWidget {

  final OnSizeChanged? listener;

  ConstrainedWithFirstChildLayout({
    Key? key,
    this.listener,
    List<Widget> children = const <Widget>[],
  }) : super(key: key, children: children);

  @override
  _CustomRender createRenderObject(BuildContext context) {
    return _CustomRender(listener: listener);
  }

  @override
  void updateRenderObject(BuildContext context, _CustomRender renderObject) {
    renderObject.listener = listener;
  }
}

class _CustomParentData extends ContainerBoxParentData<RenderBox> {}

class _CustomRender extends RenderBox
    with ContainerRenderObjectMixin<RenderBox, _CustomParentData>, RenderBoxContainerDefaultsMixin<RenderBox, _CustomParentData> {

  OnSizeChanged? listener;

  _CustomRender({
    this.listener,
    List<RenderBox>? children,
  }) {
    addAll(children);
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _CustomParentData) child.parentData = _CustomParentData();
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    return firstChild?.getMinIntrinsicWidth(height) ?? 0.0;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return firstChild?.getMaxIntrinsicWidth(height) ?? 0.0;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    return firstChild?.getMinIntrinsicHeight(width) ?? 0.0;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return firstChild?.getMaxIntrinsicHeight(width) ?? 0.0;
  }

  @override
  void performLayout() {
    final BoxConstraints constraints = this.constraints;
    Size? usedSize;
    BoxConstraints? childrenConstraints;
    RenderBox? child = firstChild;
    while (child != null) {
      final _CustomParentData childParentData = child.parentData! as _CustomParentData;
      if (childrenConstraints == null) {
        child.layout(constraints.loosen(), parentUsesSize: true);
        usedSize = child.size;
        childrenConstraints = constraints
            .copyWith(
              maxWidth: usedSize.width,
              maxHeight: usedSize.height,
            )
            .loosen();
      } else {
        child.layout(childrenConstraints, parentUsesSize: true);
      }
      assert(child.parentData == childParentData);
      child = childParentData.nextSibling;
    }
    this.size = usedSize ?? Size(0.0, 0.0);

    final l = this.listener;
    if(l != null){
      l(this.size);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }
}
