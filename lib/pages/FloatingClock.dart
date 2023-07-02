import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

class FloatingClock extends StatefulWidget {
  @override
  _FloatingClockState createState() => _FloatingClockState();
}

class _FloatingClockState extends State<FloatingClock> {
  DateTime _currentTime;

  @override
  void initState() {
    super.initState();
    // 使用定时器每秒更新时间
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });

    // 在页面加载后请求显示悬浮窗口
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SHOW_OVER_OTHERS);
      await FlutterWindowManager.addView(
        params: WindowManagerParams(
          type: WindowManagerParams.TYPE_PHONE,
          flags: WindowManagerParams.FLAG_NOT_FOCUSABLE |
          WindowManagerParams.FLAG_NOT_TOUCH_MODAL |
          WindowManagerParams.FLAG_LAYOUT_NO_LIMITS,
          width: WindowManagerParams.WRAP_CONTENT,
          height: WindowManagerParams.WRAP_CONTENT,
          gravity: WindowManagerParams.gravityTopRight,
          format: ImageFormat.TRANSPARENT,
          screenBrightness: ScreenBrightness.SCREEN_BRIGHTNESS_AUTO,
          title: 'Floating Clock',
          focusable: false,
        ),
        view: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            _currentTime != null
                ? "${_currentTime.hour}:${_currentTime.minute.toString().padLeft(2, '0')}"
                : "--:--", // 根据需要自定义时间显示格式
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

