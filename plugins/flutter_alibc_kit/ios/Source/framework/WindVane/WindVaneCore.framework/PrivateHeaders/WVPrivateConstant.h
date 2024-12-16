//
//  WVPrivateConstant.h
//  Core
//
//  Created by lianyu.ysj on 16/3/14.
//  Copyright © 2016年 WindVane. All rights reserved.
//

#import <Foundation/Foundation.h>

// 【慎用】忽略指定名称的集团 iOS 开发规约扫描规则，由 @晨燕 提供。
#define WV_IGNORE_CHECKER(RULE_NAME) __attribute__((annotate("IgnoreChecker:" #RULE_NAME)))

#pragma mark - Notification

// 表示更新完毕的配置名称的键。
FOUNDATION_EXPORT NSString * _Nonnull const WVConfigNameKey;

/**
 * 特定配置更新完毕的通知。
 * @WVConfigNameKey 更新完毕的配置名称。
 */
FOUNDATION_EXPORT NSString * _Nonnull const WVConfigUpdateFinishedNotification;
