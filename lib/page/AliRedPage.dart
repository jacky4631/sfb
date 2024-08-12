/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:maixs_utils/util/utils.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';
import 'package:maixs_utils/widget/views.dart';
import 'package:sufenbao/util/global.dart';

import '../util/toast_utils.dart';
import '../util/paixs_fun.dart';

///支付宝红包
class AliRedPage extends StatefulWidget {
  final Map? data;

  const AliRedPage(this.data, {Key? key}) : super(key: key);

  @override
  _AliRedPageState createState() => _AliRedPageState();
}

class _AliRedPageState extends State<AliRedPage> {
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
              {'gd': PFun.tbGd(Color(0xFF7AB4FE), Color(0xFF7AB4FE))}),
          PWidget.wrapperImage('https://shengqianapp.oss-cn-shanghai.aliyuncs.com/sfb/menu/alired.jpg', {'ar': 3 / 4}),

          titleBarView(),
          PWidget.positioned(
            PWidget.container(
              PWidget.text('复制 ${Global.appInfo.alired} 打开支付宝去搜索，红包拿来，实惠优享', [Colors.white, 12],{'max':2},),
              [200, 60, Colors.transparent],
              {},
            ),
            [360, null, 110, 110],
          ),
          btmBarView()

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
  ///底部操作栏
  Widget btmBarView() {
    return PWidget.positioned(
      PWidget.container(
        PWidget.wrapperImage('https://shengqianapp.oss-cn-shanghai.aliyuncs.com/sfb/menu/aliredbtn.jpg',
            {'ar': 460 / 95, 'br':40}),

        // PWidget.text('复制口令，支付宝搜索领红包', [Color(0xFF7AB4FE), 14, true], {'ct': true}),
        {'pd': [8,MediaQuery.of(context).padding.bottom+8,70,70],
          'fun': () => {
          FlutterClipboard.copy(Global.appInfo.alired).then(
                  (value){
                    ToastUtils.showToast('复制成功', bgColor: Color(0xFF4283D5));
        }

          )
        }},
      ),
      [500, null, 0, 0],
    );
  }
}
