//
//  aluEnvConfig.h
//  AliUniversalAccount
//
//  Created by ethan on 12/14/15.
//  Copyright © 2015 Alipay. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 环境 */
typedef NS_ENUM (NSUInteger, ALBBCompatibleEnvironment) {
    /** 测试环境 */
    ALBBCompatibleEnvironmentDaily,
    /** 预发环境 */
    ALBBCompatibleEnvironmentPreRelease,
    /** 线上环境 */
    ALBBCompatibleEnvironmentRelease,
};

@interface ALBBCompatibleEnvConfig : NSObject

+ (instancetype)shareInstance;

- (void) setGWServerSettings:(ALBBCompatibleEnvironment) env;

- (void)setSecAdditional:(NSString *)additional;

@end
