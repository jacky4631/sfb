/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';
import 'package:maixs_utils/widget/views.dart';
import 'package:pinput/pinput.dart';
import 'package:sufenbao/util/colors.dart';

import '../service.dart';
import '../util/global.dart';
import '../util/toast_utils.dart';
import '../widget/loading.dart';

class AddCard extends StatefulWidget {
  final Map data;

  const AddCard(this.data, {Key? key}) : super(key: key);

  @override
  _AddCardState createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> {
  TextEditingController _bankNoController = new TextEditingController();
  TextEditingController _mobileController = new TextEditingController();
  bool check = false;
  String bankName = '';
  String bindBankType = '';
  var logoUrl = null;

  @override
  void initState() {
    setState(() {
      bindBankType = widget.data['bindBankType']??'';
    });
    _mobileController.text = Global.userinfo!.phone;
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _bankNoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
        brightness: Brightness.dark,
        bgColor: Colors.white,
        appBar: buildTitle(context,
            title: "添加银行卡",
            widgetColor: Colors.black,
            leftIcon: Icon(Icons.arrow_back_ios)),
        body: PWidget.container(
            PWidget.column(
              [
                Text('输入卡号添加',
                    style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold)),
                PWidget.boxh(10),
                PWidget.container(
                    PWidget.row([
                      PWidget.icon(Icons.gpp_good_rounded, [Colors.grey, 16]),
                      PWidget.boxw(5),
                      Text("为保障正常绑卡，需收集您的卡信息和身份信息",
                          style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ]),
                    [
                      null,
                      30,
                      Colors.grey[200]
                    ],
                    {
                      'pd': [0, 0, 10, 0],
                      'br': [8, 8, 8, 8],
                    }),
                PWidget.boxh(10),
                TextField(
                  onChanged: (s) async {
                    if (s.length == 19 || s.length == 23) {
                      String bankNo = _bankNoController.text.replaceAll(' ', '');
                      Map res = await BService.getBankInfo(bankNo);
                      if (res['success']) {
                        switch (res['data']['cardType']) {
                          case 'CREDIT':
                            bankName = '该卡暂时不支持';
                            break;
                          case 'DEBIT':
                            bankName = res['data']['bankName'];
                            check = true;
                            break;
                        }
                        logoUrl = await BService.getBankLogo(bankNo);

                      }
                    } else {
                      check = false;
                    }
                    setState(() {});
                  },
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold
                  ),
                  controller: _bankNoController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(23),
                    TextInputFormatter.withFunction(
                        (oldValue, newValue) => _addSeparator(newValue.text)),
                  ],
                  decoration: InputDecoration(
                    suffixIcon: (_bankNoController.text.isNotEmpty)
                        ? IconButton(
                            onPressed: () {
                              _bankNoController.clear();
                              check = false;
                              setState(() {});
                            },
                            icon: Icon(Icons.close),
                            color: Colors.grey,
                            iconSize: 16,
                          )
                        : new SizedBox(),
                    hintStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFFcccccc),
                    ),
                    hintText: '请输入本人的卡号',
                    border: InputBorder.none,
                  ),
                ),
                if (check)
                  PWidget.row([
                    if(logoUrl != null)
                      PWidget.wrapperImage(logoUrl, [25, 15]),
                    PWidget.boxw(2),
                    Text(bankName,
                        style: TextStyle(color: Colors.black54, fontSize: 15))
                  ]),
                Divider(endIndent: 16),
                if(check)
                PWidget.row([
                  PWidget.textNormal("手机号",[Colors.black, 16, true],{'pd':[10,0,0,0]}),
                  buildTextField2(
                      con: _mobileController,
                      hint: '',
                      height: 40,
                      maxLines: 1,
                      showSearch: false,
                      bgColor: Colors.white,
                      keyboardType: TextInputType.number,
                      border: new UnderlineInputBorder(
                        // 焦点集中的时候颜色
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ))
                ],'221'),
                if(!check)
                  PWidget.boxh(15),
                if (bindBankType.isEmpty && !check)
                  PWidget.row([
                    PWidget.boxw(3),
                    Text('查看支持银行卡',
                        style: TextStyle(color: Colors.grey, fontSize: 13)),
                    PWidget.icon(Icons.keyboard_arrow_right, [Colors.grey, 20])
                  ], {
                    'fun': () {
                      Navigator.pushNamed(context, "/supportBankList");
                    }
                  }),
                PWidget.boxh(30),
                RawMaterialButton(
                  constraints: BoxConstraints(minHeight: 44),
                  fillColor: check ? Colours.app_main : Color(0XFFE28D85),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  ),
                  //点击事件
                  onPressed: () {
                    if(!check) {
                      return;
                    }
                    if (_bankNoController.text == '') {
                      ToastUtils.showToast('银行卡号不能为空');
                      return;
                    }
                    if (!check) {
                      ToastUtils.showToast('请输入正确的卡号');
                      return;
                    }
                    addCardConfirm();
                    // Navigator.pushNamed(context, "/verifyaddCard", arguments: {
                    //   "edit_cardNum": _bankNoController.text.toString()
                    // });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '提 交',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            {
              'pd': [20, 20, 20, 20]
            }));
  }

  TextEditingValue _addSeparator(String text, {String separator = " "}) {
    if (text.isEmpty) {
      return TextEditingValue(text: text);
    }

    ///移除了分隔符
    var removeSeparator = text.replaceAll(separator, "");
    var list = removeSeparator.split("");
    int separatorCount = 0;
    for (var i = 0; i < removeSeparator.length; i = i + 4) {
      if (i == 0) continue;
      list.insert(i + separatorCount, separator);
      separatorCount++;
    }
    var endText = list.join("");
    return TextEditingValue(
      text: endText,
      selection: TextSelection(
        baseOffset: endText.length,
        extentOffset: endText.length,
        affinity: TextAffinity.upstream,
      ),
    );
  }

  Future<void> addCardConfirm() async {
    String mobile = _mobileController.text.toString().replaceAll(" ", "");
    bool isPhone = Global.isPhone(mobile);
    if (!isPhone) {
      ToastUtils.showToast('手机号不正确');
      return;
    }
    Loading.show(context);
    Map reqBindBankcard;
    bindBankType.isEmpty
        ? reqBindBankcard = await BService.bindBankcard(//支付绑
            _bankNoController.text.replaceAll(' ', ''),
            4,
            _mobileController.text.toString())
        : reqBindBankcard = await BService.cashbindBankcard(//提现绑
            cardNo: _bankNoController.text.replaceAll(' ', ''),
            phone: _mobileController.text.toString());
    Loading.hide(context);
    if (reqBindBankcard['success']) {
      AwesomeDialog(
          dismissOnTouchOutside: false,
          context: context,
          dialogType: DialogType.noHeader,
          showCloseIcon: true,
          body: bindBankType.isEmpty
              ? addCardContentDialog(reqBindBankcard['data']['requestNo'],
                  _mobileController.text.toString(), '')
              : addCardContentDialog(reqBindBankcard['data']['requestNo'],
                  _mobileController.text.toString(), reqBindBankcard['data']['authSn']),
          onDismissCallback: (DismissType type) {})
        ..show().then((value) {
          if (value) {
            Navigator.pop(context,true);
          }
        });
    } else {
      ToastUtils.showToast(reqBindBankcard['msg']);
    }
  }
}

class addCardContentDialog extends Dialog {
  String No = '';
  String mobilePhone = '';
  String authSn = '';

  addCardContentDialog(this.No, this.mobilePhone, this.authSn);

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
            _createCodeRow(context),
            Padding(padding: EdgeInsets.only(top: 30)),
          ],
        ));
  }

  _createCodeRow(BuildContext context) {
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
    bool reqBindConfirm;
    Loading.show(context);
    authSn.isEmpty
        ? reqBindConfirm = await BService.bindBankcardConfirm(pin, 4, No)
        : reqBindConfirm =
            await BService.cashbindBankcardConfirm(pin, authSn, No);
    Loading.hide(context);
    if (reqBindConfirm) {
      ToastUtils.showToast('绑定成功');
      Navigator.pop(context, true);
    }
  }
}
