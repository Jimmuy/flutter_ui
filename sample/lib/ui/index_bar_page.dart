import 'package:flutter/material.dart';
import 'package:flutter_ui/ui/flutter_ui.dart';

class IndexBarPage extends StatefulWidget {
  const IndexBarPage({Key key}) : super(key: key);

  @override
  _IndexBarPageState createState() => _IndexBarPageState();
}

class _IndexBarPageState extends State<IndexBarPage> {
  @override
  Widget build(BuildContext context) {
    return YMScaffold(
      title: 'IndexBar',
      body: Stack(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IndexBar(
              indexSelected: (context, index, text) {
                print('index: $index, text: $text');
              },
              width: 20,
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 10),
              options: IndexBarOptions(
                needRebuild: true,
                ignoreDragCancel: true,
                downTextStyle: TextStyle(fontSize: 12, color: Colors.white),
                downItemDecoration: BoxDecoration(shape: BoxShape.circle, color: Colors.green),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.red,
                ),
                downDecoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.amber,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
