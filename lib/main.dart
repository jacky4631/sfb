/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maixs_utils/util/utils.dart';
import 'package:sufenbao/bindCard/addCard.dart';
import 'package:sufenbao/dy/dy_detail_page.dart';
import 'package:sufenbao/index/Index.dart';
import 'package:sufenbao/index/local_page.dart';
import 'package:sufenbao/jd/jd_details_page.dart';
import 'package:sufenbao/jd/jd_index_page.dart';
import 'package:sufenbao/login/login_code.dart';
import 'package:sufenbao/login/login_first.dart';
import 'package:sufenbao/login/login_second.dart';
import 'package:sufenbao/login/login_third.dart';
import 'package:sufenbao/me/about_us.dart';
import 'package:sufenbao/me/address_list.dart';
import 'package:sufenbao/me/auth_page.dart';
import 'package:sufenbao/me/cash/cash_index_page.dart';
import 'package:sufenbao/me/cash/cash_record_list_page.dart';
import 'package:sufenbao/me/cash/money_list.dart';
import 'package:sufenbao/me/collect_page.dart';
import 'package:sufenbao/me/create_address.dart';
import 'package:sufenbao/me/create_order.dart';
import 'package:sufenbao/me/fans/fans.dart';
import 'package:sufenbao/me/fans/fans_detail_page.dart';
import 'package:sufenbao/me/feedback_page.dart';
import 'package:sufenbao/me/help/ChewieVideoPage.dart';
import 'package:sufenbao/me/help/help_content_page.dart';
import 'package:sufenbao/me/myself.dart';
import 'package:sufenbao/me/nickname_page.dart';
import 'package:sufenbao/me/personal.dart';
import 'package:sufenbao/me/phone/phone_page.dart';
import 'package:sufenbao/me/points_mall_page.dart';
import 'package:sufenbao/me/realname_page.dart';
import 'package:sufenbao/me/settings.dart';
import 'package:sufenbao/me/spread_page.dart';
import 'package:sufenbao/me/vip/cashier_page.dart';
import 'package:sufenbao/me/vip/vip.dart';
import 'package:sufenbao/order/integral_list.dart';
import 'package:sufenbao/order/order_retrieval.dart';
import 'package:sufenbao/page/AliRedPage.dart';
import 'package:sufenbao/page/BlankPage.dart';
import 'package:sufenbao/page/ElePage.dart';
import 'package:sufenbao/page/MeiTuanPage.dart';
import 'package:sufenbao/page/TaoRedPage.dart';
import 'package:sufenbao/page/WaiMaiPage.dart';
import 'package:sufenbao/page/big_coupon_page.dart';
import 'package:sufenbao/page/brand_sale_page.dart';
import 'package:sufenbao/page/inspect_goods_page.dart';
import 'package:sufenbao/page/ku_custom_page.dart';
import 'package:sufenbao/page/mini_page.dart';
import 'package:sufenbao/page/nine_page.dart';
import 'package:sufenbao/page/pick_leak_page.dart';
import 'package:sufenbao/page/product_details.dart';
import 'package:sufenbao/page/seckill_page.dart';
import 'package:sufenbao/pay/ios_payment.dart';
import 'package:sufenbao/pdd/pdd_index_page.dart';
import 'package:sufenbao/search/search_page.dart';
import 'package:sufenbao/search/search_result.dart';
import 'package:sufenbao/shop/shop_auth_page.dart';
import 'package:sufenbao/shop/shop_contract_page.dart';
import 'package:sufenbao/shop/shop_signature_page.dart';
import 'package:sufenbao/tao/tb_index_page.dart';
import 'package:sufenbao/themes/app_theme.dart';
import 'package:sufenbao/util/global.dart';
import 'package:sufenbao/vip/vip_detail_page.dart';
import 'package:sufenbao/vip/vip_index_page.dart';
import 'package:sufenbao/webview/alipay_webview.dart';
import 'package:sufenbao/webview/custom_webview.dart';
import 'package:sufenbao/webview/pay_webview.dart';
import 'package:sufenbao/widget/camera/mask_camera.dart';
import 'package:url_strategy/url_strategy.dart';

