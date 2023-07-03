import 'package:beir_flutter/base/BLConstant.dart';
import 'package:beir_flutter/pages/VpnPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:flutter/services.dart';
class SettingsPage extends StatelessWidget {
  void startFloatingTimeService() {
    const platform = MethodChannel('floating_time_service');
    try {
      platform.invokeMethod('start_service');
    } catch (e) {
      print('Failed to start Floating Time Service: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('设置'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('城市切换'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VpnPage()), // 替换为你的 VPN 地址切换页面的构造函数
              );
            },
          ),
          ListTile(
            title: Text('悬浮时间'),
            onTap: () async {
              // 处理隐私设置的点击事件
              await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
              startFloatingTimeService();
            },
          ),
          ListTile(
            title: Text('意见反馈'),
            onTap: () {
              // 处理显示设置的点击事件
            },
          ),
          ListTile(
            title: Text('分享App'),
            onTap: () {
              // 处理显示设置的点击事件
            },
          ),
          ListTile(
            title: Text('版本信息: v'+BLConstant.version),
            onTap: () {
              // 处理显示设置的点击事件
            },
          ),
          // 添加更多的设置选项
        ],
      ),
    );
  }
}
