/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

import '../../util/colors.dart';
import '../../util/global.dart';

class HelpContentPage extends StatefulWidget {
  final Map data;
  const HelpContentPage(
    this.data, {
    Key? key,
  }) : super(key: key);

  @override
  _HelpContentPageState createState() => _HelpContentPageState();
}

class _HelpContentPageState extends State<HelpContentPage> {
  var currentPanelIndex = -1;
  late List list;

  _HelpContentPageState() {}
  @override
  void initState() {
    list = helpData[widget.data['key']]!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.data['title'],
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        color: Colours.bg_color,
        child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (_, index) {
            Map data = list[index];
            return Semantics(
              /// 将item默认合并的语义拆开，自行组合， 另一种方式见 account_record_list_page.dart
              explicitChildNodes: true,
              child: StickyHeader(
                header: Container(
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Color(0xFF242526)
                      : Colors.grey[100],
                  padding: const EdgeInsets.only(left: 8.0),
                  height: 34.0,
                  child: Text(
                    data['title'],
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                content: _buildItem(index, data),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildItem(int index, Map record) {
    Widget container = Container(
      padding: EdgeInsets.fromLTRB(8, 8, 8, 12),
      child: MergeSemantics(
        child: Text(
          record['content'],
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
        ),
      ),
    );
    return Column(children: [container]);
  }
}

class ExpandStateBean {
  var title;
  var content;
  ExpandStateBean(this.title, this.content);
}

const Map<String, List> helpData = {
  'hot': [
    {
      'title': '红包怎么拆',
      'content': '等待订单七天解锁，即可在“订单中心”拆开，部分异常订单需要等到下个月21号方可解锁拆开。'
    },
    {
      'title': '一次买多个商品怎么做',
      'content': '若要买的商品已加入购物车，请清空购物车。清空后，重新通过$APP_NAME领券后一一加入购物车，最后再一起付款。'
    },
    {
      'title': '除了淘宝天猫外，支持京东、拼多多么',
      'content': '除淘宝天猫外，同时支持京东、拼多多、美团外卖、唯品会和抖音平台。'
    },
    {
      'title': '怎么联系客服',
      'content': '首页点击右下角【我的】，进入个人中心，点击【在线客服】，就可以联系微信客服了，需要安装微信。'
    },
    {
      'title': '如何查看商品是否有优惠券',
      'content':
          '有3种方法：\n\t① 在首页顶部搜索栏，输入你想查券的商品名，点击搜索即可查看；\n\t② 在首页顶部搜索栏，粘贴宝贝标题（标题需要打开手机淘宝，进入商品详情页进行复制），点击搜索即可查看；\n\t③ 如果是APP用户，打开手机淘宝，在商品详情页复制宝贝链接后，打开本APP，就能自动查券啦。'
    },
    {
      'title': '优惠券的用途是什么',
      'content': '优惠券可抵扣部分现金进行消费。例如，使用30元的优惠券，购买商品时就可以省30元。'
    },
    {
      'title': '如何领取优惠券',
      'content': '点击商品进入详情页，点击【立即购买】或【领券购买】，在粉丝福利购页面点击【立即领券】，即领券成功。'
    },
    {
      'title': '如何使用优惠券下单',
      'content': '点击商品进入详情页，领券成功后自动跳转至淘宝商品详情页，点击立即购买，下单自动使用优惠券哦。'
    },
    {
      'title': '领取优惠券时，为什么提示“券已失效”',
      'content': '有两种情况：\n\t① 超过了优惠券的领取期限；\n\t② 优惠券已经领完啦（下次请趁早！）。'
    },
    {
      'title': '为什么付款价与标注的券后价不一致',
      'content':
          '有几种可能性哦：\n\t① 此款商品不同规格，价格不一样。比如，一个书架标注的券后价为100元，但它有好几个规格，单层书架券后的确为100元，但双层的价格可能会高50元，那么券后价也会相应提高，就成了150元；\n\t② 确定看到的是否为最终价格。在淘宝详情页看到的价格是原价，要到下单时才能看到券后价哦；\n\t③ 唔，淘宝卖家偷偷改价了，我们还没来得及更新…遇到这种情况，可以向我们的客服反馈哦~'
    },
  ],
  'gongneng': [
    {
      'title': '怎么收藏商品？怎么查看收藏的商品',
      'content': '点击商品进入详情页，点击左下角【收藏】，即可收藏成功。查看收藏商品，在首页点击右下角【我的】→在【我的收藏】中进行查看。'
    },
  ],
  'order': [
    {'title': '订单记录哪里查看', 'content': '首页点击右下角【我的】，进入个人中心，在【订单明细】查看订单明细。'},
    {'title': '订单明细无法看到订单怎么办', 'content': '首页点击右下角【我的】，进入个人中心，在【订单找回】提交订单。'},
    {
      'title': '订单找回失败怎么办',
      'content':
          '订单找回失败的原因一般如下：\n\t① 未通过$APP_NAME付款的订单，则找回失败。\n\t② 从你之前的购物车或待付款页面下单，则找回失败。\n\t③ 付款使用了淘宝红包，则找回失败。\n\t解决方法：退款重新拍；非以上原因，可联系客服协助解决。'
    },
    {
      'title': '如何联系商品卖家',
      'content':
          '① 如果您未购买商品，请点击商品→点击【领券购买】→进入商品详情页→点击左下角【客服】，就能联系卖家啦。\n② 如果您已购买商品，请进入对应电商平台，找到【我的订单】→点击未发货的订单→下拉页面，就会看到联系卖家的入口了。'
    },
    {
      'title': '如何申请退换货',
      'content':
          '进入手机淘宝等平台，找到【我的订单】→点击想退款的订单→点击商品下方的【退换】，就可以操作退货/换货啦。申请退款后，待商品寄回，钱款会原路返回到你的账户中。'
    },
    {
      'title': '如何修改收货地址',
      'content':
          '请联系商品卖家处理哦。进入手机淘宝等平台，找到【我的订单】→点击想修改地址的订单→下拉页面，就会看到联系卖家的入口，请联系卖家修改收货地址哦。'
    },
  ],
  'youhui': [
    {
      'title': '领取优惠券时，为什么提示“系统繁忙”',
      'content': '遇到这种情况，请先检查一下自己的网络状况。也可能是遇到了神秘bug，请稍候再尝试哦。'
    },
    {
      'title': '领取优惠券时，为什么提示“领取已达上限”',
      'content':
          '每件商品的优惠券数量是有限的，有些是1张，有些是好几张，当领取次数达到上限时，就会出现这个提示。如果换一个账号登录，就可以领取更多优惠券了哦。'
    },
    {
      'title': '优惠券可以和其他优惠叠加吗',
      'content':
          '根据不同优惠活动的设置，部分可以叠加，部分则只能选择一种优惠使用。告诉你一个小秘密，订单确认页面一般会自动叠加最大优惠，试试就知道啦。'
    },
    {
      'title': '领取了优惠券但无法使用',
      'content':
          '有两种情况：\n\t① 优惠券已经过期了呢。请在优惠期间尽快下单购买哦； \n\t② 已经用优惠券下单过了哦。如何确定是否已下单？请在淘宝APP中，通过【我的淘宝】→【待付款】查看你的待付款订单中是否有这个商品。若有，就表示已经用过券啦。'
    },
  ],
  'jifen': [
    {'title': '积分怎么获得', 'content': '通过平台签到可获得积分，其他积分获取方式敬请期待。'},
    {
      'title': '积分可以用来干什么',
      'content': '① 积分可以兑换各种商品，首页点击右下角【我的】，进入个人中心，在【积分商城】兑换商品。'
    },
  ],
  'tixian': [
    {'title': '如何提现', 'content': '首页点击右下角【我的】，进入个人中心，点击【立即提现】->【提现】。'},
    {'title': '提现后打款到哪里', 'content': '目前仅支持提现到【支付宝】。'},
    {'title': '提现后多久到账', 'content': 'T+1天到账(T为工作日)。'},
    {'title': '提现金额限制多少', 'content': '单次最低提现金额1元，每天可提现一次。'},
    {'title': '待解锁金额如何查看多久解锁', 'content': '【我的】->【立即提现】->【资金明细】。'},
  ],
  'invite': [
    {
      'title': '如何邀请好友',
      'content': '首页点击右下角【我的】，进入个人中心，点击【分享APP】，可以通过海报、链接和直接分享的方式邀请好友。'
    },
    {'title': '邀请的好友如何查看', 'content': '首页点击右下角【我的】，进入个人中心，点击【粉丝】。'},
    {'title': '什么是金客和银客', 'content': '金客是你自己邀请的好友，银客是你好友邀请的好友。'},
    {'title': '邀请好友有直接奖励吗', 'content': '没有直接奖励，但是分享的好友在平台下单时，推荐人可以获得推荐奖金。'},
    {'title': '邀请多少好友可以升级为VIP', 'content': 'APP目前没有会员等级设置，但是邀请的好友下单越多，推荐奖金越多。'},
    {'title': '用户下单我能得到多少奖金', 'content': '用户开红包奖金的20%，比如金客开红包得到100元，你能得到20元。'},
  ],
  'income': [
    {'title': '如何得到收益', 'content': '1.自己在平台下单；2.用户在平台下单；3.分享商品海报。'},
    {'title': '如何查看收益明细', 'content': '【我的】->【收益预估】。'},
    {'title': '在平台下单后多久能提现', 'content': '在平台下单后打开订单红包，等待账单7天解锁方可提现。'},
    {'title': '如何打开订单红包', 'content': '【我的】->【订单中心】，下单后可以立即打开。'},
    {'title': '如何查看账单解锁时间', 'content': '【我的】->【立即提现】->【资金明细】。'},
    {'title': '如何分享商品海报', 'content': '点击平台任一商品进入详情，点击【分享】。'},
    {'title': '用户下单我能得到多少奖金', 'content': '用户开红包奖金的20%，比如用户开红包得到100元，你能得到20元。'},
  ]
};
