
import 'package:beir_flutter/base/BLConfig.dart';
import 'package:beir_flutter/postpage/CategoryListPage.dart';
import 'package:beir_flutter/postpage/PostListPage.dart';
import 'package:beir_flutter/tool/CommonTool.dart';
import 'package:beir_flutter/tool/RequestUtil.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:one_context/one_context.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var categories;
  var parentCategories;
  var banners;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CommonTool().initApp();
    getCategoryList();
  }

  getCategoryList() async {

    var url_post = BLConfig.domain + "/Homepage";



    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userid = sharedPreferences.getString("userid");

    var formData = FormData.fromMap({
      'userid': userid,
    });

    print("homepageurl:$url_post");
    var response = await RequestUtil.dio.post(url_post, data: formData);

    var responseStr = response.data;
    print(responseStr);

    categories=response.data["categories"];
    parentCategories=response.data["parentCategories"];
    banners=response.data["banners"];


    setState(() {});
  }
  getCategoryTitle(item){
    var title=item["Term"]["Name"];

    return title;

  }
  showParentCategoryImg(item){
    var iconSize=50.0;
    var url=getCategoryImgUrl(item);
    if(url=="")return Container(
      width: iconSize,
      height: iconSize,
      child: Image.asset('assets/images/ic_launcher.png'),
    );
    return Container(
        width: iconSize,
        height: iconSize,
        child: Image.network(
          url,
          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
            return Image.asset('assets/images/ic_launcher.png');
          },
        )
    );
  }
  showCategoryImg(item){
    var iconSize=60.0;
    var url=getCategoryImgUrl(item);
    if(url=="")return Container(
      width: iconSize,
      height: iconSize,
      child: Image.asset('assets/images/ic_launcher.png'),
    );
    return Container(
      width: iconSize,
      height: iconSize,
      child: Image.network(
        url,
        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
          return Image.asset('assets/images/ic_launcher.png');
        },
      )
    );
  }

  showBannerImg(item){
    print("showBannerImg:$item");
    var iconSizeWidth=360.0;
    var iconSizeHeight=180.0;
    var url=getCategoryImgUrl(item);
    var title=getCategoryTitle(item);
    if(url=="")return Container(
      width: iconSizeWidth,
      height: iconSizeHeight,
      child: Image.asset('assets/images/ic_launcher.png'),
    );
    return GestureDetector(
      onTap: (){
        OneContext()
            .push(MaterialPageRoute(builder: (_) => PostListPage(categoryid: item["term_id"],title: item["Term"]["Name"],)));
      },
      child:  Stack(
        children: [
          Container(
              width: iconSizeWidth,
              height: iconSizeHeight,
              child: Image.network(
                url,
                fit: BoxFit.fill,
                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                  return Image.asset('assets/images/ic_launcher.png');
                },
              )
          ),

          Positioned(
              bottom: 10, // 将元素放置在底部
              right: 10, // 将元素放置在右侧
              child:  Row(
                children: [
                  Container(child:  Text(title,style: TextStyle(fontSize: 20),overflow: TextOverflow.ellipsis,))
                ],
              )


          ),

        ],
      )
    );





  }
  getCategoryImgUrl(item){
    var CategoryMetas=item["CategoryMetas"];
    if(CategoryMetas==null)return "";
    if(CategoryMetas!.length>0){
      var url=CategoryMetas[0]["MetaValue"];
      url=RequestUtil().replaceImgDomain(url);
      return url;
    }else{
      return "";
    }

  }

  showParentCategoryView(){
    if(parentCategories==null)return Container();
    return Container(

        child:  GridView.count(
          shrinkWrap: true,
          crossAxisCount: 3,
          // 设置每子元素的大小（宽高比）
          childAspectRatio: 1.8,
          // 元素的左右的 距离
          crossAxisSpacing: 0,
          // 子元素上下的 距离
          mainAxisSpacing: 5,

      physics:NeverScrollableScrollPhysics(),//禁用滑动事件

      children: List.generate(parentCategories!.length, (index) {
        return GestureDetector(
            onTap: (){
              OneContext()
                  .push(MaterialPageRoute(builder: (_) => CategoryListPage(categoryid: parentCategories[index]["term_id"],title: parentCategories[index]["Term"]["Name"],)));
            },
            child:  Center(
              child: Column(
                children: [
                  showParentCategoryImg(parentCategories[index]),
                  Expanded(child:  Text(
                    getCategoryTitle(parentCategories[index]),
                    style: TextStyle(fontSize: 14),
                  ),)

                ],
              ),
            )
        );


      }),
    ));


  }
  showCategoryView(){
    if(categories==null)return Container();
    return Container(

        child:  GridView.count(
          shrinkWrap: true,
      physics:NeverScrollableScrollPhysics(),//禁用滑动事件
          crossAxisCount: 1,
          // 设置每子元素的大小（宽高比）
          childAspectRatio: 5,
          // 元素的左右的 距离
          crossAxisSpacing: 10,
          // 子元素上下的 距离
          mainAxisSpacing: 5,

          children: List.generate(categories!.length, (index) {
        return GestureDetector(
            onTap: (){
              OneContext()
                  .push(MaterialPageRoute(builder: (_) => PostListPage(categoryid: categories[index]["term_id"],title: categories[index]["Term"]["Name"],)));
            },
            child:  Container(
              child: Row(
                children: [
                  showCategoryImg(categories[index]),
                  SizedBox(width: 20,),
                  Expanded(child:    Text(
                    getCategoryTitle(categories[index]),
                    style: TextStyle(fontSize: 22),
                  ),)

                ],
              ),
            )
        );


      }),
    ));



  }
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(BLConfig.AppName),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10.0,10.0,10.0,10.0),
        child: SingleChildScrollView(
          child:  Container(
            child:  Column(
              children: [
                Container(

                  child:  showBanner(),),

                SizedBox(height: 10,),
                showParentCategoryView(),
                showCategoryView(),

              ],
            )
          )



        )



      )


    );
  }

  showBanner() {
    if(banners==null)return Container();
    return Container(
        width: 360,
        height: 180,
        child:  new Swiper(
          autoplay: true,
          duration: 1500,
          onTap: (index) {
            OneContext()
                .push(MaterialPageRoute(builder: (_) => PostListPage(categoryid: banners[index]["term_id"],title: banners[index]["Term"]["Name"],)));
          },
      itemBuilder: (BuildContext context,int index){
        return showBannerImg(banners[index]);
      },
      itemCount: banners!.length,
      pagination: new SwiperPagination(),
      // control: new SwiperControl(),

    ));


  }
}
