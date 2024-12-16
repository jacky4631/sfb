/*
 * AlibcAuthHintName.h 
 *
 * 阿里百川电商
 * 项目名称：阿里巴巴电商 AlibcTradeBiz 
 * 版本号：4.0.0.9
 * 发布时间：2019-10-31
 * 开发团队：阿里巴巴商家服务引擎团队
 * 阿里巴巴电商SDK答疑群号：1488705339  2071154343(阿里旺旺)
 * Copyright (c) 2016-2020 阿里巴巴-淘宝-百川. All rights reserved.
 */

#import <Foundation/Foundation.h>

//权限点名字映射,暂时写死在这里

@interface AlibcAuthHintName : NSObject
@property(nonatomic, strong) NSMutableDictionary *dicHintName;
@property(nonatomic, strong) NSMutableDictionary *dicHintForDebug;


+ (instancetype)sharedInstantce;

- (NSArray<NSString *> *)getName:(NSArray<NSString *> *)hintList;

//自动判断环境,转换权限点
- (NSArray<NSString *> *)exchangeHint:(NSArray<NSString *> *)hintList;

- (void)addHintName:(NSString *)hintId name:(NSString *)name;

@end
