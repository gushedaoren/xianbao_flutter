import 'package:beir_flutter/base/BLConfig.dart';
import 'package:beir_flutter/homepage/MyHomePage.dart';
import 'package:beir_flutter/homepage/MyTabBarPage.dart';
import 'package:beir_flutter/pages/SplashPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qq_ads/flutter_qq_ads.dart';
import 'package:one_context/one_context.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    FlutterQqAds.initAd(BLConfig.TencentAD_APPID); // 替换为你的 QQ 广告 App ID
    return MaterialApp(
      builder: OneContext().builder,
      navigatorKey: OneContext().key,
      title: BLConfig.AppName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyTabBarPage(),
    );
  }
}
