//
//  ZUOAuthManager 联通能力接入管理者
//  OAuthSDKApp
//
//  Created by zhangQY on 2019/5/13.
//  Copyright © 2019 com.zzx.sdk.ios.test. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZUOAuthManager : NSObject

/**
 *  获取联通能力接入单例对象
 */
+ (instancetype)getInstance;
/**
 *  初始化方法 默认
 */
- (void) initWithApiKey:(NSString*)apiKey;

/**
 *  初始化方法 2
 */
- (void) initWithApiKey:(NSString*)apiKey withUA:(NSString *)ua;

/**
 *  一键登录功能 - 预取号接口
 */
- (void)login:(double)timeout resultListener:(void (^)(NSDictionary *data))listener;
/**
 *  一键登录功能 - 关闭一键登录功能默认缓存功能
 */
- (void)closeLoginCachingStrategy:(BOOL)yesOrNo;
/**
 *  一键登录功能 - 清除缓存
 */
- (void)clearCULoginCache;


/**
 *  号码认证功能 - 预认证接口
 */
- (void)oauth:(double)timeout resultListener:(void (^)(NSDictionary *data))listener;
/**
 *  号码认证功能 - 关闭号码认证功能默认缓存
 */
- (void)closeOauthCachingStrategy:(BOOL)yesOrNo;
/**
 *  号码认证功能 - 清除缓存
 */
- (void) clearCUOauthCache;
/**
 *  SDK Debug功能
 */
- (void)setDebug:(BOOL) yesOrNo;
/**
 *  SDK 获取当前版本号功能
 */
+ (NSString *)getVersionInfo;

@end
