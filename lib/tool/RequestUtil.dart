import 'dart:io';
import 'dart:convert';
import 'package:beir_flutter/base/BLConstant.dart';
import 'package:beir_flutter/tool/CommonTool.dart';
import 'package:beir_flutter/tool/EncryptTool.dart';


import 'package:dio/dio.dart';
import 'package:beir_flutter/base/BLConfig.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';


import 'package:shared_preferences/shared_preferences.dart';

class RequestUtil {
  static final BaseOptions dioOptions =
      BaseOptions(baseUrl: BLConfig.domain, connectTimeout: 10000);
  static final Dio dio = Dio(dioOptions);

  static refreshToken() async {
    var url = BLConfig.SignURL;
    print("refreshToken");
    print(url);

    Response response = await Dio()
        .get(url, queryParameters: {"key": BLConfig.APIUSER_KEY}) as Response;
    print(response.statusCode);
    print(response.data);

    var accessToken = response.data.toString();

    print("accessToken");
    print(accessToken);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("accessToken", accessToken);
  }

  getPingTimes(domains) async {
    Map map = {};
    var pingTime;
    domains.forEach((servername, domain) async {
      try {
        try {
          int startTime = CommonTool.currentTimeMillis();

          var pingDomain =
              BLConfig.userDomain.replaceAll(BLConfig.baseDomain, domain) +
                  "/Ping";
          debugPrint("pingDomain:");
          debugPrint(pingDomain);
          Response response = await Dio().post(pingDomain);
          print(response.statusCode);
          debugPrint(response.data.toString());

          if (response.statusCode == 200) {
            int endTime = CommonTool.currentTimeMillis();
            pingTime = endTime - startTime;

            debugPrint(pingDomain + " pingTime: $pingTime");
          } else {
            pingTime = 100000;
          }
        } catch (e) {
          print("domain +$domain :$e");
          pingTime = 1000000;
        }
        map[domain] = pingTime;
      } catch (e) {
        print(e);
        return map;
      }
    });

    return map;
  }

  pickBaseDomain() async {
    print("start pickBaseDomain");

    var domains = {};

    Response response = await Dio().get(BLConfig.aws_domains);

    print(response.statusCode);
    domains = response.data;

    print("云函数 response:");
    print(domains);
    var map = await getPingTimes(domains);

    var minTime = 10000;
    var resultDomain = BLConfig.baseDomain;

    // var testdomain="https://api.1207game.com";
    // var time =await  DomainPing(testdomain);
    // map[testdomain]=time;

    // 延时1s执行返回
    Future.delayed(Duration(seconds: 1), () {
      map.forEach((domain, time) {
        print("--domain, time--${domain} ${time}");

        if (time < minTime) {
          minTime = time;
          resultDomain = domain;
        }
      });
      CommonTool.updateDomain(resultDomain);
    });
  }

  static initDio() async {
    // await refreshToken();

    // 2.添加第一个拦截器
    Interceptor dInter =
        InterceptorsWrapper(onRequest: (options, handler) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      var accessToken = prefs.get("accessToken");

      print("accessToken");
      print(accessToken);

      var smheader = await genHeader();

      // Add common request parameters
      Map<String, dynamic> commonParams = {
        'smheader': EncryptTool.encryption(smheader.toString()),
      };

      if (options.data != null) {
        // 如果已有请求参数，则将公共参数添加到已有参数中
        print("before options data:${options.data}");
        Map<String, dynamic> params = {};
        options.data.fields.forEach((field) {
          params[field.key] = field.value;
        });
        params.addAll(commonParams);

        options.data = FormData.fromMap(params);
      } else {
        // 如果请求参数为空，则创建一个FormData对象，并将公共参数添加到FormData中
        options.data = FormData.fromMap(commonParams);
      }
      print("options headers:${options.headers}");
      print("options data:${options.data}");
      handler.next(options);
    }, onResponse: (Response response, ResponseInterceptorHandler handler) {
      handler.next(response);
    }, onError: (DioError error, ErrorInterceptorHandler handler) async {
      print("Interceptor error:");
      print(error.message);
      print(error.response?.statusCode);
      if (error.response?.statusCode == 403 ||
          error.response?.statusCode == 401) {
        // await refreshToken();
      }

      handler.next(error);
    });
    List<Interceptor> inters = [dInter];
    if (dInter != null) {
      inters.add(dInter);
    }

