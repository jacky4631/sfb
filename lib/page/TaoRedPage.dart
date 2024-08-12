import 'package:flutter/material.dart';
import 'package:maixs_utils/util/utils.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';
import 'package:maixs_utils/widget/views.dart';

import '../util/global.dart';
import '../util/launchApp.dart';
import '../util/paixs_fun.dart';

///淘宝看视频领红包
class TaoRedPage extends StatefulWidget {
  final Map? data;

  const TaoRedPage(this.data, {Key? key}) : super(key: key);

  @override
  _TaoRedPageState createState() => _TaoRedPageState();
}

class _TaoRedPageState extends State<TaoRedPage> {
  @override
  void initState() {
    initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      body: Stack(
        children: [
          PWidget.container(null, [double.infinity, double.infinity],
              {'gd': PFun.tbGd(Color(0xFFE95B4F), Color(0xFFDF462F))}),
          PWidget.column([
            PWidget.boxh(100),
            PWidget.wrapperImage('https://shengqianapp.oss-cn-shanghai.aliyuncs.com/sfb/menu/tbhb1.jpg',
                {'ar': 750 / 1029}),
            PWidget.stack([
              PWidget.wrapperImage('https://shengqianapp.oss-cn-shanghai.aliyuncs.com/sfb/menu/tbhb2.jpg',
                  {'ar': 750 / 123}),
              PWidget.textNormal('67💲I7udWmNlxLd₴ ${Global.appInfo.taored}  CZ0002 最少0.3元，至高2500元！帮我助力，你也可以领~'
              ,[Colors.white], {'max':3, 'pd':[4, 2, 32, 24]})
            ]),
            
            PWidget.wrapperImage('https://shengqianapp.oss-cn-shanghai.aliyuncs.com/sfb/menu/tbhb4.jpg',
                {'ar': 750 / 146, 'fun':(){
                  LaunchApp.launchTb(context, Global.appInfo.taored);
                }}),
          ]),

          titleBarView(),
        ],
      ),
    );
  }

  ///标题栏视图
  Widget titleBarView() {
    return PWidget.container(
      PWidget.row([
        PWidget.container(
          PWidget.icon(Icons.keyboard_arrow_left_rounded, [Colors.white]),
          [36, 36, Colors.black26],
          {'br': 56, 'fun': () => close()},
        ),
      ]),
      [null, 56 + pmPadd.top],
      {'pd': PFun.lg(pmPadd.top + 8, 8, 16, 16)},
    );
  }
}
