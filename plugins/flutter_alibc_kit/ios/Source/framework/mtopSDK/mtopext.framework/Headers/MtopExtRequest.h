
//
//  MtopExtRequest.h
//  mtopext
//
//  封装的mtop api 请求
//
//  Created by sihai on 4/11/14.
//  Copyright (c) 2014 Taobao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <mtopext/MtopExtRequestDelegate.h>
#import <mtopext/MtopAuthProtocol.h>
#import <mtopext/TBSDKUTUtility.h>
#import <mtopext/TBSDKAccountInfo.h>
#import <mtopext/MTopPrefetch.h>

@class TBSDKRequest;


#pragma mark - 枚举定义


/**
 * cache 策略
 */
typedef NS_ENUM(NSUInteger,CachePolicy) {
    /**
     * 默认cache策略。使用这个策略时，request会先查看cache中是否有可用的缓存数据。如果没有，request会像普通request那样工作。
     * 如果有缓存数据并且缓存数据没有过期，那么request会使用缓存的数据，而且不会向服务器通信。如果缓存数据过期了，request会先
     * 进行GET请求来向服务器询问数据是否有新的版本。如果服务器说缓存的数据就是当前版本，那么缓存数据将被使用，不会下载新数据。
     * 在这种情况下，cache的有效期将被设定为服务器端提供的新的有效期。如果服务器提供更新的内容，那么新内容会被下载，并且新的数据
     * 以及它的有效期将被写入cache。
     */
    AskServerIfModifiedWhenStaleCachePolicy = 0,
    
    
    /**
     * 不使用任何cache策略，普通的请求
     */
    DoNotReadAndWriteCacheCachePolicy,
    
    
    /**
     * 用于强制刷新，没有cache回调，一定请求网络数据
     */
    AskServerIfModifiedCachePolicy,
    
    
    /**
     * 用于强制刷新，有cache回调，一定请求网络数据
     */
    AskServerIfModifiedCacheAndReturnCachePolicy,
    
    
    /**
     * 用于MessageBox使用，有cache回调，一定请求网络数据
     */
    AskServerIfModifiedCacheAndReturnCachePolicyMessageBox
    
};


/**
 * 登录控制参数
 */
typedef NS_ENUM(NSInteger,MtopSessionExpiredOption) {
    /**
     * SDK内部标记用，外部业务禁止使用
     */
    MtopSessionExpiredOptionDummy   = -1,
    
    
    /**
     * Session失效时，什么都不做
     */
    MtopSessionExpiredOptionNone    = 0,
    
    
    /**
     * Session失效时，只做Auto Login
     */
    MtopSessionExpiredOptionAutoLogin   = 1,
    
    
    /**
     * Session失效时，先Auto Login，如果Auto Login失败，唤起登录界面
     */
    MtopSessionExpiredOptionAutoLoginAndManualLogin = 2

};



/**
 * 授权控制参数
 */
typedef NS_ENUM(NSInteger,MtopAuthExpiredOption){
    /**
     * SDK内部标记用，外部业务禁止使用
     */
    MtopAuthExpiredOptionDummy  = -1,
    
    
    /**
     * Auth失效时，什么都不做
     */
    MtopAuthExpiredOptionNone   = 0,
    
    
    /**
     * Auth失效时，只做Auto Auth
     */
    MtopAuthExpiredOptionAutoAuth = 1,
    
    
    /**
     * Auth失效时，先Auto Auth，如果Auto Auth失败，唤起登录界面
     */
    MtopAuthExpiredOptionAutAuthAndManualAuth = 2
};



/**
 * WUA 控制参数
 */
typedef NS_ENUM(NSUInteger,WuaType) {
    kWuaDefault = 3,
    kWuaGeneral,
    kWuaMini,
    kWuaAtlas
};


/**
 *  控制请求是属于导购单元还是交易单元。该参数最终体现在请求域名上。
 */
