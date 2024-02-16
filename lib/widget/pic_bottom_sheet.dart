/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';

const double _cellHeight = 50.0;
const double _spaceHeight = 5.0;
const double _titleFontSize = 13.0;
const double _textFontSize = 18.0;

const String _cancelText = '取消';

class PicBottomSheet {
  static bool _isShowBottomSheet = false;

  /// 弹出底部文字
  /// index 从上往下 1，2，3，取消是0
  static void showText(
      BuildContext context, {
        String? title,
        List<String>? dataArr,
        String? redBtnTitle,
        bool isShowRadius = true,
        Function(int selectIndex, String selectText)? clickCallback,
      }) {
    if (_isShowBottomSheet) {
      return;
    }
    _isShowBottomSheet = true;
    var radius = isShowRadius ? 10.0 : 0.0;

    showModalBottomSheet(
      context: context,
      // 设置圆角
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(radius),
          topRight: Radius.circular(radius),
        ),
      ),
      // 抗锯齿
      clipBehavior: Clip.antiAlias,
      builder: (BuildContext context) {
        return PicBottomSheetView(
          title: title,
          dataArr: dataArr,
          redBtnTitle: redBtnTitle,
          clickCallBack: clickCallback,
        );
      },
    ).then((value) => _isShowBottomSheet = false);
  }
}

class PicBottomSheetView extends StatefulWidget {
  const PicBottomSheetView({
    Key? key,
    this.title,
    this.dataArr,
    this.redBtnTitle,
    this.clickCallBack,
  }) : super(key: key);

  final String? title;
  final List<String>? dataArr;
  final String? redBtnTitle;
  final Function(int selectIndex, String selectText)? clickCallBack;

  @override
  State<PicBottomSheetView> createState() => _PicBottomSheetViewState();
}

class _PicBottomSheetViewState extends State<PicBottomSheetView> {
  List<String> _dataArr = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.dataArr != null) {
      _dataArr = widget.dataArr!;
    }
    if (widget.redBtnTitle != null) {
      _dataArr.insert(_dataArr.length, widget.redBtnTitle!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  _body() {
    var titleHeight = _cellHeight;
    var titleLineHeight = 0.6;
    if (widget.title == null) {
      titleHeight = 0.0;
      titleLineHeight = 0.0;
    }
    var bgHeight =
        _cellHeight * (_dataArr.length + 1) + (_dataArr.length - 1) * 1 + _spaceHeight + titleHeight + titleLineHeight;

    // 默认颜色
    var redTextColor = dynamicColor(context, Color(0xFFE64242));
    var bgColor = dynamicColor(context, Colors.white, Color(0xFF1E1E1E));
    var titleColor = dynamicColor(context, Color(0xFF787878), Color(0xFF878787));
    var textColor = dynamicColor(context, Color(0xFF333333), Color(0xFFC6C6C6));
    var lineColor = dynamicColor(context, Color(0xFFE6E6E6), Color(0xFF232323));

    return Container(
      color: bgColor,
      height: bgHeight + MediaQuery.of(context).padding.bottom,
      child: Column(
        children: <Widget>[
          Container(
            color: bgColor,
            height: titleHeight,
            child: Center(
              child: Text(
                widget.title ?? '',
                style: TextStyle(fontSize: _titleFontSize, color: titleColor),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: titleLineHeight, child: Container(color: lineColor)),
          ListView.separated(
            padding: const EdgeInsets.all(0),
            itemCount: _dataArr.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              Color btnTextColor =
              (widget.redBtnTitle != null && index == _dataArr.length - 1) ? redTextColor : textColor;

              return GestureDetector(
                child: Container(
                  height: _cellHeight,
                  color: bgColor,
                  child: Center(
                    child: Text(
                      _dataArr[index],
                      style: TextStyle(fontSize: _textFontSize, color: btnTextColor),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                onTap: () {
                  widget.clickCallBack?.call(index + 1, _dataArr[index]);
                  Navigator.of(context).pop();
                },
              );
            },
            separatorBuilder: (context, index) => Divider(height: 1, color: lineColor),
          ),
          SizedBox(height: _spaceHeight, child: Container(color: lineColor)),
          GestureDetector(
            child: Container(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
              height: _cellHeight + MediaQuery.of(context).padding.bottom,
              color: bgColor,
              child: Center(
                child: Text(
                  _cancelText,
                  style: TextStyle(fontSize: _textFontSize, color: textColor),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            onTap: () {
              widget.clickCallBack?.call(0, _cancelText);
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  static Color dynamicColor(BuildContext context, Color lightColor, [Color? darkColor]) {
    var isDark = false;
    return isDark ? darkColor ?? lightColor : lightColor;
  }
}
