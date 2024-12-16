/*
 * AlibcUrlhandleResult.h 
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
#import "AlibcTradeSDKDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface AlibcUrlhandleResult : NSObject

// 成功与否
@property(nonatomic,assign)BOOL isSuccess;

// 最终打开的url
@property(nonatomic,copy)NSString *url;

// 最终打开的方式
@property(nonatomic,assign)AlibcOpenPageResultType openPageType;

// 是否filter url
@property(nonatomic,assign)BOOL filtered;

// 是否不允许唤端
@property(nonatomic,assign)BOOL isNotAllowLink;

// 失败信息
@property(nonatomic,strong)AlibcError *resultError;

@end

NS_ASSUME_NONNULL_END
