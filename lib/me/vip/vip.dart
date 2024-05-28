/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'dart:ui';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluwx/fluwx.dart';
import 'package:maixs_utils/model/data_model.dart';
import 'package:maixs_utils/util/utils.dart';
import 'package:maixs_utils/widget/my_custom_scroll.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';
import 'package:maixs_utils/widget/views.dart';
import 'package:sufenbao/util/global.dart';
import 'package:sufenbao/util/toast_utils.dart';
import 'package:vector_math/vector_math.dart' as vector;

import '../../../service.dart';
import '../../../util/colors.dart';
import '../../util/bao_icons.dart';
import '../../util/login_util.dart';
import '../../util/paixs_fun.dart';
import '../../widget/CustomWidgetPage.dart';
import '../../widget/custom_button.dart';
import '../../widget/my_scroll_view.dart';
import '../listener/PersonalNotifier.dart';
import '../listener/WxPayNotifier.dart';

const marginSide = 14.0;

class VipPage extends StatefulWidget {
  final Map data;

  const VipPage(this.data, {Key? key}) : super(key: key);
  @override
  _VipPageState createState() => _VipPageState(data);
}

class _VipPageState extends State<VipPage> {
  final Map data;
  _VipPageState(this.data);

  late PageController _pageController;
  final _pageNotifier = ValueNotifier(0.0);
  int _withdrawalType = 1;
  List _grades = [];
  Map gradeModel = {};
  Map<String, dynamic> userinfo = {};
  int selectedGrade = 1;
  num price = 0;
  List<Widget> lastItems = [];
  String expired = '';
  bool payEnabled = true;
  bool loading = true;
  String levelKey = 'level';
  int userLevel = 1;
  bool isDispose = false;
  //rechargeType 0=年卡 2=月卡
  int rechargeType = 0;
  num valid = 0;

  Map helpUser = {};
  void _listener() {
    _pageNotifier.value = _pageController.page!;
    bool isInt = _pageNotifier.value % 1 == 0;
    if (isInt) {
      //滑动tab后保留上一次的会员卡片
      data['data'] = null;
      _initGradeData(_pageNotifier.value.toInt());
    }
    setState(() {});
  }

  _initGradeData(index) {
    gradeModel = _grades[index];
    selectedGrade = gradeModel['grade'];
    if(rechargeType == 0) {
      price = gradeModel['money'];
      valid = gradeModel['validDate'];
    }
    //当前是否可以支付 如果用户过期或者选择的等级
    payEnabled = (userLevel == EXPIRED_LEVEL) || ((selectedGrade >= userLevel) && selectedGrade > 1 && price >0);
    //帮助加盟的用户不为空 校验其等级 是否允许支付
    if(helpUser.isNotEmpty) {
      var helpUserLevel = helpUser[levelKey];
      //当用户等级小于5允许支付
      payEnabled = (helpUserLevel == EXPIRED_LEVEL) || (helpUserLevel < 5);
    }
    initTermItems();

  }

  @override
  void initState() {
    super.initState();
    initData();
    wxPayNotifier.addListener(_wechatPayCallback);
  }

  void _wechatPayCallback() {
    WeChatResponse res = wxPayNotifier.value;
    if (res != null && res is WeChatPaymentResponse) {
      WeChatPaymentResponse payRes = res;
      if (payRes.errCode == 0) {
        ToastUtils.showToast('支付成功');
        refreshAfterPaySuccess();
      } else if (payRes.errCode == -2) {
        ToastUtils.showToast('用户取消支付了');
      } else {
        ToastUtils.showToast('支付失败原因：${payRes.errStr}');
      }
    }
  }

  refreshVd() {
    personalNotifier.value = true;
  }

