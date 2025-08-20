/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:sufenbao/service.dart';

import '../util/colors.dart';
import '../util/picker_helper.dart';

import '../util/toast_utils.dart';

class CreateAddress extends StatefulWidget {
  final Map data;

  const CreateAddress(this.data, {Key? key}) : super(key: key);

  @override
  _CreateAddressState createState() => _CreateAddressState();
}

class _CreateAddressState extends State<CreateAddress> {
  TextEditingController _cityController = new TextEditingController();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _mobileController = new TextEditingController();
  TextEditingController _detailController = new TextEditingController();
  bool _checked = false;
  var cityList;
  var location = [];
  @override
  void initState() {
    initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    cityList = await BService.getCityList();
    if (widget.data.isNotEmpty) {
      String province = widget.data['province'];
      String city = widget.data['city'];
      String district = widget.data['district'];
      setState(() {
        _cityController.text = '$province${province == city ? '' : ' '}${province == city ? '' : city} $district';
        _nameController.text = widget.data['realName'];
        _mobileController.text = widget.data['phone'];
        _detailController.text = widget.data['detail'];
        _checked = widget.data['isDefault'] == 1;
        location.add(province);
        location.add(city);
        location.add(district);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          '新建收货人',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(16, 6, 16, 6),
            margin: EdgeInsets.fromLTRB(6, 16, 6, 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                // 收货人
                Row(
                  children: [
                    Container(
                      width: 80,
                      child: Text(
                        '收货人',
                        style: TextStyle(
                          color: Colors.black.withValues(alpha: 0.75),
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: '请填写收货人姓名',
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0x19000000),
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // 手机号码
                Row(
                  children: [
                    Container(
                      width: 80,
                      child: Text(
                        '手机号码',
                        style: TextStyle(
                          color: Colors.black.withValues(alpha: 0.75),
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _mobileController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: '请填写收货人手机号',
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0x19000000),
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // 所在地区
                Row(
                  children: [
                    Container(
                      width: 80,
                      child: Text(
                        '所在地区',
                        style: TextStyle(
                          color: Colors.black.withValues(alpha: 0.75),
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _cityController,
                        readOnly: true,
                        onTap: () {
                          PickerHelper.openCityPicker(context, this.cityList, onConfirm: (selectInfo, selectLocation) {
                            this.location = selectInfo;
                            var addr = selectInfo[0];
                            if (addr != selectInfo[1]) {
                              addr = addr + selectInfo[1];
                            }
                            addr += selectInfo[2];
                            _cityController.text = addr;
                            setState(() {});
                          }, title: '选择地区', selectCityIndex: [0, 0, 0]);
                        },
                        decoration: InputDecoration(
                          hintText: '省市区县、乡镇等',
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0x19000000),
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // 详细地址
                Row(
                  children: [
                    Container(
                      width: 80,
                      child: Text(
                        '详细地址',
                        style: TextStyle(
                          color: Colors.black.withValues(alpha: 0.75),
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _detailController,
                        decoration: InputDecoration(
                          hintText: '街道、楼牌号等',
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0x19000000),
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // 设置默认地址
                Row(
                  children: [
                    Text(
                      '设置默认地址',
                      style: TextStyle(
                        color: Colors.black.withValues(alpha: 0.75),
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(width: 20),
                    FlutterSwitch(
                      width: 50.0,
                      height: 24.0,
                      activeText: '',
                      inactiveText: '',
                      valueFontSize: 12.0,
                      activeColor: Colours.app_main,
                      toggleSize: 20.0,
                      value: _checked,
                      borderRadius: 24.0,
                      padding: 4.0,
                      showOnOff: true,
                      onToggle: (val) {
                        setState(() {
                          _checked = val;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          btmBarView(context),
        ],
      ),
    );
  }

  ///底部操作栏
  Widget btmBarView(BuildContext context) {
    return Positioned(
      bottom: 5,
      left: 5,
      right: 5,
      child: Container(
        padding: EdgeInsets.fromLTRB(
          8,
          8,
          8,
          MediaQuery.of(context).padding.bottom + 8,
        ),
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 44,
                child: ElevatedButton(
                  onPressed: () {
                    if (_nameController.text == '') {
                      ToastUtils.showToast('姓名不能为空');
                    } else if (_mobileController.text == '') {
                      ToastUtils.showToast('手机号不能为空');
                    } else if (_detailController.text == '') {
                      ToastUtils.showToast('详细地址不能为空');
                    } else if (location.isEmpty) {
                      ToastUtils.showToast('所在地区不能为空');
                    } else {
                      BService.addressEdit({
                        'id': widget.data.isEmpty ? null : widget.data['id'],
                        'real_name': _nameController.text,
                        'detail': _detailController.text,
                        'phone': _mobileController.text,
                        'is_default': _checked,
                        'address': {'province': location[0], 'city': location[1], 'district': location[2]}
                      }).then((value) => {Navigator.pop(context, true)});
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colours.app_main,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(56),
                    ),
                  ),
                  child: Text(
                    '保存',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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
}
