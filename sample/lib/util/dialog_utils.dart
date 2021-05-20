import 'package:flutter/material.dart';
import 'package:flutter_ui/ui/flutter_ui.dart';

///举例说明上层的项目 在使用dialog的时候应该进行的封装，
///将项目中的主题在一个util类里配置，在使用的时候只需要关注具体的展示和返回就可以了
///
/// 例如在使用的时候直接调用    showConfirmDialog(context, "是否删除", () {})即可
///

showLoadingDialog(context, content) => LegoDialog().build(context)
  ..width = 200
  ..circularProgress()
  ..content(content)
  ..show();

showConfirmDialog(context, title, positiveCallBack, {negativeCallBack}) => LegoDialog().build(context)
  ..width = 300
  ..title(
    title,
    padding: EdgeInsets.only(top: 40.0, bottom: 40, left: 16, right: 16),
  )
  ..divider()
  ..doubleButton(
      withDivider: true,
      rightTextStyle: TextStyle(color: Colors.deepOrange, fontSize: 18),
      onLeftTap: negativeCallBack,
      onRightTap: positiveCallBack)
  ..show();