typedef NS_ENUM(NSUInteger,MtopUnitStrategy) {
    /**
     * 导购单元(默认所有请求走导购单元)
     */
    MtopUnitStrategyGuideUnit = 1,
    
    
    /**
     * 交易单元
     */
    MtopUnitStrategyTradeUnit
};

#pragma mark - MTOP请求对象

/**
 * MTOP请求对象接口。
 */
@interface MtopExtRequest : NSObject


/**
 * 本地请求的自定义域名。
 */
@property(nonatomic, strong) NSString* customHost;


/**
 * 同步请求, 还是异步请求。默认值为 NO。
 * 其值取决于对象 [MtopService sync_call:] 与 [MtopService async_call:]
 */
@property(nonatomic, assign) BOOL isSync;


/**
 * 指示是否需要登录态，由业务设置。
 * P.S. 登录相关为什么如此命名？具体原因己不可考。基于兼容性考虑，已不便变动。
 */
@property(nonatomic, assign) BOOL isNeedEcode;


/**
 * Session 失效选项。isNeedEcode = YES 的情况下有效。
 */
@property(nonatomic, assign) MtopSessionExpiredOption sessionExpiredOption;


/**
 * 指示是否需要Auth授权
 */
@property(nonatomic, assign) BOOL isNeedAuth;


/**
 * 授权过期选项。isNeedAuth = YES 的情况下有效。
 */
@property(nonatomic, assign) MtopAuthExpiredOption authExpiredOption;


/**
 * 是否启用虚机签名
 */
@property(nonatomic, assign) BOOL isEnableWUA;


/**
 * 虚机签名类型。isEnableWUA = YES 的情况下有效。
 */
@property(nonatomic, assign) WuaType wuaType;


/**
 * 本地请求的 ttid (渠道号)。如业务未设置，以 TBSDKConfiguration.wapTTID 值为准。
 */
@property(nonatomic, strong) NSString* ttid;


/**
 * cache策略
 */
@property(nonatomic, assign) CachePolicy cachePolicy;


/**
 * 计算cache key 时需要排查的参数名列表.
 * 备注：目前用数组而没有用dict是合理的, 参数数量不会多。
 */
@property(nonatomic, strong) NSMutableArray* excludedCacheKeyParameters;


/**
 * 是否已经被取消
 */
@property(atomic, assign) BOOL isCanceled;


/**
 * 是否需要校验服务端的响应
 */
@property(assign, nonatomic) BOOL isNeedValidateResponse;


/**
 * 重试的次数
 */
@property(nonatomic, assign, readonly) int8_t retryCount;


/**
 * 自定义请求user id, 影响请求 x-uid 头域
 */
@property(nonatomic, strong) NSString *userID;


/**
 * SDK 内部生成的端側trace id, 请求 x-c-traceid 头域值。
 */
@property(nonatomic, strong, readonly) NSString *clientTraceId;


/**
 * 全链路埋点ID。
 */
@property (nonatomic, copy, readonly) NSString *fullTraceID;


/**
 * 业务ID，值由构造参数传入
 */
@property(nonatomic, strong, readonly) NSString  *bizID;


/**
 * 当前请求的page name, 埋点用。
 */
@property(nonatomic, copy) NSString *pageName;


/**
 * 当前请求的page url, 埋点用。
 */
@property(nonatomic, copy) NSString *pageUrl;


/**
 * 当前请求的单元域名策略。
 */
@property(nonatomic, assign) MtopUnitStrategy  UnitStrategy;


/**
 * 是否使用主线程回调。YES: 不从主线程回调, NO: 从主线程回调。
 */
@property(nonatomic, assign) BOOL isNotUseMainThreadCallback;


/**
 * 预取优化参数配置。
 */
@property(strong, nonatomic) MTopPrefetch *prefetch;


/**
 * 淘内开放API授权参数对象
 */
@property (nonatomic,strong, readonly) AuthParamObj *authObj;


