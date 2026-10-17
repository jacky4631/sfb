/**
 *  Copyright (C) 2018-2026
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'pdd_promotion.dart';
import '../util/colors.dart';
import '../util/login_util.dart';
import '../util/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:maixs_utils/model/data_model.dart';
import 'package:maixs_utils/widget/my_custom_scroll.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';
import 'package:maixs_utils/widget/views.dart';
import 'package:sufenbao/service.dart';

import '../widget/CustomWidgetPage.dart';

///首页
class PddIndexFirstPage extends StatefulWidget {
  @override
  _PddIndexFirstPageState createState() => _PddIndexFirstPageState();
}

class _PddIndexFirstPageState extends State<PddIndexFirstPage> {
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
  var listId = '';
  Future<int> getListData({int page = 1, bool isRef = false}) async {
    if (isRef) listId = '';
    var res = await BService.pddSearch(page,
        listId: listId)
        .catchError((v) {
      listDm.toError('网络异常');
    });
    if (res != null) {
      listId = res['minId'] ?? res['listId'] ?? '';
      listDm.addList(res['list'] ?? [], isRef, res['total'] ?? 0);
    }
    if (mounted) setState(() {});
    return listDm.flag;
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
          // return createItem(i, v);
          return createPddFadeContainer(context, i, v);
        },
      ),
    );
  }

  List<Widget> get headers {
    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(8, 12, 8, 4),
        child: Material(
          color: Colours.hb_bg,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => onTapDialogLogin(context, fun: () async {
              try {
                final word = await BService.pddSuperRedPackageLink();
                if (!mounted) return;
                await PddPromotion.open(context, word);
              } catch (_) {
                if (mounted) ToastUtils.showToast('红包领取失败，请稍后重试');
              }
            }),
            child: const Padding(
              padding: EdgeInsets.all(14),
              child: Row(children: [
                Icon(Icons.redeem_rounded, color: Colours.app_main),
                SizedBox(width: 10),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('拼多多超级红包', style: TextStyle(color: Colours.app_main, fontWeight: FontWeight.w600)),
                    SizedBox(height: 4),
                    Text('先领红包，再下单', style: TextStyle(color: Colours.dark_text_gray, fontSize: 12)),
                  ],
                )),
                Icon(Icons.chevron_right_rounded, color: Colours.app_main),
              ]),
            ),
          ),
        ),
      ),
    ];
  }
}
