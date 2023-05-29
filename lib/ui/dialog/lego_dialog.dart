import 'package:flutter/material.dart';

class LegoDialog {
  ///================================弹窗属性======================================
  List<Widget> widgetList = []; //弹窗内部所有组件
  static BuildContext? _context; //弹窗上下文
  BuildContext? context; //弹窗上下文

  double? width; //弹窗宽度
  double? height; //弹窗高度
  Duration duration = Duration(milliseconds: 250); //弹窗动画出现的时间
  Gravity gravity = Gravity.center; //弹窗出现的位置
  bool gravityAnimationEnable = false; //弹窗出现的位置带有的默认动画是否可用
  Color barrierColor = Colors.black.withOpacity(.3); //弹窗外的背景色
  BoxConstraints? constraints; //弹窗约束
  Function(Widget child, Animation<double> animation)? animatedFunc; //弹窗出现的动画
  bool barrierDismissible = true; //是否点击弹出外部消失
  EdgeInsets margin = EdgeInsets.all(0.0); //弹窗布局的外边距

  /// 用于有多个navigator嵌套的情况，默认为true
  /// @params useRootNavigator=false，push是用的是当前布局的context
  /// @params useRootNavigator=true，push是用的嵌套根布局的context
  bool useRootNavigator = true;

  Decoration? decoration; //弹窗内的装饰，与backgroundColor和borderRadius互斥
  Color backgroundColor = Colors.white; //弹窗内的背景色
  double borderRadius = 8.0; //弹窗圆角
  get isShowing => _isShowing; //当前 弹窗是否可见
  bool _isShowing = false;
  Function? _dismissCallBack;

  ///============================================================================
  static void init(BuildContext context) {
    _context = context;
  }

  LegoDialog build([BuildContext? context]) {
    if (context == null && _context != null) {
      this.context = _context;
      return this;
    }
    this.context = context;
    return this;
  }

  ///添加自定义组件
  LegoDialog widget(Widget child) {
    this.widgetList.add(child);
    return this;
  }

  ///添加dialog消失的监听
  LegoDialog addDialogDismissListener(Function callBack) {
    this._dismissCallBack = callBack;
    return this;
  }

  ///适用于作为dialog标题或者其他说明组件，内容不可换行显示 默认有居上的padding
  LegoDialog title(String text, {padding, alignment, textAlign, maxLines, textDirection, overflow, textStyle}) {
    //默认字体样式
    const defaultStyle = TextStyle(
      color: Colors.black,
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
    );
    return this.widget(
      Padding(
        padding: padding ?? EdgeInsets.only(top: 20.0, bottom: 10, left: 16, right: 16),
        child: Align(
          alignment: alignment ?? Alignment.center,
          child: Text(
            text,
            textAlign: textAlign,
            maxLines: maxLines ?? 1,
            textDirection: textDirection,
            overflow: overflow,
            style: textStyle ?? defaultStyle,
          ),
        ),
      ),
    );
  }

  ///适用于作为dialog 子标题 内容可以换行显示 ，或者其他说明组件
  LegoDialog content(String? text, {padding, alignment, textAlign, maxLines, textDirection, overflow, textStyle}) {
    //默认字体样式
    const defaultStyle = TextStyle(
      color: Colors.black38,
      fontSize: 14.0,
    );
    return this.widget(
      Padding(
        padding: padding ?? EdgeInsets.only(bottom: 20.0, left: 16, right: 16),
        child: Align(
          alignment: alignment ?? Alignment.center,
          child: Text(
            text ?? "",
            textAlign: textAlign,
            maxLines: maxLines,
            textDirection: textDirection,
            overflow: overflow,
            style: textStyle ?? defaultStyle,
          ),
        ),
      ),
    );
  }

