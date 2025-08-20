/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';

import '../util/global.dart';
import '../util/toast_utils.dart';
import '../service.dart';
import '../widget/loading.dart';

class VerifyAddCard extends StatefulWidget {
  final Map data;

  const VerifyAddCard(this.data, {Key? key}) : super(key: key);

  @override
  _VerifyAddCardState createState() => _VerifyAddCardState();
}

class _VerifyAddCardState extends State<VerifyAddCard> {
  TextEditingController _mobileController = new TextEditingController();
  TextEditingController _cardNameController = new TextEditingController();
  TextEditingController _bankNoController = new TextEditingController();
  String bankcardNum = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("银行卡信息"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  '卡号           ',
                  style: TextStyle(
                    color: Colors.black.withValues(alpha: 0.75),
                    fontSize: 16,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _bankNoController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      TextInputFormatter.withFunction(
                          (oldValue, newValue) => _addSeparator(newValue.text)),
                    ],
                    decoration: InputDecoration(
                      hintText: '',
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x19000000),
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Text(
                  '卡类型        ',
                  style: TextStyle(
                    color: Colors.black.withValues(alpha: 0.75),
                    fontSize: 16,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _cardNameController,
                    decoration: InputDecoration(
                      hintText: '',
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x19000000),
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Text(
                  '手机号码    ',
                  style: TextStyle(
                    color: Colors.black.withValues(alpha: 0.75),
                    fontSize: 16,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _mobileController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: '',
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x19000000),
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),
            RawMaterialButton(
              constraints: BoxConstraints(minHeight: 44),
              fillColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              //点击事件
              onPressed: () {
                addcard();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '确 定',
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

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future initData() async {
    bankcardNum = widget.data['edit_cardNum'] == null
        ? "无效卡号"
        : widget.data['edit_cardNum'];
    _bankNoController.text = bankcardNum;
    _mobileController.text = Global.userinfo!.phone;
    _cardNameController.text = "招商银行储蓄卡";
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _cardNameController.dispose();
    _bankNoController.dispose();
    super.dispose();
  }

  void addcard() {
    if (_bankNoController.text == '') {
      ToastUtils.showToast('银行卡号不能为空');
      return;
    }
    if (_cardNameController.text == '') {
      ToastUtils.showToast('卡类型不能为空');
      return;
    }
    if (_mobileController.text == '') {
      ToastUtils.showToast('手机号不能为空');
      return;
    }
    confirm();
  }

  Future<void> confirm() async {
    String mobile = _mobileController.text.toString().replaceAll(" ", "");
    bool isPhone = Global.isPhone(mobile);
    if (!isPhone) {
      ToastUtils.showToast('手机号不正确');
      return;
    }
    Loading.show(context);
    Map reqBindBankcard = await BService.bindBankcard(
        _bankNoController.text.toString(),
        4,
        _mobileController.text.toString());
    Loading.hide(context);
    if (reqBindBankcard['success']) {
      AwesomeDialog(
          dismissOnTouchOutside: false,
          context: context,
          dialogType: DialogType.noHeader,
          showCloseIcon: true,
          body: ContentDialog(
              reqBindBankcard['data']['requestNo'], _mobileController.text.toString()),
          onDismissCallback: (DismissType type) {})
        ..show();
    } else {
      ToastUtils.showToast(reqBindBankcard['msg']);
    }
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
}

class ContentDialog extends Dialog {
  final String No;
  final String mobilePhone;

  ContentDialog(this.No, this.mobilePhone);

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
    Loading.show(context);
    bool reqBindConfirm = await BService.bindBankcardConfirm(pin, 4, No);
    Loading.hide(context);
    if (reqBindConfirm) {
      ToastUtils.showToast('绑定成功');
      Navigator.popUntil(context, ModalRoute.withName('/cashierPage')); //回到指定页
    }
  }
}
