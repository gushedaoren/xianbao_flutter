import 'package:flutter/material.dart';

abstract class BLBasePage extends StatefulWidget {
  final Key key;
  BLBasePage({required this.key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => cState();

  State<StatefulWidget> cState();
}

class BLBaseState<T extends BLBasePage> extends State<T> {
  late BuildContext mContext;

  @override
  void initState() {
    beforeInit();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    mContext = context;
    return Scaffold();
  }

  @override
  void dispose() {
    beforeDispose();
    super.dispose();

  }



  //初始化之前的操作
  void beforeInit() {}
  //销毁之前的操作
  void beforeDispose() {}
}
