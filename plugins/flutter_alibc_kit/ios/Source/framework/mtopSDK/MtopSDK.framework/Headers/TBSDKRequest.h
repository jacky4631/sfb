//    '########'########::'######:'########:'##:::'##:
//    ... ##..::##.... ##'##... ##:##.... ##:##::'##::
//    ::: ##::::##:::: ##:##:::..::##:::: ##:##:'##:::
//    ::: ##::::########:. ######::##:::: ##:#####::::
//    ::: ##::::##.... ##:..... ##:##:::: ##:##. ##:::
//    ::: ##::::##:::: ##'##::: ##:##:::: ##:##:. ##::
//    ::: ##::::########:. ######::########::##::. ##:
//    :::..::::........:::......::........::..::::..::
//
//  Created by 亿刀 on 13-1-28.
//  Copyright (c) 2013年 Taobao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MtopSDK/TBSDKMTOPEnvConfig.h>
/*!
 * System parameters
 */
#define SYS_PARAMETER_API_NAME          @"api"
#define SYS_PARAMETER_API_VERSOIN       @"v"
#define SYS_PARAMETER_SECURITY_APPKEY   @"security_appkey"
#define SYS_PARAMETER_APPKEY            @"appkey"
#define SYS_PARAMETER_SID               @"sid"
#define SYS_PARAMETER_TTID              @"ttid"
#define SYS_PARAMETER_TIMESTAMP         @"timestamp"
#define SYS_PARAMETER_DEVID             @"devid"
#define SYS_PARAMETER_LOCATION          @"location"


/**
 * 系统http headers
 */
#define SYS_HTTP_HEADER_PV                      @"x-pv"
#define SYS_HTTP_HEADER_APPKEY                  @"x-appkey"
#define SYS_HTTP_HEADER_SID                     @"x-sid"
#define SYS_HTTP_HEADER_UID                     @"x-uid"
#define SYS_HTTP_HEADER_TTID                    @"x-ttid"
#define SYS_HTTP_HEADER_TIMESTAMP               @"x-t"
#define SYS_HTTP_HEADER_DEVID                   @"x-devid"
#define SYS_HTTP_HEADER_LOCATION                @"x-location"
#define SYS_HTTP_HEADER_SIGN                    @"x-sign"
#define SYS_HTTP_HEADER_UTDID                   @"x-utdid"
#define SYS_HTTP_HEADER_REQBIZ                  @"x-reqbiz-ext"
#define SYS_HTTP_HEADER_APP_VER                 @"x-app-ver"
#define SYS_HTTP_HEADER_MINI_WUA                @"x-mini-wua"
#define SYS_HTTP_HEADER_WUAT                    @"x-wuat"
#define SYS_HTTP_HEADER_FEATURES                @"x-features"
#define SYS_HTTP_HEADER_PAGEURL                 @"x-page-url"
#define SYS_HTTP_HEADER_PAGENAME                @"x-page-name"


/**
 * 开放体系头
 */
#define SYS_HTTP_HEADER_MINI_APPKEY             @"x-mini-appkey"
#define SYS_HTTP_HEADER_REQ_APPKEY              @"x-req-appkey"
#define SYS_HTTP_HEADER_OPEN_BIZ_CODE           @"x-open-biz"
#define SYS_HTTP_HEADER_OPEN_BIZ_DATA           @"x-open-biz-data"


/**
 * open api ext params，sdk use‘s property
 */
#define SYS_HTTP_HEADER_EXTDATA                 @"x-extdata"
#define SYS_HTTP_HEADER_EXTTYPE                 @"x-exttype"
#define SYS_HTTP_HEADER_SECURITY_APPKEY         @"x-s-appkey"
#define SYS_HTTP_HEADER_ACT                     @"x-act"
#define SYS_HTTP_HEADER_ROUTER_ID               @"x-router-id"
#define SYS_HTTP_HEADER_PLACE_ID                @"x-place-id"

/**
 * security guard headers
 */
#define SYS_HTTP_HEADER_SIGNTYPE                @"x-sign-type"
#define SYS_HTTP_HEADER_UMT                     @"x-umt"
#define SYS_HTTP_HEADER_SGEXT                   @"x-sgext"
#define SYS_HTTP_HEADER_BAXIA_VERSION           @"x-bx-version"

