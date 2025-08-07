import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

final globalKey = GlobalKey<NavigatorState>();
final routerConfig = AppRouter().config(
    // 2.注册路由观察者
    navigatorObservers: () => [
          // 其他观察者可以在这里添加
        ]);
final appRouter = AppRouter();

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  AppRouter() : super(navigatorKey: globalKey);
  @override
  List<AutoRoute> get routes {
    return [
      // AutoRoute(page: HomeRoute.page, initial: true, guards: [
      //   WelcomeGuard()
      // ], children: [
      //   AutoRoute(page: DiscoverRoute.page),
      //   AutoRoute(page: DyMusicRoute.page),
      //   AutoRoute(page: SettingRoute.page)
      // ]),
    ];
  }
}

class AuthGuard extends AutoRouteGuard {
  final bool isLoggedIn;

  AuthGuard(this.isLoggedIn);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (isLoggedIn) {
      resolver.next(true); // 允许导航
    } else {
      // router.push(LoginRoute()); // 跳转到登录页面
    }
  }
}

class WelcomeGuard extends AutoRouteGuard with WidgetsBindingObserver {
  final Permission permission = Permission.appTrackingTransparency;

  late final StreamSubscription listener;

  WelcomeGuard() {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Future<void> onNavigation(NavigationResolver resolver, StackRouter router) async {
    print('onNavigation');

    resolver.next(true); // 允许导航
    // listener = await InternetConnection().onStatusChange.listen((InternetStatus status) async {
    //   switch (status) {
    //     case InternetStatus.connected:
    //       // The internet is now connected
    //       Log.e("The internet is now connected");
    //
    //       SmartDialog.show(
    //         animationType: SmartAnimationType.fade,
    //         maskColor: Colors.transparent,
    //         builder: (context) => FlutterGTAds.splashWidget(
    //           context,
    //           dismiss: () async {
    //             SmartDialog.dismiss();
    //             listener.cancel();
    //             resolver.next(true); // 允许导航
    //           },
    //         ),
    //       );
    //       break;
    //     case InternetStatus.disconnected:
    //       // The internet is now disconnected
    //       Log.e("The internet is now disconnected");
    //       resolver.next(true); // 允许导航
    //
    //       break;
    //   }
    // });
  }

  ///AppLifecycleState是个状态枚举，共有四种状态：
  ///resumed：应用程序可见且获取焦点状态
  ///paused：应用程序处于用户不可见，不响应用户状态，处于后台运行状态
  ///inactive：应用程序处于非活动状态
  ///detached：应用程序被销毁
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // 监听 app 从后台切回前台
    if (state == AppLifecycleState.resumed) {
      print("=================监听 app 从后台切回前台");
    } else if (state == AppLifecycleState.paused) {
      // 应用进入后台
      print("=================应用进入后台");
    } else if (state == AppLifecycleState.inactive) {
      // 应用非活动状态
      print("=================应用非活动状态");
    } else if (state == AppLifecycleState.detached) {
      // 应用被销毁
      print("=================应用被销毁");
    }
  }
}
