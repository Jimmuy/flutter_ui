import 'package:flutter/material.dart';
import 'package:flutter_ui/ui/flutter_ui.dart';
import 'package:ui_sample/util/dialog_utils.dart' as dialog;

class DialogWidgetPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var style = TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
    return Scaffold(
      appBar: AppBar(
        title: Text("Dialog Widget"),
      ),
      body: Column(
        children: [
          InkWell(
            onTap: () => _showSingleButtonDialog(context),
            child: Container(
                height: 40,
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 16, right: 16, bottom: 10, top: 100),
                color: Colors.blue[300],
                child: Text("Single Button Dialog", style: style)),
          ),
          InkWell(
            onTap: () => _showDoubleButtonDialog(context),
            child: Container(
                height: 40,
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                color: Colors.blue[300],
                child: Text(
                  "Double Button Dialog",
                  style: style,
                )),
          ),
          InkWell(
            onTap: () => _showInputDialog(context),
            child: Container(
                height: 40,
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                color: Colors.blue[300],
                child: Text(
                  "Single Input Button Dialog",
                  style: style,
                )),
          ),
          InkWell(
            onTap: () => dialog.showConfirmDialog(context, "是否删除", () {}),
            child: Container(
                height: 40,
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                color: Colors.blue[300],
                child: Text(
                  "Double Confirm Button Dialog",
                  style: style,
                )),
          ),
          InkWell(
            onTap: () => dialog.showLoadingDialog(context, "loading"),
            child: Container(
                height: 40,
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                color: Colors.blue[300],
                child: Text(
                  "Loading Dialog",
                  style: style,
                )),
          ),
          InkWell(
            onTap: () => showLoadingDialog(context, "", isLightStyle: true, barrierDismissible: true).show(),
            child: Container(
                height: 40,
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                color: Colors.blue[300],
                child: Text(
                  "Loading Dialog Chain",
                  style: style,
                )),
          ),
          getLoadingImage(true)
        ],
      ),
    );
  }

  _showSingleButtonDialog(BuildContext context) {
    print("--------- _showSingleButtonDialog");
    LegoDialog().build(context)
      //介绍两种设置dialog宽度的方法
      //直接设置dialog宽度
      ..width = 300

      //宽度撑满，通过配置dialog的横向margin来限制dialog宽度
      //   ..margin = EdgeInsets.symmetric(horizontal: 30)
      ..title("这是标题")
      ..content("这是内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容")
      ..divider()
      ..singleButton()
      ..show();
  }

  _showDoubleButtonDialog(context) {
    LegoDialog().build(context)
      ..width = 300
      ..barrierDismissible = false
      ..title("这是标题")
      ..content("这是内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容")
      ..divider()
      ..doubleButton()
      ..show();
  }

  _showInputDialog(BuildContext context) {
    String text = "";
    LegoDialog().build(context)
      ..width = 300
      ..title("这是标题")
      ..content("这是内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容", alignment: Alignment.centerLeft)
      ..input((value) {
        text = value;
      }, content: "输入的内容")
      ..divider()
      ..singleButton(onBtnTap: () => {print("----------------$text")})
      ..show();
  }
}
