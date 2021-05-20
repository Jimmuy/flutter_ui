import 'package:flutter/cupertino.dart';
import 'package:flutter_ui/ui/refresher/indicator/ym_indicator.dart';
import 'package:flutter_ui/ui/refresher/smart_refresher.dart';

class YMRefresher extends StatelessWidget {
  final Widget child;
  final Widget header;
  final Widget footer;
  final VoidCallback onRefresh;
  final VoidCallback onLoad;
  final IYMRefreshController controller;

  const YMRefresher({
    Key key,
    @required this.child,
    this.controller,
    this.header,
    this.footer,
    this.onRefresh,
    this.onLoad,
  })  : assert(controller is _RefreshControllerImpl),
        super(key: key);

  @override
  Widget build(BuildContext context) => SmartRefresher(
      enablePullDown: onRefresh != null,
      enablePullUp: onLoad != null,
      header: header ?? YmHeader(),
      footer: footer ?? YmFooter(),
      onRefresh: onRefresh,
      onLoading: onLoad,
      controller: (controller as _RefreshControllerImpl)._controller,
      child: child);
}

class _RefreshControllerImpl with IYMRefreshController {
  final bool initialRefresh;
  final bool initialNotify;
  final RefreshController _controller;

  _RefreshControllerImpl({
    this.initialRefresh: true,
    this.initialNotify: true,
  }) : _controller = RefreshController(initialRefresh: initialRefresh, initialNotify: initialNotify);

  @override
  Future<void> requestRefresh({bool notify = true, Duration duration = const Duration(milliseconds: 180), Curve curve = Curves.linear}) {
    return _controller.requestRefresh(notify: notify, duration: duration, curve: curve);
  }

  @override
  void refreshCompleted({bool resetFooterState = false}) {
    _controller.refreshCompleted(resetFooterState: resetFooterState);
  }

  @override
  void loadComplete() {
    _controller.loadComplete();
  }

  @override
  void loadFailed() {
    _controller.loadFailed();
  }

  @override
  void loadNoData() {
    _controller.loadNoData();
  }

  @override
  void refreshFailed() {
    _controller.refreshFailed();
  }
}

/// RefreshController接口，解耦Refresher的实现类，便于后期切换控件

abstract class IYMRefreshController {
  Future<void> requestRefresh({
    bool notify: true,
    Duration duration: const Duration(milliseconds: 180),
    Curve curve: Curves.linear,
  });

  void refreshCompleted({bool resetFooterState: false});

  void loadNoData();

  void refreshFailed();

  void loadFailed();

  void loadComplete();

  factory IYMRefreshController.impl({bool initialRefresh = true, bool initialNotify = true}) => _RefreshControllerImpl(
        initialRefresh: initialRefresh,
        initialNotify: initialNotify,
      );
}
