import 'package:flutter/material.dart';

import '../../models/data_model.dart';
import '../../util/global.dart';
import '../../widget/lunbo_widget.dart';

//首页圆形轮播
class TilesWidget extends StatefulWidget {
  final DataModel tilesDm;
  const TilesWidget(
    this.tilesDm, {
    Key? key,
  }) : super(key: key);
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<TilesWidget> {
  @override
  Widget build(BuildContext context) {
    return LunboWidget(
      widget.tilesDm.list,
      value: 'img',
      radius: 8,
      margin: 16,
      padding: [16, 8, 8, 8],
      aspectRatio: 710 / (170 + 30),
      fun: (v) {
        ///点击事件
        Global.kuParse(context, v);
      },
    );
  }
}