#pragma mark - 小程序开放体系参数

/**
 * 开放小程序 Appkey. 影响协议头： x-mini-appkey
 */
@property (nonatomic, strong) NSString  *miniAppkey;


/**
 * 小程序appkey/插件appkey. 影响协议头： x-req-appkey
 */
@property (nonatomic, strong) NSString  *requestAppkey;


/**
 * 开放业务平台标识码, 目前只有 mini-app / baichuan 两种类型。影响协议头： x-open-biz
 */
@property (nonatomic, strong) NSString  *openBizCode;


/**
 * 开放业务拓展字段。影响协议头： x-open-biz-data
 */
@property (nonatomic, strong) NSString  *openBizData;


/**
 * 原底层的 mtop 请求对象. 外部业务禁止修改。
 */
@property(nonatomic, strong) TBSDKRequest* mrequest;

#pragma mark - 回调

/**
 * Block回调，请求开始
 */
@property(atomic, copy) MtopExtRequestStarted  startedBlock;


/**
 * Block回调，请求失败
 */
@property(atomic, copy) MtopExtRequestFailed   failedBlock;


/**
 * Block回调，请求成功
 */
@property(atomic, copy) MtopExtRequestSucceed  succeedBlock;


/**
 * Delegate回调, 该回调与block回调语义等价，业务方可选择合适自己的方式来设置回调。
 */
@property(atomic, weak, atomic) id<MtopExtRequestDelegate> delegate;


#pragma mark - 埋点信息

/**
 * 埋点信息
 */
@property(strong, nonatomic) UTDataSet* mtopUT;


#pragma mark - 废弃参数

@property(nonatomic, strong) NSString  *h5URL DEPRECATED_MSG_ATTRIBUTE("使用 pageUrl 代替");
@property(nonatomic, strong) NSString* wuaPageName DEPRECATED_MSG_ATTRIBUTE("无用参数");
@property(nonatomic, strong) NSString* wuaCtrlName DEPRECATED_MSG_ATTRIBUTE("无用参数");
@property(nonatomic, assign) float xCoordinate DEPRECATED_MSG_ATTRIBUTE("无用参数");
@property(nonatomic, assign) float yCoordinate DEPRECATED_MSG_ATTRIBUTE("无用参数");
@property(nonatomic, strong) NSArray *customHostList DEPRECATED_MSG_ATTRIBUTE("无用参数");
@property(nonatomic, weak) id context DEPRECATED_MSG_ATTRIBUTE("无用参数");
@property(nonatomic, assign) BOOL isFromOfflineOperation DEPRECATED_MSG_ATTRIBUTE("无用参数");
@property(nonatomic, assign) ServerType serverType DEPRECATED_MSG_ATTRIBUTE("无用参数");
@property(nonatomic, assign) BOOL isForceHttps DEPRECATED_MSG_ATTRIBUTE("无用参数");
@property(nonatomic, assign) BOOL isForceSpdy DEPRECATED_MSG_ATTRIBUTE("无用参数");

/**
 * 初始化一个API请求对象
 * @param apiName       API名称
 * @param apiVersion    API版本
 * @return
 *              MtopExtRequest
 */
- (MtopExtRequest*) initWithApiName: (NSString*) apiName apiVersion: (NSString*) apiVersion;

/*!
 * 初始化一个API请求对象
 * @param apiName       API名称
 * @param apiVersion    API版本
 * @param bizID         业务组件ID
 * @return
 *              MtopExtRequest
 */
- (MtopExtRequest *)initWithApiName:(NSString *)apiName apiVersion:(NSString *)apiVersion bizID:(NSString *)bizID;


/*
 *  设置请求不被网络库接管
 */
- (MtopExtRequest *)unHostedByNetWork;

/*!
 * 设置网络超时
 * @param timeout 超时时间，单位秒
 * @return
 *              MtopExtRequest 以便可以链式操作
 */
