import 'package:flutter/material.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';
import 'package:maixs_utils/widget/views.dart';
import 'package:sufenbao/util/global.dart';

import '../service.dart';
import '../util/paixs_fun.dart';
import '../widget/loading.dart';

///美团外卖红包
class MeiTuanPage extends StatefulWidget {
  final Map? data;

  const MeiTuanPage(this.data, {Key? key}) : super(key: key);

  @override
  _AliRedPageState createState() => _AliRedPageState();
}

class _AliRedPageState extends State<MeiTuanPage> {
  List data = [];
  @override
  void initState() {
    initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    var res = await BService.mtActivityList();
    if (res != null) {
      data = res['content'];
    };
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      brightness: Brightness.dark,
      appBar: buildTitle(context,
          title: '美团外卖红包',
          widgetColor: Colors.black,
          leftIcon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          )),
      body: Stack(
        children: [
          PWidget.container(null, [double.infinity, double.infinity],
              {'gd': PFun.tbGd(Color(0xFFFEE5D2), Color(0xFFFED9BB))}),
          ScaffoldWidget(
            bgColor: Colors.transparent,
            body: Stack(children: [
              ListView.builder(
                itemCount: data.length,
                itemBuilder: (_, index) {
                  var activity = data[index];
                  var image = activity['img'];
                  var imageRatio = 69/22;
                  return PWidget.container(
                      PWidget.stack([
                        PWidget.wrapperImage(
                            image,
                            {'ar': imageRatio,'br':10,
                              'fun':() async{
                                Loading.show(context);
                                var res = await BService.mtActivityWord(activity['activityId']);
                                Loading.hide(context);
                                Global.launchMeituanWechat(context, url: res['miniProgramPath']);
                              }
                            }),
                        PWidget.positioned(
                          PWidget.row([
                            PWidget.image(
                                'assets/images/share/wx.png', [12, 12]),
                            PWidget.boxw(5),
                            PWidget.text('微信小程序', [Colors.white, 12, true]),
                      ]),
                          [null, 5, 5, null],
                        ),
                      ]),{'pd':15,'br':10}
                  );
                },
              )
            ]),
          )
        ],
      ),
    );
  }
}
