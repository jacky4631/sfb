//
//  Constants.h
//  mtopext
//
//  Created by sihai on 18/11/14.
//  Copyright (c) 2014 Taobao. All rights reserved.
//

#ifndef mtopext_Constants_h
#define mtopext_Constants_h

#define MTOP_SDK_VERSION      @"1.9.3.48"

#define C_TRUE                @"true"
#define C_FALSE               @"false"

#define STRING_NULL_VALUE                               @""

#define DEFAULT_TIMEOUT         30

/*!
 * HTTP响应码
 */
#define HTTP_OK                 200
#define HTTP_304                304
#define HTTP_LimitFlow          420

/*!
 * 客户端支持的特性
 */
#define HTTP_HEADER_FEATURES    @"x-features"
#define HTTP_HEADER_UTDID       @"x-utdid"
#define HTTP_HEADER_UMT         @"x-umt"

/*！
 * 服务端返回的Http响应头
 */
#define RESPONSE_HEADER_RET_CODE                        @"m-retcode"
#define RESPONSE_HEADER_RET_MSG                         @"m-retmsg"
#define RESPONSE_HEADER_SESSION_EXPIRED_REASON          @"S"

#define RESPONSE_HEADER_API_CONFIG                      @"x-m-apiconfig"
#define RESPONSE_HEADER_API_CONFIG_V                    @"x-m-apiconfig-v"

#define RESPONSE_HEADER_ETAG                            @"Etag"
#define RESPONSE_HEADER_ETAG_1                          @"etag"
#define RESPONSE_LAST_MODIFIED                          @"Last-Modified"
#define RESPONSE_LAST_MODIFIED_1                        @"last-modified"
#define RESPONSE_CACHE_CONTROL                          @"Cache-Control"
#define RESPONSE_CACHE_CONTROL_1                        @"cache-control"
#define RESPONSE_HEADER_MTOP_XETAG                      @"MTOP-XEtag"
#define RESPONSE_HEADER_MTOP_XETAG_1                    @"mtop-xetag"


#define RESPONSE_XCOMMAND                               @"MTOP-X-Command"
#define RESPONSE_XCOMMAND_N                             @"MTOP-X-Command_N"

#define RESPONSE_HEADER_MD5                             @"m-content-md5"

#define KEY_RET             @"ret"
#define RET_SUCCESS         @"SUCCESS"
#define KEY_APPCONF         @"appConf"
#define ERRORCODE_MSG       @"x-session-ret"
#define Date                @"Date"

/*!
 * 服务端返回json的常量key
 */
#define RESULT_KEY_API                  @"api"
#define RESULT_KEY_VERSION              @"v"
#define RESULT_KEY_RET                  @"ret"
#define RESULT_KEY_DATA                 @"data"


/*!
 * 错误码常量定义
 */

#define ERROR_CODE_SUCCEED                  @"SUCCESS"

#define ERROR_CODE_NETWORK_TIMEOUT          @"network_timeout"

#define ERROR_CODE_SESSION_EXPIRED          @"FAIL_SYS_SESSION_EXPIRED"        // api4 session失效错误码
#define ERROR_CODE_AUTH_EXPIRED             @"FAIL_SYS_AUTH_EXPIRED"           // 授权过期错误码
#define ERROR_CODE_REQUEST_EXPIRED          @"FAIL_SYS_REQUEST_EXPIRED"        // 请求过期
#define ERROR_CODE_ILLEGAL_SIGN             @"FAIL_SYS_ILEGEL_SIGN"            // api4 签名错误

/*!
 * 授权错误码常量定义
 */
#define ERROR_CODE_ACCESS_TOKEN_EXPIRED     @"FAIL_SYS_ACCESS_TOKEN_EXPIRED" // 授权accessToken过期
#define ERROR_CODE_ACCESS_TOKEN_ILLEGAL     @"FAIL_SYS_ILLEGAL_ACCESS_TOKEN" // 授权的accessToken非法


#define ERROR_CODE_FAILED                   @"FAIL"

#define ERROR_CODE_WRONG_RESPONSE           @"Wrong_Server_Response"           // 服务端返回了错误的响应

#define ERROR_CODE_DISPATCH_ERROR_0         @"-2003"
#define ERROR_CODE_DISPATCH_ERROR_1         @"-2004"
#define ERROR_CODE_DISPATCH_ERROR_2         @"-2005"

#define ERROR_CODE_RESPONSE_FALSIFIED       @"FAIL_CLIENT_RESPONSE_FALSIFIED"