import 'bindCard/supportBank_list.dart';
import 'bindCard/verify_addCard.dart';
import 'dy/dy_index_page.dart';
import 'energy/energy_list.dart';
import 'energy/energy_page.dart';
import 'generated/l10n.dart';
import 'init/splash_page.dart';
import 'me/cash/cash_page.dart';
import 'me/cash/cash_result_page.dart';
import 'me/fee/fee_page.dart';
import 'me/fee/fee_tab_page.dart';
import 'me/help/help_fanli_page.dart';
import 'me/help/help_page.dart';
import 'me/kouling_page.dart';
import 'me/messageCenter.dart';
import 'me/phone/phone_code_page.dart';
import 'me/points_mall_details.dart';
import 'me/setting/account_cancel.dart';
import 'me/share_page.dart';
import 'me/vip/tab_vip.dart';
import 'order/order_list.dart';
import 'page/sell_page.dart';
import 'page/top_page.dart';
import 'pdd/pdd_detail_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // initWebview();
  // 强制竖屏
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown
  // ]);
  setPathUrlStrategy();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(ProviderScope(child: SfbApp()));
}

// Future initWebview() async {
//   if (Global.isAndroid()) {
//     await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
//   }
// }

class SfbApp extends StatelessWidget {
  // 路由路径匹配
  Route<dynamic>? _getRoute(RouteSettings settings) {
    Map arg = {};
    if (settings.arguments != null) {
      arg = settings.arguments as Map;
    }
    Map<String, WidgetBuilder> routes = {
      '/': (BuildContext context) => SplashPage(),
      '/index': (BuildContext context) => Index(),
      '/login': (BuildContext context) => LoginFirst(arg),
      '/loginSecond': (BuildContext context) => LoginSecond(arg),
      '/loginThird': (BuildContext context) => LoginThird(arg),
      '/loginCode': (BuildContext context) => LoginCode(arg),
      '/webview': (BuildContext context) => CustomWebView(arg),
      '/payWebview': (BuildContext context) => PayWebView(arg),
      '/alipayWebview': (BuildContext context) => AlipayWebView(arg),
      '/detail': (BuildContext context) => ProductDetails(arg),
      '/detailJD': (BuildContext context) => JDDetailsPage(arg),
      '/detailPDD': (BuildContext context) => PddDetailPage(arg),
      '/detailDY': (BuildContext context) => DyDetailPage(arg),
      '/detailVIP': (BuildContext context) => VipDetailPage(arg),
      '/top': (BuildContext context) => TopPage(data: arg),
      '/settings': (BuildContext context) => Settings(arg),
      '/me': (BuildContext context) => MySelfPage(),
      '/pointsMall': (BuildContext context) => PointsMallPage(arg),
      '/pointsMallDetail': (BuildContext context) => PointsMallDetail(arg),
      '/createOrder': (BuildContext context) => CreateOrder(arg),
      '/addressList': (BuildContext context) => AddressList(data: arg),
      '/createAddress': (BuildContext context) => CreateAddress(arg),
      '/search': (BuildContext context) => SearchPage(data: arg),
      '/orderRetrieval': (BuildContext context) => OrderRetrieval(arg),
      '/orderList': (BuildContext context) => OrderList(arg),
      '/personal': (BuildContext context) => Personal(arg),
      '/feedback': (BuildContext context) => FeedbackPage(),
      '/aboutUs': (BuildContext context) => AboutUs(),
      '/integralList': (BuildContext context) => IntegralList(),
      '/fans': (BuildContext context) => Fans(arg),
      '/nickname': (BuildContext context) => NicknamePage(),
      '/realName': (BuildContext context) => RealNamePage(),
      '/cashIndex': (BuildContext context) => CashIndexPage(arg),
      '/cash': (BuildContext context) => CashPage(arg),
      '/cashResult': (BuildContext context) => CashResultPage(),
      '/cashRecord': (BuildContext context) => CashRecordListPage(),
      '/jdIndex': (BuildContext context) => JdIndexPage(),
      '/pddIndex': (BuildContext context) => PddIndexPage(),
      '/dyIndex': (BuildContext context) => DyIndexPage(),
      '/bigCouponPage': (BuildContext context) => BigCouponPage(data: arg),
      '/ddq': (BuildContext context) => SeckillPage(),
      '/miniPage': (BuildContext context) => MiniPage(),
      '/kuCustomPage': (BuildContext context) => KuCustomPage(arg),
      '/ninePage': (BuildContext context) => NinePage(),
      '/pickLeakPage': (BuildContext context) => PickLeakPage(),
      '/brandSalePage': (BuildContext context) => BrandSalePage(
            data: arg,
          ),
      '/searchResult': (BuildContext context) => SearchResultPage(
            arg,
          ),
      '/inspectGoodsPage': (BuildContext context) => InspectGoodsPage(arg),
      '/vipPage': (BuildContext context) => VipIndexPage(arg),
      '/helpPage': (BuildContext context) => HelpPage2(),
      '/helpContentPage': (BuildContext context) => HelpContentPage(arg),
      '/vip': (BuildContext context) => VipPage(arg),
      '/authPage': (BuildContext context) => AuthPage(arg),
      '/phonePage': (BuildContext context) => PhonePage(arg),
      '/phoneCodePage': (BuildContext context) => PhoneCodePage(arg),
      '/spreadPage': (BuildContext context) => SpreadPage(),
      '/collectPage': (BuildContext context) => CollectPage(),
      '/koulingPage': (BuildContext context) => KoulingPage(arg),
      '/iosPayment': (BuildContext context) => IOSPayment(),
      '/accountCancel': (BuildContext context) => AccountCancel(arg),
      '/helpFanliPage': (BuildContext context) => HelpFanliPage(),
      '/helpVideo': (BuildContext context) => ChewieVideoPage(arg),
      '/aliRed': (BuildContext context) => AliRedPage(arg),
      '/waimai': (BuildContext context) => WaiMaiPage(arg),
      '/moneyList': (BuildContext context) => MoneyList(arg),
      '/tbIndex': (BuildContext context) => TbIndexPage(),
      '/tabVip': (BuildContext context) => TabVip(arg),
      '/feeTabPage': (BuildContext context) => FeeTabPage(arg),
      '/feePage': (BuildContext context) => FeePage(arg),
      '/fansDetailPage': (BuildContext context) => FansDetailPage(arg),
      '/shopAuthPage': (BuildContext context) => ShopAuthPage(),
      '/idCard': (BuildContext context) => MaskOCRCam(
            onCapture: arg['fun'],
          ),
      '/shopContractPage': (BuildContext context) => ShopContractPage(arg),
      '/signaturePage': (BuildContext context) => ShopSignaturePage(),
      '/cashierPage': (BuildContext context) => CashierPage(arg),
      '/addCard': (BuildContext context) => AddCard(arg),
      '/verifyaddCard': (BuildContext context) => VerifyAddCard(arg),
      '/sharePage': (BuildContext context) => SharePage(arg),
      '/energyPage': (BuildContext context) => EnergyPage(arg),
      '/energyList': (BuildContext context) => EnergyList(arg),
      '/messageCenter': (BuildContext context) => MessageCenter(),
      '/sellPage': (BuildContext context) => SellPage(arg),
      '/supportBankList': (BuildContext context) => SupportBankList(),
      '/blankPage': (BuildContext context) => BlankPage(arg),
      '/taoRedPage': (BuildContext context) => TaoRedPage(arg),
      '/meiTuanPage': (BuildContext context) => MeiTuanPage(arg),
      '/elePage': (BuildContext context) => ElePage(arg),
      '/localPage': (BuildContext context) => LocalPage(),
    };
    var widget = routes[settings.name];

    if (widget != null) {
      return MaterialPageRoute<void>(
        settings: settings,
        builder: widget,
      );
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    String multipleThemesMode = 'default'; // 主题

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate, //一定要配置,否则iphone手机长按编辑框有白屏卡着的bug出现
            S.delegate
          ],
          supportedLocales: S.delegate.supportedLocales,
          debugShowCheckedModeBanner: false,
          title: APP_NAME,
          themeMode: ThemeMode.light,
          theme: AppTheme(multipleThemesMode).multipleThemesLightMode(),
          darkTheme: AppTheme(multipleThemesMode).multipleThemesDarkMode(),
          // themeMode: ThemeMode.light,
          // theme: ThemeData(
          //   useMaterial3: false,
          //   primarySwatch: Colors.red,
          //   textTheme: Theme.of(context).textTheme,
          //   platform: TargetPlatform.iOS,
          // ),
          home: child,
          onGenerateRoute: _getRoute,
          navigatorKey: navigatorKey,
        );
      },
      child: Global.isWeb() ? Index() : SplashPage(),
    );
    ;
  }
}
