import 'dart:io';

import 'package:beir_flutter/base/BLConfig.dart';
import 'package:beir_flutter/homepage/MyTabBarPage.dart';
import 'package:beir_flutter/pages/VpnPage.dart';
import 'package:beir_flutter/tool/CommonTool.dart';
import 'package:beir_flutter/tool/RequestUtil.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


import '../pages/DetailPage.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>  {


  void navigateToNextScreen() {
    // 跳转到下一页
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyTabBarPage()),
    );
  }

  Future<void> loadAndShowAd() async {


  }
  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values); // 恢复标题栏相关的覆盖物
    super.dispose();
  }
  @override
  void initState() {
    super.initState();

    loadAndShowAd();
    CommonTool().initApp();
    SystemChrome.setEnabledSystemUIOverlays([]); // 设置标题栏相关的覆盖物为空列表
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height; // 获取设备屏幕高度
    double adContainerHeight = screenHeight * 0.95; // 计算广告容器的高度
    return  Container(
        height: adContainerHeight,

    );
  }


}
