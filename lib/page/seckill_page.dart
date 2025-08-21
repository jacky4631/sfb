/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:maixs_utils/model/data_model.dart';
import 'package:maixs_utils/util/utils.dart';
import 'package:maixs_utils/widget/anima_switch_widget.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';
import 'package:maixs_utils/widget/views.dart';
import 'package:sufenbao/page/product_details.dart';
import 'package:sufenbao/service.dart';
import 'package:sufenbao/widget/CustomWidgetPage.dart';

import '../util/colors.dart';
import '../util/global.dart';
import '../util/paixs_fun.dart';
import '../util/toast_utils.dart';

///咚咚抢 秒杀页面
class SeckillPage extends StatefulWidget {
  @override
  _SeckillPageState createState() => _SeckillPageState();
}

class _SeckillPageState extends State<SeckillPage> {
  var roundTime;

  var seleRounds = {};

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    await this.getCardData(true);
  }

  ///卡片数据
  var cardDm = DataModel<Map>(object: {});
  Future<int> getCardData(isFirst) async {
    var res = await BService.ddq(roundTime);
    if (res != null) {
      cardDm.addObject(res['data']);
      var roundsList = (cardDm.object?['roundsList'] ?? []) as List;
      var first = roundsList.where((w) => w['status'] == 1).toList().first;
      // flog(first, '哈哈哈');
      if (first != null && first != '' && isFirst) roundTime = first['ddqTime'];
    } else {
      cardDm.toError('网络异常');
    }
    setState(() {});
    return cardDm.flag;
  }

  @override
  Widget build(BuildContext context) {
    final goodsList = ValueUtil.toList(cardDm.object?['goodsList']);

    return ScaffoldWidget(
      brightness: Brightness.light,
      body: Stack(children: [
        ListView(
          children: [
            Image.asset('assets/images/mall/ms_bg.png',
                width: double.infinity, fit: BoxFit.cover, alignment: Alignment.topCenter),
            PWidget.container(
              AnimatedSwitchBuilder(
                value: cardDm,
                errorOnTap: () => this.getCardData(true),
                errorView: PWidget.boxh(0),
                noDataView: PWidget.boxh(0),
                initialState: PWidget.container(null, [double.infinity]),
                isAnimatedSize: false,
                objectBuilder: (v) {
                  Map map = v! as Map;
                  var roundsList = map['roundsList'] as List;

                  return PWidget.row(
                    List.generate(roundsList.length, (i) {
                      var rounds = roundsList[i];
                      // flog(roundTime, '哈哈哈');
                      var isDy = '${rounds['ddqTime']}' == roundTime;
                      // flog(rounds['ddqTime'], '哈哈哈');
                      // flog(isDy, '哈哈哈');
                      // flog(rounds['ddqTime']);
                      // flog(roundTimeStr, 'roundTimeStr');
                      var ddqTime = DateTime.parse(rounds['ddqTime']);
                      var list = ddqTime.toString().split(' ').last.split(':');
                      list.removeLast();
                      return PWidget.container(
                        PWidget.ccolumn([
                          PWidget.text(
                            '${list.join(':')}',
                            [isDy ? Colours.app_main : Colors.black.withOpacity(0.75), 16, true],
                          ),
                          PWidget.spacer(),
                          PWidget.container(
                            PWidget.text(
                              '${['已开抢', '疯抢中', '即将开始'][rounds['status']]}',
                              [isDy ? Colors.white : Colors.black.withOpacity(0.6)],
                            ),
                            [double.infinity],
                            {
                              'ali': PFun.lg(0, 0),
                              'pd': PFun.lg(2, 2),
                              'br': 56,
                              'gd': PFun.cl2crGd(Colours.app_main.withOpacity(isDy ? 1 : 0),
                                  Colours.app_main.withOpacity(isDy ? 1 : 0)),
                            },
                          ),
                          PWidget.spacer(),
                        ]),
                        [75, 56],
                        {
                          'fun': () {
                            seleRounds = rounds;
                            roundTime = rounds['ddqTime'];
                            this.getCardData(false);
                            // flog(ddqTime);
                          },
                        },
                      );
                    }),
                    {'pd': 8},
                  );
                },
              ),
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: goodsList.length,
                itemBuilder: (BuildContext context, int index) {
                  if (seleRounds['status'] == 2) {
                    return createItem(index);
                  }
                  var data = goodsList[index];
                  return Global.openFadeContainer(createItem(index), ProductDetails(data));
                })
          ],
        ),
        titleBar(),
      ]),
    );
  }

  void notStart() {
    ToastUtils.showToast('活动未开始');
  }

  Widget createItem(i) {
    var data = ((cardDm.object?['goodsList'] ?? []) as List)[i];
    var mainPic = data['mainPic'];
    var detailFun = (seleRounds['status'] == 2 ? notStart : null);
    var sales = BService.formatNum(data['monthSales']);
    return PWidget.container(
      PWidget.row(
        [
          PWidget.wrapperImage('${mainPic}_310x310', [124, 124], {'br': 8}),
          PWidget.boxw(8),
          PWidget.column([
            PWidget.row([getTitleWidget(data['dtitle'])]),
            PWidget.spacer(),
            getLabelWidget(((data['specialText']) as List).join(), textSize: 12),
            PWidget.spacer(),
            getPriceWidget(data['actualPrice'], data['originalPrice']),
            PWidget.spacer(),
            PWidget.row(
              [
                getSalesWidget(sales),
                PWidget.spacer(),
                Builder(builder: (context) {
                  var isNotStarted = seleRounds['status'] == 2;
                  return PWidget.container(
                    PWidget.text(isNotStarted ? '即将开始' : '马上抢', [Colors.white, 14, true]),
                    [null, null],
                    {
                      'ali': PFun.lg(0, 0),
                      'br': 6,
                      'pd': PFun.lg(4, 4, 16, 16),
                      'sd': PFun.sdLg(isNotStarted ? Color(0xff6DAE5F) : Colours.app_main),
                      if (isNotStarted) 'gd': PFun.cl2crGd(Color(0xff6DAE5F), Color(0xff6DAE5F)),
                      if (!isNotStarted) 'gd': PFun.cl2crGd(Colours.app_main, Colours.app_main),
                    },
                  );
                }),
              ],
            ),
          ], {
            'exp': 1
          }),
        ],
        '001',
        {'fill': true},
      ),
      [null, null, Colors.white],
      {'mg': PFun.lg(0, 10), 'pd': 8, 'br': 8, 'fun': detailFun},
    );
  }

  Widget titleBar() {
    return Stack(
      children: [
        Image.asset(
          'assets/images/mall/ms_bg.png',
          width: double.infinity,
          height: 50 + pmPadd.top,
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),
        PWidget.container(
          PWidget.row([
            PWidget.container(
                PWidget.icon(Icons.arrow_back_ios_new_rounded, [Colors.white, 20]), [32, 32], {'fun': () => close()}),
            PWidget.spacer(),
            PWidget.image('assets/images/mall/ms_logo.png', [71, 24]),
            PWidget.spacer(),
            PWidget.container(null, [32, 32]),
          ]),
          [null, 50 + pmPadd.top],
          {'pd': PFun.lg(pmPadd.top + 8, 8, 16, 16)},
        ),
      ],
    );
  }
}
