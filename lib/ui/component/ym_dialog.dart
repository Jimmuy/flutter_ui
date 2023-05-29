import 'package:flutter/material.dart';
import 'package:flutter_ui/ui/dialog/lego_dialog.dart';

import 'ym_loading_button.dart';

///采用新的dialog组件

const double DIALOG_WIDTH = 295.0;

///展示具有两个底部btn的确认框，提供自定义title 和content(非必填)内容的扩展
LegoDialog showConfirmDialog(BuildContext context, String title, Function(LegoDialog dialog) positiveCallBack,
    {String? content, Function(LegoDialog dialog)? negativeCallBack, String? negativeText, String? positiveText}) {
  var isContentEmpty = content == null || content.isEmpty;
  var dialog = LegoDialog().build(context)
    ..barrierDismissible = false
    ..width = DIALOG_WIDTH
    ..title(
      title,
      maxLines: 2,
      textAlign: TextAlign.center,
      padding: EdgeInsets.only(top: isContentEmpty ? 32.0 : 24, bottom: isContentEmpty ? 24 : 12, left: 16, right: 16),
    );
  //根据content参数判断是够需要展示子标题内容
  if (!isContentEmpty) dialog.content(content, padding: EdgeInsets.only(bottom: 16, left: 16, right: 16));
  dialog.divider()
    ..doubleButton(
        height: 50.0,
        isClickAutoDismiss: false,
        withDivider: true,
        leftText: negativeText ?? "取消",
        rightText: positiveText ?? "确定",
        leftTextStyle: TextStyle(fontSize: 16, color: Color(0xFF4D4D4D), fontWeight: FontWeight.bold),
        rightTextStyle: TextStyle(fontSize: 16, color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
        onLeftTap: _onCancelTap(negativeCallBack, dialog),
        onRightTap: () => positiveCallBack(dialog))
    ..show();
  return dialog;
}

///带输入框的dialog,默认为取消和确定按钮，可自定义，取消默认操作为关闭当前dialog
LegoDialog showInputDialog(
    BuildContext context, String title, String hint, String content, Function(String callbackContent, LegoDialog dialog) positiveCallback,
    {String? subTitle, String? negative, Function(LegoDialog dialog)? negativeCallback, String? positive, bool obscureText = false}) {
  var callbackContent = "";
  var legoDialog = LegoDialog().build(context);

  legoDialog
    ..width = DIALOG_WIDTH
    ..barrierDismissible = false
    ..title(
      title,
      textStyle: TextStyle(fontSize: 16, color: Color(0xE6000000), fontWeight: FontWeight.bold),
      padding: EdgeInsets.only(top: 24, bottom: subTitle == null ? 12 : 8, left: 16, right: 16),
    );
  if (subTitle != null) {
    legoDialog
      ..content(subTitle,
          textAlign: TextAlign.center,
          padding: EdgeInsets.only(bottom: 8, left: 16, right: 16),
          textStyle: TextStyle(fontSize: 14, color: Color(0x66000000)));
  }
  legoDialog
    ..input((content) => {callbackContent = content},
        content: content,
        obscureText: obscureText,
        contentStyle: TextStyle(color: Color(0xff595959), fontSize: 14),
        hint: hint,
        hintStyle: TextStyle(color: Color(0xaa595959), fontSize: 14),
        outBorderRadius: BorderRadius.circular(4),
        outMargin: EdgeInsets.only(bottom: 16, left: 16, right: 16))
    ..divider()
    ..doubleButton(
        height: 50.0,
        isClickAutoDismiss: false,
        withDivider: true,
        leftText: negative ?? "取消",
        rightText: positive ?? "确定",
        leftTextStyle: TextStyle(fontSize: 16, color: Color(0xFF4D4D4D), fontWeight: FontWeight.bold),
        rightTextStyle: TextStyle(fontSize: 16, color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
        onLeftTap: _onCancelTap(negativeCallback, legoDialog),
        onRightTap: () => positiveCallback(callbackContent, legoDialog))
    ..gravity = Gravity.top
    ..show(0.0, 250.0);
  return legoDialog;
}

///展示具有1个底部btn的确认框，提供自定义title 和content(非必填)内容的扩展
LegoDialog showNoticeDialog(BuildContext context, String title, {String? btnText, Function(LegoDialog dialog)? callBack}) {
  var dialog = LegoDialog().build(context)
    ..width = DIALOG_WIDTH
    ..title(
      title,
      maxLines: 2,
      textAlign: TextAlign.center,
      padding: EdgeInsets.only(top: 32.0, bottom: 32, left: 16, right: 16),
    )
    ..divider();
  dialog.singleButton(
      height: 50.0,
      btnText: btnText ?? "确定",
      btnTextStyle: TextStyle(fontSize: 16, color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
      onBtnTap: callBack != null ? () => callBack(dialog) : null)
    ..show();
  return dialog;
}

///展示loading状态的dialog 封装在YmUIMixin中使用。
LegoDialog showLoadingDialog(BuildContext? context, String title, {bool isLightStyle = false, bool barrierDismissible = false}) {
  var dialog = LegoDialog().build(context)
    ..width = 210
    ..backgroundColor = isLightStyle ? Colors.white : Colors.black.withOpacity(0.9)
    ..barrierDismissible = barrierDismissible
    ..barrierColor = Colors.transparent
    ..margin = EdgeInsets.symmetric(horizontal: 50)
    ..widget(Padding(
      padding: EdgeInsets.only(top: title.isEmpty ? 50 : 20.0),
      child: getLoadingImage(isLightStyle),
    ))
    ..widget(Padding(
      padding: EdgeInsets.only(top: title.isEmpty ? 30 : 10.0, bottom: title.isEmpty ? 0 : 20),
      child: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ));
  return dialog;
}

ImagesAnimation getLoadingImage(bool isLightStyle) {
  return ImagesAnimation(
    w: 32,
    h: 32,
    entry: ImagesAnimationEntry(0, 29, isLightStyle ? 'images/ym_common_comp_%s_light.png' : 'images/ym_common_comp_%s.png'),
  );
}

_onCancelTap(negativeCallBack, LegoDialog dialog) {
  return negativeCallBack == null ? () => dialog.dismiss() : () => negativeCallBack(dialog);
}
