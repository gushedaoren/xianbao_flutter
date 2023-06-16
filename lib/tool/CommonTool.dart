import 'dart:io';

import 'package:beir_flutter/base/BLConfig.dart';
import 'package:beir_flutter/base/BLConstant.dart';

import 'package:beir_flutter/model/EventModel.dart';
import 'package:beir_flutter/tool/EventBusUtils.dart';
import 'package:beir_flutter/user/PrivacyView.dart';


import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'package:launch_review/launch_review.dart';

import 'package:ndialog/ndialog.dart';
import 'package:one_context/one_context.dart';


import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'RequestUtil.dart';

class CommonTool {
  String _result = 'HMS availability result code: unknown';
  List<String> _eventList = ['Availability result events will be listed'];
  getCurrentPeople(var peopleid, var peoples) {
    for (var p in peoples) {
      if (peopleid == p["peopleid"]) {
        BLConstant.currentPeople = p;
        print("getCurrentPeople:");
        print(p);
        return p;
      }
    }
    return null;
  }

  ///使用md5加密
  static String generateMD5(String data) {
    Uint8List content = new Utf8Encoder().convert(data);
    Digest digest = md5.convert(content);
    return digest.toString();
  }

  static getPackageInfo() async {
    // PackageInfo packageInfo = await PackageInfo.fromPlatform();
    // BLConstant.appName = packageInfo.appName;
    // BLConstant.packageName = packageInfo.packageName;
    // BLConstant.version = packageInfo.version;
    // BLConstant.buildNumber = packageInfo.buildNumber;
    //
    // return true;

    return false;
  }

  static initAd() async {

  }

  static updateDomain(domain) {
    print("选择了较快的服务器：$domain");
    BLConfig.baseDomain = domain;
    BLConfig.userDomain = domain + BLConfig.API_USER;
    BLConfig.domain = domain + BLConfig.API_HEALTH;
    BLConfig.fileDomain = domain + BLConfig.API_FILES;
    BLConfig.img_base_url = domain + BLConfig.API_IMAGE_BASE;
    BLConfig.user_img_base_url = domain + BLConfig.API_USER_ICON;
    BLConfig.SignURL = domain + BLConfig.API_SIGN;

    BLConfig.smjobs_base_url = domain + BLConfig.API_SMJOBS;

    debugPrint(BLConfig.baseDomain);
    debugPrint(BLConfig.fileDomain);
    debugPrint(BLConfig.userDomain);
    debugPrint(BLConfig.img_base_url);
    debugPrint(BLConfig.user_img_base_url);
    debugPrint(BLConfig.SignURL);
    debugPrint(BLConfig.domain);
  }

  initApp() async {
    print("start initApp");

    if (Platform.isAndroid) {
      print("initApp android");
    } else {
      bool hasgetPackageInfo = await getPackageInfo();

      bool hasGetDeviceInfo = await getDeviceInfo();

      print("hasgetPackageInfo:$hasgetPackageInfo");
      print("hasGetDeviceInfo:$hasGetDeviceInfo");
    }
    RequestUtil.initDio();
    RequestUtil.doAction("initApp");
    // RequestUtil().pickBaseDomain();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var initAppCount = prefs.getInt("initApp");
    if (initAppCount == null) initAppCount = 0;
    initAppCount = initAppCount + 1;
    prefs.setInt("initApp", initAppCount);
    prefs.commit();
    await initAd();
    if (Platform.isAndroid) {
      // var hmsAnalytics = await HMSAnalytics.getInstance();
      // hmsAnalytics.enableLog();
      // hmsAnalytics.setAnalyticsEnabled(true);
      // var hmsApiAvailability = HmsApiAvailability();
      // final int resultCode =
      //     await hmsApiAvailability.isHMSAvailableWithApkVersion(28);
      // var _result = 'huaewi hms Availability result code: $resultCode';
      // debugPrint(_result);
      // if (resultCode != 0) {
      //   hmsApiAvailability.setResultListener = (AvailabilityEvent? event) {
      //     if (event != null) {
      //       // var event='Availability event: '+event.toString();
      //       print("AvailabilityEvent");
      //       print(event);
      //     }
      //   };
      //   hmsApiAvailability.getErrorDialog(resultCode, 1000, true);
      // }
    }

    // SdkTool().initJPush();
  }

