/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:maixs_utils/model/data_model.dart';
import 'package:maixs_utils/widget/anima_switch_widget.dart';
import 'package:maixs_utils/widget/my_custom_scroll.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';
import 'package:maixs_utils/widget/views.dart';
import 'package:sufenbao/me/fans/fans_util.dart';
import 'package:sufenbao/search/view.dart';
import 'package:sufenbao/service.dart';
import 'package:sufenbao/widget/CustomWidgetPage.dart';

import '../../util/colors.dart';
import '../../util/global.dart';
import '../../util/login_util.dart';
import '../../util/paixs_fun.dart';
import '../../widget/order_tab_widget.dart';
import 'fans_search_notifier.dart';
//我的粉丝
class Fans extends StatelessWidget {
  final Map data;
  Fans(this.data, {Key? key,}) : super(key: key);

  TextEditingController textCon = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Widget body;
    if(Global.appInfo.spreadLevel == 2) {
      body = TopChild({'title':'金客','index':0});
    } else {
      var tabDm = DataModel();
      tabDm.addList([{'title':'金客','index':0},{'title':'银客','index':1}], true, 0);
      body = AnimatedSwitchBuilder(
        value: tabDm,
        initialState: buildLoad(color: Colors.white),
        listBuilder: (list, _, __) {
          var tabList = list.map<Map>((m) => m).toList();
          return OrderTabWidget(
            color: Colours.app_main,
            unselectedColor: Colors.black.withOpacity(0.5),
            fontSize: 15,
            tabList: tabList,
            padding: EdgeInsets.only(bottom: 10),
            indicatorColor: Colours.app_main,
            indicatorWeight: 2,
            tabPage: List.generate(list.length, (i) {
              return TopChild(tabDm.list[i]);
            }),
          );
        });
    }
    return ScaffoldWidget(
      resizeToAvoidBottomInset: false,
      bgColor: Color(0xfffafafa),
      brightness: Brightness.dark,
      appBar:_searchBar(context),
      body: body,
    );
  }

  _searchBar(BuildContext context) {
    return PWidget.container(
      PWidget.row([
        PWidget.container(
            PWidget.icon(
                Icons.arrow_back_ios_rounded, [Colors.black.withOpacity(0.75)]),
            [40, 40],
            {'fun': () => Navigator.pop(context)}),
        PWidget.container(
          PWidget.row([
            Expanded(child: PWidget.container(
                buildTFView(
                  context,
                  height: 56,
                  hintText: '搜索手机号码或用户昵称',
                  hintSize: 14,
                  textSize: 14,
                  textColor: Colors.black.withOpacity(0.75),
                  con: textCon,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  onChanged: (String text){
                    if(text.isEmpty) {
                      fansSearchNotifier.value = '';
                    }
                  },
                  onSubmitted: (String text) {
                    fansSearchNotifier.value = text;
                  }
                ),
                [null, null, Colors.white.withOpacity((textCon.text??'').isNotEmpty ? 1 : 0)],
                {'br': 20,},
              ),
            ),
            PWidget.container(
              PWidget.text('搜索', [Colours.dark_text_color]),
              {
                'ali': PFun.lg(0, 0),
                'br': 20,
                'fun': () {
                  fansSearchNotifier.value = textCon.text;
                },
                'mg':2,
                'pd': PFun.lg(0, 0, 16, 16),
                'gd': PFun.cl2crGd(Colours.yellow_bg, Colours.vip_dark),
              },
            ),
          ]),
          [null, 58, Colors.white],
          {'bd': PFun.bdAllLg(Colours.vip_dark, 1.5), 'br': 20, 'exp': true, 'crr': 8},
        ),
      ]),
      [null, 58 + pmPadd.top],
      {'pd': PFun.lg(pmPadd.top + 8, 8,8,8)},
    );
  }
}

class TopChild extends StatefulWidget {
  final Map data;
  const TopChild(this.data, {Key? key,}) : super(key: key);

  @override
  _TopChildState createState() => _TopChildState();
}

class _TopChildState extends State<TopChild> {
  num total = 0;
  num index = 0;
  Map spreadUser = new Map();
  @override
  void initState() {
    initData();
    super.initState();
    fansSearchNotifier.addListener(initData);
  }
  @override
  void dispose() {
    fansSearchNotifier.removeListener(initData);
    super.dispose();
  }
  ///初始化函数
  Future initData() async {
    index = widget.data['index'];
    await getListData(isRef: true);
    await initSpreadUser();
  }