- (MtopExtRequest*) setNetworkTimeout: (int) timeout;

/*!
 * 走https
 * @return
 *              MtopExtRequest 以便可以链式操作
 */
- (MtopExtRequest*) useHttps;

/*!
 * 禁止走https
 * @return
 *              MtopExtRequest 以便可以链式操作
 */
- (MtopExtRequest*) disableHttps;

/*!
 * 使用post
 * @return
 *              MtopExtRequest 以便可以链式操作
 */
- (MtopExtRequest*) useHttpPost;

/*!
 * 添加一个http请求头
 * @param value     HTTP头value, 请不要做urlencode, 底层会统一做的
 * @param key       HTTP头key
 * @return
 *              MtopExtRequest 以便可以链式操作
 */
- (MtopExtRequest*) addHttpHeader: (NSString*) value forKey: (NSString*) key;

/*!
 * 一次添加多个头
 * @param kvs
 * @return
 *              MtopExtRequest 以便可以链式操作
 */
- (MtopExtRequest*) addHttpHeaders: (NSDictionary*) kvs;

/*!
 * 添加一个http请求头 (该接口请求头不做UrlEncode)
 * @param value     HTTP头value, 请不要做urlencode, 底层会统一做的
 * @param key       HTTP头key
 * @return
 *              MtopExtRequest 以便可以链式操作
 */
- (MtopExtRequest*) addCustomHttpHeader: (NSString*) value forKey: (NSString*) key;

/*!
 * 一次添加多个头 (该接口请求头不做UrlEncode)
 * @param kvs
 * @return
 *              MtopExtRequest 以便可以链式操作
 */
- (MtopExtRequest*) addCustomHttpHeaders: (NSDictionary*) kvs;



/*!
 * 添加一个协议级参数
 * @param value     参数值
 * @param key       参数名
 * @return
 *              MtopExtRequest 以便可以链式操作
 */
- (MtopExtRequest*) addProtocolParameter: (NSString*) value forKey: (NSString*) key;

/*!
 * 添加一个扩展参数和data参数平级
 * @param value     参数值
 * @param key       参数名
 * @return
 *              MtopExtRequest 以便可以链式操作
 */
- (MtopExtRequest*) addExtParameter: (id) value forKey: (NSString*) key;

/*!
 * 一次添加多个扩展参数和data参数平级
 * @param kvs
 * @return
 *              MtopExtRequest 以便可以链式操作
 */
- (MtopExtRequest*) addExtParameters: (NSDictionary*) kvs;

/*!
 * 移除一个扩展参数
 * @param key
 * @return
 *              MtopExtRequest 以便可以链式操作
 *
 */
- (MtopExtRequest*) removeExtParameter: (NSString*) key;

/*!
 * 添加一个业务参数(业务级别参数)
 * @param value     参数值
 * @param key       参数名
 * @return
 *              MtopExtRequest 以便可以链式操作
 */
- (MtopExtRequest*) addBizParameter: (id) value forKey: (NSString*) key;

/*!
 * 一次添加多个业务参数(业务级别参数)
 * @param kvs
 * @return
 *              MtopExtRequest 以便可以链式操作
 */
- (MtopExtRequest*) addBizParameters: (NSDictionary*) kvs;

/*!
 * 移除一个业务参数
 * @param key
 * @return
 *              MtopExtRequest 以便可以链式操作
 */
- (MtopExtRequest*) removeBizParameter:(NSString*) key;

/*!
 * 为了TBSDKMtopServer兼容提供的, 不建议使用
 * @return
 *              MtopExtRequest 以便可以链式操作
 */
- (MtopExtRequest*) clearBizParameters;

#pragma mark 排队SDK用来设置请求优先级相关参数
/*!
 * 设置API请求优先级参数
 * @param data 优先级参数
 */
- (MtopExtRequest*)addPriorityData:(NSDictionary*)data;

/*！
 * 设置API请求优先级参数
 * @param value
 * @param key
 */
