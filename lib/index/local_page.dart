/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_z_location/flutter_z_location.dart';
import 'package:maixs_utils/model/data_model.dart';
import 'package:maixs_utils/widget/my_custom_scroll.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';
import 'package:maixs_utils/widget/views.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sufenbao/index/widget/banner_widget.dart';
import 'package:sufenbao/search/search_bar_widget.dart';
import 'package:sufenbao/service.dart';
import 'package:sufenbao/util/paixs_fun.dart';

import '../util/colors.dart';
import '../util/custom.dart';
import '../util/global.dart';
import '../util/launchApp.dart';
import '../util/login_util.dart';
import '../util/picker_helper.dart';
import '../util/tao_util.dart';
import '../widget/CustomWidgetPage.dart';
import '../widget/loading.dart';

class LocalPage extends StatefulWidget {
  @override
  _LocalPageState createState() => _LocalPageState();
}

class _LocalPageState extends State<LocalPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var latitude;
  var longitude;
  List<dynamic> _datas = []; //一级分类
  List<dynamic> _categorys = []; //二级分类
  int _index = 0; //一级分类下标
  var cityList;
  var cityName = "定位中";
  int cityVal = 0;
  int categoryVal = 0;
  ScrollController _scrollController = ScrollController();
  var _showBackTop = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _page();
  }

  @override
  void initState() {
    initData();
    _scrollController.addListener(() {
      setState(() => _showBackTop = _scrollController.position.pixels >= 800);
    });
  }

  Future<int> initData() async {
    await searchRankingList();
    await getBannerData();
    // 分类类别
    await getLifeCategory();
    // 城市列表
    // await getLifeCity();

    // 权限，获取GPS定位经纬度
    bool locationGranted = await Permission.location.request().isGranted;
    if (locationGranted) {
      var res = await FlutterZLocation.getCoordinate(accuracy: 1);
      if (res != null) {
        latitude = res.latitude;
        longitude = res.longitude;
        var lifeCitysList = await BService.getLifeCity(longitude, latitude);
        cityName = lifeCitysList['city'] ?? '';
        cityVal = lifeCitysList['val'] ?? 0;
        //商品列表
        await getLifeGoodsList(isRef: true);
        setState(() {});
      }
    } else {
      await getLifeGoodsList(isRef: true);
    }
    return 0;
  }

  var listDm = DataModel();
  int pageIndex = 1;

  Future<int> getLifeGoodsList({int page = 1, bool isRef = false}) async {
    var lifeGoodsList = await BService.getLifeGoodsList(page,
            categoryId: categoryVal, cityCode: cityVal, longitude: longitude, latitude: latitude)
        .catchError((v) {
      listDm.toError('网络异常');
    });
    if (lifeGoodsList.isNotEmpty) {
      print(lifeGoodsList);
      pageIndex = lifeGoodsList['min_id'];
      var list = lifeGoodsList['data'];
      listDm.addList(list, isRef, 99);
    }
    setState(() {});
    return listDm.flag;
  }

  getLifeCity() async {
    cityList = await BService.getLifeCityList();
  }

  getLifeCategory() async {
    var categorys = await BService.getLifeCategory();
    setState(() {
      _datas = categorys['data']['list'];
    });
  }

  ///顶部banner
  var bannerDm = DataModel(value: [[], []]);

  Future<int> getBannerData() async {
    var res = await BService.banners().catchError((v) {
      bannerDm.toError('网络异常');
    });
    if (res != null) {
      //移除网络链接link_type=3 保留小样种草 移除抖音
      res.removeWhere((element) {
        return (element['link_type'] == 3 && element['id'] != 380) || element['id'] == 530;
      });
      // res.insertAll(0, pddBannerData);
      bannerDm.addList(res, true, 0);
    }
    setState(() {});
    return bannerDm.flag;
  }

  var searchRankingListDm = DataModel();

  Future<int> searchRankingList() async {
    var res = await BService.hotWords().catchError((v) {
      searchRankingListDm.toError('网络异常');
    });
    if (res != null) searchRankingListDm.addList(res, true, 0);
    setState(() {});
    return searchRankingListDm.flag;
  }

  _page() {
    return ScaffoldWidget(
      scaffoldKey: _scaffoldKey,
      endDrawer: _drawer(),
      bgColor: Colors.white,
      brightness: Brightness.dark,
      appBar: titleBarView(),
      body: _container(),
    );
  }

  _container() {
    return ScaffoldWidget(
        body: Stack(
      children: [
        ScaffoldWidget(
            floatingActionButton: _showBackTop // 当需要显示的时候展示按钮，不需要的时候隐藏，设置 null
                ? FloatingActionButton(
                    backgroundColor: Colours.app_main,
                    mini: true,
                    onPressed: () {
                      // scrollController 通过 animateTo 方法滚动到某个具体高度
                      // duration 表示动画的时长，curve 表示动画的运行方式，flutter 在 Curves 提供了许多方式
                      _scrollController.animateTo(0.0,
                          duration: Duration(milliseconds: 1000), curve: Curves.decelerate);
                    },
                    child: Icon(
                      Icons.arrow_upward,
                      color: Colors.white,
                    ),
                  )
                : null,
            body: MyCustomScroll(
              controller: _scrollController,
              isGengduo: pageIndex != 0 ? true : false,
              isShuaxin: true,
              onRefresh: () => this.getLifeGoodsList(isRef: true),
              onLoading: (p) => this.getLifeGoodsList(page: pageIndex),
              refHeader: buildClassicHeader(color: Colors.grey),
              refFooter: buildCustomFooter(color: Colors.grey),
              itemPadding: EdgeInsets.all(8),
              crossAxisCount: 2,
              crossAxisSpacing: 6,
              itemModel: listDm,
              headers: headers,
              itemModelBuilder: (i, v) {
                return PWidget.container(
                  createListItem(i, v),
                  [null, null, Colors.white],
                  {
                    'fun': () {
                      onTapDialogLogin(context, fun: () async {
                        Loading.show(context);
                        var res = await BService.getLifeGoodsWord(v['id']);
                        Loading.hide(context);
                        LaunchApp.launchDy(context, res['dy_deeplink'], res['dy_zlink']);
                      });
                    },
                    'sd': PFun.sdLg(Colors.black12),
                    'br': 8,
                    'mg': PFun.lg(0, 6),
                    'crr': [5, 5, 5, 5]
                  },
                );
              },
            )),
      ],
    ));
  }

  Widget createListItem(i, v) {
    var sales = v['sold'];
    int max = 1;
    if (i % 3 == 0) {
      max = 2;
    }
    num fee = v['origin_money'];
    String content0 = '';
    String content1 = '';
    List list = [];
    list = v['item_tag'];
    if (list.isNotEmpty) {
      content0 = v['item_tag'].isNotEmpty ? v['item_tag'][0] : '';
      content1 = v['item_tag'][1].isNotEmpty ? v['item_tag'][1] : '';
    }
    return PWidget.container(
      PWidget.column([
        PWidget.wrapperImage(getLifeMainPic(v), {'ar': 1 / 1}),
        PWidget.container(
            PWidget.column([
              PWidget.row([getTitleWidget(v['item_title'], max: max)]),
              PWidget.boxh(8),
              PWidget.row([getPriceWidget(v['price'], v['origin_price']), PWidget.spacer(), getSalesWidget(sales)]),
              PWidget.boxh(4),
              getMoneyWidget(context, fee, DY),
              PWidget.boxh(4),
              PWidget.text('$content0 | $content1', [Colors.black45, 12]),
            ]),
            {'pd': 8}),
      ]),
      [null, null, Colors.white],
    );
  }

  List<Widget> get headers {
    return [
      (bannerDm.list != null && bannerDm.list.isNotEmpty)
          ? BannerWidget(bannerDm, (v) {
              Global.kuParse(context, v);
            })
          :
          //没网络时显示默认图片
          AspectRatio(
              aspectRatio: (750 + 8) / (280 + 24),
              child: PWidget.image('assets/images/mall/bannerholder.png', {
                'br': 8,
                'pd': [8, 8, 8, 8]
              })),
      PWidget.boxh(6),
      if (listDm.list.isNotEmpty) PWidget.text('~ 本地精选 ~', [Colors.black.withOpacity(0.75), 16, true], {'ct': true}),
      PWidget.boxh(8),
    ];
  }

  titleBarView() {
    return PWidget.container(
      PWidget.row([
        PWidget.row(
          [
            TextButton(
              style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.transparent)),
              child: PWidget.row([
                PWidget.text(cityName, [Colors.grey, 14]),
                // PWidget.icon(Icons.arrow_drop_down, [Colors.grey, 20]),
              ]),
              onPressed: () {
                // _switchAddress();
              },
            ),
          ],
        ),
        SearchBarWidget(
          '',
          searchRankingListDm,
          readOnly: true,
          onChanged: (v) {},
          onSubmit: (v, t) {
            navigatorToSearchPage();
          },
          onClear: () {},
          onTap: (f) {
            navigatorToSearchPage();
          },
        ),
        PWidget.boxw(8),
        PWidget.container(PWidget.icon(Icons.menu, [
          Colors.grey,
          20
        ], {
          'fun': () {
            _scaffoldKey.currentState!.openEndDrawer();
          }
        })),
        PWidget.boxw(8),
      ]),
      [null, 56 + pmPadd.top],
      {'pd': PFun.lg(pmPadd.top + 8, 8)},
    );
  }

  FocusNode _searchFocus = FocusNode();

  navigatorToSearchPage() {
    _searchFocus.unfocus();
    Navigator.pushNamed(context, '/search', arguments: {'showArrowBack': true});
  }

  _drawer() {
    return ScaffoldWidget(
        floatingActionButton: FloatingActionButton(
          mini: true,
          backgroundColor: Colours.app_main,
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        body: PWidget.container(
          PWidget.row([
            Expanded(
                child: Container(
                  color: Colors.white,
                  child: ListView.builder(
                    itemCount: _datas.length,
                    itemBuilder: (BuildContext context, int position) {
                      return getRow(position);
                    },
                  ),
                ),
                flex: 2),
            Expanded(
                child: ListView(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.all(10),
                      color: Colors.grey[100],
                      child: getChip(_index), //传入一级分类下标
                    )
                  ],
                ),
                flex: 5),
          ]),
          // ]),
          [null, double.infinity, Colors.grey[100]],
        ));
  }

  _switchAddress() {
    PickerHelper.openCityPicker(context, this.cityList['data']['list'], onConfirm: (selectInfo, selectLocation) {
      // var addr = selectInfo[1];
      // if (addr != selectInfo[1]) {
      //   addr = addr + selectInfo[1];
      // }
      // addr += selectInfo[2];
      // cityName = selectInfo[1];

      setState(() {});
    }, title: '选择地区', selectCityIndex: [0, 0, 0]);
  }

  getRow(int i) {
    return GestureDetector(
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        decoration: BoxDecoration(
            color: _index == i ? Colours.app_main : Colors.white,
            border: Border(left: BorderSide(width: 5, color: _index == i ? Colours.app_main : Colors.white))),
        child: Text(
          _datas[i]['title'],
          style: TextStyle(
            color: _index == i ? Colors.white : Colors.grey[600],
            fontWeight: _index == i ? FontWeight.w600 : FontWeight.w400,
            fontSize: _index == i ? 18 : 14,
          ),
        ),
      ),
      onTap: () {
        setState(() {
          _index = i;
        });
      },
    );
  }

  getChip(int i) {
    if (_datas.isNotEmpty) {
      _categorys = _datas[i]['children'];
    }
    //更新对应下标数据
    _updateArticles(i);
    return Wrap(
      spacing: 10.0, //两个widget之间横向的间隔
      direction: Axis.horizontal, //方向
      alignment: WrapAlignment.start, //内容排序方式
      children: List<Widget>.generate(
        _categorys.length,
        (int index) {
          return ActionChip(
            //标签文字
            label: Text(
              _categorys[index]['title'],
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            //点击事件
            onPressed: () {
              setState(() {
                categoryVal = _categorys[index]['val'];
                getLifeGoodsList(page: 1, isRef: true);
              });
              Navigator.pop(context);
            },
            elevation: 3,
            backgroundColor: Colors.white30,
          );
        },
      ).toList(),
    );
  }

  List _updateArticles(int i) {
    setState(() {
      if (_datas.length != 0) _categorys = _datas[i]['children'];
    });
    return _categorys;
  }
}
