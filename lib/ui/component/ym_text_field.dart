import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///自带删除和密码显示的TextField
typedef void YMTextFieldCallBack(String content);

enum YMTextInputType { text, multiline, number, phone, datetime, emailAddress, url, password }

// ignore: must_be_immutable
class YMTextField extends StatefulWidget {
  final YMTextInputType keyboardType;
  final int maxLines;
  final int maxLength;
  final String hintText;
  final TextStyle hintStyle;
  final YMTextFieldCallBack fieldCallBack;
  final Icon deleteIcon;
  final bool isShowDelete;
  final Icon plainIcon;
  final InputBorder inputBorder;
  final Widget prefixIcon;
  final TextStyle textStyle;
  final String text;

  final FormFieldValidator<String> validator;
  final bool isShowPlain; //是否显示密码明文，目前该功能与右侧删除按钮互斥。只有在输入类型是密码时，才生效
  var _obscureText = true;

  YMTextField(
      {Key key,
      YMTextInputType keyboardType: YMTextInputType.text,
      this.maxLines = 1,
      this.maxLength,
      this.hintText,
      this.hintStyle,
      this.fieldCallBack,
      this.deleteIcon,
      this.plainIcon,
      this.inputBorder,
      this.textStyle,
      this.prefixIcon,
      this.validator,
      this.isShowPlain = false,
      this.text = "",
      this.isShowDelete = true})
      : assert(maxLines == null || maxLines > 0),
        assert(maxLength == null || maxLength > 0),
        keyboardType = maxLines == 1 ? keyboardType : YMTextInputType.multiline,
        super(key: key);

  @override
  State<StatefulWidget> createState() => _YMTextFieldState();
}

class _YMTextFieldState extends State<YMTextField> {
  String _inputText = "";
  bool _hasDeleteIcon = false;
  bool _isNumber = false;
  bool _isPassword = false;

  ///输入类型
  TextInputType _getTextInputType() {
    switch (widget.keyboardType) {
      case YMTextInputType.text:
        return TextInputType.text;
      case YMTextInputType.multiline:
        return TextInputType.multiline;
      case YMTextInputType.number:
        _isNumber = true;
        return TextInputType.number;
      case YMTextInputType.phone:
        _isNumber = true;
        return TextInputType.phone;
      case YMTextInputType.datetime:
        return TextInputType.datetime;
      case YMTextInputType.emailAddress:
        return TextInputType.emailAddress;
      case YMTextInputType.url:
        return TextInputType.url;
      case YMTextInputType.password:
        _isPassword = true;
        return TextInputType.text;
      default:
        return TextInputType.text;
    }
  }

  ///输入范围
  List<TextInputFormatter> _getTextInputFormatter() {
    return _isNumber
        ? <TextInputFormatter>[
            WhitelistingTextInputFormatter.digitsOnly,
          ]
        : null;
  }

  @override
  void initState() {
    super.initState();
    if (widget.text.isEmpty) return;
    _inputText = widget.text;
    _hasDeleteIcon = (_inputText.isNotEmpty) && widget.isShowDelete;
    widget.fieldCallBack(_inputText);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _controller = new TextEditingController.fromValue(TextEditingValue(
        text: _inputText,
        selection: new TextSelection.fromPosition(TextPosition(affinity: TextAffinity.downstream, offset: _inputText.length))));
    TextField textField = new TextField(
      controller: _controller,
      decoration: InputDecoration(
          hintStyle: widget.hintStyle,
          counterStyle: TextStyle(color: Colors.white),
          hintText: widget.hintText,
          border: widget.inputBorder != null ? widget.inputBorder : UnderlineInputBorder(),
          fillColor: Colors.transparent,
          filled: true,
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.keyboardType != YMTextInputType.password //判断是否输入类型是密码
              ? (_hasDeleteIcon //输入类型不是密码，判断是否开启显示删除按钮
                  ? new Container(
                      width: 20.0,
                      height: 20.0,
                      child: new IconButton(
                        alignment: Alignment.center,
                        iconSize: 18.0,
                        icon: widget.deleteIcon != null ? widget.deleteIcon : Icon(Icons.cancel),
                        onPressed: () {
                          setState(() {
                            _inputText = "";
                            _hasDeleteIcon = (_inputText.isNotEmpty) && widget.isShowDelete;
                            widget.fieldCallBack(_inputText);
                          });
                        },
                      ),
                    )
                  : new Text(""))
              : (widget.isShowPlain //输入类型是密码，判断是否开启显示明文按钮
                  ? new Container(
                      width: 20.0,
                      height: 20.0,
                      child: new IconButton(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(0.0),
                        iconSize: 18.0,
                        icon: widget.plainIcon != null ? widget.plainIcon : Icon(Icons.remove_red_eye),
                        onPressed: () {
                          setState(() {
                            widget._obscureText = !widget._obscureText;
                          });
                        },
                      ),
                    )
                  : new Text(""))),
      onChanged: (str) {
        setState(() {
          _inputText = str;
          _hasDeleteIcon = (_inputText.isNotEmpty) && widget.isShowDelete;
          widget.fieldCallBack(_inputText);
        });
      },
      keyboardType: _getTextInputType(),
      maxLength: widget.maxLength,
      maxLines: widget.maxLines,
      inputFormatters: _getTextInputFormatter(),
      style: widget.textStyle,
      obscureText: _isPassword ? widget._obscureText : false,
    );
    return textField;
  }
}
