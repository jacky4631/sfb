/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';
import 'package:maixs_utils/widget/views.dart';
import 'package:device_info_plus/device_info_plus.dart';

import '../util/toast_utils.dart';
import '../service.dart';
import '../util/colors.dart';
import '../util/global.dart';
import '../util/login_util.dart';
import '../widget/custom_button.dart';

class LoginCode extends StatefulWidget {
  final Map data;
  const LoginCode(this.data, {Key? key,}) : super(key: key);

  @override
  _LoginCodeState createState() => _LoginCodeState();
}

class _LoginCodeState extends State<LoginCode> {
  TextEditingController _mobileController = new TextEditingController();
  Map phone = {"value": null, "verify": false};
  int inputLength = 0;

  bool checkboxSelected = false;
  bool skipCode = false;

  @override
  void initState() {
    initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    String code = await Global.getPrefsString(PREFS_INVITE_CODE)??'';
    _mobileController.text = code;
    refreshStatus(code);
    await initSkipCode();
  }
  refreshStatus(e) {
    setState(() {
      String trimTxt = e.replaceAll(' ', '');
      phone['value'] = trimTxt;
      phone['verify'] = Global.isPhone(trimTxt) || (trimTxt.length >=4&&trimTxt.length<=8);
    });
  }

  Future _bindCode() async {
    if (!phone['verify']) {
      return;
    }
    String code = _mobileController.text.toString().replaceAll(" ", "");
    Map res = await BService.userEdit({'code': code}, token: widget.data['token']);
    FocusScope.of(context).requestFocus(FocusNode());
    if(res['success']) {
      loginThenRoutingMe(context, widget.data);
    } else {
      ToastUtils.showToast(res['msg']);
    }
  }

  Future initSkipCode() async {
    //如果配置了全局可跳过 直接跳过
    skipCode = Global.homeUrl['skipCode'] != null && Global.homeUrl['skipCode'] == '1';

    //如果未配置跳过 校验是否是华为手机 是可跳过 因为华为不允许强制邀请码的app存在
    if(!skipCode) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      if(androidInfo != null && androidInfo.manufacturer != null) {
        skipCode = androidInfo.manufacturer.toLowerCase() == 'huawei';
      }
    }
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      brightness: Brightness.dark,
      bgColor: Colors.white,
      appBar: buildTitle(context,
          widgetColor: Colors.white, leftIcon: Icon(Icons.arrow_back)),
      body: Container(
          padding: EdgeInsets.only(left: 30, right: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.only(top: 30)),
              Text('请输入邀请信息',
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
                    refreshStatus(e);
                  },
                  onSubmitted: (text) {
                    print("内容提交时回调");
                  },
                  decoration: InputDecoration(
                      counterText: "",
                      hintText: "请输入邀请口令或者邀请人手机号",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
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
              PWidget.boxh(20),
              Column(
                children: [
                  CustomButton(onPressed: () {

                      _bindCode();

                  },showIcon: false,
                  text: '确认',
                      textColor: phone['verify']
                          ? Colors.white
                          : Colors.grey,
                  bgColor: phone['verify']
                      ? Colours.app_main
                      : Color(0xFFD6D6D6)),

                  Padding(padding: EdgeInsets.only(top: 20)),
                ],
              ),
              PWidget.boxh(20),
              if(skipCode)
                PWidget.textNormal('跳过填写>',[Colors.grey, 18], {'ct': true, 'fun':(){
                  loginThenRoutingMe(context, widget.data);
                }})
            ],
          )),
    );
  }
}
