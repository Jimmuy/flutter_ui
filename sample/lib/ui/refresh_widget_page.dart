import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ui_sample/util/custom_refresher.dart';

class RefreshWidgetPage extends StatefulWidget {
  @override
  State createState() {
    return _RefreshWidgetPageState();
  }
}

class _RefreshWidgetPageState extends State<RefreshWidgetPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dialog Widget")),
      body: _buildBody(),
    );
  }

  _buildBody() {
    var iymRefreshController = IYMRefreshController.impl();
    return Container(
      child: YMRefresher(
        child: Container(
          alignment: Alignment.topCenter,
          height: double.infinity,
          color: Colors.blue,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: _getDescText("下拉刷新~"),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: _getDescText("上拉加载~"),
              ),
            ],
          ),
        ),
        controller: iymRefreshController,
        onRefresh: () {
          ///刷新成功
          iymRefreshController.refreshCompleted();

          ///刷新失败
          // iymRefreshController.refreshFailed();
          ///手动触发刷新操作
          // iymRefreshController.requestRefresh();
        },
        onLoad: () {
          ///加载成功
          iymRefreshController.loadComplete();

          ///没有更多数据
          // iymRefreshController.loadNoData();
          ///加载失败
          // iymRefreshController.loadFailed();
        },
      ),
    );
  }

  Text _getDescText(String desc) => Text(
        desc,
        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      );
}
