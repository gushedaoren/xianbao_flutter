import 'package:beir_flutter/base/BLConfig.dart';
import 'package:beir_flutter/tool/RequestUtil.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';

import 'package:fluttertoast/fluttertoast.dart';


import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class VpnPage extends StatefulWidget {
  @override
  _VpnPageState createState() => _VpnPageState();
}

class _VpnPageState extends State<VpnPage> {
  var proxyList = [];
  static const platform = const MethodChannel('wifi_proxy_channel');

  void setWifiProxy(String proxyAddress, String proxyPort) async {
    try {
      await platform.invokeMethod('setWifiProxy', {
        'proxyAddress': proxyAddress,
        'proxyPort': proxyPort,
      });
    } catch (e) {
      print('Failed to set WiFi proxy: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProxyList();
  }

  Future<void> fetchProxyList() async {
    final url_get = BLConfig.domain +'/proxyall';
    print("fetchProxyList url_get:$url_get");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userid = sharedPreferences.getString("userid");
    var queryParams = {'userid': userid};
    var response = await RequestUtil.dio.get(url_get, queryParameters: queryParams,options: Options(
      // responseType: ResponseType.plain, // 指定接收纯文本响应
    ),);

    if (response.statusCode == 200) {
      print(response.data);
      setState(() {
        proxyList = response.data["datas"];
        print(proxyList);
      });
    } else {
      // 处理请求失败的情况
    }
  }


  Future<void> switchProxy(proxy) async {
    // 执行地址切换的逻辑，可以根据具体需求自行实现
    // 在这个示例中，只是打印被选中的代理地址
    print('Switching to proxy: $proxy');

    // setWifiProxy(proxy["ipaddress"],proxy["port"]);
    var ipaddress = proxy["ipaddress"];
    Clipboard.setData(ClipboardData(text: ipaddress));
    var msg='ip地址已复制，请砌筑端口号为:'+proxy["port"];
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG, // Toast持续时间，可以是Toast.LENGTH_SHORT或Toast.LENGTH_LONG
      gravity: ToastGravity.BOTTOM, // Toast显示的位置
      backgroundColor: Colors.black54, // Toast背景颜色
      textColor: Colors.white, // Toast文字颜色
      fontSize: 16.0, // Toast文字大小
    );

    final url = 'App-Prefs:root=WIFI';
    if (await  canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch Wi-Fi settings.';
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('城市切换'),
      ),
      body: ListView.builder(
        itemCount: proxyList.length,
        itemBuilder: (context, index) {
          final proxy = proxyList[index];
          return ListTile(
            title: Text(proxy["region"]),
            onTap: () {
              switchProxy(proxy);
            },
          );
        },
      ),
    );
  }
}
