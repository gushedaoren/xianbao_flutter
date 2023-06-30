import 'package:app_settings/app_settings.dart';
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
  void navigateToSettings(BuildContext context) async {
    // 显示持续时间较长的消息
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('提示'),
          content: Text('即将跳转到WiFi设置界面'),
          actions: [
            ElevatedButton(
              onPressed: () {

                Navigator.pop(context);
              },
              child: Text('取消'),
            ),
            ElevatedButton(
              onPressed: () {
                AppSettings.openWIFISettings(callback: () {
                  print("sample callback function called");
                });

                Navigator.pop(context);
              },
              child: Text('确认'),
            ),
          ],
        );
      },
    );
  }


  Future<void> switchProxy(proxy) async {
    // 执行地址切换的逻辑，可以根据具体需求自行实现
    // 在这个示例中，只是打印被选中的代理地址
    print('Switching to proxy: $proxy');

    // setWifiProxy(proxy["ipaddress"],proxy["port"]);
    var ipaddress = proxy["ipaddress"];
    Clipboard.setData(ClipboardData(text: proxy["proxy"]));
    var msg='ip地址已复制，请记住端口号为:'+proxy["port"];
    navigateToSettings(context);


  }
  getListItem(proxy){
    var mtype=proxy["type"];
    Color remarkColor = mtype == "稳定" ? Colors.green : Colors.red; // 根据mtype值确定remark文本颜色
    return ListTile(
      title: Text(proxy["proxy"]),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // 设置子组件左对齐
        children: [
          Text(proxy["region"],style: TextStyle(
            fontSize: 16, // 设置字体大小
          ),),
          Text(proxy['remark'],style: TextStyle(
            fontSize: 12, // 设置字体大小
            color: remarkColor, // 设置remark文本颜色
          ),),
        ],
      ),

      onTap: () {
        switchProxy(proxy);
      },
    );
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
          return getListItem(proxy);
        },
      ),
    );
  }
}

