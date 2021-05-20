# Refresher

### 简介

**分页控件，嵌套[^1]可滚动`Widget`，用于下拉刷新和上拉加载**

------



### 使用方式

> 创建控制器，控制器一般作为成员属性，默认创建方式会在页面第一次显示的时候以动画的形式下滑显示出刷新头并触发`onRefresh`回调

```dart
final controller = IYMRefreshController.impl();
```

> 如果不需要默认显示刷新头，则添加初始化属性

```dart
final controller = IYMRefreshController.impl(initialRefresh: false);
```

> 创建控件

```dart
YMRefresher(
  child: ListView(),
  onRefresh: () {
    Future.delayed(const Duration(seconds: 3), () {
      controller.refreshCompleted();
    });
  },
  onLoad: () {
    Future.delayed(const Duration(seconds: 3), () {
      controller.loadComplete();
    });
  },
);
```

`onRefresh`和`onLoad`是刷新和加载的回调，在回调中执行接口调用或其它耗时任务，任务结束以后需要调用控制器的`refreshCompleted/loadComplete`来收回控件的头尾控件，不设置`onRefresh`或者`onLoad`就可以**禁止下拉或者上拉操作**



> 当用户修改分页参数或者在页面的resume中刷新列表，这就需要触发刷新逻辑

------



### 属性说明

| 名称       | 类型                 | 说明                       |
| ---------- | -------------------- | -------------------------- |
| child      | Widget               | 可滚动的主体控件           |
| header     | Widget               | 刷新头控件，一般不需要设置 |
| footer     | Widget               | 加载尾控件，一般不需要设置 |
| onRefresh  | VoidCallback         | 刷新回调，不设置会禁止下拉 |
| onLoad     | VoidCallback         | 加载回调，不设置会禁止上拉 |
| controller | IYMRefreshController | 控制器，控制头尾的状态     |



[^1]:ListView，GridView，SingleChildScrollView，CustomScrollView