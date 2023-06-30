import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share/share.dart';
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

  getHtmlContent(){
    final String htmlContent = '''
      <html>
        <head>
          <style>
            body {
              margin-left: 16px;
              margin-right: 16px;
              font-size: 36px; /* 设置字体大小 */
            }
            img {
              max-width: 80%;
              height: auto;
              margin-left: auto;
              margin-right: auto;
            }
          </style>
          <script>
            function setupContextMenu() {
              var body = document.getElementsByTagName('body')[0];
              body.addEventListener('contextmenu', function(event) {
                var selectedText = window.getSelection().toString();
                if (selectedText.length > 0) {
                  window.flutter_inappwebview.callHandler('contextMenu', selectedText);
                }
              });
            }
            setupContextMenu();
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
        </body>
      </html>
    ''';
    return htmlContent;
  }
  @override
  void initState() {
    super.initState();
    if (_webViewController != null) {
      _webViewController!.addJavaScriptHandler(
        handlerName: 'contextMenu',
        callback: (args) {
          setState(() {
            _selectedText = args[0];
          });
        },
      );
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
                  Share.share('$title\n$url\n$date');

              },
            ),
          ],
        ),
        body:
              GestureDetector(
                  behavior: HitTestBehavior.opaque,

                  child: InAppWebView(
                    initialData: InAppWebViewInitialData(data: htmlContent),
                    onWebViewCreated: (controller) {
                      _webViewController = controller;
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
                      // Fluttertoast.showToast(
                      //   msg: '链接已复制',
                      //   toastLength: Toast.LENGTH_SHORT, // Toast持续时间，可以是Toast.LENGTH_SHORT或Toast.LENGTH_LONG
                      //   gravity: ToastGravity.BOTTOM, // Toast显示的位置
                      //   backgroundColor: Colors.black54, // Toast背景颜色
                      //   textColor: Colors.white, // Toast文字颜色
                      //   fontSize: 16.0, // Toast文字大小
                      // );
                      return NavigationActionPolicy.ALLOW;
                    },
                  ),)
            );
  }
}
