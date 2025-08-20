/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';

import 'package:sufenbao/service.dart';

import '../util/toast_utils.dart';

///吐槽我们
class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPage createState() => _FeedbackPage();
}

class _FeedbackPage extends State<FeedbackPage> {
  TextEditingController _feedbackController = new TextEditingController();
  @override
  void initState() {
    initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    //todo 暂未实现
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('吐槽我们'),
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(children: [
          TextField(
              controller: _feedbackController,
              maxLength: 100,
              maxLines: 10,
              //是否自动更正
              autocorrect: true,
              //是否是密码
              style: TextStyle(fontSize: 16.0, color: Colors.black),
              onChanged: (e) {},
              onSubmitted: (text) {
                print("内容提交时回调");
              },
              decoration: InputDecoration(
                  counterText: "",
                  hintText: "请输入反馈意见（最多100字）",
                  hintStyle: TextStyle(color: Colors.grey),
                  suffixIconColor: Colors.grey,
                  border: InputBorder.none)),
          Divider(
            height: 1,
            color: Colors.grey[200],
          ),
          Padding(padding: EdgeInsets.only(top: 30)),
          Column(
            children: [
              RawMaterialButton(
                  constraints: BoxConstraints(minHeight: 44),
                  fillColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  ),
                  onPressed: () async {
                    if (_feedbackController.text == '') {
                      ToastUtils.showToast('请填写更多意见');
                      return;
                    }
                    await BService.userFeedbackAdd(_feedbackController.text);
                    ToastUtils.showToast('反馈成功');
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '提交',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )),
              Padding(padding: EdgeInsets.only(top: 20)),
            ],
          )
        ]),
      ),
    );
  }
}
