/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';
import 'package:maixs_utils/widget/views.dart';
import 'package:sufenbao/service.dart';

import '../../util/global.dart';
import '../../util/toast_utils.dart';

///修改手机号
class PhonePage extends StatefulWidget {
  final Map data;
  const PhonePage(this.data, {Key? key,}) : super(key: key);

  @override
  _PhonePage createState() => _PhonePage();
}

class _PhonePage extends State<PhonePage> {
  TextEditingController _mobileController = new TextEditingController();
  Map phone = {"value": null, "verify": false};
  int inputLength = 0;

  @override
  void initState() {
    initData();
    super.initState();
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

  ///初始化函数
  Future initData() async {}
  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
        brightness: Brightness.dark,
        bgColor: Colors.white,
        appBar: buildTitle(context,
            title: '修改手机号',
            widgetColor: Colors.black,
            leftIcon: Icon(Icons.arrow_back_ios)),
        body: PWidget.container(PWidget.ccolumn([
          TextField(
              controller: _mobileController,
              maxLength: 13,
              maxLines: 1,
              //是否自动更正
              autocorrect: true,
              //是否是密码
              style: TextStyle(fontSize: 16.0, color: Colors.black),
              onChanged: (e) {
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
          Padding(padding: EdgeInsets.only(top: 30)),
          Column(
            children: [
              RawMaterialButton(
                  constraints: BoxConstraints(minHeight: 44),
                  fillColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  ),
                  onPressed: () {
                    if(_mobileController.text == '') {
                      ToastUtils.showToast('手机号不能为空');
                      return;
                    }
                    modifyPhone();
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '确定',
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
        ], [], {
          'pd': 15
        })));
  }
  Future modifyPhone() async{
    String mobile = _mobileController.text.toString().replaceAll(" ", "");
    bool isPhone = Global.isPhone(mobile);
    if(!isPhone) {
      ToastUtils.showToast('手机号不正确');
      return;
    }
    Map res = await BService.modifyPhone(mobile);
    if(res['success']) {
      Navigator.pushNamed(context, "/phoneCodePage",
          arguments: {'mobile': _mobileController.text.toString()});
    } else {
      ToastUtils.showToast(res['msg']);
    }

  }
}
