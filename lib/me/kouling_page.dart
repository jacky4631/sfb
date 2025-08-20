/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:sufenbao/util/colors.dart';

import '../util/global.dart';
import '../util/toast_utils.dart';
import '../service.dart';
import 'listener/PersonalNotifier.dart';
import 'model/userinfo.dart';

///修改专属口令
class KoulingPage extends StatefulWidget {
  final Map data;
  const KoulingPage(this.data, {Key? key,}) : super(key: key);

  @override
  _KoulingPage createState() => _KoulingPage();
}

class _KoulingPage extends State<KoulingPage> {
  TextEditingController _textController = new TextEditingController();
  int fans = 0;
  int canChanged = 0;
  @override
  void initState() {
    initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    var userinfo = await BService.userinfo();
    Global.userinfo = Userinfo.fromJson(userinfo);
    setState(() {
      fans = Global.userinfo!.spreadCount;
      canChanged = userinfo['canChangeCode'];
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('申请专属口令'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Text('邀请口令的作用', style: TextStyle(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.bold)),
              Text('1.邀请口令可用于好友下载APP注册后绑定', style: TextStyle(color: Colors.black54, fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
              Text('2.好友通过您的邀请口令绑定后，将成为您的用户', style: TextStyle(color: Colors.black54, fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
              SizedBox(height: 10),
              Text('敏感词的说明', style: TextStyle(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.bold)),
              Text('1.不可申请带有政治、情色、赌博等违规的邀请口令', style: TextStyle(color: Colors.black54, fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
              Text('2.不可申请带有$APP_NAME官方名义的邀请口令', style: TextStyle(color: Colors.black54, fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
              SizedBox(height: 10),
              Text('专属口令申请/修改条件', style: TextStyle(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.bold)),
              Text('1.邀请人数≥2人时，可修改一次专属口令', style: TextStyle(color: Colors.black54, fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
              Text('2.邀请人数≥20且有效下单人数≥10人，可修改一次专属口令', style: TextStyle(color: Colors.black54, fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
              Text('2.邀请人数≥200且有效下单人数≥100人，可修改一次专属口令', style: TextStyle(color: Colors.black54, fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
              SizedBox(height: 10),
              Text('三次修改机会使用完毕，将不允许用户修改专属口令，请谨慎设置', style: TextStyle(color: Colors.black54, fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
              SizedBox(height: 30),
              Row(
                children: [
                  Expanded(flex: 2, child: Text('当前邀请人数', style: TextStyle(color: Colors.black54, fontSize: 12))),
                  Expanded(flex: 2, child: Text('$fans', style: TextStyle(color: Colors.red, fontSize: 12))),
                  Expanded(flex: 1, child: Text('人', style: TextStyle(color: Colors.black54, fontSize: 12))),
                ],
              ),
              SizedBox(height: 10),
              // createTextField(),
              canChanged ==1 ? createTextField() : SizedBox(),
              canChanged ==1 ? SizedBox(height: 10) : SizedBox(),
              Column(
                children: [
                  RawMaterialButton(
                      constraints: BoxConstraints(minHeight: 45),
                      fillColor: canChanged == 1 ? Colours.app_main : Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      ),
                      onPressed: canChanged == 1 ? () {
                        modifyPhone();
                      } : null,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              canChanged==1 ? '确定' : '不符合修改条件',
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
        ));
  }
  Widget createTextField() {
    return TextField(
        controller: _textController,
        maxLength: 8,
        maxLines: 1,
        //是否自动更正
        autocorrect: true,
        //是否是密码
        style: TextStyle(fontSize: 16.0, color: Colors.black),
        onChanged: (e) {
          setState(() {
          });
        },
        onSubmitted: (text) {
          print("内容提交时回调");
        },
        decoration: InputDecoration(
            counterText: "",
            hintText: "请输入专属口令，4-8位，可以输入中文哦",
            hintStyle: TextStyle(color: Colors.grey),
            suffixIcon:
            _textController.text == ''
                ? new SizedBox()
                : IconButton(
                onPressed: () {
                  setState(() {
                    _textController.clear();
                  });
                },
                icon: Icon(
                  Icons.dangerous_outlined,
                  color: Colors.grey,
                )),
            suffixIconColor: Colors.grey,
            border: InputBorder.none));
  }

  Future modifyPhone() async{
    //todo 校验位数
    Map data = await BService.userEdit({'changedCode': _textController.text.trim()});
    FocusScope.of(context).requestFocus(FocusNode());
    if (data['success']) {
      ToastUtils.showToast('修改成功');
      personalNotifier.value = true;
      Navigator.pop(context, _textController.text.trim());
    } else {
      ToastUtils.showToast(data['msg']);
    }
  }
}