  ///列表数据
  var listDm = DataModel();
  Future<int> getListData({int page = 1, bool isRef = false}) async {
    var res;
    if(index == 0) {
      res = await BService.fans(page, keyword: fansSearchNotifier.value);
    } else {
      res = await BService.fans(page, grade: 1, keyword: fansSearchNotifier.value);
    }
    if (res != null) {
      total = res['data']['total'];
      listDm.addList(res['data']['list'], isRef, total);
    }
    setState(() {});
    return listDm.flag;
  }
   initSpreadUser() async {
    if(index == 0) {
      spreadUser = await BService.userSpread();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyCustomScroll(
      isGengduo: listDm.hasNext,
      isShuaxin: true,
      onRefresh: () => this.getListData(isRef: true),
      onLoading: (p) => this.getListData(page: p),
      refHeader: buildClassicHeader(color: Colours.app_main),
      refFooter: buildCustomFooter(color: Colours.app_main),
      headers: [top()],
      crossAxisSpacing: 8,
      itemPadding: EdgeInsets.all(8),
      itemModel: listDm,
      itemModelBuilder: (i, v) {
        Map data = v as Map;
        String phone = data['phone']??'';
        if(!Global.isEmpty(phone)) {
          phone = phone.replaceAll(phone.substring(3,7),"****");
        }
        String nickname = data['nickname']??'';
        if(nickname.isNotEmpty && Global.isPhone(nickname)) {
          nickname = nickname.replaceAll(nickname.substring(3,7), '****');
        }
        String showName = nickname.isEmpty ? phone : nickname;

        data['showName'] = showName;
        String feeStr = getFansFee(data['fee']??'0');

        String updateTime = data['updateTime'];
        double padding = 12;
        if(index != 0) {
          padding= 56;
        }
        return PWidget.container(
          PWidget.column([
            PWidget.row(
                [
                  PWidget.wrapperImage('${data['avatar']}', [64, 64], {'br': 8,'fun':(){
                    // showSignDialog(context, title: '提示',
                    //     desc: '是否帮助${data['showName']}加盟',
                    //     okTxt: '去加盟', () async {
                    //   Map<String, dynamic> card = await BService.userCard();
                    //   String contractPath = card['contractPath']??'';
                    //   if(contractPath.isEmpty) {
                    //     showSignDialog(context, (){
                    //       Navigator.pushNamed(context, '/shopAuthPage');
                    //     });
                    //     return;
                    //   }
                    //   onTapLogin(context, '/tabVip', args: {'index': 0, 'user': data});
                    // });
                    AwesomeDialog(
                        dialogType: DialogType.noHeader,
                        showCloseIcon: true,
                        context: context,
                        body: CardDialog(data)
                    )..show();
                  }}),
                  PWidget.boxw(8),
                  PWidget.column([
                    PWidget.row([
                      PWidget.text(showName,),
                      createFansLevelWidget(data),
                    ]),
                    PWidget.boxh(16),
                    PWidget.textNormal('加入日期：${data['time']}',[Colors.black.withOpacity(0.5), 13])
                  ],'021'),

                  PWidget.spacer(),
                  if(index == 0)
                    PWidget.textNormal('', [], {'fun':(){
                      Navigator.pushNamed(context, '/fansDetailPage', arguments: data);
                    }}, [
                      PWidget.textIsNormal('邀请明细 >', [Colors.black.withOpacity(0.75)]),
                    ]),
                  if(index != 0)
                    PWidget.textNormal('', [], {'fun':(){
                      Navigator.pushNamed(context, '/feeTabPage', arguments: data);
                    }}, [
                      PWidget.textIsNormal('本月预估 >', [Colors.black.withOpacity(0.75)]),
                    ]),
                ],'021'),
            PWidget.boxh(12),
            PWidget.row(
              [
                PWidget.column([
                  PWidget.text(updateTime, [Colors.black.withOpacity(0.75)]),
                  PWidget.textNormal('最近登录', [Colors.black.withOpacity(0.5)], ),
                ],'221'),
                PWidget.spacer(),
                SizedBox(height: 15, child: VerticalDivider(color: Colors.black.withOpacity(0.75),),),

                PWidget.spacer(),
                PWidget.column([
                  PWidget.text(feeStr, [Colors.black.withOpacity(0.75),13],
                      {
                        'td': TextDecoration.underline,
                        'fun':(){
                          Navigator.pushNamed(context, '/feeTabPage', arguments: data);
                        }}),
                  PWidget.textNormal('本月预估', [Colors.black.withOpacity(0.5),13]),
                ],'221'),
                if(index == 0)
                  PWidget.spacer(),
                if(index == 0)
                  SizedBox(height: 15, child: VerticalDivider(color: Colors.black.withOpacity(0.75),),),
                if(index == 0)
                  PWidget.spacer(),
                if(index == 0)
                  PWidget.column([
                    PWidget.text(data['childCount'], [Colors.black.withOpacity(0.75),13],
                        {
                          'td': TextDecoration.underline,
                          'fun':(){
                            Navigator.pushNamed(context, '/fansDetailPage', arguments: data);
                          }}),
                    PWidget.textNormal('用户数量', [Colors.black.withOpacity(0.5),13], ),
                  ],'221'),

              ],
              '221',
              {'pd':[0,0,padding,padding]},
            )
          ]),
          [null, 130, Colors.white],
          {'pd': 8,'mg':[6,6,12,12],'br':12},
        );
      },
    );
  }
  
  createFansLevelWidget(data) {
    return PWidget.row([
      PWidget.boxw(4),
      if(data['level'] == 5)
        getLevelWidget(5, 'tb'),
      if(data['levelJd'] == 5)
        getLevelWidget(5, 'jd'),
      if(data['levelPdd'] == 5)
        getLevelWidget(5, 'pdd'),
      if(data['levelDy'] == 5)
        getLevelWidget(5, 'dy'),
      if(data['levelVip'] == 5)
        getLevelWidget(5, 'vip'),
    ],{'pd':[4,0,0,0]});
  }

  Widget top() {
    if(index == 0) {
      return
        PWidget.container(PWidget.row([
          if(spreadUser.isNotEmpty)
          PWidget.column([
            PWidget.boxh(10),
            PWidget.text(Global.getHideName(spreadUser['nickname']), [Colors.black, 20]),
            PWidget.boxh(4),
            PWidget.textNormal(spreadUser['phone'], [Colors.black], ),
            PWidget.boxh(4),
            PWidget.textNormal('我的邀请人',[Colors.grey]),
            PWidget.boxh(20)
          ],'221'),
          PWidget.column([
            PWidget.boxh(10),
            PWidget.text('$total', [Colors.black, 20]),
            PWidget.boxh(4),
            PWidget.textNormal(Global.appInfo.spreadLevel == 3 ? '我的金客' : '我的用户', [Colors.black], ),
              PWidget.boxh(4),
              PWidget.textNormal('去邀请 >',[Colours.app_main], {'fun':(){
                onTapLogin(context, '/sharePage');
              }}),
            PWidget.boxh(20)
          ],'221'),
        ],'251'));
    }
    return
      PWidget.container(PWidget.row([
        PWidget.column([
          PWidget.boxh(10),
          PWidget.text('$total', [Colors.black, 20]),
          PWidget.boxh(4),
          PWidget.textNormal('我的银客', [Colors.black], ),
          PWidget.boxh(20)
        ],'221'),
      ],'221'));
  }
}
class CardDialog extends Dialog {
  final Map data;
  CardDialog(this.data);

  @override
  Widget build(BuildContext context) {
    return PWidget.container(
        PWidget.column([
        PWidget.textNormal('我的用户', [Colors.black,18],{'ct':true}),
        PWidget.boxh(15),
        PWidget.textNormal('您想为‘${data['showName']}’做些什么', [Colors.black,14],{'ct':true}),
        PWidget.boxh(15),
        PWidget.row([
          TextButton(onPressed: (){
                  press(context,0);
                },
              child: Text("加盟星选会员",style: TextStyle(color: Colors.white,fontSize: 14)),
              style : TextButton.styleFrom(
                padding: EdgeInsets.only(top: 4, left: 14, right: 14, bottom: 4),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                backgroundColor: Colours.app_main,))
        ],'221')
      ],{'pd':[10,20,15,15]}),
    );
  }

  Future<void> press(BuildContext context, int rechargeType) async {
      Map<String, dynamic> card = await BService.userCard();
      String contractPath = card['contractPath']??'';
      if(contractPath.isEmpty) {
        showSignDialog(context, (){
          Navigator.pushNamed(context, '/shopAuthPage');
        });
        return;
      }
      data['rechargeType'] = rechargeType;
      onTapLogin(context, '/tabVip', args: {'index': 0, 'user': data});
  }
}