#define FAIL_ACCS                           @"FAIL_ACCS"


/*!
 * 错误信息常量定义
 */
#define ERROR_MSG_SUCCEED                       @"接口调用成功"
#define ERROR_MSG_OFFLINE_OPERATION_SUCCEED     @"离线调用成功"
#define ERROR_MSG_SESSION_EXPIRED               @"Session过期失效"
#define ERROR_MSG_AUTH_EXPIRED                  @"授权过期失效"
#define ERROR_MSG_ACCESS_TOKEN_EXPIRED          @"服务竟然出错了"
#define ERROR_MSG_ACCESS_TOKEN_EXPIRED          @"服务竟然出错了"
#define ERROR_MSG_FAILED                        @"网络异常，请稍后再试"               
#define ERROR_MSG_WRONG_RESPONSE                @"错误的响应，服务端下发数据为空或数据不是mtop格式的数据"
#define ERROR_MSG_RESPONSE_FALSIFIED            @"数据被篡改"
#define ERROR_MSG_CACHE_FAILED                  @"服务竟然出错了"
#define ERROR_MSG_MTOPSYS                       @"服务竟然出错了"


/*!
 * API Local Configuration Key
 */
#define API_LOCAL_CONFIGURATION_KEY_CACHE                   @"cache"
#define API_LOCAL_CONFIGURATION_KEY_OFFLINE_OPERATION       @"offlineOp"
#define API_LOCAL_CONFIGURATION_KEY_EXCLUDED_PARAMETERS     @"excludeQueryList"
#define API_LOCAL_CONFIGURATION_KEY_PUSH                    @"push"


#define X_M_API_CONFIG              @"x-m-apiconfig"
#define X_M_API_CONFIG_V            @"x-m-apiconfig-v"
#define F_NW_BIZID                  @"f-nw-bizId"

/*!
 * API动态配置常量
 */
#define SPDY                @"spdy"
#define HTTP                @"http"

#define API_CONFIG_SPDY     @"spdy"
#define API_CONFIG_SSL      @"ssl"

//#define API_CONFIG_SEND_TYPE_HEADER  @"network-send-type"

/*!
 * 常量API名称
 */
#define C_API_NAME_GET_TIMESTAMP        "mtop.common.getTimestamp"
#define API_NAME_GET_TIMESTAMP          @"mtop.common.getTimestamp"
#define DEFAULT_API_VERSION             @"*"

#define API_NAME_NEW_DEVICE_ID          @"mtop.sys.newDeviceId"


/*!
 * 参数常量
 */
#define PARAMETER_RND                   @"rnd"
#define PARAMETER_WUA                   @"wua"


/*!
 *
 */
#define MAX_RETRY_COUNT                 1

#define MAX_LOGIN_PENDING_REQUEST       256


/**
 *  限流
 *
 */
#define kAvalancheLocalJSONString @"{\"api\":\"mtop.api.api\",\"v\":\"2.0\",\"ret\":[\"FAIL_LOCAL_ERROR_FANG_XUE_FENG::哎呦喂，被挤爆啦，请稍后重试\"],\"data\":{}}"

/*!
 * 防刷
 */
#define kAvalancheVerificationJSONString @"{\"api\":\"mtop.api.api\",\"v\":\"2.0\",\"ret\":[\"FAIL_LOCAL_ERROR_FANG_SHUO::请求太频繁，亲是机器人？\"],\"data\":{}}"


#define kFaileSystemErrorCode                @"小二很忙，系统很累，请稍后重试"

#define FAIL_LOCAL_ERROR_FANG_XUE_FENG       @"FAIL_LOCAL_ERROR_FANG_XUE_FENG"

#define DEFAULT_DISPATCH_VERSION             @"0.0"

#define MTOP_DISPATCH_CONFIGURATION          @"dispatch_config"

// 限流端上映射码
#define IOS_SYS_API_FLOW_LIMIT_LOCKED        @"IEC20000"
#define ERROR_CODE_FAILED_MAPPING            @"IEC30003"
#define FAIL_SYS_SESSION_EXPIRED_CODE        @"ES10003"
#define FAIL_SYS_ACCESS_TOKEN_EXPIRED        @"ES10041"


// Error类中属性Key值宏定义
#define ERROR_CODE_PROPERTY_CODE                    @"code"
#define ERROR_CODE_PROPERTY_MSG                     @"msg"
#define ERROR_CODE_PROPERTY_SUBCODE                 @"subCode"
#define ERROR_CODE_PROPERTY_SUBMSG                  @"subMsg"
#define ERROR_CODE_PROPERTY_MAPPINGCODE             @"mappingCode"
#define ERROR_CODE_PROPERTY_RESPONSESTATUSCODE      @"responseStatusCode"