#define CUSTOM_HTTP_UTDID             @"custom-utdid"
/**
 * 协议版本
 */
#define M_PV_INNER                              @"6.2"
#define M_PV_OPEN                               @"1.3"
#define M_PV_INNER_OLD                          @"5.2"

#define SYS_PARAMETER_DATA @"data"

@protocol TBSDKConnectionProtocol;

typedef enum _TBSDKRequestErrorType
{
    TBSDKRequestErrorTypeConnectionFailure = 1, //网络连接失败或者无网络
    TBSDKRequestErrorTypeTimedOut = 2,          //网络连接超时
    TBSDKRequestErrorTypeUserInvalid = 3,       // user sid invalid time
    TBSDKREquestTooMuchRedirectionErrorType,
} TBSDKRequestErrorType;

typedef NS_ENUM(NSInteger,TBMtopUnitStrategy){
    TBMtopUnitStrategyGuideUnit = 1,
    TBMtopUnitStrategyTradeUnit
};

@protocol TBSDKRequestDataSource;
@protocol TBSDKRequestDelegate;
@protocol TBSDKRequestProgressProtocol;

//! 网络请求默认超时时间
#define TIME_OUT_SCONDS 10.

@class TBSDKConnection;


/** TBSDK的真正的网络请求类
 *
 *  此类主要做联网控制，如超时时间、最大联网个数、取消所有网络连接等。
 *  TBSDK的真正的网络请求类，此类通过delegate来获取网络请求
 *  的配置参数（get或post，post的value，需要上传的数据）。
 *
 */
@interface TBSDKRequest : NSObject

@property (nonatomic, strong) NSError                                           *error;
//! 代理对象
@property (nonatomic, weak) id<TBSDKRequestDelegate>                            delegate;

//! 代理对象
@property (nonatomic, weak) id<TBSDKRequestDataSource>                          dataSource;

//! 上传下载进度代理对象
@property (nonatomic, weak) id<TBSDKRequestProgressProtocol>                    requestProgressDelegate;

@property (nonatomic, strong, readonly) TBSDKConnection                         *request;

// api request url
@property (nonatomic, strong) NSURL                                             *url;

// api single request custom host
@property (nonatomic, strong) NSString*                                         customHost;
// 请求级别设置线上、预发、日常 custom host (按顺序设置线上、预发、日常域名)
@property (nonatomic, strong) NSArray *customHostList;

//! 请求过期时间，默认10s
@property (nonatomic, assign) NSTimeInterval                         timeOutSeconds;

//! NSData 对象的请求响应数据
@property (nonatomic, strong) NSData                                            *responseData;

//! NSString 对象的请求响应数据
@property (nonatomic, strong) NSString                                          *responseString;

//! http responseStatusCode
@property (nonatomic, assign) int                                    responseStatusCode;

@property (nonatomic, strong, readonly) NSDictionary                            *responseHeaders;

@property (nonatomic, strong) NSDictionary                                      *requestHeaders;

//! 默认关闭
@property (nonatomic, assign) BOOL                                   useHTTPCache;

@property (nonatomic, assign) BOOL                                   forceRefresh;

@property (nonatomic, strong) NSString                                          *apiMethod;

@property (nonatomic)                    BOOL                                   isAvalancheCache;

// post method of body gzip size
@property (nonatomic, assign) int                                    gzipLimitedSize;

@property (nonatomic, strong) NSArray                                           *blackCacheKeyParam;

@property (nonatomic, strong) NSMutableDictionary                               *networkDataSet;
@property (nonatomic) CFAbsoluteTime                                            operationQueueTime;
@property (nonatomic) CFAbsoluteTime                                            networkFinishedTime;


// base property
@property(strong, nonatomic) NSString* userId;                                  // app user's id
@property(strong, nonatomic) NSString* apiName;                                 // 网关URL
@property(strong, nonatomic) NSString* apiVersion;                              // 网关URL

