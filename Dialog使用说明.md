
## Lego Dialog

### 使用

```groovy
flutter_ui:
  git:
    url: https://github.com/Jimmuy/flutter_ui.git
    ref: 'last version' //这行可以不写，不写默认为master最新提交，写了就是指定的提交
```

提供默认样式的dialog统一封装，方便上层统一调用

1. 支持通用语义化组件的方法，填充弹窗内部的组件内容
2. 对于没有的组件支持自定义编辑dialog内容，灵活扩展
3. 支持设置弹窗背景色、前景色、位置、动画、点击外部消失等功能
4. 支持无Context调用弹窗

弹窗的属性设置可以通过成员变量的方法去调用，具体详见下表

```dart
LegoDialog  noticeDialog() {
  return LegoDialog().build()
    ..width = 120
    ..height = 110
    ..backgroundColor = Colors.black.withOpacity(0.8)
    ..borderRadius = 10.0
    ..showCallBack = () {
      print("showCallBack invoke");
    }
    ..dismissCallBack = () {
      print("dismissCallBack invoke");
    }
    ..widget(Padding(
      padding: EdgeInsets.only(top: 21),
      child: Image.asset(
        'images/success.png',
        width: 38,
        height: 38,
      ),
    ))
    ..widget(Padding(
      padding: EdgeInsets.only(top: 10),
      child: Text(
        "Success",
        style: TextStyle(
          fontSize: 15,
          color: Colors.white,
        ),
      ),
    ))
    ..animatedFunc = (child, animation) {
      return ScaleTransition(
        child: child,
        scale: Tween(begin: 0.0, end: 1.0).animate(animation),
      );
    }
    ..show();
}
```

支持的属性

| property               | description                          | default             |
| ---------------------- | ------------------------------------ | ------------------- |
| width                  | 弹窗宽度                             | 0                   |
| height                 | 弹窗高度                             | 自适应组件高度      |
| duration               | 弹窗动画出现的时间                   | 250毫秒             |
| gravity                | 弹窗出现的位置                       | 居中                |
| gravityAnimationEnable | 弹窗出现的位置带有的默认动画是否可用 | false               |
| margin                 | 弹窗的外边距                         | EdgeInsets.all(0.0) |
| barrierColor           | 弹窗外的背景色                       | 30%黑色             |
| decoration             | 弹窗内的装饰                         | null                |
| backgroundColor        | 弹窗内的背景色                       | 白色                |
| borderRadius           | 弹窗圆角                             | 0.0                 |
| constraints            | 弹窗约束                             | 无                  |
| animatedFunc           | 弹窗出现的动画                       | 从中间出现          |
| showCallBack           | 弹窗展示的回调                       | 无                  |
| dismissCallBack        | 弹窗消失的回调                       | 无                  |
| barrierDismissible     | 是否点击弹出外部消失                 | true                |
| useRootNavigator       | 是否使用根导航                       | true                |

* 设置完gravity后，若需要动画则设置gravityAnimationEnable = true
* 若设置decoration属性，则backgroundColor和borderRadius不生效，他们是互斥关系

支持的方法

| method    | description    |
| --------- | -------------- |
| show[x,y] | 显示弹窗       |
| dismiss   | 隐藏弹窗       |
| isShowing | 弹窗是否在展示 |

### Lego Widget

顾名思义，像组装Lego一样组装你的Dialog,默认提供了几种Dialog组件来进行简单的拼装就可以快速使用。

```dart
LegoDialog  AlertDialogWithDivider(BuildContext context) {
  return LegoDialog().build(context)
    ..width = 220
    ..borderRadius = 4.0
    ..text(
      padding: EdgeInsets.all(25.0),
      alignment: Alignment.center,
      text: "确定要退出登录吗?",
      color: Colors.black,
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
    )
    ..divider()
    ..doubleButton(
      padding: EdgeInsets.only(top: 10.0),
      gravity: Gravity.center,
      withDivider: true,
      text1: "取消",
      color1: Colors.redAccent,
      fontSize1: 14.0,
      fontWeight1: FontWeight.bold,
      onTap1: () {
        print("取消");
      },
      text2: "确定",
      color2: Colors.redAccent,
      fontSize2: 14.0,
      fontWeight2: FontWeight.bold,
      onTap2: () {
        print("确定");
      },
    )
    ..show();
}
```