#define ERROR_CODE_PROPERTY_ERRORCODE               @"errorCode"
#define ERROR_CODE_PROPERTY_SUBERRORCODE            @"subErrorCode"
#define ERROR_CODE_PROPERTY_ERRORMESSAGE            @"errorMessage"
#define ERROR_CODE_PROPERTY_SUBERRORMESSAGE         @"subErrorMessage"

#define k_MTOP_LOCAL_ERROR_CODE_NO_AUTH_MODEL       @"MTOP_LOCAL_ERROR_NO_AUTH_MODEL"
#define k_MTOP_LOCAL_ERROR_MSG_NO_AUTH_MODEL        @"没有找到授权模块"

#define k_MTOP_LOCAL_ERROR_CODE_NO_LOGIN_MODEL      @"MTOP_LOCAK_ERROR_NO_LOGIN_MODEL"
#define k_MTOP_LOCAL_ERROR_MSG_NO_LOGIN_MODEL       @"没有找到登录模块"

// MTOP错误DOMAIN
#define MTOPERROR_DOMAIN                            @"MTOPERROR"
#define MTOPBIZERROR_DOMAIN                         @"MTOPBIZERROR"

// MTOP错误DOMAINCODE
#define MTOPERROR_DOMAINCODE                        -900000
#define MTOPBIZERROR_DOMAINCODE                     -900001

// MTOPSDK底层文案
#define MTOP_NETWORK_ERROR                          @"网络竟然崩溃了"
#define MTOP_LIMIT_FLOW_ERROR                       @"前方拥挤，亲稍等再试试"
#define MTOP_SERVICE_ERROR                          @"服务竟然出错了"

// MTOP缓存配置宏定义
#define APPCACHECONFIG_VERSION                      @"appConfigVersion"

// 420 订单排队错误码
#define LIMITORDER_ERROR                             @"FAIL_SYS_REQUEST_QUEUED"
/*!
 * 服务类型
 *
 */
typedef enum {
    WJAS = 0,
    ASERVER
} ServerType;

#define SERVER_TIME_OFFSET_KEY                  @"server time date offset key in userDefaults"
#define DEVICEID_KEY                            @"devicdID key"
#define DEVICEID_VERSION_KEY                    @"devicdID version key"
#define DEVICEID_APP_KEY                        @"device app key"
#define kIsNotFist                              @"is newiphone"
#define kTBSDKNetworkSDKOldDeviceIdKey          @"kTBSDKNetworkSDKOldDeviceIdKey"
#define kTBSDKNetworkSDKDeviceIDChange          @"kTBSDKNetworkSDKDeviceIDChange"

#define TBNotificationXCommand              @"kXCommand"
#define TBNotificationXCommandN             @"kXCommandN"

#define k_MTOP_HEADER_LONGITUDE_DEFAULT_VALUE -10000

#define k_MTOP_HEADER_LATITUDE_DEFAULT_VALUE -10000

/**
 * MTOPSD内部引起的UI界面变化事件: 将要弹出霸下防刷解封界面
 */
#define MTOP_SECURITY_VERIFICATION_PAGE_WILL_DISPLAY    @"mtop_security_verfication_page_will_display"

/**
 * 当业务收到 MTOP_SECURITY_VERIFICATION_PAGE_WILL_DISPLAY 事件时，触发该事件的请求ID.
 * 该值等于  [MtopExRequest getRequestId]
 */
#define MTOP_SECURITY_VERIFICATION_REQUEST_ID           @"mtop_security_verfication_request_id"

/**
 * 当业务收到 MTOP_SECURITY_VERIFICATION_PAGE_WILL_DISPLAY 事件时，触发该事件的 api name.
 * 该值等于  [MtopExRequest getApiName]
 */
#define MTOP_SECURITY_VERIFICATION_REQUEST_API_NAME     @"mtop_security_verfication_request_api_name"

/**
 * 当业务收到 MTOP_SECURITY_VERIFICATION_PAGE_WILL_DISPLAY 事件时，触发该事件的 api version.
 * 该值等于  [MtopExRequest getApiVersion]
 */
#define MTOP_SECURITY_VERIFICATION_REQUEST_API_VERSION  @"mtop_security_verfication_request_api_version"


#endif