    dio.interceptors.addAll(inters);
  }

  // ignore: non_constant_identifier_names
  static Future<int> DomainPing(domain) async {
    try {
      int startTime = CommonTool.currentTimeMillis();

      var pingDomain =
          BLConfig.userDomain.replaceAll(BLConfig.baseDomain, domain) + "/Ping";
      debugPrint("pingDomain:");
      debugPrint(pingDomain);
      Response response = await Dio().post(pingDomain) as Response;
      print(response.statusCode);
      debugPrint(response.data.toString());

      if (response.statusCode == 200) {
        int endTime = CommonTool.currentTimeMillis();
        int pingTime = endTime - startTime;

        debugPrint(pingDomain + " pingTime: $pingTime");

        return pingTime;
      } else {
        return 100000;
      }
    } catch (e) {
      print(e);
      return 1000000;
    }
  }

  static doAction(action) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userid = sharedPreferences.getString("userid");
    var username = sharedPreferences.getString("username");

    try {
      var formData = FormData.fromMap({
        'userid': userid,
        'action': action,
      });

      Response response = await RequestUtil.dio
          .post(BLConfig.userDomain + "/Action", data: formData) as Response;
      print(response.statusCode);
      print(response.data.toString());
      var msg = response.data["msg"];
      if (response.statusCode == 200) {
      } else {}
    } catch (e) {
      print(e);
    }
  }

  static Future<bool> checkVip() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userid = sharedPreferences.getString("userid");

    try {
      var formData = FormData.fromMap({
        'Userid': userid,
      });

      Response response = await RequestUtil.dio
          .post(BLConfig.userDomain + "/CheckVip", data: formData) as Response;

      if (response.statusCode == 200) {
        print(response.statusCode);
        print(response.data.toString());

        var data = response.data["data"];
        BLConstant.isVip = data["Vip"];
        // if (Platform.isAndroid) {
        //   BLConstant.isVip = true;
        // }
        BLConstant.huiyuan = data;
        return BLConstant.isVip;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> CollectFood(foodid, collected) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userid = sharedPreferences.getString("userid");

    try {
      var formData = FormData.fromMap({
        'Userid': userid,
        'Collected': collected,
        "Foodid": foodid,
      });

      Response response = await RequestUtil.dio
          .post(BLConfig.domain + "/CollectFood", data: formData) as Response;

      if (response.statusCode == 200) {
        print(response.statusCode);
        print(response.data.toString());

        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  static changeNickname(nickname) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userid = sharedPreferences.getString("userid");

    print("nickname");
    print(nickname);

    try {
      var formData = FormData.fromMap({
        'Userid': userid,
        'Nickname': nickname,
      });

      Response response = await RequestUtil.dio
              .post(BLConfig.userDomain + "/UpdateUserNickname", data: formData)
          as Response;
      print(response.statusCode);
      print(response.data.toString());
      var msg = response.data["msg"];
      if (response.statusCode == 200) {
      } else {}
    } catch (e) {
      print(e);
    }
  }

  void uploadBingliImage(String path) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userid = sharedPreferences.getString("userid");

    try {
      var formData = FormData.fromMap({
        'userid': userid,
      });

      formData.files.add(MapEntry("file", await MultipartFile.fromFile(path)));

      Response response = await RequestUtil.dio
              .post(BLConfig.domain + "/UploadBingLiImage", data: formData)
          as Response;
      print(response.statusCode);
      print(response.data.toString());
      EasyLoading.dismiss();
      var msg = response.data["msg"];
      if (response.statusCode == 200) {
      } else {}
    } catch (e) {
      print(e);
    }
  }

  UpdateDeviceToken(deviceToken, brand) async {
    Future.delayed(Duration(milliseconds: 2000), () async {
      print("UpdateDeviceToken");
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var userid = sharedPreferences.getString("userid");

      if (userid == "" || userid == "0") {
        print("userid 为空不更新devicetoken");
        return;
      }

      try {
        var formData = FormData.fromMap({
          'Userid': userid,
          'DeviceToken': deviceToken,
          'Brand': brand,
          'PackageName': BLConfig.PackageName,
        });

        Response response = await RequestUtil.dio.post(
            BLConfig.userDomain + "/UpdateDeviceToken",
            data: formData) as Response;
        print(response.statusCode);
        print(response.data.toString());
        var msg = response.data["msg"];
        if (response.statusCode == 200) {
        } else {}
      } catch (e) {
        print(e);
      }
    });
  }
  replaceImgDomain(url){
    var resurl=url.replaceAll("beir.1kcal.net","d1aol66zd82bh4.cloudfront.net");
    return resurl;
  }
}


genHeader() async {
  // print("build config:");
  var headers = {};
  if (Platform.isAndroid) {
    // headers['Deviceid'] = BLConstant.androidDeviceInfo!.androidId;
    // headers['DeviceName'] = BLConstant.androidDeviceInfo!.product.toString();
    // headers['DeviceModel'] = BLConstant.androidDeviceInfo!.model;
    // headers['Brand'] = BLConstant.androidDeviceInfo!.brand;
    // BLConstant.brand = BLConstant.androidDeviceInfo!.brand!;
    // headers['IsPhysicalDevice'] =
    //     BLConstant.androidDeviceInfo!.isPhysicalDevice;
    // headers['Manufacturer'] = BLConstant.androidDeviceInfo!.manufacturer;
    // headers['SystemVersion'] = BLConstant.androidDeviceInfo!.version.release;
    // headers['SystemName'] = BLConstant.androidDeviceInfo!.version.baseOS;
    headers['Platform'] = "android";
    headers['Channel'] = BLConfig.Channel;
  } else if (Platform.isIOS) {
    headers['Deviceid'] = BLConstant.iosDeviceInfo!.identifierForVendor;
    headers['DeviceName'] = BLConstant.iosDeviceInfo!.name.toString();
    headers['DeviceModel'] = BLConstant.iosDeviceInfo!.model;
    BLConstant.brand = "APPLE";
    headers['Brand'] = BLConstant.brand;
    headers['Platform'] = "ios";
    headers['IsPhysicalDevice'] = BLConstant.iosDeviceInfo!.isPhysicalDevice;
    headers['Manufacturer'] = BLConstant.iosDeviceInfo!.identifierForVendor;
    headers['SystemVersion'] = BLConstant.iosDeviceInfo!.systemVersion;
    headers['SystemName'] = BLConstant.iosDeviceInfo!.systemName;
    headers['Channel'] = BLConfig.Channel;
  } else if (Platform.isMacOS) {
    headers['Brand'] = "APPLE";
    headers['Platform'] = BLConstant.platform;

    headers['Deviceid'] = BLConstant.macOsDeviceInfo!.systemGUID;

    headers['DeviceModel'] = BLConstant.macOsDeviceInfo!.model;

    headers['DeviceName'] = BLConstant.macOsDeviceInfo!.computerName;

    headers['SystemVersion'] = BLConstant.macOsDeviceInfo!.osRelease;

    headers['SystemName'] = BLConstant.macOsDeviceInfo!.hostName;
    headers['Channel'] = "MacOS";
  }

  headers['Local'] = BLConstant.local;

  headers['AppName'] = BLConfig.AppName;
  headers['PackageName'] = BLConfig.PackageName;
  headers['AppVersion'] = BLConstant.version;
  headers['BuildNumber'] = BLConstant.buildNumber;

  headers['Domain'] = BLConfig.domain;
  headers['FileDomain'] = BLConfig.fileDomain;
  headers['UserDomain'] = BLConfig.userDomain;
  headers['BaseDomain'] = BLConfig.baseDomain;

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  var userid = sharedPreferences.getString("userid");

  headers['Userid'] = userid;

  final postJson = json.encode(headers);

  debugPrint("header:");
  debugPrint(postJson);

  return postJson;
}
