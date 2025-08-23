import 'package:flutter/material.dart';
import 'package:sufenbao/service.dart';

import '../../util/colors.dart';
import '../../util/global.dart';
import '../../page/product_details.dart';
import '../../widget/everyone_buy_history_widget.dart';
import '../../widget/slide_progress_bar_widget.dart';
import '../../models/data_model.dart';

class SimpleAnimatedSwitchBuilder extends StatelessWidget {
  final DataModel value;
  final VoidCallback? errorOnTap;
  final Widget noDataView;
  final Widget errorView;
  final Widget initialState;
  final Widget Function(List list, int p, int h) listBuilder;

  const SimpleAnimatedSwitchBuilder({
    Key? key,
    required this.value,
    this.errorOnTap,
    required this.noDataView,
    required this.errorView,
    required this.initialState,
    required this.listBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (value.flag == -1) {
      return GestureDetector(
        onTap: errorOnTap,
        child: errorView,
      );
    }

    if (value.list.isEmpty) {
      return noDataView;
    }

    return listBuilder(value.list, 0, 0);
  }
}

class CustomBouncingScrollPhysics extends ScrollPhysics {
  const CustomBouncingScrollPhysics({ScrollPhysics? parent}) : super(parent: parent);

  @override
  CustomBouncingScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomBouncingScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring => const SpringDescription(
        mass: 0.5,
        stiffness: 100,
        damping: 0.8,
      );

  @override
  double get minFlingVelocity => 100.0;

  @override
  double get maxFlingVelocity => 4000.0;
}

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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SimpleAnimatedSwitchBuilder(
      value: widget.dataModel,
      errorOnTap: () => widget.fun!(),
      noDataView: SizedBox(height: 0),
      errorView: SizedBox(height: 0),
      initialState: Container(
        width: double.infinity,
      ),
      listBuilder: (list, p, h) {
        num collectCoupons = (DateTime.now().hour + 8) * 3888 + 2323;
        return Container(
          margin: EdgeInsets.fromLTRB(0, 16, 8, 8),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    '大家都在领',
                    style: TextStyle(
                      color: Colors.black.withValues(alpha: 0.75),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '$collectCoupons',
                          style: TextStyle(
                            color: Colours.app_main,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: '\t今日实时领券',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              EveryoneBuyHistoryWidget(
                bgColor: Colors.white,
                textColor: Colors.black45,
                text: '刚刚领取了优惠券',
              ),
              SizedBox(height: 8),
              Container(
                height: 166,
                child: ListView.separated(
                  itemCount: widget.dataModel.list.length.clamp(0, 5),
                  controller: controller,
                  scrollDirection: Axis.horizontal,
                  physics: CustomBouncingScrollPhysics(),
                  separatorBuilder: (_, i) => VerticalDivider(color: Colors.transparent, width: 8),
                  itemBuilder: (_, i) {
                    var data = widget.dataModel.list[i];
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Global.openFadeContainer(createItem(i, data), ProductDetails(data)),
                    );
                  },
                ),
              ),
              SizedBox(height: 8),
              SlideProgressBarWidget(controller),
              SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget createItem(i, data) {
    int couponReceiveNum = data['couponReceiveNum'];
    int couponTotalNum = data['couponTotalNum'];
    //一个随机数
    couponReceiveNum = ((couponTotalNum - couponReceiveNum) / (i % 2 == 0 ? 1.4 : 1.2)).toInt() + couponReceiveNum;
    String mainPic = data['mainPic'];
    return Container(
      width: 115,
      padding: EdgeInsets.all(4),
      child: Column(
        children: [
          mainPic.startsWith('assets')
              ? Container(
                  width: 115,
                  height: 115,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      mainPic,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : Container(
                  width: 115,
                  height: 115,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      '${data['mainPic']}_310x310',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: Icon(Icons.image_not_supported, color: Colors.grey),
                        );
                      },
                    ),
                  ),
                ),
          Spacer(),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '¥',
                  style: TextStyle(
                    color: Colours.app_main,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: '${data['actualPrice']}',
                  style: TextStyle(
                    color: Colours.app_main,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          Text(
            '已领${BService.formatNum(couponReceiveNum)}张券',
            style: TextStyle(
              color: Colors.black45,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