- (MtopExtRequest*) addPriorityData:(id)value forKey:(NSString *)key;

#pragma mark 排队SDK用来设置API请求优先级
/*!
 * 设置API请求优先级Flag
 * @param priorityFlag 优先级标识
 */
- (void) setPriorityFlag:(BOOL)priorityFlag;

/*!
 * 添加要上传的文件
 * @param data          文件数据
 * @param fileName      本地文件名(全路径)
 * @param forKey        form field 的 key
 * @return
 *              MtopExtRequest 以便可以链式操作
 *
 */
- (MtopExtRequest*) addUploadFileWithData: (NSData*) data fileName: (NSString*) fileName forKey: (NSString*) key;

/*!
 * 添加一个计算cache key 时排查的参数名
 * @param name 参数名
 *  @return
 *              MtopExtRequest 以便可以链式操作
 */
- (MtopExtRequest*) addExcludedCacheKeyParameter: (NSString*) name;

#pragma mark - 淘内开发api授权设置参数
/*!
 *
 * @param appkey        需授权的三方应用appkey
 * @param authParam     授权参数
 *  @return
 *              MtopExtRequest 以便可以链式操作
 */
- (MtopExtRequest*)setNeedAuth:(NSString *)appkey andAuthParam:(NSDictionary *)authParam;


/**
 指示生成WUA, 并设定WUA可选参数
 
 @param pageName
 @param ctrlName
 @param xCoordinate
 @param yCoordinate
 @return 带wua的MtopExtRequest
 */
- (MtopExtRequest*) enableWUAWithPageName: (NSString*) pageName
                                 ctrlName: (NSString*) ctrlName
                              xCoordinate: (float) xCoordinate
                              yCoordinate: (float) yCoordinate
                                DEPRECATED_MSG_ATTRIBUTE("enableWUAWithPageName is deprecated");


/*!
 * 获取请求id (请求id是系统生成的唯一的标识)
 * @return
 *              NSString
 */
- (NSString*) getRequestId;

/*!
 * 获取API名称
 * @return
 *              NSString
 */
- (NSString*) getApiName;

/*!
 * 获取API版本
 * @return
 *              NSString
 */
- (NSString*) getApiVersion;

/*!
 * 为了TBSDKMtopServer兼容提供的, 不建议使用
 * @param apiVersion
 *
 */
- (void) setApiName: (NSString*) apiName;

/*!
 * 为了TBSDKMtopServer兼容提供的, 不建议使用
 * @param apiVersion
 *
 */
- (void) setApiVersion: (NSString*) apiVersion;

/*!
 * 获取扩展参数
 * @return
 *              NSDictionary
 */
- (NSDictionary*) getExtParameters;

/*!
 * 获取业务参数
 * @return
 *              NSDictionary
 */
- (NSDictionary*) getBizParameters;

/*!
 * 获取http请求头(不包含协议参数头)
 */
- (NSDictionary *)getHttpHeaders;

/*!
 * 判断请求是否要求使用了post
 * @return
 *              YES
 *              NO
 */
- (BOOL) isUseHttpPost;

/*!
 * 判断请求是否要求使用了https
 * @return
 *              YES
 *              NO
 */
- (BOOL) isUseHttps;

/*!
 * 重试计数 retryCount += 1
 */
- (void) retryed;

/*!
 * 是否需要重试
 */
- (BOOL) isNeedRetry;

/*!
 * mtop ut 开始 (开始请求)
 * @param isSync
 */
- (void) utStart: (BOOL) isSync;

/*!
 * mtop ut 结束
 */
- (void) utEnd;

/*!
 * mtop ut json解析开始
 */
- (void) utJsonParseStartTime;

/*!
 * mtop ut json解析结束
 */
- (void) utJsonParseEndTime;

/*!
 * 取消
 */
- (void) cancel;

/*!
 *
 */
- (BOOL) isNeedCallback;

@end
