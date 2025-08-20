/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';

import '../util/toast_utils.dart';
import '../service.dart';

///修改姓名
class RealNamePage extends StatefulWidget {
  @override
  _NIcknamePage createState() => _NIcknamePage();
}

class _NIcknamePage extends State<RealNamePage> {
  TextEditingController _realNameController = new TextEditingController();
  @override
  void initState() {
    initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('修改姓名'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            TextField(
                controller: _realNameController,
                maxLength: 20,
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
                    hintText: "请输入真实姓名，姓名错误无法正常提现",
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
                      if (_realNameController.text == '') {
                        ToastUtils.showToast('姓名不能为空');
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
          ],
        ),
      ),
    );
  }

  Future modifyNickname() async {
    Map data = await BService.userEdit({'realName': _realNameController.text});
    FocusScope.of(context).requestFocus(FocusNode());
    if (data['success']) {
      ToastUtils.showToast('修改成功');
      Navigator.pop(context, _realNameController.text);
    } else {
      ToastUtils.showToast('修改失败');
    }
  }
}
