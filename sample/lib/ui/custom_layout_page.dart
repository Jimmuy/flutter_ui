import 'package:flutter/material.dart';
import 'package:flutter_ui/ui/flutter_ui.dart';

class CustomLayoutPage extends StatefulWidget {
  const CustomLayoutPage({Key key}) : super(key: key);

  @override
  State<CustomLayoutPage> createState() => _CustomLayoutPageState();
}

class _CustomLayoutPageState extends State<CustomLayoutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ConstrainedWithFirstChildLayout(
          children: [
            Container(
              color: Colors.red,
              width: 200,
              height: 200,
            ),
            Container(
              color: Colors.black,
              width: 100,
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}
