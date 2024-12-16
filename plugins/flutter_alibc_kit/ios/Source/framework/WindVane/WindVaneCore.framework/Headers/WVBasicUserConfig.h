/*
 * WVBasicUserConfig.h
 * 
 * Created by WindVane.
 * Copyright (c) 2017年 阿里巴巴-淘宝技术部. All rights reserved.
 */

#import "WVUserConfig.h"

// WVBasicUserConfig 已与 WVUserConfig 合并，请直接使用 WVUserConfig 类，这里的方法会逐渐废弃掉。
@interface WVBasicUserConfig : NSObject

#pragma mark - 设置方法，请使用 WVUserConfig 类的同名方法

+ (void)setAppKey:(NSString *)appKey;
+ (void)setAppName:(NSString *)appName;
+ (void)setAppVersion:(NSString *)appVersion;
+ (void)setEnvironment:(WVEnvironment)environment;
+ (void)setDebugMode:(BOOL)isDebugMode;
+ (BOOL)isDebugMode;
+ (void)openWindVaneLog;
+ (void)setLogLevel:(WVLogLevel)logLevel;
+ (void)setAppUA:(NSString *)appUA;
+ (void)setDefaultParamForFirstLoad:(NSString *)defaultParam;
+ (void)setConfigAutoUpdate:(BOOL)autoUpdate;

@end
