/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:maixs_utils/model/data_model.dart';
import 'package:maixs_utils/util/utils.dart';
import 'package:maixs_utils/widget/anima_switch_widget.dart';
import 'package:maixs_utils/widget/mylistview.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';
import 'package:maixs_utils/widget/views.dart';

import '../util/colors.dart';
import '../util/paixs_fun.dart';
import '../service.dart';

class AddressList extends StatefulWidget {
  final Map data;

  const AddressList({Key? key, required this.data}) : super(key: key);

  @override
  _AddressListState createState() => _AddressListState();
}

class _AddressListState extends State<AddressList> {
  late List addressList;

  @override
  void initState() {
    initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    await getListData(isRef: false);
  }

  ///列表数据
  var listDm = DataModel();

  Future<int> getListData({int page = 1, bool isRef = true}) async {
    addressList = await BService.addressList();
    if (addressList != null) {
      listDm.addList(addressList, isRef, addressList.length);
    }
    setState(() {});
    return listDm.flag;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      body: Stack(
        children: [
          PWidget.container(null, [double.infinity, double.infinity],
              {'gd': PFun.tbGd(Colors.white, Colors.white)}),
          ScaffoldWidget(
            brightness: Brightness.dark,
            bgColor: Colors.transparent,
            appBar: buildTitle(context,
                title: '地址管理',
                widgetColor: Colors.black,
                leftIcon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                )),
            body: createHomeChild(context),
          ),
          btmBarView(context),
        ],
      ),
    );
  }

  ///底部操作栏
  Widget btmBarView(BuildContext context) {
    return PWidget.positioned(
      PWidget.container(
        PWidget.row([
          PWidget.container(
            PWidget.row([
              PWidget.container(
                PWidget.ccolumn([
                  PWidget.text('', [], {}, [
                    PWidget.textIsNormal('新建收获地址', [Colors.white, 16, true]),
                  ]),
                ], '221'),
                [null, null, Colours.app_main],
                {
                  'exp': true,
                },
              ),
            ]),
            [null, 44],
            {'crr': 8, 'exp': true},
          ),
        ]),
        [null, null, Colors.white],
        {
          'pd': [8,MediaQuery.of(context).padding.bottom+8,8,8],
          'fun': () => {Navigator.pushNamed(context, '/createAddress').then((value) {
            getListData(isRef:true);
          })},
        },
      ),
      [null, 0, 12, 12],
    );
  }
  Widget createHomeChild(BuildContext context) {
    return AnimatedSwitchBuilder(
      value: listDm,
      initialState: buildLoad(color: Colors.white),
      errorOnTap: () => this.getListData(isRef: true),
      listBuilder: (list, p, h) {
        return MyListView(
          isShuaxin: true,
          isGengduo: h,
          header: buildClassicHeader(color: Colors.white),
          onRefresh: () => this.getListData(isRef: true),
          // onLoading: () => this.getListData(page: p),
          itemCount: list.length,
          listViewType: ListViewType.Separated,
          padding: const EdgeInsets.all(12),
          divider: const Divider(height: 12, color: Colors.transparent),
          item: (i) {
            Map data = list[i] as Map;
            return Slidable(
              // Specify a key if the Slidable is dismissible.
              key: const ValueKey(0),

              // The end action pane is the one at the right or the bottom side.
              endActionPane: ActionPane(
                motion: ScrollMotion(),
                children: [
                  SlidableAction(
                    // An action can be bigger than the others.
                    onPressed: (context) {
                      BService.addressDefaultSet(data['id']).then((value) => getListData(isRef: true));
                    },
                    backgroundColor: Colors.grey.shade200,
                    foregroundColor: Colors.black,
                    label: '设为默认',
                  ),
                  SlidableAction(
                    onPressed: (context) {
                      BService.addressDel(data['id']).then((value) => getListData(isRef: true));
                    },
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    label: '删除',
                  ),
                ],
              ),

              // The child of the Slidable is what the user sees when the
              // component is not dragged.
              child: createItem(data),
            );
          },
        );
      },
    );
  }

  Widget createItem(data) {
    return PWidget.row([
      PWidget.container(
        PWidget.column([
          PWidget.row([
            PWidget.text(
                data['province'], [Colors.black.withOpacity(0.75), 14]),
            data['province']== data['city'] ? SizedBox() :PWidget.boxw(2),
            data['province']== data['city'] ? SizedBox() :PWidget.text(
                data['city'], [Colors.black.withOpacity(0.75), 14]),
            PWidget.boxw(2),
            PWidget.text(
                data['district'], [Colors.black.withOpacity(0.75), 14]),
          ]),
          PWidget.boxh(8),
          PWidget.column([
            PWidget.text(data['detail'],
                [Colors.black.withOpacity(0.75), 16, true]),
          ]),
          PWidget.boxh(8),
          PWidget.row([
            PWidget.text(
                data['realName'], [Colors.black.withOpacity(0.75)]),
            PWidget.boxw(8),
            PWidget.text(
                data['phone'], [Colors.black.withOpacity(0.75)]),
            PWidget.boxw(8),
            data['isDefault']==1 ?PWidget.container(
              PWidget.text('默认', [Colors.white, 12]),
              [null, null, Colours.app_main],
              {
                'bd': PFun.bdAllLg(Colours.app_main, 0.5),
                'pd': PFun.lg(1, 1, 4, 4),
                'br': PFun.lg(0, 4, 0, 4)
              },
            ): SizedBox(),
          ]),
        ]),
        [null, null, Colors.white],
        {
          'br': 12,
          'pd': 12,
          'fun': () => {Navigator.pop(context, data)}
        },
      ),
      Spacer(),
      PWidget.container(
        PWidget.column([
          Icon(Icons.edit_outlined)
        ]),
        [null, null, Colors.white],
        {
          'br': 12,
          'pd': 12,
          'fun': () {
            Navigator.pushNamed(context, '/createAddress', arguments: data).then((value) => getListData(isRef: true));
          }
        },
      ),
    ]);
  }
}

