/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:sufenbao/util/global.dart';
import 'package:sufenbao/util/toast_utils.dart';
import 'package:sufenbao/me/cash/widgets/my_button.dart';
import 'package:sufenbao/me/cash/widgets/number_text_input_formatter.dart';
import 'package:sufenbao/service.dart';

import '../../dialog/simple_text_dialog.dart';

import '../../widget/CustomWidgetPage.dart';
import '../../widget/load_image.dart';
import '../../widget/loading.dart';
import '../../widget/my_scroll_view.dart';
import '../listener/PersonalNotifier.dart';
import '../styles.dart';

//提现
class CashPage extends StatefulWidget {
  final Map data;

  const CashPage(this.data, {super.key});

  @override
  _CashPageState createState() => _CashPageState();
}

class _CashPageState extends State<CashPage> {

  final TextEditingController _controller = TextEditingController();
  int _withdrawalType = 1;
  bool _clickable = false;
  String extractIntervalDesc = "每天可提现一次";

  String extractMinDesc = '满10元可提现';
  String extractFeeDesc = "T+1天到账(5%手续费，T为工作日)";
  String weixin = "0";
  String alipay = "1";
  String bank = "1";
  bool loading = true;
  num extractMax = 3000;
  num extractMin = 1;
  String bankName = '';
  String bankNo = '';
  String ListPhone = '';
  String logoUrl = '';
  late Map wxProfile = {};
  List cardList = [];
  int bankId = 0;

  @override
  void initState() {
    initData();
    super.initState();
    _controller.addListener(_verify);
    _controller.text = widget.data['cash'].toString();
  }

  Future<void> getListData() async {
    var NotextractDefault = false;
    cardList = await BService.getbindBankcardList(extract: 1);
    if (cardList.isNotEmpty) {
      for(int i = 0; i <cardList.length;i++){
        Map card = cardList[i];
        var logo = await BService.getBankLogo(card['bankNoFull']);
        card['logo'] = logo;
        if(card['extractDefault']==1){
          bankName = card['bankName'];
          bankNo = card['bankNo'];
          bankId = card['id'];
          ListPhone = card['phone'];
          logoUrl = logo;
          NotextractDefault = true;
        }
      }
      if(!NotextractDefault){
        Map card = cardList[0];
        var logo = await BService.getBankLogo(card['bankNoFull']);
        card['logo'] = logo;
        bankName = card['bankName'];
        bankNo = card['bankNo'];
        bankId = card['id'];
        ListPhone = card['phone'];
        logoUrl = logo;
      }
      setState(() {

      });
    }
  }

