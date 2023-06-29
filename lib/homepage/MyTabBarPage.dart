import 'package:beir_flutter/base/BLConfig.dart';
import 'package:beir_flutter/pages/VpnPage.dart';
import 'package:beir_flutter/tool/CommonTool.dart';
import 'package:beir_flutter/tool/RequestUtil.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pages/DetailPage.dart';

class MyTabBarPage extends StatefulWidget {
  @override
  _MyTabBarState createState() => _MyTabBarState();
}

class _MyTabBarState extends State<MyTabBarPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;
  ScrollController _scrollController = ScrollController();
  bool isLoading = true;
  var posts=[];
  var tags=[];
  var lastid="";
  var tagid="0";
  var hint="";
  var keyword="";
  @override
  void initState() {
    super.initState();
    CommonTool().initApp();
    _scrollController.addListener(_onScroll);
    _tabController = TabController(length: 5, vsync: this);
    _pageController = PageController(initialPage: 0); // Initialize the PageController
    getProductList();
  }
  void _onScroll() {
    if (isLoading) return;
    print("_onScroll:");
    print(_scrollController.position.pixels);
    print(_scrollController.position.maxScrollExtent);
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      setState(() {
        isLoading = true;
      });
      getProductList();
    }
  }
  getProductList() async {

    var url_get = BLConfig.domain + "/posts?tagid=$tagid&lastid=$lastid&keyword=$keyword";
    print(url_get);

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userid = sharedPreferences.getString("userid");

    var queryParams = {'userid': userid};
    print("homepageurl:$url_get");
    var response = await RequestUtil.dio.get(url_get, queryParameters: queryParams);

    setState(() {
      if(lastid==""){
        posts = response.data["posts"];
      }else{
        posts.addAll(response.data["posts"]);
      }

      tags = response.data["tags"];
      hint = response.data["hint"];
      lastid = response.data["lastid"];
      isLoading = false;
      print("tags:$tags");
    });

    setState(() {});
  }
   _buildTabContent() {
    return Center(
        child:
              ListView.builder(
              itemCount: posts.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(posts[index]['title']),
                  subtitle: Text(posts[index]['date']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(post:posts[index],hint:hint),
                      ),
                    );
                  },
                );
            },
          ),

      );

  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("一大波羊毛正在飞速赶来...",style: TextStyle(
              fontSize: 22, // 设置字体大小
            ),),
            Text("  "),
            CircularProgressIndicator(),
          ],
        )

      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(BLConfig.AppName),
          actions: [
            IconButton(
              icon: Icon(Icons.my_location_rounded),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VpnPage()), // 替换为你的 VPN 地址切换页面的构造函数
                );
              },
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            tabs: tags.map((tag) {
              return Tab(text: tag['name']);
            }).toList(),
            onTap: (index) {
              setState(() {
                tagid = tags[index]['id'];
                lastid = "";
                getProductList();
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              });
            },
          ),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min, // 设置为 MainAxisSize.min
            children: [

              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: tags.length,
                  itemBuilder: (context, index) {
                    return _buildTabContent();
                  },
                  onPageChanged: (index) {
                    setState(() {
                      tagid = tags[index]['id'];
                      lastid = "";
                      getProductList();
                      _tabController.animateTo(
                        index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    });
                  },
                ),
              ),
            ],
          ),
        )
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    _pageController.dispose();
    super.dispose();
  }
}
