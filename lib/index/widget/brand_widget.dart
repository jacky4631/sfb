import 'package:flutter/material.dart';
import 'package:sufenbao/service.dart';

import '../../models/data_model.dart';
import '../../util/colors.dart';

class CustomPagePhysics extends ScrollPhysics {
  const CustomPagePhysics({ScrollPhysics? parent}) : super(parent: parent);

  @override
  CustomPagePhysics applyTo(ScrollPhysics? ancestor) {
    return CustomPagePhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring => const SpringDescription(
        mass: 80,
        stiffness: 100,
        damping: 1,
      );
}

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
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/brandSalePage'),
      child: Container(
        margin: EdgeInsets.fromLTRB(8, 0, 8, 16),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '品牌特卖',
                  style: TextStyle(
                    color: Colors.black.withValues(alpha: 0.75),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  '今日上新$newUp款',
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 12,
                  ),
                ),
                Spacer(),
                Text(
                  '更多 >',
                  style: TextStyle(
                    color: Colours.app_main,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            Container(
              height: 48 + 88 + 48 + 12 + ((MediaQuery.of(context).size.width - 64) / 3) + 64,
              child: PageView.builder(
                itemCount: list.length.clamp(0, 3),
                physics: CustomPagePhysics(),
                onPageChanged: (i) => setState(() => page = i),
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, i) => itemView(list[i], (list[i]! as Map)['list']),
              ),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  list.length.clamp(0, 3),
                  (i) => Container(
                    width: 16,
                    height: 4,
                    margin: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: page == i ? 1 : 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget itemView(data, List productList) {
    var sales = BService.formatNum(data['sales']);
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                child: Image.network(
                  '${data['brandLogo']}_100x100',
                  width: 40,
                  height: 40,
                  fit: BoxFit.fitWidth,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 40,
                      height: 40,
                      color: Colors.grey[200],
                      child: Icon(Icons.image_not_supported, color: Colors.grey),
                    );
                  },
                ),
              ),
              SizedBox(width: 8),
              Text(
                data['brandName'],
                style: TextStyle(
                  color: Colors.black.withValues(alpha: 0.75),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Container(
            width: double.infinity,
            height: 112,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      '${data['background_img']}_310x310',
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
                Container(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['brand_text'],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Text(
                        data['brandFeatures'],
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Spacer(),
                      Text(
                        '已售$sales件>',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (productList.isNotEmpty) SizedBox(height: 12),
          if (productList.isNotEmpty)
            Container(
              height: ((MediaQuery.of(context).size.width - 64) / 3) + 64,
              child: Row(
                children: List.generate(productList.length.clamp(0, 4), (i) {
                  var product = productList[i];
                  var w = (MediaQuery.of(context).size.width - 64) / 3;
                  var sale = BService.formatNum(product['monthSales']);
                  return Container(
                    padding: EdgeInsets.all(4),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            product['mainPic'] + '_300x300',
                            width: w,
                            height: w,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: w,
                                height: w,
                                color: Colors.grey[200],
                                child: Icon(Icons.image_not_supported, color: Colors.grey),
                              );
                            },
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
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: '${product['actualPrice']}  ',
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
                          '已售$sale',
                          style: TextStyle(
                            color: Colors.black45,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}
