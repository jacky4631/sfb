import 'package:flutter/material.dart';
import 'package:sufenbao/service.dart';
import 'package:sufenbao/util/global.dart';

import '../util/login_util.dart';

///空白页面 用户web端的微信登录
class BlankPage extends StatefulWidget {
  final Map? data;

  const BlankPage(this.data, {Key? key}) : super(key: key);

  @override
  _BlankPageState createState() => _BlankPageState();
}

class _BlankPageState extends State<BlankPage> {
  @override
  void initState() {
    initData();
    super.initState();
  }
  
  Future wechatAppLogin(code) async {
    var data = await BService.wechatLogin(code);
    if(data['data']['openId'] != null) {
      Navigator.pushNamed(context, "/loginSecond", arguments: data['data']);
    } else {
      afterLogin(data, context, redirectUrl: widget.data!['prePage']);
    }
  }
  
  ///初始化函数
  Future initData() async {
    if(Global.isWeb()) {
      // String baseUrl = window.location.href;
      String baseUrl = '';

      var url = Uri.dataFromString(baseUrl);

      var qp = url.queryParameters;

      var code = qp['code'];

      //login
      await wechatAppLogin(code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            // 空白页面内容
          ],
        ),
      ),
    );
  }
}
