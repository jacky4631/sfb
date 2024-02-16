/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';
import 'package:maixs_utils/widget/views.dart';
import 'package:sufenbao/service.dart';

import '../util/colors.dart';
import '../util/picker_helper.dart';
import '../util/paixs_fun.dart';
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
    if(widget.data!= null && widget.data.isNotEmpty) {
      String province = widget.data['province'];
      String city = widget.data['city'];
      String district = widget.data['district'];
      setState(() {
        _cityController.text = '$province${province ==city?'':' '}${province ==city ? '': city} $district';
        _nameController.text = widget.data['realName'];
        _mobileController.text = widget.data['phone'];
        _detailController.text = widget.data['detail'];
        _checked = widget.data['isDefault']==1;
        location.add(province);
        location.add(city);
        location.add(district);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      body: Stack(
        children: [
          PWidget.container(null, [double.infinity, double.infinity],
              {'gd': PFun.tbGd(Colors.white, Colors.white)}),
          ScaffoldWidget(
            brightness: Brightness.dark,
            bgColor: Colors.transparent,
            appBar: buildTitle(context,
                title: '新建收货人',
                widgetColor: Colors.black,
                leftIcon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                )),
            body: PWidget.container(
              PWidget.ccolumn([
                PWidget.row([
                  PWidget.text(
                      '收货人    ', [Colors.black.withOpacity(0.75), 16]),
                  buildTextField2(hint:'请填写收货人姓名', showSearch:false,con: _nameController, height:40, bgColor: Colors.white, border: new UnderlineInputBorder( // 焦点集中的时候颜色
                      borderSide: BorderSide(
                          color: Color(0x19000000),
                      ),)
                  )
                ]),
                PWidget.boxh(20),
                PWidget.row([
                  PWidget.text(
                      '手机号码', [Colors.black.withOpacity(0.75), 16]),
                  buildTextField2(hint:'请填写收货人手机号', showSearch:false, con: _mobileController, height:40, bgColor: Colors.white, keyboardType: TextInputType.number,border: new UnderlineInputBorder( // 焦点集中的时候颜色
                    borderSide: BorderSide(
                      color: Color(0x19000000),
                    ),)
                  )
                ]),
                PWidget.boxh(20),
                PWidget.row([
                  PWidget.text(
                      '所在地区', [Colors.black.withOpacity(0.75), 16]),
                  buildTextField2(hint:'省市区县、乡镇等', showSearch:false,height:40, bgColor: Colors.white,
                      con: _cityController,
                      onTap: (){
                        PickerHelper.openCityPicker(context, this.cityList, onConfirm: (selectInfo,selectLocation) {
                          this.location = selectInfo;
                          var addr = selectInfo[0];
                          if(addr != selectInfo[1]) {
                            addr = addr+ selectInfo[1];
                          }
                          addr += selectInfo[2];
                          _cityController.text = addr;

                          setState(() {});
                        },title: '选择地区',selectCityIndex: [0,0,0]);
                      },
                      border: new UnderlineInputBorder( // 焦点集中的时候颜色
                    borderSide: BorderSide(
                      color: Color(0x19000000),
                    ))
                  )
                ]),
                PWidget.boxh(20),
                PWidget.row([
                  PWidget.text(
                      '详细地址', [Colors.black.withOpacity(0.75), 16]),
                  buildTextField2(hint:'街道、楼牌号等', showSearch:false, con: _detailController, height:40, bgColor: Colors.white, border: new UnderlineInputBorder( // 焦点集中的时候颜色
                    borderSide: BorderSide(
                      color: Color(0x19000000),
                    ),)
                  )
                ]),
                PWidget.boxh(20),
                PWidget.row([
                  PWidget.text(
                      '设置默认地址', [Colors.black.withOpacity(0.75), 16]),
                  PWidget.boxw(20),
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
                  )
                ]),
              ]),
              [null, null, Colors.white],
              {'br': 8, 'pd': [12,12,11,5], 'mg': PFun.lg(6, 16, 6, 6)},
            ),
          ),
          btmBarView(context),
        ],
      ),
    );
  }

  ///底部操作栏
  Widget btmBarView(BuildContext context) {
    return PWidget.positioned(
      PWidget.container(
        PWidget.row([
          PWidget.container(
            PWidget.row([
              PWidget.container(
                PWidget.ccolumn([
                  PWidget.text('', [], {}, [
                    PWidget.textIs('保存', [Colors.white, 16, true]),
                  ]),
                ], '221'),
                [null, null, Colours.app_main],
                {
                  'exp': true,
                },
              ),
            ]),
            [null, 44],
            {'crr': 56, 'exp': true},
          ),
        ]),
        [null, null, Colors.white],
        {
          'pd': [8, MediaQuery.of(context).padding.bottom+8, 8, 8],
          'fun': () => {
            if(_nameController.text=='') {
              ToastUtils.showToast('姓名不能为空')
            }else if(_mobileController.text=='') {
              ToastUtils.showToast('手机号不能为空')
            }else if(_detailController.text=='') {
              ToastUtils.showToast('详细地址不能为空')
            }else if(location==null || location.isEmpty) {
              ToastUtils.showToast('所在地区不能为空')
            } else{
              BService.addressEdit({
                'id': widget.data == null ? null : widget.data['id'],
                'real_name': _nameController.text,
                'detail': _detailController.text,
                'phone': _mobileController.text,
                'is_default': _checked,
                'address': {
                  'province': location[0],
                  'city': location[1],
                  'district': location[2]
                }
              }).then((value) => {
                Navigator.pop(context, true)
              })
            }

          }
        },
      ),
      [null, 0, 5, 5],
    );
  }

}


