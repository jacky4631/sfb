/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:maixs_utils/model/data_model.dart';
import 'package:maixs_utils/util/utils.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:sufenbao/search/search_page.dart';
import 'package:sufenbao/search/view.dart';

import '../util/colors.dart';
import '../util/paixs_fun.dart';

///搜索框
class SearchBarWidget extends StatefulWidget {
  final String keyword;
  final DataModel dataModel;
  final Function(String) onChanged;
  final Function(String, TextEditingController) onSubmit;
  final Function() onClear;
  final Function(FocusNode f) onTap;
  final bool readOnly;
  bool autoFocus;

  SearchBarWidget(this.keyword, this.dataModel,
      {Key? key, this.readOnly = false, required this.onChanged, required this.onSubmit,
      required this.onClear, required this.onTap, this.autoFocus = false}) : super(key: key);
  @override
  _SearchBarWidgetState createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late Timer timer;
  var pageCon = PageController();
  TextEditingController textCon = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    textCon.text = widget.keyword;
    // focusNode.addListener(() => focusNodeValue.changeHasFocus(focusNode.hasFocus));
      timer = Timer.periodic(Duration(seconds: 5), (t) {
        if (widget.keyword == '' && widget.dataModel.list.isNotEmpty){
          pageCon.animateToPage(
            pageCon.page?.toInt() == widget.dataModel.list.length - 1 ? 0 : (pageCon.page?.toInt()??0) + 1,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeOutCubic,
          );
        }
      });
  }

  @override
  void dispose() {
    if(pageCon != null) {
      pageCon.dispose();
    }
    if(timer != null) {
      timer.cancel();
    }
    super.dispose();
  }

  jump() {
    Navigator.pushNamed(context, '/searchResult', arguments: {'keyword':widget.dataModel.list[pageCon.page?.toInt()??0]['words'] });
  }

  @override
  Widget build(BuildContext context) {
    return PWidget.container(
      PWidget.row([
        Expanded(
          child: Stack(children: [
            if (widget.dataModel.list.isEmpty) PWidget.container(PWidget.textNormal('搜索商品或粘贴宝贝标题', [Colors.grey]), {'ali': PFun.lg(-1, 0), 'pd': PFun.lg(0, 0, 8, 8)}),
            if (widget.dataModel.list.isNotEmpty)
              PWidget.container(PageView.builder(
                controller: pageCon,
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.dataModel.list.length,
                itemBuilder: (_, i) {
                  var data = widget.dataModel.list[i];
                  return PWidget.container(
                    Row(children: [
                      PWidget.wrapperImage('${data['pic']}_100x100', [18, 18], {'br': 8}),
                      PWidget.boxw(2),
                      PWidget.text(data['theme'], [Colors.grey],{'exp':true}),
                    ],),
                    {'ali': PFun.lg(-1, 0), 'pd': PFun.lg(0, 0, 8, 8)},
                  );
                },
              )),
            PWidget.container(
              buildTFView(
                context,
                height: 48,
                hintText: '',
                hintSize: 14,
                textSize: 14,
                autofocus: widget.autoFocus,
                readOnly: widget.readOnly,
                textColor: Colors.black.withOpacity(0.75),
                con: textCon,
                focusNode: focusNode,
                onSubmitted: (v) {
                  if(v.isEmpty) {
                    v = widget.dataModel.list[pageCon.page?.toInt()??0]['words'];
                  }
                  widget.onSubmit(v, textCon);
                  },
                onChanged: (v) {
                  focusNodeValue.changeHasFocus(textCon.text.isNotEmpty);
                  widget.onChanged(v);
                  setState(() {});
                },
                onTap: () {
                  widget.onTap(focusNode);
                },
                padding: EdgeInsets.symmetric(horizontal: 8),
              ),
              [null, null, Colors.white.withOpacity(textCon.text.isNotEmpty ? 1 : 0)],
              {'br': 20,},
            ),
          ]),
        ),
        if (textCon.text.isNotEmpty)
          PWidget.container(
            PWidget.icon(Icons.close_rounded, [Colors.black.withOpacity(0.5), 16]),
            [28, 28, Colors.black.withOpacity(0.1)],
            {'br': 20,'mg': [0,0,0,4], 'fun': () => clearSearch()},
          ),
        if (textCon.text.isEmpty)
        PWidget.container(
          PWidget.text('搜索', [Colors.white]),
          {
            'ali': PFun.lg(0, 0),
            'br': 20,
            'fun': () {
              if(widget.readOnly) {
                widget.onSubmit('', textCon);
                return;
              }
              String searchTxt = textCon.text;
              if(searchTxt.isEmpty) {
                searchTxt = widget.dataModel.list[pageCon.page?.toInt()??0]['words'];
              }
              widget.onSubmit(searchTxt, textCon);
            },
            'mg':2,
            'pd': PFun.lg(0, 0, 16, 16),
            'gd': PFun.cl2crGd(Colours.dark_app_main, Colours.app_main),
          },
        ),
      ]),
      [null, null, Colors.white],
      {'bd': PFun.bdAllLg(Colours.app_main, 1.5), 'br': 20, 'exp': true, 'crr': 8},
    );
  }

  clearSearch() {
    textCon.clear();
    widget.onClear();
    setState(() {

    });
  }
}
