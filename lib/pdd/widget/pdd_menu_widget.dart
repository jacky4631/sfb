/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:maixs_utils/model/data_model.dart';
import 'package:maixs_utils/widget/anima_switch_widget.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/views.dart';

import '../../util/paixs_fun.dart';

///菜单组件
class PddMenuWidget extends StatefulWidget {
  final DataModel dataModel;
  final Function? fun;
  final int count;
  final Function(Map)? onTap;
  const PddMenuWidget(this.dataModel, {Key? key, this.count = 10, this.fun, this.onTap}) : super(key: key);
  @override
  _PddMenuWidgetState createState() => _PddMenuWidgetState();
}

class _PddMenuWidgetState extends State<PddMenuWidget> {
  int page = 0;
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitchBuilder(
      value: widget.dataModel,
      errorOnTap: () => widget.fun!(),
      noDataView: PWidget.boxh(0),
      errorView: PWidget.boxh(0),
      initialState: PWidget.container(null, [double.infinity]),
      isAnimatedSize: false,
      listBuilder: (list, p, h) {
            return PWidget.container(
              Wrap(
                children: List.generate(list.length, (i) {
                  var wh = (pmSize.width - 16) / 5;
                  var icon = list[i] as Map;
                  return PWidget.container(
                    PWidget.ccolumn([
                      PWidget.image('${icon['img']}', [56, 56]),
                      PWidget.spacer(),
                      PWidget.text('${icon['title']}'),
                      PWidget.spacer(),
                    ]),
                    [wh, 80],
                    {'fun': () => widget.onTap!(icon)},
                  );
                }),
              ),
              {'pd': PFun.lg(0, 0, 8, 8)},
            );
      },
    );
  }
}
