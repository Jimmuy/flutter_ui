import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';
//这个是一个拼接字符串的flutter库，主要是为了使用方便，你可以选择不使用，这样的话你需要自己拼接图片路径

class LoadingButton extends StatefulWidget {
  final Color fillColor; //背景颜色
  final Color disableFillColor;
  final String title;
  final bool isLoading;
  final bool enable;
  final VoidCallback buttonClick;

  const LoadingButton(this.title,
      {this.fillColor, this.disableFillColor, this.isLoading = false, this.enable = true, this.buttonClick, Key key})
      : super(key: key);

  @override
  LoadingButtonState createState() => LoadingButtonState();
}

class LoadingButtonState extends State<LoadingButton> {
  ValueNotifier<bool> _enableNotifier;
  ValueNotifier<bool> _isLoadingNotifier;

  Color _fillColor;
  Color _disableFillColor;

  void startAnimation() {
    if (_isLoadingNotifier.value) return;
    _isLoadingNotifier.value = true;
  }

  void stopAnimation() {
    if (!_isLoadingNotifier.value) return;
    _isLoadingNotifier.value = false;
  }

  void setButtonEnable(bool enable) {
    if (_enableNotifier.value == enable) return;
    _enableNotifier.value = enable;
  }

  @override
  void initState() {
    _enableNotifier = ValueNotifier<bool>(widget.enable);
    _isLoadingNotifier = ValueNotifier<bool>(widget.isLoading);

    _fillColor = widget.fillColor;
    _disableFillColor = widget.disableFillColor;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    if (_fillColor == null) {
      _fillColor = themeData.primaryColor;
    }

    if (_disableFillColor == null) {
      _disableFillColor = themeData.disabledColor;
    }

    if (_enableNotifier.value != widget.enable) {
      _enableNotifier.value = widget.enable;
    }

    if (_isLoadingNotifier.value != widget.isLoading) {
      _isLoadingNotifier.value = widget.isLoading;
    }

    return GestureDetector(
      onTap: () {
        if (this._enableNotifier.value == false) return;
        if (this._isLoadingNotifier.value == true) return;
        widget.buttonClick();
      },
      child: _configBody(),
    );
  }

  Widget _configBody() {
    return ValueListenableBuilder(
      valueListenable: _enableNotifier,
      builder: (context, value, child) {
        return Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(4)), color: value ? _fillColor : _disableFillColor),
          width: double.infinity,
          height: 48,
          child: Center(child: _configCenterWidget()),
        );
      },
    );
  }

  Widget _configCenterWidget() {
    var imagesAnimation = ImagesAnimation(
      w: 24,
      h: 24,
      entry: ImagesAnimationEntry(0, 29, 'images/loading_animation_image%s.png'),
    );
    var text = Text(widget.title, style: TextStyle(color: Colors.white, fontSize: 18));

    return ValueListenableBuilder(
      valueListenable: _isLoadingNotifier,
      builder: (context, value, child) {
        return value ? imagesAnimation : text;
      },
    );
  }
}

class ImagesAnimation extends StatefulWidget {
  final double w;
  final double h;
  final ImagesAnimationEntry entry;
  final int durationSeconds;

  ImagesAnimation({Key key, this.w: 80, this.h: 80, this.entry, this.durationSeconds: 1}) : super(key: key);

  @override
  _InState createState() {
    return _InState();
  }
}

class _InState extends State<ImagesAnimation> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: widget.durationSeconds))..repeat();
    _animation = IntTween(begin: widget.entry.lowIndex, end: widget.entry.highIndex).animate(_controller);
//widget.entry.lowIndex 表示从第几下标开始，如0；widget.entry.highIndex表示最大下标：如7
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget child) {
        String frame = _animation.value.toString();
        return Image.asset(
          sprintf(widget.entry.basePath, [frame]), //根据传进来的参数拼接路径
          gaplessPlayback: true,
          //避免图片闪烁
          width: widget.w,
          height: widget.h,
          fit: BoxFit.fitWidth,
          package: 'flutter_ui',
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class ImagesAnimationEntry {
  int lowIndex = 0;
  int highIndex = 0;
  String basePath;

  ImagesAnimationEntry(this.lowIndex, this.highIndex, this.basePath);
}
