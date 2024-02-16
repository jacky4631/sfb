/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:maixs_utils/model/data_model.dart';
import 'package:maixs_utils/widget/anima_switch_widget.dart';
import 'package:maixs_utils/widget/mylistview.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';
import 'package:maixs_utils/widget/views.dart';
import 'package:sufenbao/service.dart';
import 'package:sufenbao/util/global.dart';

import '../util/colors.dart';
import '../util/paixs_fun.dart';
import '../widget/CustomWidgetPage.dart';
import '../widget/lunbo_widget.dart';
import '../widget/tab_widget.dart';

//唯品会首页
class VipIndexPage extends StatefulWidget {
  final Map data;
  const VipIndexPage(this.data, {Key? key}) : super(key: key);

  @override
  _MIniPageState createState() => _MIniPageState();
}

class _MIniPageState extends State<VipIndexPage> {
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
    var res = [
      {'name': '美妆'},
      {'name': '母婴'},
      {'name': '鞋包'},
      {'name': '女装'},
      {'name': '男装'},
      {'name': '居家百货'},
    ];
    tabDm.addList(res, true, 0);
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
    List imgs = [
      {'img': 'https://sr.ffquan.cn/cms_pic/20220427/c9kabkv92a41b8dv6jug0.png'}
    ];

    return ScaffoldWidget(
      body: Stack(
        children: [
          PWidget.container(null, [double.infinity, double.infinity],
              {'gd': PFun.tbGd(Color(0xffff3295), Color(0xffff3295))}),
          ScaffoldWidget(
              floatingActionButton:
                  _showBackTop // 当需要显示的时候展示按钮，不需要的时候隐藏，设置 null
                      ? FloatingActionButton(
                          backgroundColor: Colours.vip_main,
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
                  var tabList =
                      list.map<String>((m) => (m! as Map)['name']).toList();
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
  bool loading = true;

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
    var res = await BService.vipList(page, keyword: widget.data['name'])
        .catchError((v) {
      listDm.toError('网络异常');
    });
    if (res != null) {
      listDm.addList(res['goodsInfoList'], isRef, res['total']);
    }
    setState(() {
      loading = false;
    });
    return listDm.flag;
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Global.showLoading2()
        : AnimatedSwitchBuilder(
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
                  return createVipFadeContainer(context, data);
                },
              );
            },
          );
  }

}
