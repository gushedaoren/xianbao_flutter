
import 'package:beir_flutter/base/BLConfig.dart';
import 'package:beir_flutter/postpage/PostDetailPage.dart';
import 'package:beir_flutter/tool/RequestUtil.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:one_context/one_context.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostListPage extends StatefulWidget {
  final dynamic categoryid;
  final dynamic title;
  const PostListPage({super.key,this.categoryid,this.title});


  @override
  State<PostListPage> createState() => _PostListPageState();
}

class _PostListPageState extends State<PostListPage> {
  var datas;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPostList();
  }

  getPostList() async {

    var url_post = BLConfig.domain + "/PostList";



    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userid = sharedPreferences.getString("userid");

    var formData = FormData.fromMap({
      'userid': userid,
      'categoryid': widget.categoryid,
    });

    var response = await RequestUtil.dio.post(url_post, data: formData);

    var responseStr = response.data;
    print(responseStr);

    datas=response.data["data"];


    setState(() {});
  }
  getTitle(item){
    var title=item["PostTitle"];

    return title;

  }

  showImg(item){
    var iconSize=60.0;
    var url=getImgUrl(item);
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
  getImgUrl(item){
    var PostMetas=item["PostMetas"];
    if(PostMetas!.length>0){
      for(var meta in PostMetas){
        if(meta["MetaKey"]=="org_img_url"){
          var url=meta["MetaValue"];
          url=RequestUtil().replaceImgDomain(url);
          return url;
        }
      }

    }else{
      return "";
    }

  }
  showCategoryView(){
    if(datas==null)return Container();
    return GridView.count(
      shrinkWrap: true,
      physics:NeverScrollableScrollPhysics(),//禁用滑动事件
      crossAxisCount: 1,
      // 设置每子元素的大小（宽高比）
      childAspectRatio: 5,
      // 元素的左右的 距离
      crossAxisSpacing: 10,
      // 子元素上下的 距离
      mainAxisSpacing: 5,

      children: List.generate(datas!.length, (index) {
        return GestureDetector(
          onTap: (){
            OneContext()
                .push(MaterialPageRoute(builder: (_) => PostDetailPage(data:datas[index])));
          },
          child: Center(
            child: Row(
              children: [
                showImg(datas[index]),
                SizedBox(width: 20,),
                Expanded(child:   Text(
                  getTitle(datas[index]),
                  style: TextStyle(fontSize: 18),
                ),)

              ],
            ),
          )
        );



      }),
    );
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
        title: Text(widget.title),
      ),
      body:Padding(
        padding: const EdgeInsets.fromLTRB(10.0,10.0,10.0,10.0),
        child:  SingleChildScrollView(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: showCategoryView(),

        ),
      )



    );
  }
}
