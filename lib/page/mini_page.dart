/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:maixs_utils/model/data_model.dart';
import 'package:maixs_utils/widget/anima_switch_widget.dart';
import 'package:maixs_utils/widget/mylistview.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';
import 'package:maixs_utils/widget/views.dart';
import 'package:sufenbao/service.dart';
import 'package:sufenbao/widget/CustomWidgetPage.dart';

import '../util/colors.dart';
import '../util/launchApp.dart';
import '../util/login_util.dart';
import '../util/paixs_fun.dart';
import '../widget/loading.dart';
import '../widget/lunbo_widget.dart';

//小样种草机
class MiniPage extends StatefulWidget {
  const MiniPage({Key? key}) : super(key: key);

  @override
  _MIniPageState createState() => _MIniPageState();
}

class _MIniPageState extends State<MiniPage> {
  ScrollController _scrollController = ScrollController();
  var _showBackTop = false;

  @override
  void initState() {
    super.initState();

    // 对 scrollController 进行监听
    _scrollController.addListener(() {
      // _scrollController.position.pixels 获取当前滚动部件滚动的距离
      // 当滚动距离大于 800 之后，显示回到顶部按钮
      setState(() => _showBackTop = _scrollController.position.pixels >= 800);
    });
  }

  @override
  void dispose() {
    // 记得销毁对象
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var bannerList = [
      {'img': 'https://img.bc.haodanku.com/cms/1646037895?t=1660822200000'}
    ];
    return ScaffoldWidget(
      body: Stack(
        children: [
          PWidget.container(null, [double.infinity, double.infinity],
              {'gd': PFun.tbGd(Color(0xfff9cc8c), Color(0xfff9cc8c))}),
          ScaffoldWidget(
              floatingActionButton:
                  _showBackTop // 当需要显示的时候展示按钮，不需要的时候隐藏，设置 null
                      ? FloatingActionButton(
                          backgroundColor: Color(0xfff9cc8c),
                          mini: true,

                          onPressed: () {
                            // scrollController 通过 animateTo 方法滚动到某个具体高度
                            // duration 表示动画的时长，curve 表示动画的运行方式，flutter 在 Curves 提供了许多方式
                            _scrollController.animateTo(0.0,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.decelerate);
                          },
                          child: Icon(
                            Icons.arrow_upward,
                            color: Colors.white,
                          ),
                        )
                      : null,
              bgColor: Colors.transparent,
              brightness: Brightness.light,
              appBar: Stack(children: [

                LunboWidget(
                  bannerList,
                  value: 'img',
                  aspectRatio: 75 / 31,
                  loop: false,
                  fun: (v) {},
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: IconButton(
                    // splashColor: bwColor,
                    icon: Icon(Icons.arrow_back_ios, color: Colors.white,),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],),
              body: Padding(
                padding:
                    EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
                child: TopChild(_scrollController),
              )),
        ],
      ),
    );
  }
}

class TopChild extends StatefulWidget {
  final ScrollController scrollController;
  const TopChild(this.scrollController, {Key? key}) : super(key: key);
  @override
  _TopChildState createState() => _TopChildState();
}

class _TopChildState extends State<TopChild> {

  late String appName;

  @override
  void initState() {
    initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appName = packageInfo.appName; //读取属性
    await getListData(isRef: true);
  }

  ///列表数据
  var listDm = DataModel();
  Future<int> getListData({int page = 1, bool isRef = false}) async {
    var res = await BService.miniList(page).catchError((v) {
      listDm.toError('网络异常');
    });
    if (res != null && res.isNotEmpty) {
      listDm.addList(res, isRef, 500);
    } else {
      listDm.hasNext = false;
    }
    // flog(listDm.toJson());
    setState(() {});
    return listDm.flag;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitchBuilder(
      value: listDm,
      initialState: buildLoad(color: Color(0xff9cc8c)),
      errorOnTap: () => this.getListData(isRef: true),
      listBuilder: (list, p, h) {
        return MyListView(
          isShuaxin: true,
          isGengduo: h,
          controller: widget.scrollController,
          header: buildClassicHeader(color: Colors.white),
          footer: buildCustomFooter(color: Colors.grey),
          onRefresh: () => this.getListData(isRef: true),
          onLoading: () => this.getListData(page: p),
          itemCount: list.length,
          listViewType: ListViewType.Separated,
          item: (i) {
            var data = list[i] as Map;

            var endPrice = data['itemendprice'];
            var endPriceD = double.parse(endPrice);
            var price = data['itemprice'];
            var priceD = double.parse(price);
            String label = '大额回购券';
            if(data['new_label'] != null) {
              List labels = data['new_label'];
              if(labels.isNotEmpty) {
                label = labels[0];
              }
            }
            return PWidget.column(
              [
                ClipRRect(
                    borderRadius: BorderRadius.circular(15), //设置圆角
                    child: PWidget.container(
                      PWidget.row(
                        [
                          PWidget.wrapperImage(
                              data['itempic'], [114, 114], {'br': 8}),
                          PWidget.boxw(8),
                          PWidget.column([
                            getTitleWidget(data['itemshorttitle'],),
                            PWidget.boxh(8),
                            ClipRRect(
                                borderRadius: BorderRadius.circular(12), //设置圆角
                                child: PWidget.container(
                                  PWidget.row([
                                    PWidget.image('assets/images/mall/mini.png',
                                        [12, 12]),
                                    PWidget.boxw(4),
                                    PWidget.text('', [], {}, [
                                      PWidget.textIs('${data['shopname']}',
                                          [Color(0xfffd4040), 12]),
                                    ])
                                  ]),
                                  [double.infinity, 32, Colours.bg_light],
                                  {
                                    'pd': PFun.lg(0, 0, 8, 8),
                                    'ali': PFun.lg(-1, 0)
                                  },
                                )),
                            PWidget.boxh(8),
                            PWidget.row([
                              PWidget.container(
                                PWidget.text(label,
                                    [Color(0xfff3a731), 12]),
                                {
                                  'bd': PFun.bdAllLg(Color(0xFFFFCA7E), 0.5),
                                  'pd': PFun.lg(1, 1, 4, 4),
                                  'br': PFun.lg(4, 0, 4, 0)
                                },
                              ),
                            ]),
                            PWidget.spacer(),
                            Stack(alignment: Alignment.centerRight, children: [
                              PWidget.container(

                                getPriceWidget(endPriceD, priceD, endPrefix: '抢购价', endPrefixColor: Color(0xFFFD471F)),
                                {
                                  'pd': PFun.lg(0, 0, 8, 8),
                                  'mg': PFun.lg(0, 0, 0, 15),
                                  'ali': PFun.lg(-1, 0)
                                },
                              ),
                              Stack(alignment: Alignment.center, children: [
                                PWidget.image(
                                    'assets/images/mall/ljq.jpg', [70, 39]),
                                PWidget.text('立即抢', [Colors.white, 14, true],
                                    {'pd': PFun.lg(0, 4)}),
                              ]),
                            ]),
                          ], {
                            'exp': 1,
                          }),
                        ],
                        '001',
                        {'fill': true},
                      ),
                      [null, null, Colors.white],
                      {
                        'pd': 12,
                        'fun': () {
                          onTapDialogLogin(context,
                              fun: (){
                                jump2Tb(data['itemid']);
                              });

                        }
                      },
                    )),
                PWidget.boxh(15)
              ],
            );
          },
        );
      },
    );
  }

  Future jump2Tb(itemId) async {
    AwesomeDialog(
        context: context,
        dialogType: DialogType.noHeader,
        title: '提示',
        desc: '$appName想要打开【淘宝APP】，是否继续？',
        btnOkColor: Colours.app_main,
        btnCancelColor: Colors.grey[400],
        btnOkText: '继续',
        btnCancelText: '取消',
        btnCancelOnPress: () {},
        btnOkOnPress: () async {
          Loading.show(context);
          var res = await BService.getGoodsWord(itemId);
          Loading.hide(context);

          LaunchApp.launchTb(context, res['itemUrl']);
        },
    )..show();
  }
}
