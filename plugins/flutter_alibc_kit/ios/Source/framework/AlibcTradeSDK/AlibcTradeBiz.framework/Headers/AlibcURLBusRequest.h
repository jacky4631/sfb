/*
 * AlibcURLBusRequest.h 
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
#import "AlibcURLBusPageOpenParams.h"
#import "AlibcTradeSDKDefines.h"

/**
 *  原始页面类型
 */
typedef NS_ENUM(NSUInteger, AlibcPageType) {
    /**unkown**/
    AlibcUnkownPage,
    /** h5 */
    AlibcH5Page
};


@interface AlibcURLBusRequest : NSObject

// URL 原始页面类型
@property(nonatomic,assign)AlibcPageType pageType;

// 原始URL
@property(nonatomic,copy)NSString *originalUrl;

// 页面业务类型：detail/shop/addCart/order/login/.../unkown
@property(nonatomic,copy)NSString *pageBizCode;

// 页面打开方式集合
@property(nonatomic,copy)NSArray *openPageActionList;

// url 来源
@property(nonatomic,assign)AlibcUrlSourceType urlSource;

// 用户是否自定义拉端失败模式
@property(nonatomic,assign)BOOL isCustomNativeFailMode;

/**
 *  当isNeedCustomNativeFailMode ==YES时生效 跳手淘/天猫失败后的处理策略, 默认值为: AlibcNativeFailModeJumpH5
 */
@property(nonatomic, assign) AlibcNativeFailMode nativeFailMode;

/**
 * AppLink唤端失败，媒体自定义降级url
 * 当isNeedCustomNativeFailMode ==YES && nativeFailMode 设置为 AlibcNativeFailModeJumpH5时生效
 *
 */
@property(nonatomic, copy)NSString *degradeUrl;

// 是否是iframe
@property(nonatomic, assign) BOOL isFrame;

@end