@property(strong, nonatomic) NSMutableDictionary* protocolParameters;           // 协议参数
@property(strong, nonatomic) NSMutableDictionary* httpHeaders;                  // http请求头
@property(strong, nonatomic) NSMutableDictionary* extParameters;                // 扩展参数 (和data参数平级)
@property(strong, nonatomic) NSMutableDictionary* bizParameters;                // 业务参数
@property(strong, nonatomic) NSMutableDictionary* priorityData;                 // 排队SDK优先级参数
@property(strong, nonatomic) NSMutableDictionary* custhomHeaders;               // 自定义不进行urlencode的http请求头


@property(strong,nonatomic) NSMutableArray* uploadFiles;


@property(assign, nonatomic) BOOL isUseHttps;                                   // 是否启用https
@property(assign, nonatomic) BOOL isUseHttpPost;                                // 是否使用http post
@property(strong, nonatomic) NSString* unitPrefix;                              // 单元化前缀
@property(assign, nonatomic) MtopType type;                                     // 实例类型
@property(strong, nonatomic) NSString   *instanceID;                            // 实例ID

@property(strong, nonatomic) id context;                                        // 调用方可以使用的上下文
@property(assign, nonatomic) BOOL isEnableWua;                                  // 是否启用wua
@property(assign, nonatomic) int  wuaFlag;                                      // 启用wua类型标识
@property(assign, nonatomic) BOOL priorityFlag;                                 // API请求优先级flag(针对排队SDK)
@property(assign, nonatomic) TBMtopUnitStrategy  UnitStrategy;                  // 设置请求级别单元化域名策略
@property(assign, nonatomic) BOOL unHostedByNetWork;                            // 是否不要被网络库接管 默认 NO
@property(strong, nonatomic) NSError *rawError;                                 // 底层回调原始error(errorCode为网络库返回原始值)


/*!
 * 创建一个MtopRequest
 * @param apiName           API名称
 * @param apiVersion        API版本
 * @return
 *                      MtopRequest
 */
- (TBSDKRequest*) initWithApiName: (NSString*) apiName apiVersion: (NSString*) apiVersion;

/*!
 * 添加一个http请求头
 * @param value     HTTP头value
 * @param key       HTTP头key
 */
- (void) addHttpHeader: (NSString*) value forKey: (NSString*) key;

/*!
 * 添加一个http请求头 (不做UrlEncode)
 * @param value   HTTP头value
 * @param key     HTTP头key
 */
- (void) addCustomHttpHeader:(NSString *)value forKey:(NSString *)key;

/*!
 * 添加一个协议参数
 * @param value     参数值
 * @param key       参数名
 */
- (void) addProtocolParameter: (NSString*) value forKey: (NSString*) key;

/*!
 * 添加一个扩展参数和data参数平级
 * @param value     参数值
 * @param key       参数名
 */
- (void) addExtParameter: (id) value forKey: (NSString*) key;

/*!
 * 移除一个扩展参数
 * @param key
 */
- (void) removeExtParameter:(NSString*) key;

/*!
 * 添加一个业务参数(业务级别参数)
 * @param value     参数值
 * @param key       参数名
 */
- (void) addBizParameter: (id) value forKey: (NSString*) key;

/*!
 * 移除一个业务参数
 * @param key
 */
- (void) removeBizParameter:(NSString*) key;

/**
 * 设置API请求优先级参数
 *
 * @param value    参数值
 * @param key      参数名
 */
- (void) addPriorityData:(id) value forKey:(NSString*) key;

/*!
 * 添加要上传的文件
 * @param data          文件数据
 * @param fileName      本地文件名(全路径)
 * @param forKey        form field 的 key
 *
 */
- (void) addUploadFileWithData: (NSData*) data fileName: (NSString*) fileName forKey: (NSString*) key;


//! 取消TBSDK中的所有的网络连接
+ (void)cancelTBSDKAllRequest;

//! 开始同步网络请求, 当网络请求完成或失败后返回
- (BOOL)startSynchronous;

//! 开始异步请求
- (void)startAsynchronous;

//! 退出网路请求，并把delegate设置为空
- (void)cancelRequest;

/*!
 * 重置
 */
- (void) reset;

@end

