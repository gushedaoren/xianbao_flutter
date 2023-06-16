import 'package:beir_flutter/base/BLConfig.dart';
import 'package:flutter/material.dart';

class MyTabBarPage extends StatefulWidget {
  @override
  _MyTabBarState createState() => _MyTabBarState();
}

class _MyTabBarState extends State<MyTabBarPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(BLConfig.AppName),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Tab 1'),
            Tab(text: 'Tab 2'),
            Tab(text: 'Tab 3'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          Center(child: Text('Content for Tab 1')),
          Center(child: Text('Content for Tab 2')),
          Center(child: Text('Content for Tab 3')),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
