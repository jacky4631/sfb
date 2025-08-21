/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'dart:ui';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:sufenbao/dy/dy_detail_page.dart';
import 'package:sufenbao/util/toast_utils.dart';
import 'package:sufenbao/service.dart';
import 'package:sufenbao/util/global.dart';
import 'package:sufenbao/vip/vip_detail_page.dart';

import '../hb/red_packet.dart';
import '../httpUrl.dart';
import '../jd/jd_details_page.dart' hide DataModel;
import '../me/listener/PersonalNotifier.dart';
import '../page/product_details.dart';
import '../pdd/pdd_detail_page.dart';
import '../util/colors.dart';
import '../widget/CustomWidgetPage.dart';
import '../widget/order_tab_widget.dart';

//订单明细
class OrderListSecond extends StatefulWidget {
  final Map data;
  const OrderListSecond(
    this.data, {
    Key? key,
  }) : super(key: key);

  @override
  _OrderListSecondState createState() => _OrderListSecondState();
}

class _OrderListSecondState extends State<OrderListSecond> {
  List<Map> _tabList = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  ///初始化函数
  Future<void> _initData() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
       var res = await BService.orderTab(widget.data['level'], widget.data['innerType']);
       if (mounted) {
         setState(() {
           _tabList = List<Map>.from(res);
           _isLoading = false;
           _hasError = false;
         });
       }
     } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('加载失败，请重试', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _initData,
              child: Text('重试'),
            ),
          ],
        ),
      );
    }

    int page = 0;
    if (widget.data['page'] != null) {
      page = widget.data['page'];
    }

    return OrderTabWidget(
      color: Colours.app_main,
      unselectedColor: Colors.black.withValues(alpha: 0.5),
      indicatorColor: Colours.app_main,
      page: page,
      fontSize: 15,
      tabList: _tabList,
      indicatorWeight: 2,
      padding: EdgeInsets.only(top: 10),
      labelBgColor: Colours.app_main,
      tabPage: List.generate(_tabList.length, (i) {
        return TopChild(i, widget.data);
      }),
    );
  }
}

class TopChild extends StatefulWidget {
  final int index;
  final Map data;
  const TopChild(this.index, this.data, {Key? key}) : super(key: key);

  @override
  _TopChildState createState() => _TopChildState();
}

class _TopChildState extends State<TopChild> {
  List<Map> _orderList = [];
  bool _isLoading = true;
  bool _hasError = false;
  bool _hasMore = true;
  int _currentPage = 1;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  ///初始化函数
  Future<void> _initData() async {
    await _getListData(isRefresh: true);
  }

