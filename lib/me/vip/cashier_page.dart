/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fluwx/fluwx.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'package:pinput/pinput.dart';
import 'package:sufenbao/util/global.dart';
import 'package:sufenbao/util/toast_utils.dart';
import 'package:tobias/tobias.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../service.dart';
import '../../../util/colors.dart';
import '../../pay/ios_payment_state.dart';

import '../../widget/CustomWidgetPage.dart';
import '../../widget/custom_button.dart';
import '../../widget/load_image.dart';
import '../../widget/loading.dart';
import '../../widget/my_scroll_view.dart';
import '../listener/PersonalNotifier.dart';
import '../listener/WxPayNotifier.dart';

class CashierPage extends StatefulWidget {
  final Map data;

  const CashierPage(this.data, {Key? key}) : super(key: key);

  @override
  _CashierPageState createState() => _CashierPageState(this.data);
}

class _CashierPageState extends IOSPaymentState {
  final Map data;
  _CashierPageState(this.data);

  //1=支付宝 2=微信 3=银行卡
  int _withdrawalType = 1;
  num price = 0;
  String rechargeId = '';
  String platform = '';
  bool loading = true;
  num coupon = 0;
  num endPrice = 0;
  String start = '';
  String end = '00';
  String alipayE = '1';
  String wechatE = '0';
  String bankE = '0';
  String bindBank = '0';
  String ac = '0';
  String wc = '0';
  String bc = '0';
  String bbc = '0';
  List cardList = [];
  int rechargeType = 0;
  num valid = 0;

  @override
  void initState() {
    super.initState();
    initData();
    wxPayNotifier.addListener(_wechatPayCallback);
  }

  void _wechatPayCallback() {
    WeChatResponse res = wxPayNotifier.value;
    if (res != null && res is WeChatPaymentResponse) {
      WeChatPaymentResponse payRes = res;
      if (payRes.errCode == 0) {
        ToastUtils.showToast('支付成功');
        refreshAfterPaySuccess();
      } else if (payRes.errCode == -2) {
        ToastUtils.showToast('用户取消支付了');
      } else {
        ToastUtils.showToast('支付失败原因：${payRes.errStr}');
      }
    }
  }

  refreshVd() {
    personalNotifier.value = true;
  }

  //iOS支付回调
  @override
  Future<void> deliverProduct(PurchaseDetails purchaseDetails) async {
    super.deliverProduct(purchaseDetails);
    ToastUtils.showToast('支付成功');
    Future.delayed(Duration(seconds: 1)).then((value) => {refreshAfterPaySuccess()});
  }

  Future initData() async {
    bool isIos = Global.isIOS();
    if(!isIos) {
      getListData();
    }

    rechargeId = this.data['rechargeId'];
    platform = this.data['platform'];
    price = this.data['price'];
    rechargeType = this.data['rechargeType'];
    valid = this.data['valid'];
    Map res = await BService.rechargeCoupon(rechargeId, platform);
    if (res != null) {
      coupon = res['coupon'];
    }
    Map payMap = await BService.payConfig();
    if (payMap != null) {
      alipayE = payMap['alipay'];
      wechatE = payMap['wechat'];
      bankE = payMap['bank'];
      bindBank = payMap['bankBind'];
      ac = payMap['ac'];
      wc = payMap['wc'];
      bc = payMap['bc'];
      bbc = payMap['bbc'];
      if (wechatE == '1') {
        _withdrawalType = 2;
      }
      if (bankE == '1') {
        _withdrawalType = 3;
      }
      if (alipayE == '1') {
        _withdrawalType = 1;
      }
    }
    if(isIos) {
      _withdrawalType = 0;
    }
    initPrice();
  }

  String getTitle() {
    switch (platform) {
      case 'tb':
        return '淘星选';
      case 'jd':
        return '京星选';
      case 'pdd':
        return '多星选';
      case 'dy':
        return '抖星选';
      case 'vip':
        return '唯星选';
      default:
        return '';
    }
  }

