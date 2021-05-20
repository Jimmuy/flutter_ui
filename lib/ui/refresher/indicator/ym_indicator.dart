import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide RefreshIndicator, RefreshIndicatorState;
import 'package:flutter/widgets.dart';
import 'package:flutter_ui/ui/refresher/localization/refresh_localizations.dart';
import 'package:sprintf/sprintf.dart';

import '../internals/indicator_wrap.dart';
import '../smart_refresher.dart';

/// direction that icon should place to the text
enum IconPosition { left, right, top, bottom }

/// wrap child in outside,mostly use in add background color and padding
typedef Widget OuterBuilder(Widget child);

///the most common indicator,combine with a text and a icon
///
/// See also:
///
/// [YmFooter]
class YmHeader extends RefreshIndicator {
  final OuterBuilder outerBuilder;
  final String releaseText, idleText, refreshingText, completeText, failedText, canTwoLevelText;
  final Widget releaseIcon, idleIcon, refreshingIcon, completeIcon, failedIcon, canTwoLevelIcon, twoLevelView;

  /// icon and text middle margin
  final double spacing;
  final IconPosition iconPos;

  final TextStyle textStyle;

  const YmHeader({
    Key key,
    RefreshStyle refreshStyle: RefreshStyle.Follow,
    double height: 60.0,
    Duration completeDuration: const Duration(milliseconds: 600),
    this.outerBuilder,
    this.textStyle: const TextStyle(color: Colors.grey),
    this.releaseText,
    this.refreshingText,
    this.canTwoLevelIcon,
    this.twoLevelView,
    this.canTwoLevelText,
    this.completeText,
    this.failedText,
    this.idleText,
    this.iconPos: IconPosition.left,
    this.spacing: 15.0,
    this.refreshingIcon,
    this.failedIcon: const Icon(Icons.error, color: Colors.grey),
    this.completeIcon: const Icon(Icons.done, color: Colors.grey),
    this.idleIcon = const Icon(Icons.arrow_downward, color: Colors.grey),
    this.releaseIcon = const Icon(Icons.refresh, color: Colors.grey),
  }) : super(
          key: key,
          refreshStyle: refreshStyle,
          completeDuration: completeDuration,
          height: height,
        );

  @override
  State createState() {
    return _YmHeaderState();
  }
}

class _YmHeaderState extends RefreshIndicatorState<YmHeader> {
  var _refreshTime = "";
  RefreshString _strings;

  Widget _buildText(mode) {
    _strings = RefreshLocalizations.of(context)?.currentLocalization ?? ChRefreshString();
    return Column(
      children: <Widget>[
        Text(
            mode == RefreshStatus.canRefresh
                ? widget.releaseText ?? _strings.canRefreshText
                : mode == RefreshStatus.completed
                    ? widget.completeText ?? _strings.refreshCompleteText
                    : mode == RefreshStatus.failed
                        ? widget.failedText ?? _strings.refreshFailedText
                        : mode == RefreshStatus.refreshing || mode == RefreshStatus.refreshing_without_notify
                            ? widget.refreshingText ?? _strings.refreshingText
                            : mode == RefreshStatus.idle
                                ? widget.idleText ?? _strings.idleRefreshText
                                : mode == RefreshStatus.canTwoLevel
                                    ? widget.canTwoLevelText ?? _strings.canTwoLevelText
                                    : "",
            style: widget.textStyle ?? TextStyle(color: Color(0xff666666), fontSize: 15)),
        Text(
          "${_refreshTime.isEmpty ? _getFormatDate() : _refreshTime}",
          style: TextStyle(color: Color(0xff7c7c7c), fontSize: 12),
        )
      ],
    );
  }

  Widget _buildIcon(mode) {
    Widget icon = mode == RefreshStatus.canRefresh
        ? widget.releaseIcon
        : mode == RefreshStatus.idle
            ? widget.idleIcon
            : mode == RefreshStatus.completed
                ? widget.completeIcon
                : mode == RefreshStatus.failed
                    ? widget.failedIcon
                    : mode == RefreshStatus.canTwoLevel
                        ? widget.canTwoLevelIcon
                        : mode == RefreshStatus.canTwoLevel
                            ? widget.canTwoLevelIcon
                            : mode == RefreshStatus.refreshing || mode == RefreshStatus.refreshing_without_notify
                                ? widget.refreshingIcon ??
                                    SizedBox(
                                      width: 25.0,
                                      height: 25.0,
                                      child: defaultTargetPlatform == TargetPlatform.iOS
                                          ? const CupertinoActivityIndicator()
                                          : const CupertinoActivityIndicator(),
                                    )
                                : widget.twoLevelView;
    if (mode == RefreshStatus.completed) {
      _refreshTime = _getFormatDate();
    }
    return icon ?? Container();
  }

  String _getFormatDate() {
    var dateTime = DateTime.now();
    var hour = dateTime.hour.toString();
    var minute = dateTime.minute.toString();
    if (dateTime.hour < 10) {
      hour = "0${dateTime.hour}";
    }
    if (dateTime.minute < 10) {
      minute = "0${dateTime.minute}";
    }
    var time = "$hour:$minute";
    return sprintf(_strings.lastModifyTime, [time]);
  }

