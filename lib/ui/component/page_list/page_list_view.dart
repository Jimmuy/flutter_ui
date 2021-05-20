import 'package:flutter/material.dart' hide FutureBuilder;
import 'package:flutter_ui/ui/component/page_list/page_helper.dart';

import '../ym_empty_view.dart';
import '../ym_refresher.dart';

///数据转换器
typedef Converter<T, S> = S Function(T src);

///用于页面回调
typedef OnPageResult<T> = void Function(BuildContext context, T result);
typedef ItemWidgetBuilder<T> = Widget Function(
  BuildContext context,
  IYMRefreshController controller,
  List<T> data,
  int index,
);
typedef ListViewBuilder<T> = Widget Function(
  BuildContext context,
  IYMRefreshController controller,
  ListViewOptions options,
  List<T> data,
);
typedef ErrorWidgetBuilder = Widget Function(BuildContext context, dynamic e);
typedef EmptyWidgetBuilder = Widget Function(BuildContext context);

typedef ValueCallback<T> = void Function(T value);

///分页组件，用于封装分页逻辑，示例代码：
///```dart
///PageListView(
/// futureBuilder: _buildRequest,
/// itemBuilder: (context, controller, data, index) => _buildItem(data, controller, index),
///)
///```
///简单分页列表提供一个[futureBuilder]和[itemBuilder]就能够完成一个分页的页面
class PageListView<T> extends StatefulWidget {
  ///分页控件的控制器，用于外部代码可以控制分页控件，控制内容查看[IYMRefreshController]
  final IYMRefreshController _refreshController;

  ///控制器，可以外部给控件赋值和刷新
  final PageListViewController controller;

  ///列表构建器，[ListView.builder]不符合需求的时候，可以自定义[ListView]
  final ListViewBuilder<T> listViewBuilder;

  final PageHelper<T> helper;

  ///数据转换器，在构建列表之前预留一次数据转换操作，目的是用于构建多类型布局，
  ///示例代码：
  ///```dart
  /// converter: (src) {
  ///   final list = <dynamic>[0];
  ///   list.addAll(src);
  ///   return list;
  /// }
  /// ```
  final Converter<List<T>, List<T>> converter;

  ///有两种值，true表示使用默认布局，或者[ErrorWidgetBuilder]自己构建布局
  final dynamic errorBuilder;

  ///有两种值，true表示使用默认布局，或者[EmptyWidgetBuilder]自己构建布局
  final dynamic emptyBuilder;

  ///配置默认[ListView]的参数
  final ListViewOptions<T> options;

  PageListView.helper({
    Key key,
    IYMRefreshController refreshController,
    this.errorBuilder = true,
    this.emptyBuilder = true,
    this.listViewBuilder,
    this.controller,
    this.converter,
    this.options,
    this.helper,
  })  : _refreshController = refreshController,
        super(key: key);

  @override
  State<StatefulWidget> createState() => _PageListViewState<T>();
}

class _PageListViewState<T> extends State<PageListView<T>> {
  IYMRefreshController refreshController;
  PageResult _result;
  dynamic _error;

  void setRefreshControllerState(PageResult result) {
    final _refreshController = refreshController;
    switch (result) {
      case PageResult.SUCCESS:
        _refreshController.loadComplete();
        break;
      case PageResult.COMPLETED:
        _refreshController.loadNoData();
        break;
      case PageResult.R_SUCCESS:
        _refreshController.refreshCompleted(resetFooterState: true);
        break;
      case PageResult.EMPTY:
      case PageResult.R_COMPLETED:
        _refreshController.refreshCompleted(resetFooterState: true);
        _refreshController.loadNoData();
        break;
    }
  }

  Future _requestRefresh() => refreshController
          .requestRefresh(notify: false)
          .then((v) => widget.helper.load(true).then((result) {
                _update(result);
              }))
          .catchError((e) {
        _refreshError(e);
      });

  void _refreshError(e) {
    refreshController.refreshCompleted();
    setState(() {
      _error = e;
      _result = null;
    });
  }

  _load(bool isRefresh) {
    widget.helper.load(isRefresh).then((result) => _update(result)).catchError((e, s) {
      print(e);
      print(s);
      if (isRefresh) {
        _refreshError(e);
      } else {
        refreshController.loadFailed();
      }
    });
  }

  _update(result) {
    setRefreshControllerState(result);
    setState(() {
      _error = null;
      _result = result;
    });
  }

  @override
  void initState() {
    super.initState();
    refreshController = widget._refreshController ?? IYMRefreshController.impl();
    widget.controller?._attach(this);
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller?._detach();
  }

  @override
  void didUpdateWidget(PageListView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller._detach();
      widget.controller._attach(this);
    }
  }

  @override
  Widget build(BuildContext context) => YMRefresher(
      onLoad: () {
        _load(false);
      },
      onRefresh: () {
        _load(true);
      },
      controller: refreshController,
      child: _buildContent(context));

  _buildContent(context) {
    if (_displayRefreshEmpty()) {
      return widget.emptyBuilder == true ? _buildDefaultEmpty() : widget.emptyBuilder(context);
    } else if (_displayRefreshError()) {
      return widget.errorBuilder == true ? _buildDefaultError() : widget.errorBuilder(context, _error);
    } else {
      final fun = widget.listViewBuilder ?? _buildDefaultListView;
      final result = widget.converter == null ? widget.helper.data : widget.converter(widget.helper.data);
      return fun(context, refreshController, widget.options, List.unmodifiable(result));
    }
  }

  Widget _buildDefaultListView(BuildContext context, IYMRefreshController controller, ListViewOptions<T> options, List<T> data) =>
      ListView.builder(
          itemExtent: options.itemExtent,
          itemCount: data?.length ?? 0,
          reverse: options.reverse,
          controller: options.controller,
          shrinkWrap: options.shrinkWrap,
          padding: options.padding,
          addAutomaticKeepAlives: options.addAutomaticKeepAlives,
          itemBuilder: (BuildContext context, int index) => options.itemBuilder(context, controller, data, index));

  _buildDefaultEmpty() => YmEmptyView();

  _buildDefaultError() => YmEmptyView(hint: "网络异常");

  bool _displayRefreshEmpty() => widget.emptyBuilder != null && _result == PageResult.EMPTY;

  bool _displayRefreshError() => widget.errorBuilder != null && _error != null;
}

class PageListViewController {
  _PageListViewState _state;

  _attach(_PageListViewState state) {
    this._state = state;
  }

  _detach() {
    this._state = null;
  }

  Future requestRefresh() => _state?._requestRefresh();
}

class ListViewOptions<T> {
  final ScrollController controller;
  final bool reverse;
  final ScrollPhysics physics;
  final bool shrinkWrap;
  final EdgeInsetsGeometry padding;
  final double itemExtent;
  final ItemWidgetBuilder<T> itemBuilder;
  final bool addAutomaticKeepAlives;

  ListViewOptions({
    @required this.itemBuilder,
    this.controller,
    this.reverse = false,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    this.itemExtent,
    this.addAutomaticKeepAlives = true,
  });
}
