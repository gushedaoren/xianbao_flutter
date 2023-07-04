import 'package:beir_flutter/base/BLConfig.dart';
import 'package:beir_flutter/tool/RequestUtil.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  String _feedbackText = '';
  String feedback_url = BLConfig.userDomain + "/FeedBack";
  void _submitFeedback() async {

    EasyLoading.show(status: '加载中');

    var content = _feedbackText;

    try {
      var formData = FormData.fromMap({

        'content': content,

        'channel': BLConfig.Channel,
      });

      print(feedback_url);
      print(formData.toString());

      Response response =
          await RequestUtil.dio.post(feedback_url, data: formData) as Response;
      print(response.statusCode);
      print(response.data.toString());
      var msg = response.data["msg"];
      if (response.statusCode == 200) {
        EasyLoading.showSuccess(msg);

        Navigator.pop(context);
      } else {
        EasyLoading.showError(msg);
      }
    } catch (e) {
      print(e);
      EasyLoading.showError("网络异常,请稍后再试");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('意见反馈'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              '请填写您的反馈意见：',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: TextFormField(
                maxLines: null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '在这里输入您的反馈',
                ),
                onChanged: (value) {
                  setState(() {
                    _feedbackText = value;
                  });
                },
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _feedbackText.isEmpty ? null : _submitFeedback,
              child: Text('提交反馈'),
            ),
          ],
        ),
      ),
    );
  }
}
