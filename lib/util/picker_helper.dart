/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */

import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';

const double _kPickerSheetHeight = 216.0;
const double _kPickerItemHeight = 32.0;

typedef PickerConfirmCityCallback = Function(List<dynamic>,List<int>);

class PickerHelper {

  static final textDarkGrayColor = Color.fromRGBO(64, 64, 64, 1.0);

  ///普通简易选择器
  static void openSimpleDataPicker<T>(
      BuildContext context, {
        required List<T> list,
        required String title,
        required T value,
        PickerDataAdapter? adapter,
        required PickerConfirmCallback onConfirm,
      }) {
    var incomeIndex = 0;
    if (list != null) {
      for (int i = 0; i < list.length; i++) {
        if (list[i] == value) {
          incomeIndex = i;
          break;
        }
      }
    }
    openModalPicker(context,
        adapter: adapter ??
            PickerDataAdapter(
              pickerData: list,
              isArray: false,
            ),
        onConfirm: onConfirm,
        selecteds: [incomeIndex],
        title: title);
  }

  ///数字选择器
  static void openNumberPicker(
      BuildContext context, {
        required String title,
        required List<NumberPickerColumn> datas,
        NumberPickerAdapter? adapter,
        required PickerConfirmCallback onConfirm,
      }) {
    openModalPicker(context,
        adapter: adapter ?? NumberPickerAdapter(data: datas),
        title: title,
        onConfirm: onConfirm);
  }

  ///日期选择器
  static void openDateTimePicker(
      BuildContext context, {
        required String title,
        required DateTime maxValue,
        required DateTime minValue,
        DateTime? value,
        DateTimePickerAdapter? adapter,
        required PickerConfirmCallback onConfirm,
      }) {
    openModalPicker(context,
        adapter: adapter ??
            DateTimePickerAdapter(
                type: PickerDateTimeType.kYMD,
                isNumberMonth: true,
                yearSuffix: "年",
                maxValue: maxValue,
                minValue: minValue,
                value: value ?? DateTime.now(),
                monthSuffix: "月",
                daySuffix: "日"),
        title: title,
        onConfirm: onConfirm);
  }

  ///地址选择器
  static void openCityPicker(BuildContext context, List cityList,
      {required String title,
        required PickerConfirmCityCallback onConfirm,
        List<int>? selectCityIndex}) async {
    /* 用于array
   * [
   *   {'一级标题1':
   *      [ {'二级标题1' : ['三级标题1','三级标题2']},
   *        {'二级标题2' : ['三级标题1','三级标题2']},
   *      ],
   *    '一级标题1':
   *      [ {'二级标题1' : ['三级标题1','三级标题2']},
   *        {'二级标题2' : ['三级标题1','三级标题2']},
   *      ],
   *   },
   * ]
   * */
    openModalPicker(context,
        adapter: PickerDataAdapter(
            data: cityList.map<PickerItem>((addressProvince) {
              var province = addressProvince['n'];
              var cities = addressProvince['c'];
              return PickerItem(
                text: Center(
                  child: Text(
                    province,
                    style: TextStyle(color: textDarkGrayColor,fontSize: 17),
                  ),
                ),
                value: province,
                children: cities.map<PickerItem<Object>>((cityModel) {

                  var cityStr = cityModel['n'];
                  return PickerItem(
                    text: Center(
                      child: Text(
                        cityStr,
                        style: TextStyle(color: textDarkGrayColor,fontSize: 17),
                      ),
                    ),
                    value: cityStr,
                    children: cityModel['c'].map<PickerItem<Object>>((districtModel) {
                      var area = districtModel['n'];
                      return PickerItem(
                          text: Center(
                            child: Text(
                              area,
                              style: TextStyle(color: textDarkGrayColor,fontSize: 17),
                            ),
                          ),
                          value: area
                      );
                    }).toList(),
                  );

                }).toList(),
              );
            }).toList()
        ),
        title: title, onConfirm: (pick, value) {
          onConfirm(pick.adapter.getSelectedValues(),value);
        },selecteds: selectCityIndex ?? [0,0,0]);
  }

  static void openModalPicker(
      BuildContext context, {
        required PickerAdapter adapter,
        required String title,
        List<int>? selecteds,
        required PickerConfirmCallback onConfirm,
      }) {
    new Picker(
      adapter: adapter,
      title: new Text(title),
      selecteds: selecteds,
      cancelText: '取消',
      confirmText: '确定',
      cancelTextStyle: TextStyle(color: Colors.black,fontSize: 16.0),
      confirmTextStyle: TextStyle(color: Colors.black,fontSize: 16.0),
      textAlign: TextAlign.right,
      itemExtent: _kPickerItemHeight,
      height: _kPickerSheetHeight,
      selectedTextStyle: TextStyle(color: textDarkGrayColor,fontSize: 17),
      onConfirm: onConfirm,
    ).showModal(context);
  }

}
