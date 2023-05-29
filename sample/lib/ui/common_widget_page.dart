import 'package:flutter/material.dart';
import 'package:flutter_ui/ui/component/ym_arc_progress.dart';
import 'package:flutter_ui/ui/flutter_ui.dart';

class CommonWidgetPage extends StatefulWidget {
  @override
  State createState() {
    return _CommonWidgetPageState();
  }
}

class _CommonWidgetPageState extends State<CommonWidgetPage> {
  var iymRefreshController = IYMRefreshController.impl(initialRefresh: true);
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: YMAppBar(
        title: "Common Widget",
        titleTextColor: Colors.white,
        backgroundColor: Colors.blue,
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: _getDescText("CheckBox"),
          ),
          YMCheckbox(
            value: _isChecked,
            activeColor: Theme.of(context).primaryColor,
            onChanged: (newValue) {
              _isChecked = newValue;
              update();
            },
            width: 30,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: _getDescText("Switch"),
          ),
          YMSwitch(
              activeColor: Colors.blue,
              value: _isChecked,
              onChanged: (value) {
                _isChecked = value;
                update();
              }),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: _getDescText("Loading Button"),
          ),
          Container(
            child: LoadingButton(
              "loading",
              isLightStyle: false,
              buttonClick: () {
                _isChecked = !_isChecked;
                update();
              },
              isLoading: _isChecked,
            ),
            margin: EdgeInsets.symmetric(horizontal: 20),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: _getDescText("Verification Box"),
          ),
          Container(
            height: 50,
            child: SCVerificationBox(),
            margin: EdgeInsets.symmetric(horizontal: 30),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: _getDescText("Arc Progress"),
          ),
          Container(
            width: 100,
            height: 100,
            child: YMArcProgress(
              width: 10,
              progressColor: Colors.blue,
              progress: 0.5,
              startAngle: 0,
              backgroundColor: Colors.white,
              child: Center(child: Text("50%")),
            ),
          ),
          Container(
            child: YMTextField(
              hintText: "input",
            ),
            margin: EdgeInsets.symmetric(horizontal: 30),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: _getDescText("Empty View"),
          ),
          YmEmptyView(
            hint: "EmptyView",
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: _getDescText("Empty View"),
          ),
        ],
      ),
    );
  }

  Text _getDescText(String desc) => Text(
        desc,
        style: TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.bold),
      );

  void update() {
    if (mounted) setState(() {});
  }
}
