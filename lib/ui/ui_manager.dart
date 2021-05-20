import 'package:flutter/widgets.dart';

class UiManager {
  IUiConfig _config;
  static UiManager _instance;

  static UiManager getInstance() {
    if (_instance == null) {
      _instance = UiManager._();
    }
    return _instance;
  }

  UiManager._();

  setUiConfig(IUiConfig config) {
    this._config = config;
  }

  IUiConfig getUiConfig() {
    if (_config == null) {
      throw FlutterError("u have to setUiConfig() in flutter_ui lib or initUiConfig()in flutter_sc lib to pop");
    }
    return _config;
  }
}

abstract class IUiConfig {
  //关闭flutter容器
  void finish();
}
