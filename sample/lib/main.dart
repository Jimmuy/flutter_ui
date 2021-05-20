import 'package:flutter/material.dart';
import 'package:ui_sample/ui/dialog_widget_page.dart';
import 'package:ui_sample/ui/refresh_widget_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // CommonDialog.init(context);

    return MaterialApp(
      title: 'Flutter UI Sample',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter UI Sample'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            InkWell(
              onTap: () => _naviDialogPage(),
              child: Container(
                alignment: Alignment.center,
                height: 50,
                margin: EdgeInsets.only(top: 20, left: 16, right: 16),
                color: Colors.blue[300],
                child: Text(
                  'Dialog Widget',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            InkWell(
              onTap: () => _naviRefreshPage(),
              child: Container(
                alignment: Alignment.center,
                height: 50,
                margin: EdgeInsets.only(top: 20, left: 16, right: 16),
                color: Colors.blue[300],
                child: Text(
                  'Refresh Widget',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _naviRefreshPage() {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return RefreshWidgetPage();
    }));
  }

  _naviDialogPage() {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return DialogWidgetPage();
    }));
  }
}
