import 'package:flutter/material.dart';
import 'package:maixs_utils/model/data_model.dart';
import 'package:maixs_utils/widget/anima_switch_widget.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';

import '../../widget/lunbo_widget.dart';

///首页顶部轮播
class BannerWidget extends StatefulWidget {
  final DataModel bannerDm;
  final Function? callback;
  const BannerWidget(this.bannerDm, this.callback, {Key? key, }) : super(key: key);
  @override
  _BannerWidgetState createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitchBuilder(
      value: widget.bannerDm,
      noDataView: PWidget.boxh(0),
      errorView: PWidget.boxh(0),
      initialState: PWidget.container(null, [double.infinity]),
      isAnimatedSize: false,
      listBuilder: (list, _, __) {
        return LunboWidget(
          widget.bannerDm.list,
          value: 'img',
          radius: 8,
          padding: [8,8,8,8],
          aspectRatio: (750+8) / (280 + 24),
          fun: (v) {
            widget.callback!(v);
          },
        );
      },
    );
  }
}
