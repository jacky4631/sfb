import 'package:flutter/material.dart';
import 'package:sufenbao/util/colors.dart';

const List menuData = [
  [
  ],
  //type 1=native 2=外部 3=小程序 4=webview
  [

    {
      "title": "购物拆红包",
      "img":
      "https://img.alicdn.com/imgextra/i3/2053469401/O1CN01FqA1ff2JJi9Jb6VCV_!!2053469401.gif",
      'path': 'assets/images/menu/7.png',
      "type": "1",
      "url": "/helpFanliPage",
    },
    {
      "title": "9块9包邮",
      "img": "https://img.alicdn.com/imgextra/i2/2053469401/O1CN01xWCtV62JJi9b21iQp_!!2053469401.png",
      'path': 'assets/images/menu/99.png',
      "type": "1",
      "url": "/ninePage",
      'color': Color(0xfff9cc8c)
    },

    {
      "title": "美团红包",
      "img":
      "https://img.alicdn.com/imgextra/i3/2053469401/O1CN01FqA1ff2JJi9Jb6VCV_!!2053469401.gif",
      'path': 'assets/images/mt.gif',
      "type": "1",
      "url": "/meiTuanPage",
      'color': Color(0xFFF12929),
    },
    {
      "title": "饿了么",
      "img":
      "https://img.alicdn.com/imgextra/i2/2053469401/O1CN01ZiytSl2JJi9mY2paN_!!2053469401.png",
      'path': 'assets/images/ele.gif',
      "type": "1",
      "url": "/elePage",
    },
    {
      'img': 'https://mailvor.oss-cn-shanghai.aliyuncs.com/sufenbao/fuli4.png',
      'path': 'assets/images/menu/6.png',
      'title': '捡漏清单',
      'type': '1',
      'url': '/pickLeakPage',
      'color': Colors.green,
    },
    {
      'img':
      'https://mailvor.oss-cn-shanghai.aliyuncs.com/sufenbao/cao.png',
      'title': '淘券',
      'path': 'assets/images/menu/5.gif',
      "type": "1",
      // 'arrow': '火爆',
      'url': '/tbIndex',
      'color': Color(0xfff9cc8c)
      // 'color': Colors.green
    },
    {
      "title": "京券",
      "img":
      "https://img.alicdn.com/imgextra/i2/2053469401/O1CN01Iu2xBJ2JJi9nqIQpb_!!2053469401.png",
      'path': 'assets/images/menu/jd.png',
      "type": '1',
      // 'arrow': '立省40%',
      "url": "/jdIndex",
      'color': Colours.jd_main
    },
    {
      "title": "多券",
      "img":
      "https://img.alicdn.com/imgextra/i4/2053469401/O1CN01fSvhoh2JJi9hQMrEF_!!2053469401.png",
      'path': 'assets/images/menu/pdd.png',
      "type": "1",
      "url": "/pddIndex",
      'color': Colours.pdd_main
    },
    {
      "title": "抖券",
      "img": "https://sr.ffquan.cn/cms_pic/20220309/c8k95qi3fg9k53m0g0600.gif",
      'path': 'assets/images/menu/dy.gif',
      "type": "1",
      "url": "/dyIndex",
      'color': Colours.dy_main
    },
    {
      "title": "唯券",
      "img":
      "https://img.alicdn.com/imgextra/i3/2053469401/O1CN01NR08P22JJiAret8ZV_!!2053469401.gif",
      'path': 'assets/images/menu/vip.gif',
      "type": "1",
      // 'arrow': '100%正品',
      "url": "/vipPage",
      'color': Colours.vip_main
    },
    // {
    //   "title": "大额优惠券",
    //   "img":
    //   "https://img.alicdn.com/imgextra/i2/2053469401/O1CN01ZiytSl2JJi9mY2paN_!!2053469401.png",
    //   'path': 'assets/images/menu/4.png',
    //   "type": "1",
    //   "url": "/bigCouponPage",
    // },
  ],
];
