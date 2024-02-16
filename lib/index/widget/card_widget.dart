import 'dart:async';

import 'package:flutter/material.dart';
import 'package:maixs_utils/model/data_model.dart';
import 'package:maixs_utils/widget/anima_switch_widget.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';

import '../../util/colors.dart';
import '../../util/paixs_fun.dart';

///热销榜和限时秒杀
class CardWidget extends StatefulWidget {
  final DataModel cardDm;
  final Function? fun;

  const CardWidget(this.cardDm, {Key? key, this.fun}) : super(key: key);
  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitchBuilder(
      value: widget.cardDm,
      errorOnTap: () => widget.fun!(),
      noDataView: PWidget.boxh(0),
      errorView: PWidget.boxh(0),
      initialState: PWidget.container(null, [double.infinity]),
      isAnimatedSize: false,
      defaultBuilder: () {
        var list = widget.cardDm.value;
        return PWidget.container(
          PWidget.row([
            PWidget.container(
              Stack(children: [
                PWidget.column([
                  PWidget.text('实时榜单', [Colors.black.withOpacity(0.75), 16, true]),
                  PWidget.boxh(8),
                  PWidget.row(
                    List.generate(list.length + 1, (i) {
                      if (i == 1) return PWidget.boxw(8);
                      if (i > 0) i = i - 1;
                      var mainPic = list[i]['mainPic'];
                      var actualPrice = list[i]['actualPrice'];
                      var twoHoursSalesStr = '';
                      var twoHoursSales = list[i]['twoHoursSales'] as int;
                      twoHoursSalesStr = '$twoHoursSales';
                      if (twoHoursSales >= 10000) twoHoursSalesStr = '${'$twoHoursSales'.substring(0, '$twoHoursSales'.length - 3)}万';
                      return itemView('${i + 1}', '${mainPic}_310x310', '2小时抢$twoHoursSalesStr', '¥$actualPrice');
                    }),
                  ),
                ]),
                PWidget.positioned(
                  PWidget.container(
                    PWidget.text('实时好货', [Colors.black45, 12]),
                    {'pd': PFun.lg(0, 0, 8, 8), 'br': 8},
                  ),
                  [4, null, null, 0],
                ),
              ]),
              [null, null, Colors.white],
              {'exp': true, 'br': 8, 'pd': 8, 'fun': () => Navigator.pushNamed(context, '/top')},
            ),
            PWidget.boxw(8),
            Builder(builder: (context) {
              List goodsList = [];
              List roundsList = [];
              if (widget.cardDm.object.isNotEmpty) {
                goodsList = widget.cardDm.object['goodsList'] as List;
                if(goodsList.length > 2) {
                  goodsList = goodsList.sublist(0, 2);
                }
                roundsList = widget.cardDm.object['roundsList'] as List;
              }
              return PWidget.container(
                Stack(children: [
                  PWidget.column([
                    PWidget.text('限时秒杀', [Colors.black.withOpacity(0.75), 16, true]),
                    PWidget.boxh(8),
                    if (goodsList.isNotEmpty)
                      PWidget.row(
                        List.generate(goodsList.length + 1, (i) {
                          if (i == 1) return PWidget.boxw(8);
                          if (i > 0) i = i - 1;
                          var mainPic = goodsList[i]['mainPic'];
                          var specialText = (goodsList[i]['specialText'] ?? []) as List;
                          var actualPrice = goodsList[i]['actualPrice'];
                          return itemView('${i + 1}', '${mainPic}_310x310', '${specialText.join('')}', '¥$actualPrice', rexiao: false);
                        }),
                      ),
                  ]),
                  PWidget.positioned(
                    Builder(builder: (context) {
                      var first = roundsList.where((w) => w['status'] == 2).first;
                      return CardCountDownWidget(DateTime.parse(first['ddqTime']), fun: () {});
                    }),
                    [4, null, null, 0],
                  ),
                ]),
                [null, null, Colors.white],
                {'exp': true, 'br': 8, 'pd': 8, 'fun': () => Navigator.pushNamed(context, '/ddq')},
              );
            }),
          ]),
          {'pd': [0,16,8,8]},
        );
      },
    );
  }

  Widget itemView(i, img, text, value, {gd, bool rexiao = true}) {
    return PWidget.column([
      PWidget.container(
        Stack(children: [
          PWidget.wrapperImage(img, {'ar': 1 / 1, 'br': 8}),
        ]),
        {'crr': 6},
      ),
      PWidget.container(
        PWidget.text(text, [Colors.black45, 10], {'ct': true}),
        [double.infinity, null, if (!rexiao) Colors.white],
        {
          'pd': PFun.lg(2, 2),
          'br': 24,
        },
      ),
      PWidget.boxh(4),
      PWidget.text(value, [Colours.app_main, 16, true], {'ct': true}),
    ], {
      'exp': 1
    });
  }
}

///限时秒杀倒计时
class CardCountDownWidget extends StatefulWidget {
  final DateTime dateTime;
  final Function fun;

  const CardCountDownWidget(this.dateTime, {Key? key, required this.fun}) : super(key: key);
  @override
  _CardCountDownWidgetState createState() => _CardCountDownWidgetState();
}

class _CardCountDownWidgetState extends State<CardCountDownWidget> {
  late Timer timer;

  Duration duration = const Duration();

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      duration = widget.dateTime.difference(DateTime.now());
      if (duration.inSeconds <= 0) {
        timer.cancel();
        widget.fun();
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var timeStr = '${DateTime.now().hour}点场';
    return PWidget.container(
      PWidget.text('$timeStr${'$duration'.split('.').first}', [Colors.black45, 12]),
      {'pd': PFun.lg(0, 0, 6, 6), 'br': 8},
    );
  }
}
