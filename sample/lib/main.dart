import 'package:flutter/material.dart' hide RefreshIndicator, RefreshIndicatorState;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_ui/ui/flutter_ui.dart';
import 'package:flutter_ui/ui/refresher/ym_refresh_localizations.dart';
import 'package:ui_sample/ui/common_widget_page.dart';
import 'package:ui_sample/ui/custom_layout_page.dart';
import 'package:ui_sample/ui/dialog_widget_page.dart';
import 'package:ui_sample/ui/index_bar_page.dart';
import 'package:ui_sample/ui/refresh_widget_page.dart';

void main() {
  UiManager.getInstance().initGlobalThemeStyle(
      refreshHeader: CustomHeader("test"), appBarLeading: buildUiImageView("ym_common_comp_20_light", width: 24, height: 24));
  runApp(MyApp());
}

class CustomHeader extends RefreshIndicator {
  final title;
  @override
  State<StatefulWidget> createState() {
    return _YmHeaderState();
  }

  CustomHeader(this.title);
}

class _YmHeaderState extends RefreshIndicatorState<CustomHeader> {
  @override
  Widget buildContent(BuildContext context, RefreshStatus mode) {
    return Text(widget.title);
  }
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
      localizationsDelegates: [
        // this line is important
        YMRefreshLocalizations.delegate,
        RefreshLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate
      ],
      supportedLocales: [
        const Locale('en'),
        const Locale('zh'),
      ],
      localeResolutionCallback: (Locale locale, Iterable<Locale> supportedLocales) {
        //print("change language");
        return locale;
      },
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
      appBar: YMAppBar(
        title: widget.title,
        actions: <Widget>[
          IconButton(
            icon: Image.asset(
              'images/ym_common_back.png',
              package: 'flutter_ui',
            ),
            tooltip: 'Open shopping cart',
            onPressed: () {
              // handle the press
            },
          ),
        ],
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
            InkWell(
              onTap: () => _naviCommon(),
              child: Container(
                alignment: Alignment.center,
                height: 50,
                margin: EdgeInsets.only(top: 20, left: 16, right: 16),
                color: Colors.blue[300],
                child: Text(
                  'Common Widget',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            InkWell(
              onTap: () => _naviIndexBar(),
              child: Container(
                alignment: Alignment.center,
                height: 50,
                margin: EdgeInsets.only(top: 20, left: 16, right: 16),
                color: Colors.blue[300],
                child: Text(
                  'Index Bar Widget',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return CustomLayoutPage();
                }));
              },
              child: Container(
                alignment: Alignment.center,
                height: 50,
                margin: EdgeInsets.only(top: 20, left: 16, right: 16),
                color: Colors.blue[300],
                child: Text(
                  'CustomLayoutPage',
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

  _naviCommon() {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return CommonWidgetPage();
    }));
  }

  _naviIndexBar() {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return IndexBarPage();
    }));
  }
}
