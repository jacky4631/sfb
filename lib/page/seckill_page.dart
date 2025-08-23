/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sufenbao/page/product_details.dart';
import 'package:sufenbao/service.dart';
import 'package:sufenbao/widget/CustomWidgetPage.dart';

import '../util/colors.dart';
import '../util/global.dart';
import '../util/toast_utils.dart';

class SimpleDataModel<T> {
  T? object;
  int flag = 0;
  String error = '';

  SimpleDataModel({this.object});

  void addObject(T data) {
    object = data;
    flag = 1;
  }

  void toError(String errorMsg) {
    error = errorMsg;
    flag = -1;
  }
}

class SimpleAnimatedSwitchBuilder<T> extends StatelessWidget {
  final SimpleDataModel<T> value;
  final VoidCallback? errorOnTap;
  final Widget errorView;
  final Widget noDataView;
  final Widget initialState;
  final Widget Function(T? v) objectBuilder;

  const SimpleAnimatedSwitchBuilder({
    Key? key,
    required this.value,
    this.errorOnTap,
    required this.errorView,
    required this.noDataView,
    required this.initialState,
    required this.objectBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (value.flag == -1) {
      return GestureDetector(
        onTap: errorOnTap,
        child: errorView,
      );
    }

    if (value.object == null) {
      return noDataView;
    }

    return objectBuilder(value.object);
  }
}

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
  var cardDm = SimpleDataModel<Map>(object: {});
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

  EdgeInsets get pmPadd => MediaQuery.of(context).padding;

  @override
  Widget build(BuildContext context) {
    final goodsList = (cardDm.object?['goodsList'] as List?) ?? [];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: Stack(children: [
          ListView(
            children: [
              Image.asset('assets/images/mall/ms_bg.png',
                  width: double.infinity, fit: BoxFit.cover, alignment: Alignment.topCenter),
              Container(
                child: SimpleAnimatedSwitchBuilder(
                  value: cardDm,
                  errorOnTap: () => this.getCardData(true),
                  errorView: SizedBox(height: 0),
                  noDataView: SizedBox(height: 0),
                  initialState: Container(width: double.infinity),
                  objectBuilder: (v) {
                    Map map = v!;
                    var roundsList = map['roundsList'] as List;

                    return Container(
                        padding: EdgeInsets.all(8),
                        height: 80,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            // shrinkWrap: true,
                            // physics: NeverScrollableScrollPhysics(),
                            itemCount: roundsList.length,
                            itemBuilder: (BuildContext context, int index) {
                              var rounds = roundsList[index];
                              var isDy = '${rounds['ddqTime']}' == roundTime;
                              var ddqTime = DateTime.parse(rounds['ddqTime']);
                              var list = ddqTime.toString().split(' ').last.split(':');
                              list.removeLast();
                              return GestureDetector(
                                onTap: () {
                                  seleRounds = rounds;
                                  roundTime = rounds['ddqTime'];
                                  this.getCardData(false);
                                },
                                child: Container(
                                  width: 75,
                                  height: 56,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${list.join(':')}',
                                        style: TextStyle(
                                          color: isDy ? Colours.app_main : Colors.black.withValues(alpha: 0.75),
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Spacer(),
                                      Container(
                                        width: double.infinity,
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.symmetric(vertical: 2),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(56),
                                          gradient: LinearGradient(
                                            colors: [
                                              Colours.app_main.withValues(alpha: isDy ? 1 : 0),
                                              Colours.app_main.withValues(alpha: isDy ? 1 : 0),
                                            ],
                                          ),
                                        ),
                                        child: Text(
                                          '${['已开抢', '疯抢中', '即将开始'][rounds['status']]}',
                                          style: TextStyle(
                                            color: isDy ? Colors.white : Colors.black.withValues(alpha: 0.6),
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                ),
                              );
                            }));
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
      ),
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
    return GestureDetector(
      onTap: detailFun,
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  '${mainPic}_310x310',
                  width: 124,
                  height: 124,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 124,
                      height: 124,
                      color: Colors.grey[200],
                      child: Icon(Icons.image_not_supported, color: Colors.grey),
                    );
                  },
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row(children: [getTitleWidget(data['dtitle'])]),
                    getTitleWidget(data['dtitle']),
                    getLabelWidget(((data['specialText']) as List).join(), textSize: 12),
                    Spacer(),
                    getPriceWidget(data['actualPrice'], data['originalPrice']),
                    Spacer(),
                    Row(
                      children: [
                        getSalesWidget(sales),
                        Spacer(),
                        Builder(builder: (context) {
                          var isNotStarted = seleRounds['status'] == 2;
                          return Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              gradient: LinearGradient(
                                colors: [
                                  isNotStarted ? Color(0xff6DAE5F) : Colours.app_main,
                                  isNotStarted ? Color(0xff6DAE5F) : Colours.app_main,
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: (isNotStarted ? Color(0xff6DAE5F) : Colours.app_main).withValues(alpha: 0.3),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              isNotStarted ? '即将开始' : '马上抢',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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
        Container(
          height: 50 + pmPadd.top,
          padding: EdgeInsets.fromLTRB(16, pmPadd.top + 8, 16, 8),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => close(),
                child: Container(
                  width: 32,
                  height: 32,
                  child: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                ),
              ),
              Spacer(),
              Image.asset('assets/images/mall/ms_logo.png', width: 71, height: 24),
              Spacer(),
              Container(width: 32, height: 32),
            ],
          ),
        ),
      ],
    );
  }

  void close() {
    Navigator.of(context).pop();
  }
}