  Future initData() async {
    if(data.isEmpty) {
      return;
    }
    helpUser = data['data']['user']??{};
    _grades = data['vipData']['list'];
    levelKey = data['vipData']['key'];
    userinfo = await BService.userinfo();
    //如果用户等级为0，相当于1
    if(userinfo[levelKey] > 0) {
      userLevel = userinfo[levelKey];
    }
    //显示最终等级
    int index = _grades.indexWhere((element) {
      return element['grade'] == userLevel;
    });
    if(data['data'] != null && data['data']['index'] != null) {
      index = data['data']['index'];
    }
    if(helpUser.isNotEmpty) {
      rechargeType = helpUser['rechargeType'];
    } else if(data['data']['rechargeType'] != null) {
      rechargeType = data['data']['rechargeType'];
    }
    _initGradeData(index);
    _pageNotifier.value = index.toDouble();
    _pageController =
        PageController(initialPage: index, viewportFraction: 0.78);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pageController.addListener(_listener);
    });
    setState(() {
      loading = false;
    });
  }

  @override
  void dispose() {
    isDispose = true;
    _pageController.removeListener(_listener);
    _pageController.dispose();
    _pageNotifier.dispose();
    super.dispose();
    wxPayNotifier.removeListener(_wechatPayCallback);
  }

  ///列表数据
  var listDm = DataModel();
  initTermItems() {
    listDm.list.clear();
    int dOne = gradeModel['discountOne'].toInt();
    int dTwo = gradeModel['discountTwo'].toInt();
    var term = getTerm();
    List list = [
      {'type': 1, 'path': 'assets/svg/integral.svg', 'title': '订单奖励', 'content': term + '自购奖励',
        'fun': () {
          ToastUtils.showToast('自购可获得$term红包奖励');
        }
      }];

    if(dOne > 0) {
      list.add({'type': 1, 'path': 'assets/svg/fans.svg', 'title': '金客订单奖励',
        'content': '金客订单额外奖励','color':Color(0XFFFFD700),
        'fun': () {
          ToastUtils.showToast('奖励金客订单拆红包的$dOne%');
        }
      });
    }
    if(dTwo > 0) {
      list.add({'type': 1, 'path': 'assets/svg/fans.svg', 'title': '银客订单奖励',
        'content': '银客订单额外奖励','color':Color(0XFFC0C0C0),
        'fun': () {
          ToastUtils.showToast('奖励银客订单拆红包的$dTwo%');
        }
      });
    }
    if (selectedGrade != 1) {
      list.add({'type': 1, 'path': 'assets/svg/member.svg', 'title': '金客加盟奖励',
        'content': '金客加盟返红包','color':Color(0XFFFFD700),
        'fun': () {
          ToastUtils.showToast('奖励金客加盟的${userinfo['storeBrokerageRatio']}%');
        }
      });
      list.add({'type': 1, 'path': 'assets/svg/member.svg', 'title': '银客加盟奖励',
        'content': '银客加盟返红包','color':Color(0XFFC0C0C0),
        'fun': () {
          ToastUtils.showToast('奖励银客加盟的${userinfo['storeBrokerageTwo']}%');
        }
      });
    }
    list.add({'type': 1, 'path': 'assets/svg/iphone.svg', 'title': '积分兑换', 'icon': BaoIcons.shop,
      'content': '苹果手机可兑',
      'fun': () {
        ToastUtils.showToast('请去积分商城兑换商品');
      }
    },
    );
    list.add({'type': 1, 'path': 'assets/svg/integral.svg', 'title': '赠送热度',
      'content': '热度可转订单',
      'fun': () {
        ToastUtils.showToast('赠送一定数量热度');
      }
    });
    list.add({'type': 1, 'path': 'assets/svg/coupon.svg', 'title': '隐藏优惠',
      'content': '海量优惠券',
      'fun': () {
        ToastUtils.showToast('先领券再下单，花更少的钱，购超值的物');
      }
    });
    list.add({'type': 1, 'path': 'assets/svg/more.svg', 'title': '更多特权', 'content': '',
      'fun': () {
        ToastUtils.showToast('敬请期待');
      }
    });

    listDm.addList(list, false, 10);
    return listDm;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if(data['multi']) {
      return ScaffoldWidget(
          bgColor: Colours.vip_white,
          body: createContent(size)
      );
    }
    return ScaffoldWidget(
      brightness: Brightness.dark,
      appBar: buildTitle(context,
          title: '加盟星选会员',
          widgetColor: Colours.vip_black,
          color: Colours.vip_white,
          leftIcon: Icon(
            Icons.arrow_back_ios,
            color: Colours.vip_black,
          )),
      bgColor: Colours.vip_white,
      body: createContent(size)
    );
  }

  createContent(size){
    List<Widget> widgets = [
      loading
          ? Global.showLoading2()
          : PWidget.container(PageView.builder(
          controller: _pageController,
          itemCount: _grades.length,
          itemBuilder: (context, index) {
            return createItem(index, size);
          }),[null, 200]),
      PWidget.container(MyCustomScroll(
        isShuaxin: false,
        isGengduo: false,
        itemPadding: EdgeInsets.all(5),
        crossAxisCount: 2,
        btmWidget: SizedBox(),
        itemModel: listDm,
        itemModelBuilder: (i, v) {
          return PWidget.container(
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: createBoxItem(v)),
            [null, null, Colors.white],
            {'pd': 2, 'mg': PFun.lg(0, 16), 'fun': v['fun']},
          );
        },
      ),[null, 250]),
      createPayItem()
    ];
    return Stack(children: [
      ListView.builder(
          itemCount: widgets.length,
          itemBuilder: (context, i) {
            return widgets[i];
          }),
    ],);
  }

  createBoxItem(v) {
    Widget titleWidget;
    Widget descWidget;
    String title = v['title'];
    String desc = v['content'];

    titleWidget = PWidget.text(title, [Colors.black, 14]);
    if(userLevel == 5) {
      descWidget = shimmerWidget(PWidget.textNormal(desc, [Colors.black, 12]));
    } else {
      descWidget = PWidget.textNormal(desc, [Colors.black, 12]);
    }
    return [
      v['icon'] ==null ?
      SvgPicture.asset(
          v['path'],
          width: 24,
          height: 24,
          color: v['color']
      ):PWidget.icon(v['icon'], [Colors.red, 24]),
      PWidget.boxh(5),
      titleWidget,
      descWidget,
    ];
  }

  Widget createItem(index, size) {
    String expired = '';
    if (userinfo[data['vipData']['key']] == _grades[index]['grade'] && helpUser.isEmpty) {
      expired = userinfo[data['vipData']['expKey']]??'';
      if (expired.isNotEmpty) {
        expired = expired.split(' ')[0];
        expired = '$expired到期';
      }
    }

    final t = (index - _pageNotifier.value);
    final translationXShoes = lerpDouble(0, 150, t);
    final rotationShoe = lerpDouble(0, -45, t)!;

    final transformShoe = Matrix4.identity();
    transformShoe.translate(translationXShoes);
    transformShoe.rotateZ(vector.radians(rotationShoe));
    return InkWell(
          onTap: () {
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Stack(
                  children: [
                    PWidget.image('assets/images/lv/vip_bg.png', [450, 310],),
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "星选会员",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              )
                            ],
                          ),
                          Spacer(),
                          Row(
                            children: [
                              !Global.isEmpty(expired)
                                  ? PWidget.container(
                              shimmerWidget(PWidget.text(expired, [Colors.white, 12],{'pd':[0,0,4,4]}),
                                  color: Colors.white),
                                      [],
                                      {
                                        'pd': PFun.lg(4, 4, 4, 18),
                                      },
                                    )
                                  : SizedBox(),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
              ),
            ],
          ),
        );
  }

  Widget createPayItem() {
    List<Widget> items = [];

    items.add(PWidget.boxh(10));
    if(_withdrawalType != 0) {
      items.add(PWidget.boxh(10));
    }
    items.add(createPayBtn());

    return MyScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      children: items,
    );
  }

  Widget createPayBtn() {
    String okTxt = '立即加盟';
    if(helpUser.isNotEmpty) {
      okTxt = '立即代付';
    }
    return PWidget.container(CustomButton(
      bgColor: payEnabled ? Colours.open_shop : Colors.grey,
      showIcon: false,
      textColor: payEnabled ? Colors.white : Colours.text_disabled,
      text:
      _withdrawalType == 0 ? '立即升级' : okTxt,
      borderRadius: BorderRadius.all(Radius.circular(22.0)),
      onPressed: () async {
        if (!payEnabled) {
          return;
        }
        //校验当前用户是否已加盟
        if(helpUser.isNotEmpty) {
          //当用户等级小于5 提示加盟
          if(userLevel < 5) {
            showSignDialog(context, desc: '需要加盟星选会员后方可帮助用户加盟', okTxt: '去加盟', (){
              onTapLogin(context, '/tabVip', args: {'index': 0});
            });
            return;
          }
        }

        //校验是否签署合同
        Map<String, dynamic> card = await BService.userCard(uid: helpUser['uid']);
        String contractPath = card['contractPath']??'';
        if(contractPath.isEmpty) {
          if(helpUser.isEmpty) {
            showSignDialog(context, (){
              Navigator.pushNamed(context, '/shopAuthPage');
            });
          } else {
            ToastUtils.showToast('提醒用户${helpUser['showName']}完成实名认证');
          }
          return;
        }
        //支付
        AwesomeDialog(
            dialogType: DialogType.noHeader,
            showCloseIcon: true,
            context: context,
            body: signCashierPage()
        )..show();

      },
    ), {'pd':[0,0,30,30]});
  }

  refreshAfterPaySuccess() {
    Future.delayed(Duration(seconds: 1)).then((value) => {initData()}).then((value) =>
    {
      initData()
    });
    //刷新个人中心
    refreshVd();
  }

  getTerm() {
    String platform = data['vipData']['platform'];
    double? scale = 1;
    switch (platform) {
      case "tb":
        scale = Global.commissionInfo?.tbTimes;
        break;
      case 'jd':
        scale = Global.commissionInfo?.jdTimes;
        break;
      case 'pdd':
        scale = Global.commissionInfo?.pddTimes;
        break;
      case 'dy':
        scale = Global.commissionInfo?.dyTimes;
        break;
      case 'vip':
        scale = Global.commissionInfo?.vipTimes;
        break;
    }

    if(scale == null) {
      scale = 1;
    }
    return '${(scale * 100).toInt()}%';
  }

  signCashierPage() {
    return PWidget.container(
      PWidget.column([
        PWidget.textNormal('星选会员', [Colors.black,18],{'ct':true}),
        PWidget.boxh(15),
        PWidget.textNormal('请选择加盟方式', [Colors.black,14],{'ct':true}),
        PWidget.boxh(15),
        PWidget.row([
          TextButton(onPressed: (){
            price = gradeModel['monthMoney'];
            valid = gradeModel['monthValidDate'];
            rechargeType = 2;
            //有效期一个月
            press(context);
          },
              child: Text("月会员￥${gradeModel['monthMoney']}",style: TextStyle(color: Colors.white,fontSize: 14)),
              style : TextButton.styleFrom(
                padding: EdgeInsets.only(top: 4, left: 14, right: 14, bottom: 4),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                backgroundColor: Colors.orange,)),
          PWidget.boxw(20),
          TextButton(onPressed: (){
            price = gradeModel['money'];
            rechargeType = 0;
            press(context);
          },
              child: Text("年会员￥${gradeModel['money']}",style: TextStyle(color: Colors.white,fontSize: 14)),
              style : TextButton.styleFrom(
                padding: EdgeInsets.only(top: 4, left: 14, right: 14, bottom: 4),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                backgroundColor: Colours.app_main,))
        ],'221')
      ],{'pd':[10,20,15,15]}),
    );
  }

  void press(BuildContext context) {
    // if(Global.isIOS()) {
    //   ToastUtils.showToast("该设备不支持购买");
    //   return;
    // }
    Navigator.pushNamed(context, '/cashierPage', arguments: {
      "rechargeId": gradeModel['rechargeId'],
      "platform": data['vipData']['platform'],
      'price': price,
      'rechargeType': rechargeType,
      'valid': valid,
      'user': helpUser

    }).then((value) => {
      if(value != null && value as bool) {
        refreshAfterPaySuccess()
      },
        Navigator.pop(context)
    });
  }

}
