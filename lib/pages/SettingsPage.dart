import 'package:beir_flutter/base/BLConstant.dart';
import 'package:beir_flutter/pages/FeedbackPage.dart';
import 'package:beir_flutter/pages/VpnPage.dart';
import 'package:beir_flutter/tool/CommonTool.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';
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
              // 检查是否拥有悬浮窗口权限
              PermissionStatus status = await Permission.systemAlertWindow.status ;

              if (status != PermissionStatus.granted) {
                // 申请悬浮窗口权限
                PermissionStatus permissionStatus = await Permission.systemAlertWindow.request();

                if (permissionStatus != PermissionStatus.granted) {
                  // 权限未被授予，做相应的处理
                  print("用户未授权");
                  return;
                }
              }

              // // 处理隐私设置的点击事件
              // await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
              startFloatingTimeService();
            },
          ),
          ListTile(
            title: Text('意见反馈'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FeedbackPage()), // 替换为你的 VPN 地址切换页面的构造函数
              );
            },
          ),
          ListTile(
            title: Text('分享App'),
            onTap: () {
              var title =  BLConstant.shareAppMsg;
              var url = BLConstant.appHelpUrl;

              var source="来源:线报好羊毛安卓版\n";
              Share.share('$title\n$url\n$source');
            },
          ),
          ListTile(
            title: Text('版本信息: v'+BLConstant.version),
            onTap: () {
              CommonTool().checkUpdate(context,false);
            },
          ),
          // 添加更多的设置选项
        ],
      ),
    );
  }
}
