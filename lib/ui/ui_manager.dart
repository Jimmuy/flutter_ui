import 'package:flutter/widgets.dart';

import 'flutter_ui.dart';

///配置全局的通用控件，方便后续UI统一变动后需要手动更改所有的Flutter代码来进行适配。
///删除了之前用来关闭界面的方法 config.finish，如有需要请使用framework提供的SystemNavigator.pop();来关闭native容器
class UiManager {
  IUiConfig? _config;
  RefreshIndicator? refreshHeader;
  LoadIndicator? loadFooter;
  Image? appBarLeading;
  Widget? errorBuilder;
  Widget? emptyBuilder;
  static UiManager? _instance;

  static UiManager getInstance() {
    return _instance ??= UiManager._();
  }

  UiManager._();

  initGlobalThemeStyle(
      {RefreshIndicator? refreshHeader, LoadIndicator? loadFooter, Image? appBarLeading, Widget? errorBuilder, Widget? emptyBuilder}) {
    this.refreshHeader = refreshHeader;
    this.loadFooter = loadFooter;
    this.appBarLeading = appBarLeading;
    this.errorBuilder = errorBuilder;
    this.emptyBuilder = emptyBuilder;
  }

  setUiConfig(IUiConfig config) {
    this._config = config;
  }

  IUiConfig getUiConfig() {
    if (_config == null) {
      throw FlutterError("u have to setUiConfig() in flutter_ui lib or initUiConfig()in flutter_sc lib to pop");
    }
    return _config!;
  }
}

abstract class IUiConfig {
  //关闭flutter容器
  void finish();
}
