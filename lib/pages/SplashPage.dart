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

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {


  void navigateToNextScreen() {
    // 跳转到下一页
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyTabBarPage()),
    );
  }
  @override
  void initState() {
    super.initState();
    FlutterQqAds.initAd(BLConfig.TencentAD_APPID);
    FlutterQqAds.showSplashAd(
      BLConfig.TencentAD_Android_SPLASH_ID,
      fetchDelay: 5,
    );
    FlutterQqAds.onEventListener((event) {
      print(event.action);
      if(event.action=="action"){

      }
      // navigateToNextScreen();

    });
    CommonTool().initApp();

  }


}
