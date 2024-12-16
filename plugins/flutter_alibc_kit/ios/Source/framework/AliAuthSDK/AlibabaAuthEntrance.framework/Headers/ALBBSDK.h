//
//  AlibabaAuthSDK.h
//  AlibabaAuthSDK
//
//  Created by Bangzhe Liu on 6/15/16.
//  Copyright © 2016 taobao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


/** 回调定义 */
typedef void (^SuccessCallback)(void);
typedef void (^FailureCallback)(NSError *error);


@interface ALBBSDK : NSObject

+ (ALBBSDK *)sharedInstance;

//必须在主线程调用
- (void)ALBBSDKInit;

- (void)auth:(UIViewController *)parentController successCallback:(SuccessCallback) onSuccess failureCallback:(FailureCallback) onFailure;

/**
 退出登录
 */
- (void)logout;

/**
 是否是登录URL
 */
- (BOOL)isLoginURL:(NSString *)url;

/**
 是否是登出URL
 */
- (BOOL)isLogoutUrl:(NSString *)url;

- (BOOL)handleUrl:(NSString *)url;

//如果是接入的极简版本需要手动设置appkey
- (void)setAppkey : (NSString *)appKey;

- (void)setH5Only:(BOOL)h5Only;
@end