  ///输入框 向dialog中添加输入框
  LegoDialog input(Function(String content) callback,
      {required String content,
      TextStyle? contentStyle,
      String? hint,
      Color? cursorColor,
      TextStyle? hintStyle,
      double? height,
      outMargin,
      outPadding,
      bool obscureText = false,
      innerPadding,
      outBorderRadius,
      outBorderColor}) {
    TextEditingController controller = TextEditingController();
    controller.addListener(() {
      callback(controller.value.text);
    });
    if (content.isNotEmpty) controller.text = content;
    return this.widget(
      Container(
        padding: outPadding ?? EdgeInsets.all(0),
        decoration: BoxDecoration(
            border: Border.all(color: outBorderColor ?? Color(0xFFC7C7C7)), borderRadius: outBorderRadius ?? BorderRadius.circular(4)),
        margin: outMargin ?? EdgeInsets.only(left: 16, right: 16, bottom: 10),
        height: height ?? 40.0,
        child: Container(
          child: TextField(
            style: contentStyle ?? TextStyle(fontSize: 12, color: Color(0xFF595959)),
            obscureText: obscureText,
            cursorColor: cursorColor ?? Theme.of(context!).primaryColor,
            decoration: InputDecoration(
              counter: null,
              counterText: "",
              hintText: hint ?? "请输入",
              hintStyle: hintStyle ?? TextStyle(fontSize: 12, color: Color(0xFF595959)),
              contentPadding: innerPadding ?? EdgeInsets.only(left: 8, right: 8, bottom: 12),
              border: InputBorder.none,
            ),
            maxLines: 1,
            maxLength: 50,
            controller: controller,
          ),
        ),
      ),
    );
  }