  @override
  Widget buildContent(BuildContext context, RefreshStatus mode) {
    Widget textWidget = _buildText(mode);
    Widget iconWidget = _buildIcon(mode);
    List<Widget> children = <Widget>[iconWidget, textWidget];
    final Widget container = Wrap(
      spacing: widget.spacing,
      textDirection: widget.iconPos == IconPosition.left ? TextDirection.ltr : TextDirection.rtl,
      direction: widget.iconPos == IconPosition.bottom || widget.iconPos == IconPosition.top ? Axis.vertical : Axis.horizontal,
      crossAxisAlignment: WrapCrossAlignment.center,
      verticalDirection: widget.iconPos == IconPosition.bottom ? VerticalDirection.up : VerticalDirection.down,
      alignment: WrapAlignment.center,
      children: children,
    );
    return widget.outerBuilder != null
        ? widget.outerBuilder(container)
        : Container(
            padding: EdgeInsets.only(right: 20),
            child: Center(child: container),
            height: widget.height,
          );
  }
}

///the most common indicator,combine with a text and a icon
///
// See also:
//
// [ClassicHeader]
class YmFooter extends LoadIndicator {
  final String idleText, loadingText, noDataText, failedText, canLoadingText;

  /// a builder for re wrap child,If you need to change the boxExtent or background,padding etc.you need outerBuilder to reWrap child
  /// example:
  /// ```dart
  /// outerBuilder:(child){
  ///    return Container(
  ///       color:Colors.red,
  ///       child:child
  ///    );
  /// }
  /// ````
  /// In this example,it will help to add backgroundColor in indicator
  final OuterBuilder outerBuilder;

  final Widget idleIcon, loadingIcon, noMoreIcon, failedIcon, canLoadingIcon;

  /// icon and text middle margin
  final double spacing;

  final IconPosition iconPos;

  final TextStyle textStyle;

  /// notice that ,this attrs only works for LoadStyle.ShowWhenLoading
  final Duration completeDuration;

  const YmFooter({
    Key key,
    VoidCallback onClick,
    LoadStyle loadStyle: LoadStyle.ShowAlways,
    double height: 60.0,
    this.outerBuilder,
    this.textStyle: const TextStyle(color: Colors.grey),
    this.loadingText,
    this.noDataText,
    this.noMoreIcon,
    this.idleText,
    this.failedText,
    this.canLoadingText,
    this.failedIcon: const Icon(Icons.error, color: Colors.grey),
    this.iconPos: IconPosition.left,
    this.spacing: 15.0,
    this.completeDuration: const Duration(milliseconds: 300),
    this.loadingIcon,
    this.canLoadingIcon: const Icon(Icons.autorenew, color: Colors.grey),
    this.idleIcon = const Icon(Icons.arrow_upward, color: Colors.grey),
  }) : super(
          key: key,
          loadStyle: loadStyle,
          height: height,
          onClick: onClick,
        );

  @override
  State<StatefulWidget> createState() {
    return _ClassicFooterState();
  }
}

class _ClassicFooterState extends LoadIndicatorState<YmFooter> {
  Widget _buildText(LoadStatus mode) {
    RefreshString strings = RefreshLocalizations.of(context)?.currentLocalization ?? ChRefreshString();
    return Text(
        mode == LoadStatus.loading
            ? widget.loadingText ?? strings.loadingText
            : LoadStatus.noMore == mode
                ? widget.noDataText ?? strings.noMoreText
                : LoadStatus.failed == mode
                    ? widget.failedText ?? strings.loadFailedText
                    : LoadStatus.canLoading == mode
                        ? widget.canLoadingText ?? strings.canLoadingText
                        : widget.idleText ?? strings.idleLoadingText,
        style: widget.textStyle);
  }

  Widget _buildIcon(LoadStatus mode) {
    Widget icon = mode == LoadStatus.loading
        ? widget.loadingIcon ??
            SizedBox(
              width: 25.0,
              height: 25.0,
              child: defaultTargetPlatform == TargetPlatform.iOS ? const CupertinoActivityIndicator() : const CupertinoActivityIndicator(),
            )
        : mode == LoadStatus.noMore
            ? widget.noMoreIcon
            : mode == LoadStatus.failed
                ? widget.failedIcon
                : mode == LoadStatus.canLoading
                    ? widget.canLoadingIcon
                    : widget.idleIcon;
    return icon ?? Container();
  }

  @override
  Future endLoading() {
    return Future.delayed(widget.completeDuration);
  }

  @override
  Widget buildContent(BuildContext context, LoadStatus mode) {
    Widget textWidget = _buildText(mode);
    Widget iconWidget = _buildIcon(mode);
    List<Widget> children = <Widget>[iconWidget, textWidget];
    final Widget container = Wrap(
      spacing: widget.spacing,
      textDirection: widget.iconPos == IconPosition.left ? TextDirection.ltr : TextDirection.rtl,
      direction: widget.iconPos == IconPosition.bottom || widget.iconPos == IconPosition.top ? Axis.vertical : Axis.horizontal,
      crossAxisAlignment: WrapCrossAlignment.center,
      verticalDirection: widget.iconPos == IconPosition.bottom ? VerticalDirection.up : VerticalDirection.down,
      alignment: WrapAlignment.center,
      children: children,
    );
    return widget.outerBuilder != null
        ? widget.outerBuilder(container)
        : Container(
            height: widget.height,
            child: Center(
              child: container,
            ),
          );
  }
}
