import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

///
/// @author Jimmy
///
class Toast {
  static OverlayEntry _overlayEntry; //toast靠它加到屏幕上
  static ValueNotifier _showing = ValueNotifier<bool>(false); //toast是否正在showing
  static DateTime _startedTime; //开启一个新toast的当前时间，用于对比是否已经展示了足够时间
  static String _msg;
  static Widget _widget;
  static ToastPosition _position;
  static BuildContext _context;
  static TextStyle _style;
  static Color _bgColor;

  static void toast(BuildContext context, String msg,
      {Widget widget, ToastPosition position = ToastPosition.CENTER, TextStyle style, Color bgColor}) async {
    _msg = msg;
    _bgColor = bgColor;
    _style = style;
    _widget = widget;
    _position = position;
    _context = context;
    assert(_msg != null);
    assert(_context != null);
    _startedTime = DateTime.now();
    _showing.value = true;
    if (_overlayEntry == null) {
      _overlayEntry = OverlayEntry(builder: (BuildContext context) {
        return Positioned(
          //top值，可以改变这个值来改变toast在屏幕中的位置
          top: _getPositionOffset(context),
          child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 56.0),
                child: ValueListenableBuilder(
                  valueListenable: _showing,
                  builder: (BuildContext context, value, Widget child) => Offstage(
                    offstage: !value,
                    child: Center(
                      child: Card(
                        color: _bgColor ?? Colors.black.withOpacity(0.8),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                          child: Column(
                            children: _buildContent(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )),
        );
      });
      Overlay.of(_context).insert(_overlayEntry);
    } else {
      //重新绘制UI，类似setState
      _overlayEntry.markNeedsBuild();
    }
    await Future.delayed(Duration(milliseconds: 2000)); //等待两秒

    //2秒后 到底消失不消失
    if (DateTime.now().difference(_startedTime).inMilliseconds >= 2000) {
      _showing.value = false;
      _overlayEntry.markNeedsBuild();
    }
  }

  static void release() {
    _overlayEntry = null;
  }

  static double _getPositionOffset(BuildContext context) {
    double rate = 1 / 2;
    if (_position == ToastPosition.CENTER_BOTTOM) {
      rate = 2 / 3;
    } else if (_position == ToastPosition.CENTER_TOP) {
      rate = 1 / 3;
    }
    return MediaQuery.of(context).size.height * rate;
  }

  static List<Widget> _buildContent() {
    var widgets = <Widget>[];
    if (_widget != null) {
      widgets.add(_widget);
    }
    widgets.add(Text(
      _msg,
      textAlign: TextAlign.center,
      style: _style ??
          TextStyle(
            fontSize: 14.0,
            color: Colors.white.withOpacity(0.7),
          ),
    ));
    return widgets;
  }
}

enum ToastPosition {
  CENTER_TOP,
  CENTER_BOTTOM,
  CENTER,
}
