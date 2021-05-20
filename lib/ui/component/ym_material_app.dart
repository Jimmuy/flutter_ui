import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///提供了透明状态栏以及可配置各个业务平台相关平台信息的MaterialApp子类
class YmMaterialApp extends MaterialApp {
  static BusinessData _data;

  //平台信息
  YmMaterialApp(
      {Key key,
      BusinessData businessData = const BusinessData.minerva(),
      navigatorKey,
      home,
      routes = const <String, WidgetBuilder>{},
      initialRoute,
      RouteFactory onGenerateRoute,
      onGenerateInitialRoutes,
      onUnknownRoute,
      navigatorObservers = const <NavigatorObserver>[],
      builder,
      title = '',
      onGenerateTitle,
      color,
      theme,
      darkTheme,
      highContrastTheme,
      highContrastDarkTheme,
      themeMode,
      locale,
      Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates,
      localeListResolutionCallback,
      localeResolutionCallback,
      supportedLocales,
      debugShowMaterialGrid = false,
      showPerformanceOverlay = false,
      checkerboardRasterCacheImages = false,
      checkerboardOffscreenLayers = false,
      showSemanticsDebugger = false,
      debugShowCheckedModeBanner = false,
      isTransparentStatusBar = true, //默认状态栏是透明的
      shortcuts,
      actions})
      : super(
            key: key,
            navigatorKey: navigatorKey,
            home: home,
            routes: routes,
            initialRoute: initialRoute,
            onGenerateRoute: onGenerateRoute,
            onGenerateInitialRoutes: onGenerateInitialRoutes,
            onUnknownRoute: onUnknownRoute,
            navigatorObservers: navigatorObservers,
            builder: builder ?? (context, widget) => MediaQuery(data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0), child: widget),
            title: title,
            onGenerateTitle: onGenerateTitle,
            color: color,
            theme: theme,
            darkTheme: darkTheme,
            highContrastTheme: highContrastTheme,
            highContrastDarkTheme: highContrastDarkTheme,
            themeMode: themeMode,
            locale: locale,
            localizationsDelegates: localizationsDelegates,
            localeListResolutionCallback: localeListResolutionCallback,
            localeResolutionCallback: localeResolutionCallback,
            supportedLocales: supportedLocales,
            debugShowMaterialGrid: debugShowMaterialGrid,
            showPerformanceOverlay: showPerformanceOverlay,
            checkerboardRasterCacheImages: checkerboardRasterCacheImages,
            checkerboardOffscreenLayers: checkerboardOffscreenLayers,
            showSemanticsDebugger: showSemanticsDebugger,
            debugShowCheckedModeBanner: debugShowCheckedModeBanner,
            shortcuts: shortcuts,
            actions: actions) {
    initBusinessData(businessData);
    initStatusBar(isTransparentStatusBar);

    ///只有debug模式下才会打印日志
    if (!kDebugMode) {
      debugPrint = (String message, {int wrapWidth}) {};
    }
  }

  ///初始化状态栏为透明
  void initStatusBar(isTransparentStatusBar) {
    if (isTransparentStatusBar) {
      // statusBar设置为透明，去除半透明遮罩
      final SystemUiOverlayStyle _style = SystemUiOverlayStyle(statusBarColor: Colors.transparent);
      //将style设置到app
      SystemChrome.setSystemUIOverlayStyle(_style);
    }
  }

  ///初始化平台信息
  void initBusinessData(BusinessData businessData) {
    _data = businessData;
  }
}

///平台信息 默认有三个命名构造函数提供出来 方便目前已经存在的平台直接使用
class BusinessData {
  final String name;
  final String desc;
  final int code;

  const BusinessData(this.name, this.desc, this.code);

  const BusinessData.retail() : this("retail", "连锁", 1);

  const BusinessData.minerva() : this("minerva", "普教云", 2);

  const BusinessData.community() : this("hbl", "社区云", 3);
}

///获取平台相关的信息
BusinessData getBusinessInfo() {
  if (YmMaterialApp._data == null)
    throw Exception("you have to use YmMaterialApp in place of MaterialApp and init PlatformData param in your main.dart");
  return YmMaterialApp._data;
}
