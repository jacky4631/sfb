/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';
import 'package:maixs_utils/widget/views.dart';
import 'package:sufenbao/util/toast_utils.dart';

import '../service.dart';

///修改邀请口令
class SpreadPage extends StatefulWidget {
  @override
  _SpreadPage createState() => _SpreadPage();
}

class _SpreadPage extends State<SpreadPage> {
  TextEditingController _spreadController = new TextEditingController();
  @override
  void initState() {
    initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {}
  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
        brightness: Brightness.dark,
        bgColor: Colors.white,
        appBar: buildTitle(context,
            title: '绑定邀请口令',
            widgetColor: Colors.black,
            leftIcon: Icon(Icons.arrow_back_ios)),
        body: PWidget.container(PWidget.ccolumn([
          TextField(
              controller: _spreadController,
              maxLength: 30,
              maxLines: 1,
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
                  hintText: "请输入邀请口令或者邀请人手机号",
                  hintStyle: TextStyle(color: Colors.grey),
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
                    if(_spreadController.text == '') {
                      ToastUtils.showToast('邀请口令不能为空');
                      return;
                    }
                    modifySpread();
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
  Future modifySpread() async{
    Map data = await BService.userEdit({'code': _spreadController.text});
    FocusScope.of(context).requestFocus(FocusNode());
    if(data['success']) {
      ToastUtils.showToast('绑定成功');
      Navigator.pop(context, _spreadController.text);
    } else {
      ToastUtils.showToast(data['msg']);
    }

  }
}
