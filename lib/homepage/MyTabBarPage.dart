import 'dart:io';

import 'package:beir_flutter/base/BLConfig.dart';
import 'package:beir_flutter/pages/VpnPage.dart';
import 'package:beir_flutter/tool/CommonTool.dart';
import 'package:beir_flutter/tool/RequestUtil.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qq_ads/flutter_qq_ads.dart';

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
  ScrollController _scrollController = ScrollController();
  bool isLoading = true;
  var posts=[];
  var tags=[];
  var lastid="";
  var tagid="0";
  var hint="";
  var keyword="";
  Future<void> loadAndShowAd() async {
    // await FlutterQqAds.initAd(BLConfig.kt.TencentAD_APPID); // 替换为你的 QQ 广告 App ID
    await Future.delayed(Duration(seconds: 0)); // 延迟 5 秒钟展示广告
    if (mounted) {
      setState(() {
        FlutterQqAds.showSplashAd(
          BLConfig.TencentAD_Android_SPLASH_ID,
          fetchDelay: 5,
        );
      });
    }
  }
  @override
  void initState() {
    loadAndShowAd();
    super.initState();

    CommonTool().initApp();
    _scrollController.addListener(_onScroll);
    _tabController = TabController(length: 5, vsync: this);
    _pageController = PageController(initialPage: 0); // Initialize the PageController
    checkUpdate();
    getProductList();
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
  Future<void> checkUpdate() async{
    //Android , 需要下载apk包
    if(Platform.isAndroid){
      print('is android');
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String appVersion = packageInfo.version;
      var versioncode=packageInfo.buildNumber;
      var url_get = BLConfig.domain + "/CheckAppVersion?versioncode=$versioncode";
      print(url_get);

      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      var userid = sharedPreferences.getString("userid");

      var queryParams = {'userid': userid};
      print("homepageurl:$url_get");
      var response = await RequestUtil.dio.get(url_get, queryParameters: queryParams);
      print(response.data);
      var needUpdate=response.data["needUpdate"];
      var updateurl=response.data["url"];
      var serverVersionName=response.data["serverVersionName"];
      if(needUpdate){
        print("needUpdate true 开始下载...");
        showUpdateAlert(updateurl);

      }


    }


  }

  showUpdateAlert(apkurl){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('提示'),
          content: Text('线报好羊毛更新了，赶紧去下载'),
          actions: [
            ElevatedButton(
              onPressed: () {

                Navigator.pop(context);
              },
              child: Text('取消'),
            ),
            ElevatedButton(
              onPressed: () {
                _downloadApk(apkurl);
                Navigator.pop(context);
              },
              child: Text('确认'),
            ),
          ],
        );
      },
    );
  }
  void _downloadApk(apkUrl) async {
    if (await canLaunch(apkUrl)) {
      await launch(apkUrl);
    } else {
      throw 'Could not launch $apkUrl';
    }
  }


  getProductList() async {

    var url_get = BLConfig.domain + "/posts?tagid=$tagid&lastid=$lastid&keyword=$keyword&platform=android";
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
                title: Text(posts[index]['title']),
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
