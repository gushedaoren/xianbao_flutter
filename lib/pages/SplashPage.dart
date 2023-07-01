import 'dart:io';

import 'package:beir_flutter/base/BLConfig.dart';
import 'package:beir_flutter/homepage/MyTabBarPage.dart';
import 'package:beir_flutter/pages/VpnPage.dart';
import 'package:beir_flutter/tool/CommonTool.dart';
import 'package:beir_flutter/tool/RequestUtil.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qq_ads/flutter_qq_ads.dart';

import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

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
    await FlutterQqAds.initAd(BLConfig.TencentAD_APPID); // 替换为你的 QQ 广告 App ID
    // await Future.delayed(Duration(seconds: 5)); // 延迟 5 秒钟展示广告

    FlutterQqAds.showSplashAd(
      BLConfig.TencentAD_Android_SPLASH_ID,
      fetchDelay: 5,
    );

  }
  @override
  void initState() {
    super.initState();

    loadAndShowAd();
    CommonTool().initApp();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // 设置背景透明
      body: Container(), // 空的Container，不显示任何内容
    );
  }


}
