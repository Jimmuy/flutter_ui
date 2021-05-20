import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui/ui/utils/ui_utils.dart';

class YmEmptyView extends StatelessWidget {
  final String hint;
  final Image image;

  const YmEmptyView({Key key, this.hint, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          image ??
              buildUiImageView(
                "ic_empty",
                width: 334,
                height: 310,
              ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              hint ?? "暂无数据",
              style: TextStyle(color: Color(0xffBFBFBF), fontSize: 15),
            ),
          )
        ],
      ),
    );
  }
}
