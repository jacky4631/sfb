//
//  ALSmartLink.h
//  AlibcLinkPartnerSDK
//
//  Created by 诺夏 on 2019/3/11.
//  Copyright © 2019 czp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ALSLURI.h"

/**
 *  返回结果。
 *  如果唤端成功，会返回唤起成功App的名称，可能会返回降级页面。注意，由于智能唤端策略，唤起成功的App可能不是指定的目标App。
 *  如果唤端失败，会返回目标App的名称以及降级页面。
 *  @param errorCode 见ALPError中的 LinkPartnerErrorType 定义
 */
typedef void(^ALSLCompletionBlock)(BOOL success, NSString * _Nonnull target, NSString * _Nullable degradeURL, int errorCode);

#pragma mark - Public method

/**
 *  在目标App中打开指定页面。
 *  @param URL 页面地址
 *  @param target 目标App的名称。默认"手机淘宝"
 *  @param completionBlock 唤端结束回调
 */
void ALSLOpenURL(NSString * _Nonnull URL, NSString * _Nonnull target, ALSLCompletionBlock _Nonnull completionBlock);


#pragma mark - ALSmartLink

NS_ASSUME_NONNULL_BEGIN

@interface ALSmartLink : NSObject

+ (instancetype)sharedInstance;

/**
 *  初始化方法，请在唤端之前务必先调用此方法，建议放在启动完成阶段。
 */
- (void)initWithAppkey:(NSString *)appkey;

/**
 *  根据URI跳转到目标App。(请务必在主线程调用)
 *  @param uri 参考ALSLURI.h说明
 *  @param completionHandler 唤端结束回调
 */
- (void)openURI:(ALSLURI *)uri completionHandler:(ALSLCompletionBlock)completionHandler;

/**
 *  是否可以打开指定APP. 注意，此方法仅针对info.plist的LSApplicationQueriesSchemes中有配置的scheme生效。其它均返回false
 *  @param target 目标APP对应的key值。比如淘宝的target为taobao
 */
- (BOOL)canOpenApp:(nonnull NSString *)target;

- (void)supportOpenTaobaoWhenTmallNotInstalled:(BOOL)enable;

/**
 *  是否应用DeferredLink。即在目标App无法打开，降级到下载页（Appstore），在下载好指定App并打开时，自动跳转到指定页面
 *  @param useDeferredLink 默认false
 */
- (void)useDeferredLink:(BOOL)useDeferredLink;

/**
 *  禁用智能唤端。默认false
 */
- (void)disableSmartOpen:(BOOL)disable;

/**
 *  是否打开Debug模式。debug模式下会有log输出，log日志以“ALSL:”开头
 */
- (void)setDebugOn:(BOOL)on;

@end

NS_ASSUME_NONNULL_END