  /// 吊起QQ
  /// [number]QQ号
  /// [isGroup]是否是群号,默认是,不是群号则直接跳转聊天
  void callQQ({int number = 790242370, bool isGroup = true}) async {
    print("start callQQ:$number");
    String url =
        'mqqapi://card/show_pslcard?src_type=internal&version=1&uin=${number ?? 0}&card_type=group&source=qrcode';

    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      print('不能访问');
    }
  }

  checkAndOpenReview(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var initAppCount = prefs.getInt("initApp");
    var userid = prefs.getString("userid");
    var remarked = prefs.getBool("remarked");
    var remark_refused = prefs.getBool("remark_refused");
    if (userid == "6") {
      //苹果测试账户不提示
      print("苹果测试账户不提示");
      return;
    }
    if (remarked == true) {
      print("已经提示过好评");
      return;
    }
    if (remark_refused == true) {
      print("已经拒绝过好评");
      return;
    }
    if (initAppCount! >= 2) {
      NDialog(
        dialogStyle: DialogStyle(titleDivider: true),
        title: Text("Give a good opinion"),
        content: Text("Project team work is not easy, ask for praise"),
        actions: <Widget>[
          TextButton(
              child: Text(
                "赏个好评".tr(),
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.green,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () async {
                RequestUtil.doAction("remarked");
                OneContext().pop();
                openReview();
                prefs.setBool("remarked", true);
                prefs.commit();

              }),
          TextButton(
              child: Text("disagree".tr()),
              onPressed: () {
                RequestUtil.doAction("remark_refused");
                OneContext().pop();
                prefs.setBool("remark_refused", true);
                prefs.commit();

              }),
        ],
      ).show(context);
    }
  }

  static getDeviceInfo() async {
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      BLConstant.platform = "android";
      // BLConstant.androidDeviceInfo = await deviceInfo.androidInfo;
      //
      // print(deviceInfo);
      return true;
    } else if (Platform.isIOS) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      BLConstant.platform = "ios";
      BLConstant.iosDeviceInfo = await deviceInfo.iosInfo;

      print(deviceInfo);
      return true;
    } else if (Platform.isMacOS) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      BLConstant.platform = "MacOS";
      BLConstant.macOsDeviceInfo = await deviceInfo.macOsInfo;
      print(deviceInfo);
      return true;
    }
    return false;
  }

  Future<bool> checkLogin() async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

    var logined = await _prefs.then((SharedPreferences prefs) {
      var logined = prefs.getBool('smlogined') ?? false;

      BLConstant.Logined = logined;
      return logined;
    });

    return logined;
  }

  Future<bool> checkPermission() async {
    var logined = await checkLogin();
    if (logined == false) return false;
    var isVip = await checkVip();
    if (isVip == false) return false;

    return true;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    var login_type = prefs.getString("login_type");
    if (login_type == "huawei_sign") {}

    prefs.setBool("smlogined", false);
    prefs.commit();
  }

  static metsToCalory(num mets, num weight, num miniute) {
    //净热量消耗（千卡/分钟） =（净代谢当量Net METs×3.5×体重公斤）/200

    num calory = mets * 3.5 * weight / 200.0 * miniute;

    return calory.round();
  }

  static caloryTokj(num calory) {
    //1千卡（也就是大家常说的1大卡）＝1000卡， 1千卡＝4．182千焦耳

    num kj = calory * 4.182;

    return kj;
  }

  static Future<bool> checkVip() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var userid = sharedPreferences.getString("userid");

    if (userid == "1" || userid == "3") {
      return true;
    } else {
      return false;
    }
  }

  static Future<void> showAd() async {}

  static bool isToday(DateTime date) {
    var today = DateTime.now();

    if (date.year == today.year &&
        date.month == today.month &&
        date.day == today.day) {
      return true;
    }

    return false;
  }

  static String formatNumberWithShortcuts(
      double number, int maxFractionDigits) {
    var thousandsNum = number / 1000;
    var millionNum = number / 1000000;

    if (number >= 1000 && number < 1000000) {
      return '${thousandsNum.toStringAsFixed(maxFractionDigits)}k';
    }

    if (number >= 1000000) {
      return '${millionNum.toStringAsFixed(maxFractionDigits)}M';
    }

    return number.toStringAsFixed(maxFractionDigits);
  }

  static int currentTimeMillis() {
    return new DateTime.now().millisecondsSinceEpoch;
  }

  String _data = "亲爱的" +
      "app_name".tr() +
      "用户，感谢您信任并使用" +
      "app_name".tr() +
      "APP！\n" +
      " \n" +
      "我们十分重视用户权利及隐私政策并严格按照相关法律法规的要求," +
      "请您仔细阅读并充分理解相关条款，方便您了解自己的权利。如您点击“同意”，即表示您已仔细阅读并同意本《用户协议》及《隐私政策》，将尽全力保障您的合法权益并继续为您提供优质的产品和服务。如您点击“不同意”，将可能导致您无法继续使用我们的产品和服务。";

  showUserAgreementDialog(context) async {
    if (Platform.isAndroid) {
      final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
      final SharedPreferences prefs = await _prefs;

      var agreed = prefs.getBool("user_privacy_agreed");

      if (agreed == null) agreed = false;
      BLConstant.privacy_agreed = agreed;

      if (agreed == true) {
        print("用户已同意协议，无需再次提示");
        return;
      }
      NDialog(
        dialogStyle: DialogStyle(titleDivider: true),
        title: Text("用户协议与隐私政策提示"),
        content: SingleChildScrollView(
          child: PrivacyView(
            data: _data,
            keys: ['《用户协议》', '《隐私政策》'],
            keyStyle: TextStyle(color: BLConstant.primaryColor),
            onTapCallback: (String key) {
              if (key == '《用户协议》') {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) =>
                //           WebViewContainer(BLConfig.user_agreemnet_url, "用户协议"),
                //     ));
              } else if (key == '《隐私政策》') {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => WebViewContainer(
                //           BLConfig.privacy_url, "PrivacyAgreement".tr()),
                //     ));
              }
            },
          ),
        ),
        actions: <Widget>[
          TextButton(
              child: Text("disagree"),
              onPressed: () {
                BLConstant.privacy_agreed = false;
                Navigator.pop(context);
                exit(0);
              }),
          TextButton(
              child: Text("agree"),
              onPressed: () async {
                prefs.setBool("user_privacy_agreed", true);
                prefs.commit();

                BLConstant.privacy_agreed = true;

                EventBusUtils.getInstance().fire(BLEvent("initAppData"));
                Navigator.pop(context);
              }),
        ],
      ).show(context);
    } else {
      debugPrint("ios 无需加载隐私政策弹框");
    }
  }

  int calculateDifference(DateTime date) {
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
  }

  getBMI() {
    // //bmi=体重(kg)/身高平方
    // if (BLConstant.userdata == null) {
    //   return BMIModel("***");
    // }
    // var floatHeight = BLConstant.userdata["userHealthInfo"]["Height"];
    //
    // var weight = BLConstant.userdata["weight"];
    //
    // if (floatHeight > 0) {
    //   var bmi = (weight) / ((floatHeight / 100.0) * (floatHeight / 100.0));
    //
    //   print("bmi:$bmi");
    //   return BMIModel(bmi);
    // } else {
    //   return BMIModel("***");
    // }
  }

  getBMIWithParam(floatHeight, weight) {
    // if (floatHeight > 0) {
    //   var bmi = (weight) / ((floatHeight / 100.0) * (floatHeight / 100.0));
    //
    //   print("bmi:$bmi");
    //   return BMIModel(bmi);
    // } else {
    //   return BMIModel("***");
    // }
  }

  getTizhillv() {
    // //體脂率 = 1.2 x BMI + 0.23 x 年齡 – 5.4 -10.8 x 性別（男生的值為 1，女生為 0）
    // BMIModel bmiModel = getBMI();
    //
    // if (BLConstant.userdata == null) return "";
    //
    // var age = BLConstant.userdata["userHealthInfo"]["Age"];
    //
    // var sex = BLConstant.userdata["userHealthInfo"]["Sex"];
    //
    // var x = 0;
    //
    // if (sex == "boy") {
    //   x = 1;
    // }
    //
    // if (bmiModel.BMIStr == "***") {
    //   return "***";
    // } else {
    //   var bmi = bmiModel.BMI;
    //
    //   var tizhilv = 1.2 * bmi + 0.23 + age - 5.4 - 10.8 * x;
    //
    //   return tizhilv.toStringAsFixed(0);
    // }
  }

  getBMR() {
    // //女性：10 x 體重（kg）+6.25 x 身高（cm）–5 x 年齡（歲）–161
    // //
    // // 男性：10 x 體重（kg）+6.25 x身高（cm）–5 x 年齡（歲）+5
    // BMIModel bmiModel = getBMI();
    // if (BLConstant.userdata == null) return "";
    // var age = BLConstant.userdata["userHealthInfo"]["Age"];
    //
    // var sex = BLConstant.userdata["userHealthInfo"]["Sex"];
    // var Height = BLConstant.userdata["userHealthInfo"]["Height"];
    // var weight = BLConstant.userdata["weight"];
    // var x = 0;
    //
    // if (bmiModel.BMIStr == "***") {
    //   return "***";
    // } else {
    //   var bmi = bmiModel.BMI;
    //
    //   var bmr = 10 * weight + 6.25 * Height - 5 * age - 165;
    //
    //   if (sex == "boy") {
    //     bmr = 10 * weight + 6.25 * Height - 5 * age + 5;
    //   }
    //
    //   BLConstant.totalCal = bmr.toInt();
    //
    //   return bmr.toStringAsFixed(0);
    // }
  }

  getCategoryTitle(index) {
    var title = "";

    switch (index) {
      case 0:
        title = "breakfast";
        break;
      case 1:
        title = "lunch";
        break;
      case 2:
        title = "dinner";
        break;
      case 3:
        title = "meal";
        break;

      case 4:
        title = "sport";
        break;
    }
    return title;
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  Future<bool> isIpad() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    IosDeviceInfo info = await deviceInfo.iosInfo;
    if (info.model!.toLowerCase().contains("ipad")) {
      return true;
    }
    return false;
  }

  getWeekName(index) {
    var weekName = "";
    switch (index) {
      case 0:
        weekName = "Mon";
        break;

      case 1:
        weekName = "Tue";
        break;
      case 2:
        weekName = "Wed";
        break;
      case 3:
        weekName = "Thu";
        break;
      case 4:
        weekName = "Fri";
        break;
      case 5:
        weekName = "Sat";
        break;
      case 6:
        weekName = "Sun";
        break;
    }
    return weekName;
  }

  removeAppBadge() {
    // try {
    //   print("removeAppBadge");
    //   FlutterAppBadger.removeBadge();
    // } catch (e) {
    //   print(e);
    // }
  }

  openReview() async {
    LaunchReview.launch(
        androidAppId: BLConfig.PackageName, iOSAppId: "6443974938");
  }


}
