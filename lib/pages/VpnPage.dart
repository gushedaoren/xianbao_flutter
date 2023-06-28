import 'package:beir_flutter/base/BLConfig.dart';
import 'package:beir_flutter/tool/RequestUtil.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';



import 'package:shared_preferences/shared_preferences.dart';

class VpnPage extends StatefulWidget {
  @override
  _VpnPageState createState() => _VpnPageState();
}

class _VpnPageState extends State<VpnPage> {
  var proxyList = [];

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