  ///适用于 底部两个平分横向控件的按钮，可配置颜色和分割线等属性
  LegoDialog doubleButton({
    height = 48.0,
    isClickAutoDismiss = true, //点击按钮后自动关闭
    withDivider = false, //中间分割线
    dividerVerticalMargin = 0.0,
    dividerWidth,
    dividerColor,
    leftText,
    leftBgColor = Colors.white,
    leftTextStyle,
    VoidCallback? onLeftTap,
    rightText,
    rightTextStyle,
    rightBgColor = Colors.white,
    VoidCallback? onRightTap,
  }) {
    const textStyle = TextStyle(fontSize: 18);
    return this.widget(
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                if (onLeftTap != null) onLeftTap();
                if (isClickAutoDismiss) {
                  dismiss();
                }
              },
              child: Container(
                height: height,
                alignment: Alignment.center,
                color: leftBgColor,
                child: Text(
                  leftText ?? "取消",
                  style: leftTextStyle ?? textStyle,
                ),
              ),
            ),
          ),
          Visibility(
            visible: true,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: dividerVerticalMargin),
              height: height,
              child: VerticalDivider(
                color: dividerColor ?? Colors.grey[300],
                width: dividerWidth ?? 1,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                if (onRightTap != null) onRightTap();
                if (isClickAutoDismiss) {
                  dismiss();
                }
              },
              child: Container(
                height: height,
                alignment: Alignment.center,
                color: rightBgColor,
                child: Text(
                  rightText ?? "确定",
                  style: rightTextStyle ?? textStyle,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  ///适用于 底部一个按钮，需要可以加入到底部显示
  LegoDialog singleButton(
      {height = 48.0,
      backgroundColor = Colors.white,
      isClickAutoDismiss = true, //点击按钮后自动关闭
      btnText,
      btnTextStyle,
      VoidCallback? onBtnTap}) {
    const textStyle = TextStyle(fontSize: 18);
    return this.widget(
      SizedBox(
        width: double.infinity,
        height: height,
        child: TextButton(
          style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith((states) {
            return backgroundColor;
          })),
          onPressed: () {
            if (onBtnTap != null) onBtnTap();
            if (isClickAutoDismiss) {
              dismiss();
            }
          },
          child: Text(
            btnText ?? "确定",
            style: btnTextStyle ?? textStyle,
          ),
        ),
      ),
    );
  }

  LegoDialog circularProgress({padding, backgroundColor, valueColor, strokeWidth}) {
    return this.widget(Padding(
      padding: padding ?? EdgeInsets.all(30),
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth ?? 4.0,
        backgroundColor: backgroundColor,
        valueColor: AlwaysStoppedAnimation<Color?>(valueColor),
      ),
    ));
  }

  LegoDialog divider({color, height}) {
    return this.widget(
      Divider(
        color: color ?? Colors.grey[300],
        height: height ?? 1,
      ),
    );
  }

  ///  x坐标
  ///  y坐标
  void show([x, y]) {
    var mainAxisAlignment = getColumnMainAxisAlignment(gravity);
    var crossAxisAlignment = getColumnCrossAxisAlignment(gravity);
    if (x != null && y != null) {
      gravity = Gravity.leftTop;
      margin = EdgeInsets.only(left: x, top: y);
    }
    _isShowing = true;
    CustomDialog(
      gravity: gravity,
      gravityAnimationEnable: gravityAnimationEnable,
      context: this.context,
      barrierColor: barrierColor,
      animatedFunc: animatedFunc,
      barrierDismissible: barrierDismissible,
      dismissCallBack: _dismissCallBack,
      duration: duration,
      child: Padding(
        padding: margin,
        child: Column(
          textDirection: TextDirection.ltr,
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
          children: <Widget>[
            Material(
              clipBehavior: Clip.antiAlias,
              type: MaterialType.transparency,
              borderRadius: BorderRadius.circular(borderRadius),
              child: Container(
                width: width ?? null,
                height: height ?? null,
                decoration: decoration ??
                    BoxDecoration(
                      borderRadius: BorderRadius.circular(borderRadius),
                      color: backgroundColor,
                    ),
                constraints: constraints ?? BoxConstraints(),
                child: CustomDialogChildren(widgetList: widgetList),
              ),
            )
          ],
        ),
      ),
    );
  }

  void dismiss() {
    _isShowing = false;
    Navigator.maybeOf(context!, rootNavigator: useRootNavigator)?.pop();
  }

  getColumnMainAxisAlignment(gravity) {
    var mainAxisAlignment = MainAxisAlignment.start;
    switch (gravity) {
      case Gravity.bottom:
      case Gravity.leftBottom:
      case Gravity.rightBottom:
        mainAxisAlignment = MainAxisAlignment.end;
        break;
      case Gravity.top:
      case Gravity.leftTop:
      case Gravity.rightTop:
        mainAxisAlignment = MainAxisAlignment.start;
        break;
      case Gravity.left:
        mainAxisAlignment = MainAxisAlignment.center;
        break;
      case Gravity.right:
        mainAxisAlignment = MainAxisAlignment.center;
        break;
      case Gravity.center:
      default:
        mainAxisAlignment = MainAxisAlignment.center;
        break;
    }
    return mainAxisAlignment;
  }

  getColumnCrossAxisAlignment(gravity) {
    var crossAxisAlignment = CrossAxisAlignment.center;
    switch (gravity) {
      case Gravity.bottom:
        break;
      case Gravity.top:
        break;
      case Gravity.left:
      case Gravity.leftTop:
      case Gravity.leftBottom:
        crossAxisAlignment = CrossAxisAlignment.start;
        break;
      case Gravity.right:
      case Gravity.rightTop:
      case Gravity.rightBottom:
        crossAxisAlignment = CrossAxisAlignment.end;
        break;
      default:
        break;
    }
    return crossAxisAlignment;
  }
}

///弹窗的内容作为可变组件
class CustomDialogChildren extends StatefulWidget {
  final List<Widget> widgetList; //弹窗内部所有组件

  CustomDialogChildren({this.widgetList = const []});

  @override
  CustomDialogChildState createState() => CustomDialogChildState();
}

class CustomDialogChildState extends State<CustomDialogChildren> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.widgetList,
    );
  }
}

