/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:maixs_utils/model/data_model.dart';
import 'package:maixs_utils/widget/anima_switch_widget.dart';
import 'package:maixs_utils/widget/mylistview.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';
import 'package:maixs_utils/widget/views.dart';
import 'package:sufenbao/util/global.dart';
import 'package:sufenbao/page/product_details.dart';
import 'package:sufenbao/service.dart';

import '../util/colors.dart';
import '../util/paixs_fun.dart';
import '../widget/lunbo_widget.dart';
import '../widget/tab_widget.dart';

//库通用页面
class KuCustomPage extends StatefulWidget {
  final Map data;
  const KuCustomPage(this.data, {Key? key}) : super(key: key);

  @override
  _MIniPageState createState() => _MIniPageState();
}

class _MIniPageState extends State<KuCustomPage> {
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
    getTabData();
  }

  ///tab数据
  var tabDm = DataModel();
  Future<int> getTabData() async {
    var res = await BService.kuCustomCate(widget.data['link']).catchError((v) {
      tabDm.toError('网络异常');
    });
    if (res != null) {
      List content = res['content'];
      tabDm.addList(
          content.where((element) => element['type'] == 'list').toList(),
          true,
          0);
      tabDm.value = content;
    }
    ;
    setState(() {});
    return tabDm.flag;
  }

  @override
  void dispose() {
    // 记得销毁对象
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List imgs = [];
    Color bg = Colors.white;
    if (tabDm.value.isNotEmpty) {
      if (tabDm.value[0] is Map) {
        String imgUrl = tabDm.value[0]['_attr']['appUrl'];
        String bgColor = tabDm.value[0]['_attr']['backgroundColor'];
        if (!Global.isEmpty(bgColor)) {
          bg = Global.theColor(bgColor);
        }
        if (!imgUrl.startsWith('https')) {
          imgUrl = imgUrl.replaceFirst('http', 'https');
        }
        imgs.add({'img': imgUrl});
      }
    }
    // if(bg == Colors.white) {
    //   bg = Color(0xfff9cc8c);
    // }
    return ScaffoldWidget(
      body: Stack(
        children: [
          PWidget.container(null, [double.infinity, double.infinity],
              {'gd': PFun.tbGd(bg, bg)}),
          ScaffoldWidget(
              floatingActionButton:
                  _showBackTop // 当需要显示的时候展示按钮，不需要的时候隐藏，设置 null
                      ? FloatingActionButton(
                          backgroundColor: Colours.app_main,
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
              appBar: Stack(
                children: [
                  tabDm.value.isNotEmpty
                      ? LunboWidget(
                          imgs,
                          value: 'img',
                          aspectRatio: 75 / 31,
                          loop: false,
                          fun: (v) {},
                        )
                      : SizedBox(),
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: IconButton(
                      // splashColor: bwColor,
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
              body: AnimatedSwitchBuilder(
                value: tabDm,
                errorOnTap: () => this.getTabData(),
                initialState: buildLoad(color: Colours.app_main),
                listBuilder: (list, _, __) {
                  var tabList = list.map<String>((m) {
                    String name = (m! as Map)['_attr']['appName'];
                    if (Global.isEmpty(name)) {
                      name = (m! as Map)['_attr']['name'];
                    }
                    return name;
                  }).toList();
                  return TabWidget(
                    tabList: tabList,
                    indicatorColor: Colors.white.withOpacity(0),
                    tabPage: List.generate(tabList.length, (i) {
                      return Padding(
                          padding: EdgeInsets.only(
                              top: 10, left: 20, right: 20, bottom: 10),
                          child: TopChild(_scrollController, list[i] as Map));
                    }),
                  );
                },
              )),
        ],
      ),
    );
  }
}

class TopChild extends StatefulWidget {
  final ScrollController scrollController;
  final Map data;
  const TopChild(this.scrollController, this.data, {Key? key})
      : super(key: key);
  @override
  _TopChildState createState() => _TopChildState();
}

class _TopChildState extends State<TopChild> {
  @override
  void initState() {
    initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    await getListData(isRef: true);
  }

  ///列表数据
  var listDm = DataModel();
  Future<int> getListData({int page = 1, bool isRef = false}) async {
    Map param = widget.data['_attr']['auto_form'];
    List list = widget.data['_attr']['goodsList'];
    List<String> ids = list.map((e) => e['id'].toString()).toList();
    param['item'] = Global.listToString(ids);
    var res = await BService.kuCustomList(param).catchError((v) {
      listDm.toError('网络异常');
    });
    if (res != null) {
      listDm.addList(res, isRef, 0);
    }
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
            // return createItem(data);
            return PWidget.column(
              [
                ClipRRect(
                    borderRadius: BorderRadius.circular(15), //设置圆角
                    child: Global.openFadeContainer(
                        createItem(data), ProductDetails(data))),
                PWidget.boxh(15)
              ],
            );
          },
        );
      },
    );
  }

  Widget createItem(data) {
    var endPrice = data['itemendprice'];
    var endPriceD = double.parse(endPrice);
    var price = data['itemprice'];
    var priceD = double.parse(price);
    List<Widget> labels = getLabel(data);

    return PWidget.container(
      PWidget.row(
        [
          PWidget.wrapperImage(data['itempic'], [114, 114], {'br': 8}),
          PWidget.boxw(8),
          PWidget.column([
            PWidget.text(data['itemshorttitle'],
                [Colors.black.withOpacity(0.75), 14], {'exp': true}),
            PWidget.boxh(8),
            ClipRRect(
                borderRadius: BorderRadius.circular(12), //设置圆角
                child: PWidget.container(
                  PWidget.row([
                    PWidget.image('assets/images/mall/mini.png', [12, 12]),
                    PWidget.boxw(4),
                    PWidget.text('', [], {}, [
                      PWidget.textIs(
                          '${data['shopname']}', [Color(0xfffd4040), 12]),
                    ])
                  ]),
                  [double.infinity, 32, Colours.bg_light],
                  {'pd': PFun.lg(0, 0, 8, 8), 'ali': PFun.lg(-1, 0)},
                )),
            PWidget.boxh(8),
            PWidget.row(labels),
            PWidget.spacer(),
            Stack(alignment: Alignment.centerRight, children: [
              PWidget.container(
                PWidget.text('', [], {}, [
                  PWidget.textIs('¥$endPriceD', [Color(0xFFFD471F), 18, true]),
                  PWidget.textIs('¥$priceD', [Colors.black45, 12],
                      {'td': TextDecoration.lineThrough}),
                ]),
                {
                  'pd': PFun.lg(0, 0, 8, 8),
                  'mg': PFun.lg(0, 0, 0, 15),
                  'ali': PFun.lg(-1, 0)
                },
              ),
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
      },
    );
  }

  List<Widget> getLabel(data) {
    List<Widget> labels = [];
    num length = 0;
    if (data['new_label'] != null) {
      List newLabel = jsonDecode(data['new_label']) as List;
      if (newLabel.isNotEmpty) {
        for (int i = 0; i < newLabel.length; i++) {
          Map newL = newLabel[i];
          if(Global.isEmpty(newL['name'].trim())) {
            continue;
          }
          labels.add(getLabelElement(newL['name']));
          labels.add(PWidget.boxw(2));
          length += newL['name'].length;
          if (length >= 8) {
            break;
          }
        }
        if(labels.isEmpty) {
          initOldLabel(data, labels, length);
        }
      }
    } else {
      initOldLabel(data, labels, length);
    }
    return labels;
  }

  initOldLabel(data, labels, length) {
    List labelsStr = data['label'];
    for (int i = 0; i < labelsStr.length; i++) {
      String lbl = labelsStr[i];
      labels.add(getLabelElement(lbl));
      labels.add(PWidget.boxw(2));
      length += lbl.length;
      if (length >= 9) {
        break;
      }
    }
  }

  Widget getLabelElement(String label, {exp = false}) {
    return PWidget.container(
      PWidget.text(
        label,
        [Color(0xfff3a731), 12],
      ),
      {
        'bd': PFun.bdAllLg(Color(0xFFFFCA7E), 0.5),
        'pd': PFun.lg(1, 1, 4, 4),
        'br': PFun.lg(4, 0, 4, 0),
        'exp': exp
      },
    );
  }
}
