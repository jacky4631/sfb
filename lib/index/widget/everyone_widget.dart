import 'package:flutter/material.dart';
import 'package:maixs_utils/model/data_model.dart';
import 'package:maixs_utils/widget/anima_switch_widget.dart';
import 'package:maixs_utils/widget/my_bouncing_scroll_physics.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:sufenbao/service.dart';

import '../../util/colors.dart';
import '../../util/global.dart';
import '../../page/product_details.dart';
import '../../widget/everyone_buy_history_widget.dart';
import '../../util/paixs_fun.dart';
import '../../widget/slide_progress_bar_widget.dart';

//大家都在领
class EveryoneWidget extends StatefulWidget {
  final DataModel dataModel;
  final Function? fun;
  const EveryoneWidget(this.dataModel, {Key? key, this.fun}) : super(key: key);
  @override
  _EveryoneWidgetState createState() => _EveryoneWidgetState();
}

class _EveryoneWidgetState extends State<EveryoneWidget> {
  ScrollController controller = ScrollController();
  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    setState(() {

    });
  }
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
        num collectCoupons = (DateTime.now().hour+8)*3888 + 2323;
        return PWidget.container(
          PWidget.ccolumn([
            PWidget.row([
              PWidget.text('大家都在领', [Colors.black.withOpacity(0.75), 16, true]),
              PWidget.spacer(),
              PWidget.text('', [], {}, [
                PWidget.textIs('$collectCoupons', [Colours.app_main, 16, true]),
                PWidget.textIs('\t今日实时领券', [Colors.black]),
              ]),
            ]),
            PWidget.boxh(8),
            EveryoneBuyHistoryWidget(
              bgColor: Colors.white,
              textColor: Colors.black45,
              text: '刚刚领取了优惠券',
            ),
            PWidget.boxh(8),
            PWidget.container(
              ListView.separated(
                itemCount: widget.dataModel.list.length.clamp(0, 5),
                controller: controller,
                scrollDirection: Axis.horizontal,
                physics: MyBouncingScrollPhysics(),
                separatorBuilder: (_, i) => VerticalDivider(color: Colors.transparent, width: 8),
                itemBuilder: (_, i) {
                  var data = widget.dataModel.list[i];
                  return PWidget.container(
                    Global.openFadeContainer(createItem(i, data), ProductDetails(data)),
                    [null, null, Colors.white],
                    {
                      'br': 8,
                      'mg': PFun.lg(0, 6),
                      'crr': [5,5,5,5]},
                  );;
                },
              ),
              [null, 166],
            ),
            PWidget.boxh(8),
            SlideProgressBarWidget(controller),
            // SlideProgressBarWidget(
            //   controller,
            //   bgBarColor: Colors.black12,
            //   barColor: Colors.red,
            //   barHeight: 16,
            //   barRadius: 16,
            //   barWidth: 56,
            //   bgBarWidth: pmSize.width - 24 - 32,
            // ),
            PWidget.boxh(8),
          ]),
          [null, null, Colors.white],
          {'br': 8, 'pd': 12, 'mg': PFun.lg(0, 16, 8, 8)},
        );
      },
    );
  }

  Widget createItem(i, data) {
    int couponReceiveNum = data['couponReceiveNum'];
    int couponTotalNum = data['couponTotalNum'];
    //一个随机数
    couponReceiveNum = ((couponTotalNum - couponReceiveNum)/(i%2==0?1.4:1.2)).toInt() + couponReceiveNum;
    String mainPic = data['mainPic'];
    return PWidget.container(
      PWidget.column([
        mainPic.startsWith('assets')
            ?
          PWidget.image(mainPic, [115, 115], {'ar': 1 / 1, 'br': 8})
            :
          PWidget.wrapperImage('${data['mainPic']}_310x310', {'ar': 1 / 1, 'br': 8}),
        PWidget.spacer(),
        PWidget.text('', [], {}, [
          PWidget.textIs('¥', [Colours.app_main, 12, true]),
          PWidget.textIs('${data['actualPrice']}', [Colours.app_main, 16, true]),
        ]),
        PWidget.spacer(),
        PWidget.text('已领${BService.formatNum(couponReceiveNum)}张券', [Colors.black45, 12], ),
      ]),
      [115],
      // jumpPage(ProductDetails(data)
      {'pd':4}
    );
  }
}
