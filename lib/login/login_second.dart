/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';


import '../util/colors.dart';
import '../util/global.dart';
import '../dialog/simple_privacy_dialog.dart';
import '../httpUrl.dart';
import '../widget/custom_button.dart';

class LoginSecond extends StatefulWidget {
  final Map data;
  const LoginSecond(this.data, {Key? key,}) : super(key: key);

  @override
  _LoginSecondState createState() => _LoginSecondState();
}

class _LoginSecondState extends State<LoginSecond> {
  TextEditingController _mobileController = new TextEditingController();
  Map phone = {"value": null, "verify": false};
  int inputLength = 0;

  bool checkboxSelected = false;

  @override
  void initState() {
    initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
  }

  void _splitPhoneNumber(String text) {
    if (text.length > inputLength) {
      //输入
      if (text.length == 4 || text.length == 9) {
        text = text.substring(0, text.length - 1) +
            " " +
            text.substring(text.length - 1, text.length);
        _mobileController.text = text;
        _mobileController.selection = TextSelection.fromPosition(TextPosition(
            affinity: TextAffinity.downstream, offset: text.length)); //光标移到最后
      }
    } else {
      //删除
      if (text.length == 4 || text.length == 9) {
        text = text.substring(0, text.length - 1);
        _mobileController.text = text;
        _mobileController.selection = TextSelection.fromPosition(TextPosition(
            affinity: TextAffinity.downstream, offset: text.length)); //光标移到最后
      }
    }
    inputLength = text.length;
  }

  void _sendSms() {
    if (!phone['verify']) {
      return;
    }
    String mobile = _mobileController.text.toString().replaceAll(" ", "");
    suClient.post(API.sendSms, data: {'phone': mobile}).then((res) {
      print(res);
    }).catchError((err) {
      print(err);
    });
    String? openId = widget.data['openId'];
    Navigator.pushNamed(context, "/loginThird",
        arguments: {'mobile': _mobileController.text.toString(), 'openId': openId});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
          padding: EdgeInsets.only(left: 30, right: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.only(top: 30)),
              Text('请输入手机号',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 24,
                  )),
              Padding(padding: EdgeInsets.only(top: 30)),
              TextField(
                  controller: _mobileController,
                  maxLength: 13,
                  maxLines: 1,
                  //是否自动更正
                  autocorrect: true,
                  //是否是密码
                  style: TextStyle(fontSize: 20.0, color: Colors.black),
                  onChanged: (e) {
                    //长度变化
                    setState(() {
                      print(e);
                      phone['value'] = e;
                      phone['verify'] = Global.isPhone(e.replaceAll(' ', ''));
                    });
                    _splitPhoneNumber(e);
                  },
                  onSubmitted: (text) {
                    print("内容提交时回调");
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      counterText: "",
                      hintText: "请输入手机号",
                      hintStyle: TextStyle(color: Colors.grey),
                      suffixIcon:
                          (phone['value'] == null || phone['value'] == '')
                              ? new SizedBox()
                              : IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _mobileController.clear();
                                      phone['value'] = null;
                                      phone['verify'] = false;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.dangerous_outlined,
                                    color: Colors.grey,
                                  )),
                      suffixIconColor: Colors.grey,
                      border: InputBorder.none)),
              Divider(),
              SizedBox(height: 20),
              createPrivacyContent(),
              SizedBox(height: 10),
              Column(
                children: [
                  CustomButton(onPressed: () {
                    if(checkboxSelected) {
                      _sendSms();
                    } else {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.noHeader,
                        body: SimplePrivacyDialog(),
                        // btnCancelOnPress: () {},
                        // btnOkOnPress: () {},
                      )..show().then((value) {
                        if (value) {
                          checkboxSelected = true;
                          setState(() {});
                          _sendSms();
                        }
                      });
                    }
                  },showIcon: false,
                  text: '获取验证码',
                      textColor: phone['verify']
                          ? Colors.black
                          : Colors.grey,
                  bgColor: phone['verify']
                      ? Color(0xFFFDD835)
                      : Color(0xFFD6D6D6)),

                  Padding(padding: EdgeInsets.only(top: 20)),
                ],
              )
            ],
          )),
    );
  }

  createPrivacyContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center ,
      children: [
        Checkbox(
          value: checkboxSelected,
          onChanged: (value) {
            checkboxSelected = !checkboxSelected;
            setState(() {});
          },
          shape: CircleBorder(),
          activeColor: Colours.app_main,
        ),
        Expanded(
            child: RichText(
                text: TextSpan(
          text: '我已阅读并同意',
          style: TextStyle(color: Colors.black, fontSize: 12),
          children: [
            TextSpan(
              text: '《用户服务协议》',
              style: TextStyle(color: Colours.app_main),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Global.showProtocolPage(Global.userUrl,'用户服务协议');
                },
            ),
            TextSpan(
              text: '和',
              style: TextStyle(color: Colors.black),
            ),
            TextSpan(
              text: '《$APP_NAME隐私政策》',
              style: TextStyle(color: Colours.app_main),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Global.showProtocolPage(Global.privacyUrl,'$APP_NAME隐私政策');
                },
            ),
          ],
        )))
      ],
    );
  }
}
