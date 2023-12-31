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
  var keyword="";
  var help_url="";
  var proxyCount=0;
  TextEditingController textcontroller = TextEditingController();
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
    var queryParams = {'keyword': keyword};
    var response = await RequestUtil.dio.get(url_get, queryParameters: queryParams);
    print("response:$response");

    if (response.statusCode == 200) {
      print(response.data);
      setState(() {
        proxyList = response.data["datas"];
        print(proxyList);
        help_url = response.data["help_url"];
        proxyCount=response.data['count'];
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
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    '即将跳转到WiFi设置界面',
                    style: TextStyle(
                      fontSize: 18, // 设置字体大小
                      fontWeight: FontWeight.bold, // 加粗字体
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10), // 添加10个像素的垂直间距
              Wrap(
                children: [

                  Text("使用帮助:"),
                  GestureDetector(
                    onTap: () {
                      launchUrl(Uri.parse(help_url)); // 使用launch函数打开链接
                    },
                    child: Text(
                      help_url,
                      style: TextStyle(
                        decoration: TextDecoration.underline, // 可选：添加下划线以指示链接
                        color: Colors.blue, // 可选：设置链接颜色
                      ),
                    ),
                  ),
                ],
              ),



            ],
          ),

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
      body:Column(
        children: [
      Padding(
      padding: EdgeInsets.only(top: 10.0),
         child: Container(
           height: 40,
          margin: EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.grey[200], // 设置背景颜色
          ),
          child:
          TextField(
            textAlignVertical: TextAlignVertical.top,
            decoration: InputDecoration(
              hintText: '搜索城市',
              border: InputBorder.none, // 移除TextField的默认边框
              contentPadding: EdgeInsets.symmetric(horizontal: 16.0), // 设置输入框内边距
            ),
            controller: textcontroller, // 将controller绑定到TextField组件

            onChanged: (value) {
              setState(() {
                print("onChange:$value");
                keyword=value;
                fetchProxyList();

              });

            },
          ),
        ),
      ),
          Expanded(
            child: (proxyCount > 0)
                ? ListView.builder(
              itemCount: proxyList.length,
              itemBuilder: (context, index) {
                final proxy = proxyList[index];
                return getListItem(proxy);
              },
            )
                : Center(child: Text("抱歉现在没有数据,请稍后再来",style: TextStyle(fontSize: 20),)),
          ),
        ],
      )


    );
  }
}

