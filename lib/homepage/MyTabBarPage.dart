import 'package:beir_flutter/base/BLConfig.dart';
import 'package:beir_flutter/tool/CommonTool.dart';
import 'package:beir_flutter/tool/RequestUtil.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyTabBarPage extends StatefulWidget {
  @override
  _MyTabBarState createState() => _MyTabBarState();
}

class _MyTabBarState extends State<MyTabBarPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  var posts=[];
  var tags=[];
  var lastid="";
  var tagid="0";
  @override
  void initState() {
    super.initState();
    CommonTool().initApp();
    _tabController = TabController(length: 4, vsync: this);
    getProductList();
  }

  getProductList() async {

    var url_get = BLConfig.domain + "/posts?tagid=$tagid";

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userid = sharedPreferences.getString("userid");

    var queryParams = {'userid': userid};
    print("homepageurl:$url_get");
    var response = await RequestUtil.dio.get(url_get, queryParameters: queryParams);

    _tabController.dispose();
    setState(() {
      posts = response.data["posts"];
      tags = response.data["tags"];
      lastid = response.data["lastid"];
      print("tags:$tags");
    });

    setState(() {});
  }
  List<Widget> _buildTabContent() {
    return (tags ?? []).map((tag) {

      return Center(
        child: ListView.builder(
          itemCount: posts.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(posts[index]['title']),
              subtitle: Text(posts[index]['date']),
            );
          },
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (tags == []) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(BLConfig.AppName),
          bottom: TabBar(
            controller: _tabController,
            tabs: tags.map((tag) {
              return Tab(text: tag['name']);
            }).toList(),
            onTap: (index) {
              setState(() {
                tagid = tags[index]['id'];
              });
            },
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: _buildTabContent(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
