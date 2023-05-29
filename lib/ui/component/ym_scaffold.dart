import 'package:flutter/material.dart';

import 'ym_app_bar.dart';

class YMScaffold extends StatelessWidget {
  final dynamic title;
  final List<Widget>? actions;
  final Widget? body;
  final Key? scaffoldKey;
  final bool centerTitle;

  ///标题的背景色
  final Color appBarBackgroundColor;

  ///页面的背景色
  final Color? backgroundColor;

  ///标题文字的颜色
  final Color titleTextColor;

  ///状态栏文字的样式
  ///[Brightness.dark]白色文字和icon
  ///[Brightness.light]黑色文字和icon
  final Brightness? brightness;

  final Widget? floatingActionButton;

  ///返回按钮
  final Widget? leading;

  const YMScaffold({
    Key? key,
    this.title,
    this.actions,
    this.body,
    this.scaffoldKey,
    this.centerTitle: true,
    this.appBarBackgroundColor = Colors.white,
    this.backgroundColor,
    this.titleTextColor: const Color(0xE6000000),
    this.brightness,
    this.leading,
    this.floatingActionButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: backgroundColor,
      appBar: _buildAppBar(),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }

  PreferredSizeWidget? _buildAppBar() {
    return title is PreferredSizeWidget
        ? title
        : YMAppBar(
            title: title,
            centerTitle: centerTitle,
            actions: actions,
            backgroundColor: appBarBackgroundColor,
            titleTextColor: titleTextColor,
            leading: leading ?? const YMBackButton(),
            brightness: brightness,
          );
  }
}
