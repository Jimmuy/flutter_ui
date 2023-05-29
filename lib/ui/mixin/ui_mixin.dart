import 'package:flutter/widgets.dart';
import 'package:flutter_ui/ui/component/ym_dialog.dart';
import 'package:flutter_ui/ui/component/ym_toast.dart';
import 'package:flutter_ui/ui/dialog/lego_dialog.dart';

///UI扩展类。直接继承在 build（） 内初始化
mixin UIMixin {
  BuildContext? _context;
  LegoDialog? _dialog;

  BuildContext get context {
    if (_context == null) {
      throw Exception("u have to call initUi in your build method");
    }
    return _context!;
  }

  initUi(BuildContext context) {
    this._context = context;
  }

  showToast(String msg) {
    Toast.toast(context, msg);
  }

  ///为了避免toast弹出，容器关闭则toast立刻随着容器消失的情况，弹出toast阻塞1000毫秒再关闭flutter 原生容器
  showToastDelay(String msg) async {
    Toast.toast(context, msg);
    await Future.delayed(Duration(milliseconds: 1000));
  }

  showLoading(String msg) {
    if (_dialog == null) {
      _dialog = showLoadingDialog(context, msg);
    }
    if (_dialog?.isShowing) {
      return;
    }
    _dialog?.show();
  }

  dismissLoading() {
    if (_dialog == null || !_dialog?.isShowing) return;
    _dialog?.dismiss();
  }

  log(String msg) {
    debugPrint("--------- $msg");
  }
}
