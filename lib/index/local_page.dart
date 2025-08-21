/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_z_location/flutter_z_location.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:sufenbao/index/provider/provider.dart';
import 'package:sufenbao/index/widget/banner_widget.dart';
import 'package:sufenbao/service.dart';

import '../models/data_model.dart';
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

  EdgeInsets get pmPadd => MediaQuery.of(context).padding;

  @override
  void initState() {
    initData();
    _scrollController.addListener(() {
      setState(() => _showBackTop = _scrollController.position.pixels >= 800);
    });
  }

  Future<int> initData() async {
    await searchRankingList();
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
      return <String, dynamic>{};
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
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: _drawer(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: TextButton(
          style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.transparent)),
          child: Row(
            children: [
              Text(
                cityName,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              // Icon(Icons.arrow_drop_down, color: Colors.grey, size: 20),
            ],
          ),
          onPressed: () {
            // _switchAddress();
          },
        ),
        // title: titleBarView()
      ),
      body: _container(),
    );
  }

  _container() {
    return Stack(
      children: [
        ListView.builder(
            controller: _scrollController,
            itemCount: listDm.list.length,
            itemBuilder: (context, index) {
              final v = listDm.list[index];
              return Container(
                margin: EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: () {
                    onTapDialogLogin(context, fun: () async {
                      Loading.show(context);
                      var res = await BService.getLifeGoodsWord(v['id']);
                      Loading.hide(context);
                      LaunchApp.launchDy(context, res['dy_deeplink'], res['dy_zlink']);
                    });
                  },
                  child: createListItem(index, v),
                ),
              );
            }),
        if (_showBackTop)
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: Colours.app_main,
              mini: true,
              onPressed: () {
                _scrollController.animateTo(0.0, duration: Duration(milliseconds: 1000), curve: Curves.decelerate);
              },
              child: Icon(
                Icons.arrow_upward,
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
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
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                getLifeMainPic(v),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                Row(
                  children: [getTitleWidget(v['item_title'], max: max)],
                ),
                SizedBox(height: 8),
                Row(
                  children: [getPriceWidget(v['price'], v['origin_price']), Spacer(), getSalesWidget(sales)],
                ),
                SizedBox(height: 4),
                getMoneyWidget(context, fee, DY),
                SizedBox(height: 4),
                Text(
                  '$content0 | $content1',
                  style: TextStyle(color: Colors.black45, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> get headers {
    return [
      Consumer(builder: (
        context,
        ref,
        child,
      ) {
        final bannerDm = ref
            .watch(bannersProvider)
            .when(data: (data) => data, error: (o, s) => DataModel(), loading: () => DataModel());
        return BannerWidget(bannerDm, (v) {
          Global.kuParse(context, v);
        });
      }),
      SizedBox(height: 6),
      if (listDm.list.isNotEmpty)
        Container(
          alignment: Alignment.center,
          child: Text(
            '~ 本地精选 ~',
            style: TextStyle(
              color: Colors.black.withOpacity(0.75),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      SizedBox(height: 8),
    ];
  }

  titleBarView() {
    return Container(
      height: 56 + pmPadd.top,
      padding: EdgeInsets.only(
        top: pmPadd.top + 8,
        left: 8,
        right: 8,
        bottom: 8,
      ),
      child: Row(
        children: [
          // SearchBarWidget(
          //   '',
          //   searchRankingListDm,
          //   readOnly: true,
          //   onChanged: (v) {},
          //   onSubmit: (v, t) {
          //     navigatorToSearchPage();
          //   },
          //   onClear: () {},
          //   onTap: (f) {
          //     navigatorToSearchPage();
          //   },
          // ),
          SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              _scaffoldKey.currentState!.openEndDrawer();
            },
            child: Container(
              child: Icon(
                Icons.menu,
                color: Colors.grey,
                size: 20,
              ),
            ),
          ),
          SizedBox(width: 8),
        ],
      ),
    );
  }

  FocusNode _searchFocus = FocusNode();

  navigatorToSearchPage() {
    _searchFocus.unfocus();
    Navigator.pushNamed(context, '/search', arguments: {'showArrowBack': true});
  }

  _drawer() {
    return Scaffold(
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
        body: Container(
          height: double.infinity,
          color: Colors.grey[100],
          child: Row(
            children: [
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
            ],
          ),
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