支持的语义化组件

| method       | description                    |
| ------------ | ------------------------------ |
| title        | 文本控件（加粗字号）           |
| input        | 四周默认带有边框和圆角的输入框 |
| doubleButton | 双按钮控件                     |
| singleButton | 单按钮控件                     |
| content      | 内容组件（文字灰色，不加粗）   |
| divider      | 分割线组件                     |
| widget       | 自定义语义化组件               |

### 自定义Widget

> 开发工作中难免会遇到与提供的组件不匹配的需求，这时候可以通过widget属性创建自定义view样式。

```dart
LegoDialog LegoDialogDemo(BuildContext context) {
  return LegoDialog().build(context)
    ..width = 220
    ..height = 500
    ..widget(
      Padding(
        padding: EdgeInsets.all(0.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "",
            style: TextStyle(
              color: Colors.black,
              fontSize: 14.0,
              fontWeight: FontWeight.w100,
            ),
          ),
        ),
      ),
    )
    ..show();
}
```

### 关于Context

* 目前提供了有context调用和无context调用，
* 有参使用：在有context的地方进行调用，进行有参调用的时候则对应使用navigator.pop()可以关闭当前dialog,也可以使用dialog.dismiss()进行关闭。
* 无参应用场景：在网络请求回来后，在回调中是无Context可以引用，这时候就需要预先初始化Context，后续就可以不需要Context调用弹窗，需要使用dialog.dismiss()进行关闭当前dialog,如果使用navigator.pop()有可能会导致整个界面被关闭

**1、无参调用初始化**

在未弹窗之前先调用静态方法`LegoDialog.init(context);`

```dart
class AppHome extends StatelessWidget {
  Widget build(BuildContext context) {
    //1、初始化context
    LegoDialog.init(context);
    //2、后续使用可以不需要context
    ......
  }
}
```

**2、使用**

直接使用`LegoDialog`，注意必须要调用`build()`

```dart
LegoDialog  AlertDialogBody() {
  return LegoDialog().build()
    ..width = 240
    ..text(
      text: "Hello LegoDialog",
      color: Colors.grey[700],
    )
    ..show();
}
```

### 注意

**1、dismiss**

* 请勿擅自使用`Navigator.pop(context)`让弹窗消失，否则会关掉自己的页面
* LegoDialog内部已经解决了此问题，调用内部提供的`dismiss()`即可

```dart
var dialog = LegoDialog();
dialog?.dismiss();
```

**2、上层封装**

当前依赖仅仅提供最基础的样式，由于每个项目的主题和样式不尽相同，在上层使用的时候需要进行简单的封装，方便直接调用，下面提供简单的封装思路。



```dart
///展示具有两个底部btn的确认框，提供自定义title 和content(非必填)内容的扩展
LegoDialog showConfirm(BuildContext context, String title, Function positiveCallBack,
    {String content, Function negativeCallBack, String negativeText, String positiveText}) {
  var _strings = DeviceManagerLocalizations.of(context)?.currentLocalization ?? EnString();
  var isContentEmpty = content == null || content.isEmpty;
  var dialog = LegoDialog().build(context);
  dialog.margin = EdgeInsets.symmetric(horizontal: 50);
  dialog.title(
    title,
    padding: EdgeInsets.only(top: isContentEmpty ? 50.0 : 20, bottom: isContentEmpty ? 42 : 10, left: 16, right: 16),
  );
  //根据content参数判断是够需要展示子标题内容
  if (!isContentEmpty) dialog.content(content, padding: EdgeInsets.only(bottom: 16, left: 16, right: 16));
  dialog.divider();
  dialog.doubleButton(
      height: 50.0,
      withDivider: true,
      leftText: negativeText ?? _strings.cancel,
      rightText: positiveText ?? _strings.confirm,
      leftTextStyle: TextStyle(fontSize: 17, color: Color(0xFF4D4D4D)),
      rightTextStyle: TextStyle(fontSize: 17, color: Color(0xFFFF5E34)),
      onLeftTap: () => negativeCallBack,
      onRightTap: () => positiveCallBack);
  dialog.show();
  return dialog;
}
```

如上，封装完毕后，每次调用仅仅需要确定入参就可以快速开发

如

```dart
showConfirm(context, "title", () {
 //点击确认之后的回调
});
```