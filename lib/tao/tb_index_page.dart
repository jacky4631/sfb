/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:maixs_utils/model/data_model.dart';
import 'package:maixs_utils/widget/anima_switch_widget.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';
import 'package:maixs_utils/widget/views.dart';
import 'package:sufenbao/service.dart';
import 'package:sufenbao/tao/tb_index_first_page.dart';
import 'package:sufenbao/tao/tb_index_other_page.dart';
import 'package:sufenbao/widget/tab_widget.dart';

import '../util/colors.dart';
import '../util/paixs_fun.dart';

class TbIndexPage extends StatefulWidget {
  @override
  _TbIndexPageState createState() => _TbIndexPageState();
}

class _TbIndexPageState extends State<TbIndexPage> {

  FocusNode _searchFocus = FocusNode();
  @override
  void initState() {
    initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    await getTabData();
  }

  ///tab数据
  var tabDm = DataModel();

  Future<int> getTabData() async {
    var res = await BService.goodsCategory().catchError((v) {
      tabDm.toError('网络异常');
    });
    if (res != null) {
      tabDm.addList(res, true, 0);
      tabDm.list.insert(
          0, {"cid": 0, "cname": "精选", "cpic": "", "subcategories": []});
    }
    setState(() {});
    return tabDm.flag;
  }

  @override
  Widget build(BuildContext context) {
    return _page();
  }

  _page() {
    return ScaffoldWidget(
        body: Stack(children: [
      PWidget.container(null, [double.infinity, double.infinity],
          {'gd': PFun.tbGd(Colours.pdd_main, Colors.white)}),
      ScaffoldWidget(
        // appBar: buildTitle(context, title: APP_NAME),
        // bottomSheet: BottomNav(0),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          title: PWidget.row([
            buildTextField2(
                keyboardType: TextInputType.none,
                focusNode: _searchFocus,
                hint: '搜索商品或粘贴宝贝标题',
                bgColor: Colors.white,
                height: 36,

                onTap: () => {
                  navigatorToSearchPage()
                })
          ]),
        ),
        bgColor: Colors.transparent,
        brightness: Brightness.light,
        body: PWidget.container(
          AnimatedSwitchBuilder(
            value: tabDm,
            errorOnTap: () => this.getTabData(),
            // initialState: buildLoad(color: Colors.grey),
            initialState: PWidget.container(null, [double.infinity]),
            listBuilder: (list, _, __) {
              var tabList = list.map<String>((m) => (m! as Map)['cname']).toList();
              return TabWidget(
                tabList: tabList,
                color: Colors.black,
                indicatorColor: Colours.pdd_main,
                fontSize: 14,
                indicatorWeight: 2,
                tabPage: List.generate(tabList.length, (i) {
                  return i == 0 ? TbIndexFirstPage() : TbIndexOtherPage(list[i] as Map);
                }),
              );
            },
          ),
          [null, null, Color(0xffF6F6F6)],
          {'crr': PFun.lg(16, 16)},
        ),
      )
    ]));
  }

  navigatorToSearchPage(){
    _searchFocus.unfocus();
    Navigator.pushNamed(context, '/search', arguments: {'showArrowBack': true});
  }
}
