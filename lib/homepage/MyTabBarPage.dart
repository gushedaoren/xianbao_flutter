import 'dart:io';

import 'package:beir_flutter/base/BLConfig.dart';
import 'package:beir_flutter/base/BLConstant.dart';
import 'package:beir_flutter/pages/SettingsPage.dart';
import 'package:beir_flutter/pages/VpnPage.dart';
import 'package:beir_flutter/tool/CommonTool.dart';
import 'package:beir_flutter/tool/EncryptTool.dart';
import 'package:beir_flutter/tool/RequestUtil.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../pages/DetailPage.dart';

class MyTabBarPage extends StatefulWidget {
  @override
  _MyTabBarState createState() => _MyTabBarState();
}

class _MyTabBarState extends State<MyTabBarPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;
  TextEditingController textcontroller = TextEditingController();
  ScrollController _scrollController = ScrollController();
  bool isLoading = true;
  var posts=[];
  var tags=[];
  var lastid="";
  var tagid="0";
  var hint="";
  var keyword="";
  Future<void> loadAndShowAd() async {

    setState(() {

    });

  }
  @override
  void initState() {

    super.initState();
    Future.delayed(Duration.zero, () async {
      await CommonTool().initApp();
      _scrollController.addListener(_onScroll);
      _tabController = TabController(length: 5, vsync: this);
      _pageController = PageController(initialPage: 0); // Initialize the PageController
      CommonTool().checkUpdate(context,true);
      getProductList();
    });
  }
  Widget _buildLoader() {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Container();
  }
  void _onScroll() {
    print("_onScroll:");
    if (isLoading) return;
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

    var url_get = BLConfig.domain + "/GetPosts?tagid=$tagid&lastid=$lastid&keyword=$keyword&platform=android";
    print(url_get);

    print("homepageurl:$url_get");

    var response = await RequestUtil.dio.get(url_get);

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
  Future<void> refreshData() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });
    lastid="";
    getProductList();
  }

  Widget _buildTabContent() {
    return RefreshIndicator(
        onRefresh: refreshData,
        child:ListView.builder(
          controller: _scrollController,
          itemCount: posts.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index < posts.length) {
              return ListTile(
                title: Text(posts[index]['title'],
                  style: TextStyle(
                    color: posts[index]['is_top'] ? Colors.red : Colors.black,
                  ),),
                subtitle: Text(posts[index]['date']),

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DetailPage(post: posts[index], hint: hint),
                    ),
                  );
                },
              );
            } else {
              return _buildLoader();
            }
          })




    );
  }
  @override
  Widget build(BuildContext context) {
    if (isLoading&&(posts.isEmpty)) {
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
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()), // 替换为你的 VPN 地址切换页面的构造函数
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
            Padding(
            padding: EdgeInsets.only(top: 10.0),
            child:  Container(
                height: 40,
                margin: EdgeInsets.symmetric(horizontal: 16.0,vertical: 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey[200], // 设置背景颜色
                ),
                  child: Center(
                    child: TextField(
                      textAlignVertical: TextAlignVertical.top,
                      decoration: InputDecoration(
                        hintText: '搜索内容',
                        border: InputBorder.none, // 移除TextField的默认边框
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0,vertical: 0), // 设置输入框内
                      ),
                      controller: textcontroller, // 将controller绑定到TextField组件

                      onChanged: (value) {
                        setState(() {
                          print("onChange:$value");
                          keyword=value;
                          lastid="";
                          getProductList();

                        });

                      },
                    ),

                  )




              ),
            ),
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