///弹窗API的封装
class CustomDialog {
  BuildContext? _context;
  Widget _child;
  Duration? _duration;
  Color? _barrierColor;
  RouteTransitionsBuilder? _transitionsBuilder;
  bool? _barrierDismissible;
  Gravity? _gravity;
  bool? _gravityAnimationEnable;
  Function? _animatedFunc;
  Function? _dismissCallBack;

  CustomDialog({
    required Widget child,
    required BuildContext? context,
    Duration? duration,
    Color? barrierColor,
    RouteTransitionsBuilder? transitionsBuilder,
    Gravity? gravity,
    bool? gravityAnimationEnable,
    Function? animatedFunc,
    Function? dismissCallBack,
    bool? barrierDismissible,
  })  : _child = child,
        _context = context,
        _gravity = gravity,
        _gravityAnimationEnable = gravityAnimationEnable,
        _duration = duration,
        _barrierColor = barrierColor,
        _animatedFunc = animatedFunc,
        _dismissCallBack = dismissCallBack,
        _transitionsBuilder = transitionsBuilder,
        _barrierDismissible = barrierDismissible {
    this.show();
  }

  show() {
    //fix transparent error
    if (_barrierColor == Colors.transparent) {
      _barrierColor = Colors.white.withOpacity(0.0);
    }

    showGeneralDialog(
      context: _context!,
      barrierColor: _barrierColor ?? Colors.black.withOpacity(0.3),
      barrierDismissible: _barrierDismissible ?? true,
      barrierLabel: "",
      transitionDuration: _duration ?? Duration(milliseconds: 250),
      transitionBuilder: _transitionsBuilder ?? _buildMaterialDialogTransitions,
      pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
        return WillPopScope(
          onWillPop: () => _onWillPop(),
          child: Builder(
            builder: (BuildContext context) {
              return _child;
            },
          ),
        );
      },
    );
  }

  Widget _buildMaterialDialogTransitions(
      BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    Animation<Offset> custom;
    switch (_gravity) {
      case Gravity.top:
      case Gravity.leftTop:
      case Gravity.rightTop:
        custom = Tween<Offset>(
          begin: Offset(0.0, -1.0),
          end: Offset(0.0, 0.0),
        ).animate(animation);
        break;
      case Gravity.left:
        custom = Tween<Offset>(
          begin: Offset(-1.0, 0.0),
          end: Offset(0.0, 0.0),
        ).animate(animation);
        break;
      case Gravity.right:
        custom = Tween<Offset>(
          begin: Offset(1.0, 0.0),
          end: Offset(0.0, 0.0),
        ).animate(animation);
        break;
      case Gravity.bottom:
      case Gravity.leftBottom:
      case Gravity.rightBottom:
        custom = Tween<Offset>(
          begin: Offset(0.0, 1.0),
          end: Offset(0.0, 0.0),
        ).animate(animation);
        break;
      case Gravity.center:
      default:
        custom = Tween<Offset>(
          begin: Offset(0.0, 0.0),
          end: Offset(0.0, 0.0),
        ).animate(animation);
        break;
    }

    //自定义动画
    if (_animatedFunc != null) {
      return _animatedFunc!(child, animation);
    }

    //不需要默认动画
    if (!_gravityAnimationEnable!) {
      custom = Tween<Offset>(
        begin: Offset(0.0, 0.0),
        end: Offset(0.0, 0.0),
      ).animate(animation);
    }

    return SlideTransition(
      position: custom,
      child: child,
    );
  }

  _onWillPop() {
    if (_barrierDismissible!) {
      Navigator.maybeOf(_context!)?.pop();
    } else {
      return Future.value(false);
    }
    if (_dismissCallBack != null) {
      _dismissCallBack!();
    }
  }
}

///================================弹窗重心======================================
enum Gravity {
  left,
  top,
  bottom,
  right,
  center,
  rightTop,
  leftTop,
  rightBottom,
  leftBottom,
}

///============================================================================
