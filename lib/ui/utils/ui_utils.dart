//获取包中的assets图片
import 'dart:convert' as convert;

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

///获取包名为flutter_ui的ImageView 支持自定义宽高
Image buildUiImageView(String imageName, {double width, double height}) {
  return buildImageView(imageName, width: width, height: height, package: "flutter_ui");
}

///获取包名为flutter_ui的SVG ImageView 支持自定义宽高
SvgPicture buildUiSvgImageView(String imageName, {double width, double height, Color color}) {
  return buildSvgImageView(imageName, width: width, height: height, color: color, package: "flutter_ui");
}

///使用的时当前项目下的资源文件，则使用此方法构建ImageView，若是使用依赖包中的资源文件则使用对应封装好的api来获取对应的ImageView
Image buildImageView(String imageName, {double width, double height, String package}) {
  final imageFullPath = 'images/$imageName.png';
  return Image.asset(
    imageFullPath,
    width: width,
    height: height,
    gaplessPlayback: true,
    package: package,
  );
} //获取包中的assets图片

SvgPicture buildSvgImageView(String imageName, {double width, double height, Color color, String package}) {
  final imageFullPath = 'images/svg/$imageName.svg';
  return SvgPicture.asset(
    imageFullPath,
    width: width,
    height: height,
    color: color,
    package: package,
  );
}

Image getImageBase64(String base64Text, {Widget errorView, double width, double height}) {
  final text = convert.base64Decode(base64Text);
  return Image.memory(
    text,
    key: Key("$text"),
    width: width,
    height: height,
    errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
      return errorView ?? Container();
    },
  );
}
