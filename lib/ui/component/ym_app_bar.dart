import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ui/ui/ui_manager.dart';

class TitleText extends StatelessWidget {
  final String text;
  final Color textColor;

  const TitleText(
    this.text, {
    Key key,
    this.textColor: const Color(0xff454545),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: TextStyle(fontSize: 18.0, color: textColor, fontWeight: FontWeight.bold),
      );
}

class YMBackButton extends StatelessWidget {
  final String icon;
  final String package;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: onTap ??
          () => Navigator.maybePop(context).then((data) {
                if (!data) {
                  //如果不是flutter栈，则对应关闭当前flutter view 容器
                  UiManager.getInstance().getUiConfig().finish();
                }
              }),
      child: _buildBackImage(icon, package));

  Image _buildBackImage(String icon, String package) {
    if ((icon == null && package == null) || (icon == null && package != null)) {
      return Image.asset('images/ym_common_back.png', package: "flutter_ui");
    } else if (icon != null && package == null) {
      return Image.asset(icon);
    } else {
      return Image.asset(
        icon,
        package: package,
      );
    }
  }

  const YMBackButton({
    this.icon,
    this.package,
    this.onTap,
  });
}

///取消样式返回
class BackTextButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.maybePop(context);
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Container(alignment: Alignment.centerLeft, child: Text("取消", style: TextStyle(fontSize: 16))),
        ));
  }

  const BackTextButton();
}

///封装的AppBar，统一返回按钮为ios风格，统一标题居中、文字样式，可以直接使用字符串描述标题而不是Text控件
///保留了原[AppBar]所有使用习惯
///titleSpacing: title的左边距
///常见使用
/// ```dart
///YMAppBar(title: '全部门店')
class YMAppBar extends AppBar {
  YMAppBar({
    Key key,
    Widget leading: const YMBackButton(),
    dynamic title,
    List<Widget> actions,
    Widget flexibleSpace,
    PreferredSizeWidget bottom,
    double elevation = 0,
    ShapeBorder shape,
    Color backgroundColor = Colors.white,
    Brightness brightness,
    IconThemeData iconTheme,
    IconThemeData actionsIconTheme,
    TextTheme textTheme,
    bool primary = true,
    bool centerTitle = true,
    double titleSpacing = NavigationToolbar.kMiddleSpacing,
    double toolbarOpacity = 1.0,
    double bottomOpacity = 1.0,
    Color titleTextColor = const Color(0xff454545),
  }) : super(
          key: key,
          leading: leading,
          automaticallyImplyLeading: false,
          title: title is String
              ? TitleText(
                  title,
                  textColor: titleTextColor,
                )
              : title,
          actions: actions,
          flexibleSpace: flexibleSpace,
          bottom: bottom,
          elevation: elevation,
          shape: shape,
          backgroundColor: backgroundColor,
          brightness: brightness,
          iconTheme: iconTheme,
          textTheme: textTheme,
          primary: primary,
          centerTitle: centerTitle,
          titleSpacing: titleSpacing,
          toolbarOpacity: toolbarOpacity,
          bottomOpacity: bottomOpacity,
        );

  ///YMAppBar的高度
  @override
  Size get preferredSize => Size.fromHeight(46);
}
