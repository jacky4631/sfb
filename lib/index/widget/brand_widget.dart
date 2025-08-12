import 'package:flutter/material.dart';
import 'package:maixs_utils/widget/anima_switch_widget.dart';
import 'package:maixs_utils/widget/custom_scroll_physics.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:sufenbao/service.dart';

import '../../models/data_model.dart';
import '../../util/colors.dart';
import '../../util/paixs_fun.dart';

///品牌特卖
class BrandWidget extends StatefulWidget {
  final DataModel dataModel;
  final Function? fun;

  const BrandWidget(this.dataModel, {Key? key, this.fun}) : super(key: key);
  @override
  _BrandWidgetState createState() => _BrandWidgetState();
}

class _BrandWidgetState extends State<BrandWidget> {
  int page = 0;

  @override
  Widget build(BuildContext context) {
    num newUp = (DateTime.now().hour + 8) * 1024 + 586;
    final list = widget.dataModel.list;
    return PWidget.container(
      PWidget.ccolumn([
        PWidget.row([
          PWidget.text('品牌特卖', [Colors.black.withOpacity(0.75), 16, true]),
          PWidget.boxw(8),
          PWidget.text('今日上新$newUp款', [Colors.black45, 12]),
          PWidget.spacer(),
          PWidget.text('更多 >', [Colours.app_main, 12]),
        ]),
        PWidget.container(
          PageView.builder(
            itemCount: list.length.clamp(0, 3),
            physics: PagePhysics(),
            onPageChanged: (i) => setState(() => page = i),
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, i) => itemView(list[i], (list[i]! as Map)['list']),
          ),
          [null, 48 + 88 + 48 + 12 + ((MediaQuery.of(context).size.width - 64) / 3) + 64],
        ),
        PWidget.row(
            List.generate(
                list.length.clamp(0, 3),
                (i) =>
                    PWidget.container(null, [16, 4, Colors.red.withOpacity(page == i ? 1 : 0.1)], {'br': 8, 'mg': 2})),
            '221'),
      ]),
      [null, null, Colors.white],
      {'br': 8, 'pd': 10, 'mg': PFun.lg(0, 16, 8, 8), 'fun': () => Navigator.pushNamed(context, '/brandSalePage')},
    );
  }

  Widget itemView(data, List productList) {
    var sales = BService.formatNum(data['sales']);
    return PWidget.container(
      PWidget.column([
        PWidget.row([
          PWidget.wrapperImage('${data['brandLogo']}_100x100', [40, 40], {'fit': BoxFit.fitWidth}),
          PWidget.boxw(8),
          PWidget.text(data['brandName'], [Colors.black.withOpacity(0.75), 16, true]),
        ]),
        PWidget.boxh(8),
        PWidget.container(
          Stack(children: [
            Positioned.fill(child: PWidget.wrapperImage('${data['background_img']}_310x310')),
            PWidget.container(
              PWidget.column([
                PWidget.text(data['brand_text'], [Colors.white, 16, true]),
                PWidget.spacer(),
                PWidget.text(data['brandFeatures'], [Colors.white]),
                PWidget.spacer(),
                PWidget.text('已售$sales件>', [Colors.white]),
              ]),
              {'pd': 12},
            ),
          ]),
          [double.infinity, 112],
          {'crr': 12},
        ),
        if (productList.isNotEmpty) PWidget.boxh(12),
        if (productList.isNotEmpty)
          PWidget.container(
            PWidget.row(
              List.generate(productList.length.clamp(0, 4), (i) {
                var product = productList[i];
                var w = (MediaQuery.of(context).size.width - 64) / 3;
                var sale = BService.formatNum(product['monthSales']);
                return PWidget.container(
                  PWidget.column([
                    PWidget.wrapperImage(product['mainPic'] + '_300x300', [w, w], {'br': 12}),
                    PWidget.spacer(),
                    PWidget.text('', [], {}, [
                      PWidget.textIs('¥', [Colours.app_main, 16, true]),
                      PWidget.textIs('${product['actualPrice']}  ', [Colours.app_main, 16, true]),
                    ]),
                    PWidget.spacer(),
                    PWidget.text('已售$sale', [Colors.black45, 12]),
                  ]),
                  {'pd': 4},
                );
              }),
              {'pd': 0},
            ),
            [null, ((MediaQuery.of(context).size.width - 64) / 3) + 64],
          ),
      ]),
      [null, null, Colors.white],
      {'br': 12, 'pd': 12},
    );
  }
}