  Future initPrice() async {
    if ((_withdrawalType == 1 && ac == '1') ||
        (_withdrawalType == 2 && wc == '1') ||
        (_withdrawalType == 3 && bc == '1') ||
        (_withdrawalType == 4 && bbc == '1')) {
      endPrice = price - coupon;
    } else {
      endPrice = price;
    }
    List split = endPrice.toStringAsFixed(2).split(".");
    start = split[0];
    if (split.length > 1) {
      end = split[1];
    }

    setState(() {
      loading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    wxPayNotifier.removeListener(_wechatPayCallback);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Color(0xfffafafa),
        appBar: AppBar(
          title: Text('收银台'),
          backgroundColor: Colours.vip_white,
          foregroundColor: Colours.vip_black,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colours.vip_black,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: loading ? Global.showLoading2() : createContent(size));
  }

  createContent(size) {
    String titlePrefix = '';
    Map helpUser = this.data['user'];
    if (helpUser.isNotEmpty) {
      titlePrefix = '用户${helpUser['showName']}';
    }
    String orderDesc;
    if(rechargeType == 0){
      orderDesc = '$titlePrefix加盟${getTitle()}会员，有效期1年';
    } else {
      orderDesc = '$titlePrefix加盟${getTitle()}会员，有效期$valid天';
    }
    bool isIos = Global.isIOS();
    List<Widget> widgets = [
      Center(
        child: RichText(
          text: TextSpan(
            text: '￥',
            style: TextStyle(color: Colours.app_main, fontSize: 16),
            children: [
              TextSpan(
                text: start,
                style: TextStyle(color: Colours.app_main, fontSize: 26),
              ),
              TextSpan(
                text: '.$end',
                style: TextStyle(color: Colours.app_main, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
      SizedBox(height: 30),
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('订单详情', style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
            SizedBox(height: 16),
            Text(orderDesc, maxLines: 2, overflow: TextOverflow.ellipsis),
            SizedBox(height: 8),
            Divider(),
            SizedBox(height: 8),
            RichText(
              text: TextSpan(
                text: '合计金额  ',
                style: TextStyle(color: Colors.black),
                children: [
                  TextSpan(text: '￥$start.$end'),
                ],
              ),
            ),
          ],
        ),
      ),
      if(!isIos)
        SizedBox(height: 20),
      if(!isIos)
        Text('选择支付方式', style: TextStyle(color: Colors.black, fontSize: 16)),
      createPayItem()
    ];
    return Stack(
      children: [
        ListView.builder(
            itemCount: widgets.length,
            padding: EdgeInsets.all(16),
            itemBuilder: (context, i) {
              return widgets[i];
            }),
      ],
    );
  }

  Widget createPriceItem() {
    var desc = '';
    if(rechargeType == 0){
      desc = '12个月';
    }else {
      desc = '$valid天 ';
    }
    return Container(
      width: 300,
      height: 40,
      decoration: BoxDecoration(
        color: Color(0xffFAEDE6),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          bottomLeft: Radius.circular(12),
          topRight: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          text: desc,
          style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
          children: [
            TextSpan(
              text: '￥',
              style: TextStyle(color: Colours.app_main, fontSize: 14, fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: '$start.$end ',
              style: TextStyle(color: Colours.app_main, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            if(rechargeType == 0)
              TextSpan(
                text: '折合${(endPrice / 12).toStringAsFixed(2)}元/月',
                style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
              ),
            if(rechargeType != 0)
              TextSpan(
                text: '折合${(endPrice / valid).toStringAsFixed(2)}元/天',
                style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }

  Widget createPayItem() {
    List<Widget> items = [];
    items.add(SizedBox(height: 15));
    List<Widget> payButtons = [];
    if (!Global.isIOS()) {
      if (alipayE == '1') {
        payButtons.add(_buildWithdrawalType(1, '支付宝支付'));
      }
      if (wechatE == '1') {
        if (alipayE == '1') {
          payButtons.add(Divider());
        }
        payButtons.add(_buildWithdrawalType(2, '微信支付'));
      }
      if (bankE == '1') {
        if (alipayE == '1' || wechatE == '1') {
          payButtons.add(Divider());
        }
        payButtons.add(_buildWithdrawalType(3, '银行卡快捷支付'));
      }
      if (bindBank == '1') {
        if (alipayE == '1' || wechatE == '1' || bankE == '1') {
          payButtons.add(Divider());
        }
        payButtons.add(
          _buildWithdrawalType(
              4, bankName == "" ? '银行卡绑卡支付' : bankName + '(' + bankNo + ')'),
        );
      }
      items.add(
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: EdgeInsets.all(16),
          child: Column(children: payButtons),
        ),
      );
    }

    items.add(SizedBox(height: 10));
    items.add(createPriceItem());
    items.add(SizedBox(height: 10));
    items.add(createPayBtn());
    items.add(SizedBox(height: 15));
    items.add(Row(
      children: [
        Text('支付前请阅读', style: TextStyle(color: Colors.black45, fontSize: 13)),
        GestureDetector(
          onTap: () {
            Global.showProtocolPage(Global.vipUrl, '加盟协议');
          },
          child: Text('《加盟协议》', style: TextStyle(
            color: Colors.black45, 
            fontSize: 13,
            decoration: TextDecoration.underline,
          )),
        ),
      ],
    ));
    return MyScrollView(
      children: items,
    );
  }

  Widget createPayBtn() {
    Color bg;
    if(_withdrawalType==4 &&cardList.isEmpty){
      bg = Colours.text_gray_c;
    }else{
      bg = Colours.app_main;
    }
    return CustomButton(
      bgColor: bg,
      showIcon: false,
      textColor: Colors.white,
      text: '确认支付',
      borderRadius: BorderRadius.all(Radius.circular(22.0)),
      onPressed: () async {
        if(_withdrawalType==4&&cardList.isEmpty){
          return ToastUtils.showToast('您还未绑定银行卡，无法支付');
        };
        //校验是否有支付渠道可绑定
        Map res = await BService.payBind(payType: _withdrawalType);
        if (res['success'] == null || !res['success']) {
          ToastUtils.showToast('暂无法加盟，请联系客服处理');
          return;
        }
        //校验是否签署合同
        Map<String, dynamic> card = await BService.userCard(uid: this.data['user']['uid']);
        String contractPath = card['contractPath'] ?? '';
        if (contractPath.isEmpty) {
          if(this.data['user'].isEmpty) {
            showSignDialog(context, (){
              Navigator.pushNamed(context, '/shopAuthPage');
            });
          } else {
            ToastUtils.showToast('用户${this.data['user']['showName']}未实名认证');
          }
          return;
        }
        //支付
        pay();
      },
    );
  }

  Future pay() async {
    if (Global.isWeb()) {
      ToastUtils.showToast('请去{$APP_NAME}APP端支付');
      return;
    }
    Map helpUser = this.data['user'];

    var uid = helpUser['uid'];
    //ios支付
    if(_withdrawalType == 0) {
      Loading.show(context);
      Map data = await BService.payIos(rechargeId, platform, uid, type: rechargeType);
      Loading.hide(context);
      if(!data['success']) {
        ToastUtils.showToast(data['msg']);
        return;
      }
      var productId;
      if(rechargeType==0) {
        //年卡
        if(platform == 'tb') {
          productId = Global.iosProductIds[0];
        } else if(platform == 'jd') {
          productId = Global.iosProductIds[1];
        } else if(platform == 'pdd') {
          productId = Global.iosProductIds[2];
        } else if(platform == 'dy') {
          productId = Global.iosProductIds[3];
        } else if(platform == 'vip') {
          productId = Global.iosProductIds[4];
        }
      } else {
        //月卡
        productId = Global.iosProductIds[5];
      }
      var product = super.products.firstWhere((element) => element.id==productId);
      //todo 需要修改
      super.payIOS(data['data']['localOrderId'], product);

    }
    //支付宝支付
    else if (_withdrawalType == 1) {

      Tobias tobias = new Tobias();

      var result = await tobias.isAliPayInstalled;
      if (Global.isIOS()) {
        result = true;
      }
      bool showConfirm = false;
      if (result) {
        Loading.show(context);
        Map data = await BService.payAli(rechargeId, platform, uid, type: rechargeType);
        Loading.hide(context);
        if(!data['success']) {
          ToastUtils.showToast(data['msg']);
          return;
        }
        Map res = data['data']??{};
        String paySign = res['payInfo'] ?? '';
        if (paySign.isEmpty) {
          ToastUtils.showToast('支付失败');
          return;
        }
        if (paySign.startsWith("alipays://")) {
          //三方支付宝
          Uri uri = Uri.parse(paySign);
          await launchUrl(uri);
          showConfirm = true;
        }else if (paySign.startsWith('https://openapi.alipay.com/gateway.do')) {
          //网页支付宝
          Navigator.pushNamed(context, '/alipayWebview', arguments: {'url':paySign});
          showConfirm = true;
        } else {
          //原生支付宝
          var payRes = await tobias.pay(paySign);
          //支付宝支付
          if (payRes['resultStatus'] == 9000 ||
              payRes['resultStatus'] == '9000') {
            refreshAfterPaySuccess();
          } else {
            print('支付失败${payRes}');
          }
        }
      } else {
        ToastUtils.showToast('请安装支付宝，再继续尝试');
      }
      if (showConfirm) {
        Future.delayed(Duration(seconds: 3)).then((value) => {
              showSignDialog(context, refreshAfterPaySuccess,
                  title: '支付结果', desc: '', okTxt: '完成支付', cancelTxt: '取消支付')
            });
      }
    } else if (_withdrawalType == 2) {
      //微信支付
      Loading.show(context);
      Map data = await BService.payWechat(rechargeId, platform, uid, type: rechargeType);
      if(!data['success']) {
        ToastUtils.showToast(data['msg']);
        return;
      }
      Map result = data['data']??{};
      if (result['sign'] != null) {
        fluwx.pay(which: Payment(
          appId: result['appid'],
          partnerId: result['partnerid'],
          prepayId: result['prepayid'],
          packageValue: result['package'],
          nonceStr: result['noncestr'],
          timestamp: int.parse(result['timestamp']),
          sign: result['sign'],
        ));
      } else {
        ToastUtils.showToast('支付失败');
      }
      Loading.hide(context);
    } else if (_withdrawalType == 3) {
      //银行卡支付
      Loading.show(context);
      Map data = await BService.payBank(rechargeId, platform, uid, type: rechargeType);
      Loading.hide(context);
      if(!data['success']) {
        ToastUtils.showToast(data['msg']);
        return;
      }
      Map res = data['data']??{};
      if (res['code'] != null && res['code'] == '1') {
        Navigator.pushNamed(context, '/payWebview', arguments: {
          'url': res['url'],
          'orderId': res['localOrderId'],
          'refresh': false,
          'appBar': AppBar(
            title: Text('收银台', style: TextStyle(color: Colors.black)),
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          )
        }).then((value) {
          if (value != null && value as bool) {
            refreshAfterPaySuccess();
          }
        });
      } else {
        ToastUtils.showToast('支付失败');
      }
    } else {
      //绑卡支付
      Loading.show(context);
      Map data = await BService.payBindBank(rechargeId, platform, uid, bankId, type: rechargeType);
      Loading.hide(context);
      if(!data['success']) {
        ToastUtils.showToast(data['msg']);
        return;
      }
      Map res = data['data']??{};
      if(res.length !=0){
        dialog(res['localOrderId'],res['bizSn']);
      }
    }
  }

  isShop() {
    return ('tb' == platform && 5 == Global.userinfo?.level) ||
        ('jd' == platform && 5 == Global.userinfo?.levelJd) ||
        ('pdd' == platform && 5 == Global.userinfo?.levelPdd) ||
        ('dy' == platform && 5 == Global.userinfo?.levelDy) ||
        ('vip' == platform && 5 == Global.userinfo?.levelVip);
  }

  refreshAfterPaySuccess() {
    //刷新个人中心
    refreshVd();
    Navigator.pop(context, true);
  }

  String bankName = '';
  String bankNo = '';
  late int bankId;
  String phone = '';
  String logoUrl = '';

  Widget _buildWithdrawalType(int type, String name) {
    double iconSize = 28;
    return InkWell(
        onTap: () {
          if (type==4&&cardList.isEmpty) {
              Navigator.pushNamed(context, "/addCard").then((value) {
                setState(() {
                  getListData();
                });
              });
          }
          setState(() {
            _withdrawalType = type;
            initPrice();
          });
        },
        child: Container(
          padding: EdgeInsets.only(top: 8, bottom: 0),
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  if (type == 1)
                    LoadAssetImage(
                      'share/alipay',
                      width: iconSize,
                      height: iconSize,
                    ),
                  if (type == 2)
                    LoadAssetImage(
                      'share/wx',
                      width: iconSize,
                      height: iconSize,
                    ),
                  if (type == 3)
                    Icon(Icons.credit_card_outlined, color: Colors.blue, size: iconSize),
                  if (type == 4 && logoUrl.isEmpty)
                    Icon(Icons.credit_score, color: Colors.blue, size: iconSize),
                  if (type == 4 && logoUrl.isNotEmpty)
                    Image.network(logoUrl, width: 25, height: 15),
                  SizedBox(width: 2),
                  Text(name),
                  Spacer(),
                  if ((type == 1 && ac == '1') ||
                      (type == 2 && wc == '1') ||
                      (type == 3 && bc == '1') ||
                      type == 4 && bbc == '1')
                    Container(
                      decoration: BoxDecoration(
                        color: Colours.app_main,
                        border: Border.all(color: Colours.app_main, width: 0.5),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4),
                          bottomLeft: Radius.circular(4),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      child: Text('立减￥$coupon', style: TextStyle(color: Colors.white, fontSize: 12)),
                    ),
                  SizedBox(width: 10),
                  type==4 && cardList.isEmpty ?
                  Icon(Icons.keyboard_arrow_right, color: Colors.blue, size: 24)
                  :
                  LoadAssetImage(
                      _withdrawalType == type ? 'cash/txxz' : 'cash/txwxz',
                      width: 16.0),
                  SizedBox(width: 4),
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 5)),
              if (type == 4 && cardList.isNotEmpty)
                Row(
                  children: [
                    SizedBox(width: 30),
                    GestureDetector(
                      onTap: () {
                        Cardlist();
                      },
                      child: Text('换卡支付(暂不支持信用卡)', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ),
                    SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        Cardlist();
                      },
                      child: Icon(Icons.keyboard_arrow_right, color: Colors.grey, size: 20),
                    ),
                   ],
                 )
            ],
          ),
        ));
  }

  void dialog(String orderId,String bizSn) {
    AwesomeDialog(
        dismissOnTouchOutside: false,
        context: context,
        dialogType: DialogType.noHeader,
        showCloseIcon: true,
        body: PayConfirmDialog(start, end, bankNo, bankName,orderId,bizSn,phone, logoUrl, (pin) => _handleVerifyCode(pin, bizSn, orderId)),
        onDismissCallback: (DismissType type) {}
        // btnCancelOnPress: () {},
        // btnOkOnPress: () {}
    )..show().then((value){
        if(value) {
          refreshAfterPaySuccess();
        }
      });
  }

  void _handleVerifyCode(String pin, String bizSn, String orderId) async {
    Loading.show(context);
    var res = await BService.bindBankConfirm(pin, bizSn, orderId);
    Loading.hide(context);
    if (res['code'] == 200) {
      Fluttertoast.showToast(msg: '支付成功');
      Navigator.pop(context, true);
    } else {
      Fluttertoast.showToast(msg: res['msg']);
    }
  }

  void Cardlist() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(mainAxisSize: MainAxisSize.min, children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, "/addCard").then((value) {
                  setState(() {
                    getListData();
                    Navigator.pop(context);
                  });
                });
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 0, 10, 10),
                child: Row(
                  children: [
                    SizedBox(width: 20),
                    Icon(Icons.add_card, color: Colors.red, size: 28),
                    SizedBox(width: 5),
                    Text('添加新的银行卡'),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios_outlined, color: Colors.grey, size: 14),
                  ],
                ),
              ),
            ),
            Divider(),
            Container(
              // height: MediaQuery.of(context).size.height * 0.7,
              height: 150,
              child: ListView.builder(
                  itemCount: cardList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        bankName = cardList[index]['bankName'];
                        bankNo = cardList[index]['bankNo'];
                        bankId = cardList[index]['id'];
                        phone = cardList[index]['phone'];
                        logoUrl = cardList[index]['logo'];
                        setState(() {

                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(width: 20),
                                Image.network(cardList[index]['logo'], width: 25, height: 15),
                                SizedBox(width: 5),
                                Text(cardList[index]['bankName'] +
                                    '(' +
                                    cardList[index]['bankNo'] +
                                    ')'),
                                Spacer(),
                                // if(cardList[index]['isDefault'] == 1)
                                // Container(
                                //   decoration: BoxDecoration(
                                //     color: Colors.grey,
                                //     border: Border.all(color: Colors.grey, width: 0.5),
                                //     borderRadius: BorderRadius.circular(4),
                                //   ),
                                //   padding: EdgeInsets.fromLTRB(1, 2, 4, 4),
                                //   child: Text('上次支付', style: TextStyle(color: Colors.white, fontSize: 12)),
                                // )
                              ],
                            ),
                            Divider(),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ]);
        });
  }

