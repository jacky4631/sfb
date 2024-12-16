/*
 * AlibcTradeService.h 
 *
 * 阿里百川电商
 * 项目名称：阿里巴巴电商 AlibcTradeSDK 
 * 版本号：4.0.0.9
 * 发布时间：2019-10-31
 * 开发团队：阿里巴巴商家服务引擎团队
 * 阿里巴巴电商SDK答疑群号：1488705339  2071154343(阿里旺旺)
 * Copyright (c) 2016-2020 阿里巴巴-淘宝-百川. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import <AlibcTradeBiz/AlibcTradeResult.h>
#import "AlibcTradePageFactory.h"
#import <AlibcTradeBiz/AlibcTradeShowParams.h>
#import <AlibcTradeBiz/AlibcTradeSDKDefines.h>

@class UIViewController;
@class WKWebView;

/** 电商服务 */
@protocol AlibcTradeService<NSObject>
/**
 *
 * 使用openUrl方式直接打开非官方code覆盖的链接
 *
 * @param url                         想要打开的url
 （可以打开非openByBizCode所覆盖的url）
 * @param identity                    电商套件标识（需要申请），目前固定传入
 “trade”，后续开发申请通道
 * @param webView
 isv自己的webview,请先设置好自己的delegate先调用本接口,否则拦截登陆等逻辑会失效
 * @param parentController            webView所在的view controller.
 * @param showParams                  打开方式的一些自定义参数
 * @param taoKeParams                 淘客参数
 * @param trackParam                  链路跟踪参数
 * @param tradeProcessSuccessCallback
 交易流程中成功回调(加购成功(使用+[AlibcTradePageFactory
 addCartPage:]时)/发生支付) 其余打开方式不返回
 * @param tradeProcessFailedCallback  交易流程中退出或者调用发生错误的回调
 其余打开方式不返回
 *
 * @return  0:  标识跳转到手淘打开了
            1:  标识用h5打开了
            2:  标识用小程序打开了Url
           -1:  入参出错
           -2:  此URL需要使用openByCode 通过code来进行页面打开
           -3:  打开页面失败
 *         -4:  sdk初始化失败
 *         -5:  该版本SDK已被废弃，需要升级
 *         -6:  sdk不允许唤端
 *
 *
 * 返回值 仅一种情况需要媒体处理 即当AlibcTradeShowParams 中 isNeedPush 为
 YES时.此时需要媒体根据API返回值为1时
 （应用內H5打开），在传入的UINavigationController中push新页面。
 *
 */
- (NSInteger)openByUrl:(NSString *__nonnull)url
                       identity:(NSString *__nonnull)identity
                        webView:(WKWebView *_Nullable)webView
               parentController:(UIViewController *__nonnull)parentController
                     showParams:(nullable AlibcTradeShowParams *)showParams
                    taoKeParams:(nullable AlibcTradeTaokeParams *)taoKeParams
                     trackParam:(nullable NSDictionary *)trackParam
    tradeProcessSuccessCallback:
        (nullable void (^)(AlibcTradeResult *__nullable result))onSuccess
     tradeProcessFailedCallback:
         (nullable void (^)(NSError *__nullable error))onFailure;

/**
 *
 * 使用openByCode方式直接打开官方code覆盖的页面
 *
 * @param pageCode                    后台申请的官方页面pageCode
 目前支持“detail” “cart”.后续会开放更多的pageCode
 * @param page                        想要打开的page
 * @param webView
 isv自己的webview,请先设置好自己的delegate先调用本接口,否则拦截登陆等逻辑会失效
 * @param parentController            webView所在的view controller.
 * @param showParams                  打开方式的一些自定义参数
 * @param taoKeParams                 淘客参数
 * @param trackParam                  链路跟踪参数
 * @param tradeProcessSuccessCallback
 交易流程中成功回调(加购成功(使用+[AlibcTradePageFactory
 addCartPage:]时)/发生支付) 其余打开方式不返回
 * @param tradeProcessFailedCallback  交易流程中退出或者调用发生错误的回调
 其余打开方式不返回
 *
 * @return  0:  标识跳转到手淘打开了
            1:  标识用h5打开了
            2:  标识用小程序打开了Url
           -1:  入参出错
           -2:  打开页面失败
           -4:  sdk初始化失败
 *         -5:  该版本SDK已被废弃，需要升级
 *         -6:  sdkh不允许唤端

 *
 *
 * 返回值 仅一种情况需要媒体处理 即当AlibcTradeShowParams 中 isNeedPush 为
 YES时.此时需要媒体根据API返回值为1时
 （应用內H5打开），在传入的UINavigationController中push新页面。
 *
 */
- (NSInteger)openByBizCode:(NSString *__nonnull)pageCode
                       page:(id <AlibcTradePage> __nonnull)page
                    webView:(WKWebView *_Nullable)webView
           parentController:(UIViewController *__nonnull)parentController
                 showParams:(nullable AlibcTradeShowParams *)showParams
                taoKeParams:(nullable AlibcTradeTaokeParams *)taoKeParams
                 trackParam:(nullable NSDictionary *)trackParam
tradeProcessSuccessCallback:(nullable void (^)(AlibcTradeResult *__nullable result))onSuccess
 tradeProcessFailedCallback:(nullable void (^)(NSError *__nullable error))onFailure;

@end
