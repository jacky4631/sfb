/**
 *  Copyright (C) 2018-2026
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:maixs_utils/model/data_model.dart';
import 'package:maixs_utils/widget/anima_switch_widget.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';
import 'package:maixs_utils/widget/views.dart';
import 'package:sufenbao/widget/tab_widget.dart';
import 'package:sufenbao/dy/dy_index_first_page.dart';
import 'package:sufenbao/dy/dy_index_other_page.dart';
import 'package:sufenbao/service.dart';

import '../util/colors.dart';
import '../util/paixs_fun.dart';

class DyIndexPage extends StatefulWidget {
  @override
  _DyIndexPageState createState() => _DyIndexPageState();
}

class _DyIndexPageState extends State<DyIndexPage>{

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
  String? categoryError;
  bool categoryLoading = false;

  Future<int> getTabData() async {
    if (categoryLoading) return tabDm.flag;
    categoryLoading = true;
    List<Map> categories = [];
    try {
      categories = await BService.dyCate();
      categoryError = null;
    } catch (_) {
      categoryError = '分类加载失败，当前显示精选商品';
    } finally {
      categoryLoading = false;
    }
    if (!mounted) return tabDm.flag;
    tabDm.addList([
      {'cid': 0, 'title': '精选'},
      ...categories.where((item) => '${item['cid']}' != '0'),
    ], true, 0);
    setState(() {});
    return tabDm.flag;
  }

  @override
  void dispose() {
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _page();
  }

  _page() {
    return ScaffoldWidget(
        body: Stack(children: [
      PWidget.container(null, [double.infinity, double.infinity],
          {'gd': PFun.tbGd(Colours.dy_main, Colors.white)}),
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
              var tabList = list.map<String>((m) => (m! as Map)['title']).toList();
              final tabs = TabWidget(
                key: ValueKey(list.map((item) => item['cid']).join(',')),
                tabList: tabList,
                color: Colors.black,
                indicatorColor: Colours.dy_main,
                fontSize: 14,
                indicatorWeight: 2,
                tabPage: List.generate(tabList.length, (i) {
                  return i == 0 ? DyIndexFirstPage() : DyIndexOtherPage(list[i] as Map);
                }),
              );
              return Column(children: [
                if (categoryError != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(children: [
                      Expanded(child: Text(categoryError!, style: const TextStyle(fontSize: 12, color: Colours.text_gray))),
                      TextButton(onPressed: getTabData, child: const Text('重试')),
                    ]),
                  ),
                Expanded(child: tabs),
              ]);
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
