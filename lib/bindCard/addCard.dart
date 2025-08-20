/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    super.initState();
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
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: Text("添加银行卡"),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.pop(context),
            ),
        ),
        body: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('输入卡号添加',
                    style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(children: [
                      Icon(Icons.gpp_good_rounded, color: Colors.grey, size: 16),
                      SizedBox(width: 5),
                      Text("为保障正常绑卡，需收集您的卡信息和身份信息",
                          style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ])),
                SizedBox(height: 10),
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
                  Row(children: [
                    if(logoUrl != null)
                      Image.network(logoUrl, width: 25, height: 15),
                    SizedBox(width: 2),
                    Text(bankName,
                        style: TextStyle(color: Colors.black54, fontSize: 15))
                  ]),
                Divider(endIndent: 16),
                if(check)
                Row(children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Text("手机号", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _mobileController,
                      keyboardType: TextInputType.number,
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: '',
                        fillColor: Colors.white,
                        filled: true,
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ]),
                if(!check)
                  SizedBox(height: 15),
                if (bindBankType.isEmpty && !check)
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/supportBankList");
                    },
                    child: Row(children: [
                      SizedBox(width: 3),
                      Text('查看支持银行卡',
                          style: TextStyle(color: Colors.grey, fontSize: 13)),
                      Icon(Icons.keyboard_arrow_right, color: Colors.grey, size: 20)
                    ]),
                  ),
                SizedBox(height: 30),
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
        ),
    );
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
  final String No;
  final String mobilePhone;
  final String authSn;

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
