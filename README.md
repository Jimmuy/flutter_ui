## 仓库简介

### 仓库申请人
唐琦8
### 仓库负责人
唐琦8
### 仓库功能
flutter widget仓库，集成了上拉加载以及下拉刷新控件和常用的dialog基础组件功能
### 开发语言
dart
### 使用说明
#### UiManager
暴露出配置方法用来配置 flutter_ui 组件库中的UiConfig 上层需要实现UiConfig中的抽象方法.
* finish():关闭flutter 容器的方法
* IString getLocalizationString():获取组件内的多语言，返回的实例是IString的子类，需要在各自组件中去继承下IString接口

#### YmStatus
抽象类，需要上层继承并实现handleError方法,handleError是用来统一处理网络异常情况下的一个api
```
///抽象的Status实现类 用来指定本组件的国际化 以及 网络请求失败后 错误如何处理
abstract class DemoStatus<T extends StatefulWidget> extends YmStatus<T, ScString> {
  ///每个项目需要重写自己的handleError来处理网络请求错误的情况
  @override
  handleError(error) {
    if (error is NetWorkException) {
      if (error.code == 10086) {
        error.message = "网络异常，请稍后再试";
      }
      showToast(error.message);
    } else {
      showToast("网络异常");
      debugPrint('---------- handleError $error');
    }
  }
}

```
在YmStatus中提供了界面常用的UI Api可直接使用 如

```
  showToast(String msg);

  ///为了避免toast弹出，容器关闭则toast立刻随着容器消失的情况，弹出toast阻塞1000毫秒再关闭flutter 原生容器
  showToastDelay(String msg);

  showLoading(String msg);

  dismissLoading();

  /// log 日志 debug模式可见
  log(String msg);
```
### Widget List
| Widget Name  | Widget Readme | Remark |
| ------------- | ------------- |---------|
| Lego Dialog  | [链接](/Dialog使用说明.md)   |基础dialog组件|
| Refresher    | [链接](/Refresher使用说明.md)|上拉加载下拉刷新组件|
| YMAppBar     |                            |封装的appbar组件 默认带有返回键以及title居中的功能|
| YMCheckbox   |                            |云眸风格的checkbox 支持自定义的颜色配置|
| ym_dialog    |                            |统一封装了云眸风格的dialog,包括确认弹框，输入弹框和loading等|
| YmEmptyView  |                            |统一封装了云眸风格的空界面，上图下文|
| LoadingButton|                            |有loading动画的button,云眸风格，支持自定义颜色和边框等|
| YMScaffold   |                            |云眸风格的scaffold|
| YmStatus     |                            |抽象类，需要上层继承并实现handleError方法,handleError是用来统一处理网络异常情况下的一个api|
| SCVerificationBox|                        |验证码输入框 安全中心中使用|
| PageListView |                            |分页列表工具，封装了常用的分页逻辑|
| PageListHelper|                           |分页辅助类|
| PYmSafeArea   |                           |                                    |
