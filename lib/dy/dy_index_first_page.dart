/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:maixs_utils/model/data_model.dart';
import 'package:maixs_utils/widget/anima_switch_widget.dart';
import 'package:maixs_utils/widget/my_custom_scroll.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';
import 'package:maixs_utils/widget/views.dart';
import 'package:sufenbao/service.dart';
import 'package:sufenbao/util/global.dart';

import '../widget/CustomWidgetPage.dart';
import '../widget/lunbo_widget.dart';

///首页
class DyIndexFirstPage extends StatefulWidget {
  @override
  _DyIndexFirstPageState createState() => _DyIndexFirstPageState();
}

class _DyIndexFirstPageState extends State<DyIndexFirstPage> {
  @override
  void initState() {
    initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    await getBannerData();
    await getListData(isRef: true);
  }

  ///列表数据
  var listDm = DataModel();
  Future<int> getListData({int page = 1, bool isRef = false}) async {
    var res = await BService.dyList(0, page).catchError((v) {
      listDm.toError('网络异常');
    });
    if (res != null) {
      listDm.addList(res['products'], isRef, res['total']);
    }
    setState(() {});
    return listDm.flag;
  }

  ///banner
  var bannerDm = DataModel(value: [[], []]);
  Future<int> getBannerData() async {
    var res = await BService.dyNav().catchError((v) {
      bannerDm.toError('网络异常');
    });
    if (res != null) {
      List banners = res['banners'];
      //移除抖音盛夏洗护530
      banners.removeWhere((element) {
        return element['id'] == 530;
      });
      bannerDm.addList(banners, true, 0);
    }
    setState(() {});
    return bannerDm.flag;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      bgColor: Color(0xffF4F5F6),
      body: MyCustomScroll(
        isGengduo: listDm.hasNext,
        isShuaxin: true,
        onRefresh: () => this.getListData(isRef: true),
        onLoading: (p) => this.getListData(page: p),
        refHeader: buildClassicHeader(color: Colors.grey),
        refFooter: buildCustomFooter(color: Colors.grey),
        headers: headers,
        itemPadding: EdgeInsets.all(8),
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        itemModel: listDm,
        itemModelBuilder: (i, v) {
          return createDyFadeContainer(context, i, v);
        },
      ),
    );
  }
  List<Widget> get headers {
    return [
      //轮播
      AnimatedSwitchBuilder(
        value: bannerDm,
        errorOnTap: () => this.getBannerData(),
        noDataView: PWidget.boxh(0),
        errorView: PWidget.boxh(0),
        initialState: PWidget.container(null, [double.infinity]),
        isAnimatedSize: false,
        listBuilder: (list, _, __) {
          return LunboWidget(
            bannerDm.list,
            value: 'img',
            radius: 8,
            margin: 16,
            aspectRatio: 391 / (154 + 16),
            fun: (v) {
              ///点击事件
              Global.kuParse(context, v);
            },
          );
        },
      ),
      PWidget.boxh(4),
    ];
  }
}
