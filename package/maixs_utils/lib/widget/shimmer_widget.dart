import 'package:flutter/material.dart';
import '../widget/views.dart';
import 'package:shimmer/shimmer.dart';

import 'mytext.dart';

enum ShimmerType {
  loupan,
  loupanInfo,
  xinFang,
  xinFangCard,
  xinFangInfo,
  louPanImgCard,
  lunboCard,
  videoCard,
  plCard,
  yxsphCard,
}

class ShimmerWidget extends StatelessWidget {
  final ShimmerType type;
  final String text;
  final Color textColor;
  final String redText;
  final Function? callBack;
  final Color color;

  const ShimmerWidget({
    Key? key,
    this.type = ShimmerType.loupanInfo,
    required this.text,
    this.callBack,
    this.redText = '点击重试',
    this.color = Colors.white,
    this.textColor = const Color(0xff999999),
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Map views = {
      ShimmerType.loupan: buildWrap(context),
      ShimmerType.loupanInfo: buildLouPanInfoView(),
      ShimmerType.xinFang: buildXinfangView(context),
      ShimmerType.xinFangCard: buildXinfangCardView(context),
      ShimmerType.xinFangInfo: buildXinfangInfoView(context),
      ShimmerType.louPanImgCard: buildLouPanImgCardView(context),
      ShimmerType.lunboCard: buildLunBoCardView(context),
      ShimmerType.videoCard: buildVideoCardView(context),
      ShimmerType.plCard: buildPlCardView(context),
      ShimmerType.yxsphCard: Container(
        height: 56,
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(8),
        ),
        margin: EdgeInsets.symmetric(horizontal: 16),
      ),
    };

    var isToken = text.contains('token');
    return Container(
      color: color,
      alignment: Alignment.center,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 250),
        child: text == null
            ? Shimmer.fromColors(
                child: views[type],
                baseColor: Colors.grey,
                highlightColor: Colors.white,
              )
            : GestureDetector(
                onTap: callBack == null ? () {} : () => callBack!(),
                child: MyText(
                  isToken ? '登录状态已过期' : text,
                  size: 16,
                  color: textColor,
                  textAlign: TextAlign.center,
                  isOverflow: false,
                  children: [
                    MyText.ts(
                      callBack == null ? '' : (isToken ? '' : '\t$redText'),
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  ///热门楼盘view
  Widget buildWrap(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: List.generate(4, (i) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: (size(context).width / 2) - 15,
              height: 86,
              color: Colors.black12,
            ),
          );
        }),
      ),
    );
  }

  ///楼盘信息
  Widget buildLouPanInfoView() {
    return Column(
      children: List.generate(3, (i) {
        return Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(8),
            ),
            margin: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
            ),
          ),
        );
      }),
    );
  }

  ///新房
  Widget buildXinfangView(context) {
    var boxDecoration = BoxDecoration(
      color: Colors.black12,
      borderRadius: BorderRadius.circular(8),
    );
    return Column(
      children: <Widget>[
        Container(
          height: size(context).width / 2.5,
          margin: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: 8,
          ),
          decoration: boxDecoration,
        ),
        Container(
          height: 40,
          margin: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 8,
            bottom: 8,
          ),
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(56),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (_, i) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 112,
                      height: 112,
                      decoration: boxDecoration,
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Color(0x20000000),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            itemCount: 5,
          ),
        ),
      ],
    );
  }

  ///新房详情
  Widget buildXinfangInfoView(context) {
    var boxDecoration = BoxDecoration(
      color: Colors.black12,
      borderRadius: BorderRadius.circular(8),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 260,
          margin: EdgeInsets.only(bottom: 8),
          color: Colors.black12,
        ),
        Container(
          height: 40,
          margin: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 8,
            bottom: 8,
          ),
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(56),
          ),
        ),
        Container(
          height: 40,
          width: size(context).width / 3,
          margin: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 8,
            bottom: 8,
          ),
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(56),
          ),
        ),
        Container(
          height: 40,
          width: size(context).width / 2,
          margin: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 8,
            bottom: 8,
          ),
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(56),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (_, i) {
              if (i == 1)
                return Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 8,
                    bottom: 8,
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              return Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 8,
                  bottom: 8,
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: 80,
                        decoration: boxDecoration,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        height: 80,
                        decoration: boxDecoration,
                      ),
                    ),
                  ],
                ),
              );
            },
            itemCount: 2,
          ),
        ),
      ],
    );
  }

  ///新房
  Widget buildXinfangCardView(context) {
    var boxDecoration = BoxDecoration(
      color: Colors.black12,
      borderRadius: BorderRadius.circular(3),
    );
    return Row(
      children: <Widget>[
        Container(
          height: 80,
          width: 112,
          margin: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: 8,
          ),
          decoration: boxDecoration,
        ),
        Expanded(
          child: Container(
            height: 80,
            margin: EdgeInsets.only(
              right: 16,
              top: 16,
              bottom: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ),
      ],
    );
  }

  ///楼盘图片
  Widget buildLouPanImgCardView(context) {
    var boxDecoration = BoxDecoration(
      color: Colors.black12,
      borderRadius: BorderRadius.circular(8),
    );
    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (_, i) {
        return Row(
          children: <Widget>[
            Container(
              height: 112,
              width: 112,
              margin: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: 8,
              ),
              decoration: boxDecoration,
            ),
            Expanded(
              child: Container(
                height: 80,
                margin: EdgeInsets.only(
                  right: 16,
                  top: 8,
                  bottom: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  ///轮播
  Widget buildLunBoCardView(context) {
    return Container(
      color: Colors.black12,
    );
  }

  ///视频看房
  Widget buildVideoCardView(context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1 / 1.3,
      ),
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(left: 10, right: 10, top: 16),
      itemCount: 10,
      itemBuilder: (_, i) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            color: Colors.black12,
          ),
        );
      },
    );
  }

  ///视频看房
  Widget buildPlCardView(context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(left: 16, right: 16),
      itemCount: 10,
      itemBuilder: (_, i) {
        return Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 6),
                child: ClipOval(
                  child: Container(
                    width: 38,
                    height: 38,
                    color: Colors.black12,
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    height: 72,
                    color: Colors.black12,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
