import 'dart:async';

import 'package:flutter/material.dart';

import '../../models/data_model.dart';
import '../../util/colors.dart';

///热销榜和限时秒杀
class CardWidget extends StatefulWidget {
  final DataModel cardDm;
  final Function? fun;

  const CardWidget(this.cardDm, {Key? key, this.fun}) : super(key: key);
  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  @override
  Widget build(BuildContext context) {
    var list = widget.cardDm.value;
    return Container(
      padding: EdgeInsets.fromLTRB(8, 0, 8, 16),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/top'),
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '实时榜单',
                          style: TextStyle(
                            color: Colors.black.withValues(alpha: 0.75),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: List.generate(list.length + 1, (i) {
                            if (i == 1) return SizedBox(width: 8);
                            if (i > 0) i = i - 1;
                            var mainPic = list[i]['mainPic'];
                            var actualPrice = list[i]['actualPrice'];
                            var twoHoursSalesStr = '';
                            var twoHoursSales = list[i]['twoHoursSales'] as int;
                            twoHoursSalesStr = '$twoHoursSales';
                            if (twoHoursSales >= 10000)
                              twoHoursSalesStr = '${'$twoHoursSales'.substring(0, '$twoHoursSales'.length - 3)}万';
                            return itemView('${i + 1}', '${mainPic}_310x310', '2小时抢$twoHoursSalesStr', '¥$actualPrice');
                          }),
                        ),
                      ],
                    ),
                    Positioned(
                      top: 4,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '实时好货',
                          style: TextStyle(
                            color: Colors.black45,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Builder(builder: (context) {
              List goodsList = [];
              List roundsList = [];
              if (widget.cardDm.object.isNotEmpty) {
                goodsList = widget.cardDm.object['goodsList'] as List;
                if (goodsList.length > 2) {
                  goodsList = goodsList.sublist(0, 2);
                }
                roundsList = widget.cardDm.object['roundsList'] as List;
              }
              return GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/ddq'),
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '限时秒杀',
                            style: TextStyle(
                              color: Colors.black.withValues(alpha: 0.75),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          if (goodsList.isNotEmpty)
                            Row(
                              children: List.generate(goodsList.length + 1, (i) {
                                if (i == 1) return SizedBox(width: 8);
                                if (i > 0) i = i - 1;
                                var mainPic = goodsList[i]['mainPic'];
                                var specialText = (goodsList[i]['specialText'] ?? []) as List;
                                var actualPrice = goodsList[i]['actualPrice'];
                                return itemView(
                                    '${i + 1}', '${mainPic}_310x310', '${specialText.join('')}', '¥$actualPrice',
                                    rexiao: false);
                              }),
                            ),
                        ],
                      ),
                      Positioned(
                        top: 4,
                        right: 0,
                        child: Builder(builder: (context) {
                          var first = roundsList.where((w) => w['status'] == 2).first;
                          return CardCountDownWidget(DateTime.parse(first['ddqTime']), fun: () {});
                        }),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget itemView(i, img, text, value, {gd, bool rexiao = true}) {
    return Expanded(
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: AspectRatio(
              aspectRatio: 1 / 1,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      img,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: Icon(Icons.image_not_supported, color: Colors.grey),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 2),
            decoration: BoxDecoration(
              color: !rexiao ? Colors.white : null,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: Colors.black45,
                fontSize: 10,
              ),
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: Colours.app_main,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

///限时秒杀倒计时
class CardCountDownWidget extends StatefulWidget {
  final DateTime dateTime;
  final Function fun;

  const CardCountDownWidget(this.dateTime, {Key? key, required this.fun}) : super(key: key);
  @override
  _CardCountDownWidgetState createState() => _CardCountDownWidgetState();
}

class _CardCountDownWidgetState extends State<CardCountDownWidget> {
  late Timer timer;

  Duration duration = const Duration();

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      duration = widget.dateTime.difference(DateTime.now());
      if (duration.inSeconds <= 0) {
        timer.cancel();
        widget.fun();
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var timeStr = '${DateTime.now().hour}点场';
    return Container(
      padding: EdgeInsets.fromLTRB(6, 0, 6, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$timeStr${'$duration'.split('.').first}',
        style: TextStyle(
          color: Colors.black45,
          fontSize: 12,
        ),
      ),
    );
  }
}
