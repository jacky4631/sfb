/*
 * AlibcTradeShowParams.h 
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
#import "AlibcLinkPartnerBridge.h"

/**
 *  打开页面的类型
 *
 */
typedef NS_ENUM(NSUInteger, AlibcOpenType) {
    /** 智能判断 */
    AlibcOpenTypeAuto,
    /** 强制拉端(手淘/天猫) */
    AlibcOpenTypeNative
};

@interface AlibcTradeShowParams : NSObject
/** 
 * 是否为push方式打开新页面
 * 当show page时传入自定义webview时,本参数没有实际意义
 * 当show page时传入自定义webview时 只能设置 isNeedPush = YES，不支持present 自定义webView。
 * 使用百川webView支持push、present两种方式
 * NO : 在当前view controller上present新页面
 * YES: 在传入的UINavigationController中push新页面
 * 默认值:NO
 */
@property(nonatomic, assign) BOOL isNeedPush;
/** 
 * 打开页面的方式,详见AlibcOpenType
 * 默认值:Auto 
 */
@property(nonatomic, assign) AlibcOpenType openType;
/**
 * 指定手淘回跳的地址，跳转至isv指定的url
 * 规则: tbopen${appkey}://xx.xx.xx
 */
@property(nonatomic, strong) NSString *backUrl;

/**
 * applink使用，优先拉起的linkKey，手淘：@"taobao" 天猫:@"tmall"
 * 其中当设置天猫时发现未安装，如果安装手淘会拉起手淘
 */
@property(nonatomic, strong) NSString *linkKey;


/**
 *  是否需要自定义处理跳手淘/天猫失败后的处理策略，默认未无需自定义
 */
@property(nonatomic, assign)BOOL isNeedCustomNativeFailMode;

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

@end