  Future initData() async {
    getListData();
    Map res = await BService.extractConfig();
    if(res != null) {
      extractIntervalDesc = res['extractIntervalDesc'];
      extractFeeDesc = res['extractFeeDesc'];
      extractMinDesc = res['extractMinDesc'];
      weixin = res['weixin'];
      if(weixin == '1') {
        _withdrawalType = 0;
      }
      alipay = res['alipay'];
      if(alipay == '1') {
        _withdrawalType = 1;
      }
      bank = res['bank'];
      if(bank == '1') {
        _withdrawalType = 2;
      }
      extractMax = num.parse(res['extractMax']);
      extractMin = num.parse(res['extractMin']);
      setState(() {
        loading = false;
      });
      Map wxMap = await BService.userWxProfile();
      setState(() {
        wxProfile = wxMap['wxProfile']?? {};
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_verify);
    _controller.dispose();
    super.dispose();
  }

  void _verify() {
    final price = _controller.text;
    if (price.isEmpty || double.parse(price) < extractMin) {
      setState(() {
        _clickable = false;
      });
      return;
    }
    setState(() {
      _clickable = true;
    });
  }

  @override
  Widget build(BuildContext context) {

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
         /// 拦截返回，关闭键盘，否则会造成上一页面短暂的组件溢出
         FocusManager.instance.primaryFocus?.unfocus();
       },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text('提现', style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: loading ? Global.showLoading2() : MyScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          children: <Widget>[
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const <Widget>[
                Text('提现金额', style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold
                )),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: <Widget>[
                Container(
                  width: 15.0,
                  height: 40.0,
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: LoadAssetImage('cash/rmb', color: Theme.of(context).brightness == Brightness.dark ? Color(0xFFB8B8B8) : null,),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    maxLength: 10,
                    controller: _controller,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [UsNumberTextInputFormatter()],
                    style: TextStyles.nowMoneyBlack,
                    onChanged: (e){
                      if(e.isEmpty){
                        return;
                      }
                      num price = num.parse(e);
                      if(price > widget.data['cash'] || price > extractMax || price < extractMin) {
                        setState(() {
                          _clickable = false;
                        });
                      } else {
                        setState(() {
                          _clickable = true;
                        });
                      }
                    },
                    decoration:  InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 8.0),
                      hintStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFFcccccc),
                      ),
                      hintText: extractMinDesc,
                      counterText: '',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
            Divider(),
            SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(extractIntervalDesc, style: Theme.of(context).textTheme.titleSmall),
                GestureDetector(
                  child: SizedBox(
                    height: 48.0,
                    child: Text(extractMinDesc, style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).primaryColor,
                    )),
                  )
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const <Widget>[
                Text('转出方式', style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold
                )),
                LoadAssetImage('cash/sm', width: 16.0)
              ],
            ),
            if(bank == '1')
              _buildBankWithdrawal(),
            if(weixin == '1')
              Divider(),
            if(weixin == '1')
              _buildWithdrawalType(0),
            if(alipay == '1')
              Divider(),
            if(alipay == '1')
              _buildWithdrawalType(1),
            SizedBox(height: 24),
            MyButton(
              radius: 8,
              backgroundColor: _withdrawalType==2 && cardList.isEmpty ? Colors.grey :null,
              key: const Key('提现'),
              onPressed: _clickable ? () async {
                if(_withdrawalType == 2) {
                  //校验是否签署合同
                  Map<String, dynamic> card = await BService.userCard();
                  String contractPath = card['contractPath']??'';
                  if(contractPath.isEmpty) {
                    showSignDialog(context, desc: '需要实名认证并且绑定银行卡后方可提现', (){
                      Navigator.pushNamed(context, '/shopAuthPage');
                    });
                    return;
                  }
                } else {
                  if(_withdrawalType == 0) {
                    if(wxProfile.isEmpty) {
                      showDialog('授权提示', '请【微信授权】和【实名】后再申请提现');
                      return;
                    }
                  }else if(_withdrawalType == 1) {
                    if(Global.isBlank(Global.userinfo!.aliProfile)) {
                      showDialog('授权提示', '请【支付宝授权】和【实名】后再申请提现');
                      return;
                    }
                  }
                  if(Global.isBlank(Global.userinfo!.realName)) {
                    showDialog('授权提示', '请【实名】后再申请提现');
                    return;
                  }
                  if(Global.userinfo!.spreadUid == 0) {
                    showDialog('授权提示', '请绑定【邀请口令】后再申请提现', path: '/personal');
                    return;
                  }
                }

                withdrawal();
              } : null,
              text: '提现',
            ),
          ],
        ),
      ),
    );
  }
  Future withdrawal() async {
    if(_withdrawalType==2&& cardList.isEmpty){
      ToastUtils.showToast('请先添加可提现的银行卡');
      return;
    }
    FocusScope.of(context).requestFocus(FocusNode());
    Loading.show(context);
    Map data = await BService.extract(_withdrawalType,_controller.text,bankId: bankId);
    Loading.hide(context);
    if(data['success']) {
      ToastUtils.showToast('提现成功');
      _controller.text = '0';
      setState(() {

      });
    }else if(data['msg'] == '提现银行卡未绑定'){
      var reqBindBankcard = await BService.cashbindBankcard(phone: ListPhone,id: bankId);
      if (reqBindBankcard.isNotEmpty) {
        AwesomeDialog(
            dismissOnTouchOutside: false,
            context: context,
            dialogType: DialogType.noHeader,
            showCloseIcon: true,
            body: cashaddCardContentDialog(
                reqBindBankcard['data']['requestNo'],
                ListPhone,
                reqBindBankcard['data']['authSn']),
            onDismissCallback: (DismissType type) {})
          ..show().then((value) {
            if (value) {
              withdrawal();
            }
          });
      }else {
        ToastUtils.showToast('提现失败，请联系客服处理');
      }
    } else {
      ToastUtils.showToast(data['msg']);
    }

  }

  Widget _buildWithdrawalType(int type) {
    return InkWell(
      onTap: () {
        setState(() {
          _withdrawalType = type;

          FocusScope.of(context).requestFocus(FocusNode());
        });
      },
      child: SizedBox(
        width: double.infinity,
        height: 74.0,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 18.0,
              left: 0.0,
              child: LoadAssetImage(_withdrawalType == type ? 'cash/txxz' : 'cash/txwxz', width: 16.0),
            ),
            Positioned(
              top: 16.0,
              left: 24.0,
              right: 0.0,
              child: Text(type == 0 ? '微信到账' : '支付宝到账'),
            ),
            Positioned(
              bottom: 16.0,
              left: 24.0,
              right: 0.0,
              child: RichText(
                text: TextSpan(
                  text: '预计',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12),
                  children: <TextSpan>[
                    TextSpan(text: extractFeeDesc, style: TextStyle(color: Color(0xFFFF8547))),
                  ],
                ),
              )
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBankWithdrawal() {
    int type = 2;
    return InkWell(
      onTap: () {
        setState(() {
          _withdrawalType = type;

          FocusScope.of(context).requestFocus(FocusNode());
        });
      },
      child:
          Column(
             children: [
      SizedBox(
        width: double.infinity,
        height: 74.0,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 18.0,
              left: 0.0,
              child: LoadAssetImage(_withdrawalType == type ? 'cash/txxz' : 'cash/txwxz', width: 16.0),
            ),
            Positioned(
              top: 16.0,
              left: 24.0,
              right: 0.0,
              child: Row(
                   children: [
                Text('银行卡到账'),
                SizedBox(width: 5),
                Spacer(),
                if(logoUrl.isNotEmpty)
                  Container(
                    width: 25,
                    height: 15,
                    child: Image.network(logoUrl, fit: BoxFit.contain),
                  ),
                GestureDetector(
                  onTap: () {
                    Cardlist();
                  },
                  child: Text(
                    cardList.isEmpty ? '添加银行卡' : bankName + '(' + bankNo + ')',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(width: 2),
                GestureDetector(
                  onTap: () {
                    Cardlist();
                  },
                  child: Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.black54,
                    size: 24,
                  ),
                ),
               ]),
             ),
            Positioned(
                bottom: 16.0,
                left: 24.0,
                right: 0.0,
                child: RichText(
                  text: TextSpan(
                    text: '预计',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12),
                    children: <TextSpan>[
                      TextSpan(text: extractFeeDesc, style: TextStyle(color: Color(0xFFFF8547))),
                    ],
                  ),
                )
            ),
          ],
        ),
      )
     ])
    );
  }
  void Cardlist() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(mainAxisSize: MainAxisSize.min, children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, "/addCard",arguments: {'bindBankType':'cash_page'}).then((value) {
                  setState(() {
                    getListData();
                    Navigator.pop(context);
                  });
                });
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Row(
                 children: [
                  SizedBox(width: 20),
                  Icon(Icons.add_card, color: Colors.red, size: 28),
                  SizedBox(width: 5),
                  Text('添加新的银行卡'),
                  Spacer(),
                  Icon(Icons.arrow_forward_ios_outlined, color: Colors.grey, size: 14),
                ]),
               ),
             ),
            Divider(),
            Container(
              height: 150,
              child: ListView.builder(
                  itemCount: cardList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () {
                          setState(() {
                            bankName = cardList[index]['bankName'];
                            bankNo = cardList[index]['bankNo'];
                            bankId = cardList[index]['id'];
                            ListPhone = cardList[index]['phone'];
                            logoUrl = cardList[index]['logo'];
                            Navigator.pop(context);
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: Column(
                             children: [
                            Row(
                               children: [
                              SizedBox(width: 20),
                              Container(
                                width: 25,
                                height: 15,
                                child: Image.network(cardList[index]['logo'], fit: BoxFit.contain),
                              ),
                              SizedBox(width: 5),
                              Text(cardList[index]['bankName'] +
                                  '(' +
                                  cardList[index]['bankNo'] +
                                  ')'),
                              Spacer(),
                             ]),
                             Divider(),
                           ]),
                        ));
                  }),
            ),
          ]);
        });
  }
  void showDialog(title, content, {path}) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      body: SimpleTextDialog(title, content, okText: '去授权',),
      // btnCancelOnPress: () {},
      // btnOkOnPress: () {},
    )..show().then((value) {
      if (value) {
        personalNotifier.value = false;
        Navigator.pushNamed(context, path??"/authPage", arguments: widget.data);
      }
    });
  }
}
class cashaddCardContentDialog extends Dialog {
  String No = '';
  String mobilePhone = '';
  String authSn = '';

  cashaddCardContentDialog(this.No, this.mobilePhone, this.authSn);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: EdgeInsets.only(top: 30)),
            Text('请输入验证码',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 18,
                )),
            Padding(padding: EdgeInsets.only(top: 10)),
            Row(
              children: [
                Text('已发送验证码至',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    )),
                Padding(padding: EdgeInsets.only(left: 5)),
                Text(mobilePhone,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                    )),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 30)),
            _createcashCodeRow(context),
            Padding(padding: EdgeInsets.only(top: 30)),
          ],
        ));
  }

  _createcashCodeRow(BuildContext context) {
    final defaultPinTheme = PinTheme(
        width: 40,
        height: 36,
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
        onCompleted: (pin) => {confirm(pin, context)},
      ),
    );
  }

  confirm(String pin, BuildContext context) async {
    Loading.show(context);
    bool  reqBindConfirm = await BService.cashbindBankcardConfirm(pin, authSn, No);
    Loading.hide(context);
    if (reqBindConfirm) {
      Navigator.pop(context, true);
    }
  }
}