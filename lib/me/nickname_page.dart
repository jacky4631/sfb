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

///修改昵称
class NicknamePage extends StatefulWidget {
  @override
  _NicknamePage createState() => _NicknamePage();
}

class _NicknamePage extends State<NicknamePage> {
  TextEditingController _nicknameController = new TextEditingController();
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
            title: '修改昵称',
            widgetColor: Colors.black,
            leftIcon: Icon(Icons.arrow_back_ios)),
        body: PWidget.container(PWidget.ccolumn([
          TextField(
              controller: _nicknameController,
              maxLength: 8,
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
                  hintText: "请输入昵称（最多8字）",
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
                    if(_nicknameController.text == '') {
                      ToastUtils.showToast('昵称不能为空');
                      return;
                    }
                    modifyNickname();
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
  Future modifyNickname() async{
    Map data = await BService.userEdit({'nickname': _nicknameController.text});
    FocusScope.of(context).requestFocus(FocusNode());
    if (data['success']) {
      ToastUtils.showToast('修改成功');
      Navigator.pop(context, true);
    } else {
      ToastUtils.showToast('修改失败');
    }

  }
}
