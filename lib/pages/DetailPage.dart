import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DetailPage extends StatelessWidget {
  final dynamic post;
  final dynamic hint;
  InAppWebViewController? _webViewController;
  DetailPage({required this.post,required this.hint});


  void _handleLinkClick(String href) {
    // Call the platform channel to copy the link to the clipboard
    const platform = const MethodChannel('clipboard_channel');
    platform.invokeMethod('copyToClipboard', {'text': href});

    print("连接复制成功");

    // Call the showToast method to display a toast message
    // showToast('Link copied to clipboard!');

  }

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
            function copyTextToClipboard(text) {
              var textField = document.createElement('textarea');
              textField.innerText = text;
              document.body.appendChild(textField);
              textField.select();
              document.execCommand('copy');
              textField.remove();
            }
            function handleLinkClick(event) {
              var target = event.target;
              if (target.tagName.toLowerCase() === 'a') {
                var href = target.getAttribute('href');
                if (href.startsWith('mailto:')) {
                  // Allow default behavior for mailto links
                  return;
                }
                event.preventDefault();
                copyTextToClipboard(href);
                LinkClickChannel.postMessage(href);
                
              }
            }
            document.addEventListener('click', handleLinkClick);
          </script>
        </head>
        <body>
          ${post['content']}
          </br>
          ${hint}${post['date']}
          </br>
          原文连接：<a href="${post['guid']}">${post['guid']}</a>
          </br>
          </br>
        </body>
      </html>
    ''';
    return htmlContent;
  }
  @override
  Widget build(BuildContext context) {
    var htmlContent=getHtmlContent();

    return Scaffold(
        appBar: AppBar(
          title: Text(post['title']),
        ),
        body:
              GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onLongPress: () {},
                  child: InAppWebView(
                    initialData: InAppWebViewInitialData(data: htmlContent),
                    initialOptions: InAppWebViewGroupOptions(
                      crossPlatform: InAppWebViewOptions(
                        useShouldOverrideUrlLoading: true,
                        useOnLoadResource: true,
                      ),
                    ),
                    shouldOverrideUrlLoading: (controller, navigationAction) async {
                      // 处理链接点击事件
                      final url = navigationAction.request.url.toString();
                      print('链接已复制: $url');
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('链接已复制: $url'),
                      ));

                      Fluttertoast.showToast(
                        msg: '链接已复制',
                        toastLength: Toast.LENGTH_SHORT, // Toast持续时间，可以是Toast.LENGTH_SHORT或Toast.LENGTH_LONG
                        gravity: ToastGravity.BOTTOM, // Toast显示的位置
                        backgroundColor: Colors.black54, // Toast背景颜色
                        textColor: Colors.white, // Toast文字颜色
                        fontSize: 16.0, // Toast文字大小
                      );
                      return NavigationActionPolicy.ALLOW;
                    },
                  ),)
            );
  }
}