  ///列表数据
  Future<void> _getListData({int page = 1, bool isRefresh = false}) async {
    if (isRefresh) {
      setState(() {
        _isLoading = true;
        _hasError = false;
        _currentPage = 1;
      });
    } else {
      setState(() {
        _isLoadingMore = true;
      });
    }

    try {
      int innerType = widget.data['innerType'];
      Map param = _getPlatformData(widget.index, 0);
      var res = await BService.taoOrders(page, param, level: widget.data['level'], innerType: innerType);
       
       if (mounted) {
         setState(() {
           if (isRefresh) {
             _orderList = List<Map>.from(res?['content'] ?? []);
           } else {
             _orderList.addAll(List<Map>.from(res?['content'] ?? []));
           }
           _hasMore = _orderList.length < (res?['totalElements'] ?? 0);
           _currentPage = page;
           _isLoading = false;
           _isLoadingMore = false;
           _hasError = false;
         });
       }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isLoadingMore = false;
          _hasError = true;
        });
      }
    }
  }

  Future<void> _onRefresh() async {
    await _getListData(isRefresh: true);
  }

  Future<void> _onLoadMore() async {
    if (!_hasMore || _isLoadingMore) return;
    await _getListData(page: _currentPage + 1);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colours.app_main),
        ),
      );
    }

    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('加载失败，请重试', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _getListData(isRefresh: true),
              child: Text('重试'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
              _hasMore &&
              !_isLoadingMore) {
            _onLoadMore();
          }
          return false;
        },
        child: ListView.separated(
          padding: EdgeInsets.all(8),
          itemCount: _orderList.length + (_hasMore ? 1 : 0),
          separatorBuilder: (context, index) => SizedBox(height: 4),
          itemBuilder: (context, index) {
            if (index == _orderList.length) {
              return Container(
                padding: EdgeInsets.all(16),
                alignment: Alignment.center,
                child: _isLoadingMore
                    ? CircularProgressIndicator()
                    : Text('没有更多数据了', style: TextStyle(color: Colors.grey)),
              );
            }
            Map data = _orderList[index];
            return _getPlatformWidget(widget.index, data);
          },
        ),
      ),
    );
  }

  /**
   * type=0是接口数据， type = 1是组件数据
   * */
  _getPlatformData(int index, int type) {
    switch (index) {
      case 0:
        return {"api": API.taoOrders, "sort": 'tk_create_time'};
      case 1:
        return {"api": API.jdOrders, "sort": 'order_time'};
      case 2:
        return {"api": API.pddOrders, "sort": 'order_create_time'};
      case 3:
        return {"api": API.dyOrders, "sort": 'pay_success_time'};
      case 4:
        return {"api": API.vipOrders, "sort": 'order_time'};
      case 5:
        return {"api": API.mtOrders, "sort": 'order_pay_time'};
      default:
        return {"api": API.taoOrders, "sort": 'tk_create_time'};
    }
  }

  Widget _getPlatformWidget(int index, Map data) {
    switch (index) {
      case 0:
        return _buildTaoWidget(data);
      case 1:
        return _buildJdWidget(data);
      case 2:
        return _buildPddWidget(data);
      case 3:
        return _buildDyWidget(data);
      case 4:
        return _buildVipWidget(data);
      case 5:
        return _buildMtWidget(data);
      default:
        return _buildTaoWidget(data);
    }
  }

  Widget _buildTaoWidget(Map data) {
    String img = BService.formatUrl(data['itemImg']);
    num fee = data['pubSharePreFee'];
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () => _showRed(data, data['tradeParentId'], fee, 'tb'),
        child: _createGoodsDesc(
          data,
          data['itemTitle'],
          data['tradeParentId'],
          data['alipayTotalPrice'] ?? 0,
          fee,
          data['tkCreateTime'],
          'tb',
          img,
          data['orderType'] == '天猫' ? 'assets/images/mall/tm.png' : 'assets/images/mall/tb.png',
        ),
      ),
    );
  }

  Widget _buildJdWidget(Map data) {
    num price = data['estimateCosPrice'];
    num fee = data['estimateFee'];
    if (price == 0) {
      fee = 0;
    }
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () => _showRed(data, data['orderId'], fee, 'jd'),
        child: _createGoodsDesc(
          data,
          data['skuName'],
          data['orderId'],
          price,
          fee,
          data['orderTime'],
          'jd',
          data['goodsInfo']['imageUrl'],
          'assets/images/mall/jd.png',
        ),
      ),
    );
  }

  Widget _buildPddWidget(Map data) {
    num fee = data['promotionAmount'] / 100;
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () => _showRed(data, data['orderSn'], fee, 'pdd'),
        child: _createGoodsDesc(
          data,
          data['goodsName'],
          data['orderSn'],
          data['orderAmount'] != null ? data['orderAmount'] / 100 : 0,
          fee,
          data['orderCreateTime'],
          'pdd',
          data['goodsThumbnailUrl'],
          'assets/images/mall/pdd.png',
        ),
      ),
    );
  }

  Widget _buildDyWidget(Map data) {
    num fee = data['estimatedTotalCommission'];
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () => _showRed(data, data['orderId'], fee, 'dy'),
        child: _createGoodsDesc(
          data,
          data['productName'],
          data['orderId'],
          data['totalPayAmount'],
          fee,
          data['paySuccessTime'],
          'dy',
          data['productImg'],
          'assets/images/mall/dy.png',
        ),
      ),
    );
  }

  Widget _buildVipWidget(Map data) {
    num fee = double.parse(data['commission']);
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () => _showRed(data, data['orderSn'], fee, 'vip'),
        child: _createGoodsDesc(
          data,
          data['detailList'][0]['goodsName'],
          data['orderSn'],
          data['totalCost'],
          fee,
          data['orderTime'],
          'vip',
          data['detailList'][0]['goodsThumb'],
          'assets/images/mall/vip.png',
        ),
      ),
    );
  }

  Widget _buildMtWidget(Map data) {
    num price = data['actualItemAmount'];
    num fee = data['balanceAmount'];
    String orderType = data['orderType'];

    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () => _showRed(data, data['uniqueItemId'], fee, 'jd'),
        child: _createGoodsDesc(
          data,
          data['shopName'],
          data['orderId'],
          price,
          fee,
          data['orderPayTime'],
          'mt',
          orderType == '外卖' ? 'assets/images/mall/mtwm_bg.png' : 'assets/images/mall/mt_bg.png',
          'assets/images/mall/mt.png',
        ),
      ),
    );
  }

  Future _showRed(data, orderId, num fee, type) async {
    var remain = data['remain'];
    if (remain == 'err') {
      ToastUtils.showToast('红包已失效');
      return;
    }
    if (data['bind'] == 1) {
      ToastUtils.showToast('红包已领取');
      return;
    }
    int index = widget.data['index'];
    if (index == 1 || index == 2 || index == 3) {
      ToastUtils.showToast('这不是您的订单哦');
      return;
    }
    showRedPacket(context, fee, type, () async {
      if (remain != 'ok') {
        await Future.delayed(Duration(seconds: 1));
        ToastUtils.showToast('红包尚未解锁');
        return;
      }
      await Future.delayed(Duration(milliseconds: 400));
      //京东订单可能相同订单号，商品不同，使用skuId做区分
      int skuId = 0;
      if (type == 'jd') {
        skuId = data['skuId'];
      }
      Map res = await BService.spreadHb(orderId, type, skuId: skuId);
      if (!res['success']) {
        ToastUtils.showToast(res['msg']);
        return;
      }
      num hb = res['data']['hb'];
      String desc = '\n￥$hb';

      AwesomeDialog(
        dismissOnTouchOutside: false,
        dismissOnBackKeyPress: false,
        context: context,
        dialogType: DialogType.noHeader,
        title: '恭喜您获得',
        titleTextStyle: TextStyle(color: Colors.white),
        desc: desc,
        dialogBackgroundColor: Colors.redAccent,
        descTextStyle: TextStyle(color: Colors.white, fontSize: 24),
        btnOkColor: Color(0xFFE5CDA8),
        btnOkText: '确定',
        btnOkOnPress: () async {
          data['bind'] = 1;
          data['hb'] = res['data']['hb'];
          data['baseHb'] = res['data']['baseHb'];
          data['shopHb'] = res['data']['shopHb'];
          personalNotifier.value = true;
          setState(() {});
        },
      )..show();
    });
  }

  Widget _createImageWidget(String img, String logo, Map data, String type) {
    Widget imgWidget;
    if (widget.data['level'] > 0 && isBlur) {
      imgWidget = ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
          child: type == 'mt'
              ? Image.asset(img, width: 124, height: 124, fit: BoxFit.cover)
              : Image.network(
                  img,
                  width: 124,
                  height: 124,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 124,
                      height: 124,
                      color: Colors.grey[200],
                      child: Icon(Icons.image, color: Colors.grey),
                    );
                  },
                ),
        ),
      );
    } else {
      if (type == 'mt') {
        imgWidget = Image.asset(img, width: 124, height: 124, fit: BoxFit.cover);
      } else {
        Widget detailPage = SizedBox();
        switch (type) {
          case 'tb':
            detailPage = ProductDetails(data);
            break;
          case 'jd':
            detailPage = JDDetailsPage(data);
            break;
          case 'pdd':
            detailPage = PddDetailPage(data);
            break;
          case 'dy':
            detailPage = DyDetailPage(data);
            break;
          case 'vip':
            data['category'] = 'vip';
            detailPage = VipDetailPage(data);
            break;
        }

        imgWidget = Global.openFadeContainer(
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              img,
              width: 124,
              height: 124,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 124,
                  height: 124,
                  color: Colors.grey[200],
                  child: Icon(Icons.image, color: Colors.grey),
                );
              },
            ),
          ),
          detailPage,
        );
      }
    }

    return Stack(
      children: [
        imgWidget,
        Positioned(
          top: 0,
          left: 0,
          child: Image.asset(
            logo,
            width: 16,
            height: 16,
            fit: BoxFit.fill,
          ),
        ),
      ],
    );
  }

  Widget _createGoodsDesc(Map data, String title, orderSn, num price, num fee, String createTime, String type, String img, String imgTag) {
    var remain = data['remain'];
    var bind = data['bind'];
    var hb = data['baseHb'];
    if (hb == null || hb == 0) {
      hb = data['hb'];
    }

    var unlockText = '红包解锁时间$remain';
    var okText = '待解锁';
    var okBg = 'ljq.jpg';
    bool notValid = remain == 'err';
    //如果已经绑定说明用户领过红包，直接显示红包数量
    if (bind == 1) {
      unlockText = '奖励$hb元';
      var shopHb = data['shopHb'];
      if (shopHb != null && shopHb > 0) {
        unlockText = '$unlockText,星选奖励$shopHb元';
      }
      okText = '已拆';
      okBg = 'ljq_disabled.png';
    } else if (remain == 'ok') {
      okText = '拆红包';
      unlockText = '红包已解锁';
    } else if (bind == 3 || notValid) {
      okText = '已失效';
      unlockText = '红包失效';
      okBg = 'ljq_disabled.png';
    }

    String orderNo = orderSn.toString();
    //下级订单 热度订单 隐藏订单后6位
    if (widget.data['level'] > 0 || widget.data['innerType'] == 2) {
      orderNo = orderNo.substring(0, orderNo.length - 6) + '******';
    }

    if (widget.data['level'] > 0 && isBlur) {
      title = '********************';
    }

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _createImageWidget(img, imgTag, data, type),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.black.withValues(alpha: 0.75),
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '订单号  ',
                          style: TextStyle(color: Colors.black45, fontSize: 12),
                        ),
                        TextSpan(
                          text: orderNo,
                          style: TextStyle(color: Colors.black45, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '付款时间  ',
                          style: TextStyle(color: Colors.black45, fontSize: 12),
                        ),
                        TextSpan(
                          text: createTime,
                          style: TextStyle(color: Colors.black45, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  if (!notValid && bind == 0) SizedBox(height: 4),
                  if (!notValid && bind == 0)
                    getMoneyWidget(
                      context,
                      fee,
                      type,
                      canClick: false,
                      column: false,
                      txtSize: 14,
                      br: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '实付￥',
                            style: TextStyle(color: Colors.black45, fontSize: 12),
                          ),
                          TextSpan(
                            text: '$price',
                            style: TextStyle(color: Colors.red, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Stack(
          alignment: Alignment.centerRight,
          children: [
            Container(
              width: double.infinity,
              height: 32,
              margin: EdgeInsets.only(right: 45),
              padding: EdgeInsets.only(left: 8, bottom: 8),
              decoration: BoxDecoration(
                color: Color(0xffFAEDE6),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                ),
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                unlockText,
                style: TextStyle(
                  color: Color(0xffDF5C12),
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/images/mall/$okBg',
                  width: 90,
                  height: 39,
                ),
                okText == '拆红包'
                    ? rainbowText(
                        okText,
                        onTap: () => _showRed(data, orderSn, fee, type),
                      )
                    : Padding(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          okText,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