  Future<void> getListData() async {
    cardList = await BService.getbindBankcardList();
    if (cardList.isNotEmpty) {
      for(var i = 0; i < cardList.length; i++) {
        Map card = cardList[i];
        var logo = await BService.getBankLogo(card['bankNoFull']);
        card['logo'] = logo;
        if(card['isDefault']==1) {
          bankName = card['bankName'];
          bankNo = card['bankNo'];
          bankId = card['id'];
          phone = card['phone'];
          logoUrl = logo;
        }
      }
      setState(() {
      });
    }
  }
}

class PayConfirmDialog extends Dialog {
  final String start;
  final String end;
  final String bankNo;
  final String bankName;
  final String orderId;
  final String bizSn;
  final String phone;
  final String logo;
  final Function(String) onVerifyCode;

  PayConfirmDialog(this.start, this.end, this.bankNo, this.bankName,
      this.orderId, this.bizSn, this.phone, this.logo, this.onVerifyCode);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 5),
      child: Column(
        children: [
          Text('请输入验证码',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 18,
              )),
          Padding(padding: EdgeInsets.only(top: 25)),
          Text('加盟星选会员',
              style: TextStyle(
                color: Colors.black87,
              )),
          Padding(padding: EdgeInsets.only(top: 5)),
          Center(
            child: RichText(
              text: TextSpan(
                text: '￥',
                style: TextStyle(color: Colours.app_main, fontSize: 16),
                children: [
                  TextSpan(
                    text: start,
                    style: TextStyle(color: Colours.app_main, fontSize: 26),
                  ),
                  TextSpan(
                    text: '.$end',
                    style: TextStyle(color: Colours.app_main, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 15)),
          Row(
            children: [
              Text('支付方式',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  )),
              Expanded(
                child: Text(''),
              ),
              Image.network(logo, width: 25, height: 15),
              Text(bankName + '(' + bankNo + ')',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  )),
            ],
          ),
          Padding(padding: EdgeInsets.only(top: 15)),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Text('已向您'+BService.formatPhone(phone) +'的手机号发送验证码',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                )),
          ]),
          Padding(padding: EdgeInsets.only(top: 20)),
          _createCodeRow(context),
          Padding(padding: EdgeInsets.only(top: 30)),
        ],
      ),
    );
  }

  _createCodeRow(BuildContext context) {
    final defaultPinTheme = PinTheme(
        width: 40,
        height: 38,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey),
        ));
    return Center(
      child: Pinput(
        defaultPinTheme: defaultPinTheme,
        length: 6,
        autofocus: true,
        onChanged: (pin) => {},
        onCompleted: (pin) => {onVerifyCode(pin)},
      ),
    );
  }
}
