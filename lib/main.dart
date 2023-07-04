import 'package:beir_flutter/base/BLConfig.dart';
import 'package:beir_flutter/homepage/MyHomePage.dart';
import 'package:beir_flutter/homepage/MyTabBarPage.dart';
import 'package:beir_flutter/pages/SplashPage.dart';
import 'package:beir_flutter/tool/CommonTool.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:one_context/one_context.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      builder: (BuildContext context, Widget? child) {
        // 在这里同时使用 OneContext().builder 和 EasyLoading.init()
        return EasyLoading.init(builder: OneContext().builder)(context, child);
      },
      navigatorKey: OneContext().key,

      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyTabBarPage(),
    );
  }
}
