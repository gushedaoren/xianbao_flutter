import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:share/share.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
class DetailPage extends StatefulWidget {
  final dynamic post;
  final dynamic hint;
  DetailPage({required this.post,required this.hint});
  @override
  DetailPageState createState() => DetailPageState();
}
class DetailPageState extends State<DetailPage>  {

  InAppWebViewController? _webViewController;

  String? _selectedText;
  late ContextMenu contextMenu;
  String? _currentImageUrl;
  getHtmlContent(){
    final String htmlContent = '''
      <html>
        <head>
          <style>
            body {
              margin-left: 16px;
              margin-right: 16px;
              font-size: 42px; /* 设置字体大小 */
              text-align: left; /* 设置文本左对齐 *
              word-wrap: break-word; /* 自动换行 */
            }
            img {
              max-width: 90%;
              height: auto;
              margin-left: 16px;
              margin-right: 16px;
            }
          </style>
          <script>
            function handleImageLongPress(src) {
              window.flutter_inappwebview.callHandler('handleImageLongPress', src);
            }
          </script>
        </head>
        <body>
          ${widget.post['content']}
          </br>
          ${widget.hint}${widget.post['date']}
          </br>
          原文连接：<a href="${widget.post['guid']}">${widget.post['guid']}</a>
          </br>
          </br>
           <script>
            // 遍历所有的img标签并添加onclick事件
            var images = document.getElementsByTagName('img');
            for (var i = 0; i < images.length; i++) {
             images[i].setAttribute('oncontextmenu', 'event.preventDefault(); handleImageLongPress(this.src); return false;');
            }
          </script>
        </body>
      </html>
    ''';
    return htmlContent;
  }
  @override
  void initState() {
    super.initState();

  }
  void saveImageToGallery(String imageUrl) async {
    var response = await http.get(Uri.parse(imageUrl));

    final result = await ImageGallerySaver.saveImage(
      Uint8List.fromList(response.bodyBytes),
    );

    if (result['isSuccess']) {
      print("Image saved successfully");
    } else {
      print("Failed to save image: ${result['errorMessage']}");
    }
  }

  @override
  Widget build(BuildContext context) {
    var htmlContent=getHtmlContent();

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.post['title'],style: TextStyle(
            fontSize: 18, // 设置字体大小
          ),),
          actions: [
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                  var title =  widget.post["title"];
                  var url = widget.post["guid"];
                  var date = "发布时间:"+widget.post["date"];
                  var source="来源:线报好羊毛安卓版\n";
                  Share.share('$title\n$url\n$date\n$source');
              },
            ),
          ],
        ),
        body:_currentImageUrl != null
            ? Center(
          child: Image.network(_currentImageUrl!),
        )
            :
        Center(

                  child: InAppWebView(
                    initialData: InAppWebViewInitialData(data: htmlContent),
                    onWebViewCreated: (controller) {
                      _webViewController = controller;
                      if (_webViewController != null) {
                        _webViewController!.addJavaScriptHandler(
                          handlerName: 'contextMenu',
                          callback: (args) {
                            setState(() {
                              print("contextMenu:$args");
                              _selectedText = args[0];
                            });
                          },
                        );
                        controller.addJavaScriptHandler(handlerName: 'handleImageLongPress', callback: (args) {

                          setState(() {
                            String _currentImageUrl = args[0];
                            print("handleImageLongPress:$_currentImageUrl");
                            saveImageToGallery(_currentImageUrl);
                            Fluttertoast.showToast(
                              msg: '图片已保存到相册',
                              toastLength: Toast.LENGTH_SHORT, // Toast持续时间，可以是Toast.LENGTH_SHORT或Toast.LENGTH_LONG
                              gravity: ToastGravity.BOTTOM, // Toast显示的位置
                              backgroundColor: Colors.black54, // Toast背景颜色
                              textColor: Colors.white, // Toast文字颜色
                              fontSize: 16.0, // Toast文字大小
                            );
                          });
                        });
                      }
                    },
                    initialOptions: InAppWebViewGroupOptions(
                      crossPlatform: InAppWebViewOptions(
                        useShouldOverrideUrlLoading: true,
                        useOnLoadResource: true,

                      ),

                    ),
                    shouldOverrideUrlLoading: (controller, navigationAction) async {
                      print("shouldOverrideUrlLoading start");
                      final url = navigationAction.request.url.toString();
                      print('shouldOverrideUrlLoading: $url');

                      return NavigationActionPolicy.ALLOW;
                    },
                  ),)
            );
  }
}
