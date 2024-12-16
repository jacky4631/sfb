//
//  MtopExtResponse.h
//  mtopext
//
//  Created by sihai on 4/11/14.
//  Copyright (c) 2014 Taobao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MtopSDK/TBSDKRequest.h>
#import <mtopext/Constants.h>
#import <mtopext/MtopError.h>
#import <mtopext/MtopExtRequest.h>
#import <mtopext/TBSDKCacheStorage.h>

@interface MtopExtResponse : NSObject

@property(assign, nonatomic) int httpResponseCode;          // http 响应码
@property(strong, nonatomic) MtopError* error;                  // 错误信息

@property(strong, nonatomic) NSMutableDictionary* headers;  // http响应头
@property(strong, nonatomic) NSData* rawbody;               // 原始的http响应body
@property(strong, nonatomic) NSString* body;                // 原始的http响应body
@property(strong, nonatomic) NSDictionary* json;            // json响应，从http body 解析

@property(assign, nonatomic) BOOL isFromCache;              // 响应是否来至cache
@property(assign, nonatomic) BOOL isCacheExpired;           // cache是否失效了

@property(strong, nonatomic) MtopExtRequest* request;       // 响应对应的API Request

// 为问题排查准备的
@property(strong, nonatomic) NSURL* requestURL;             // 底层发出去的URL
@property(strong, nonatomic) NSString* requestMethod;       // 底层http 请求方法
@property(strong, nonatomic) NSDictionary* requestHeaders;  // 底层发出去的http headers
@property(strong, nonatomic) NSData* requestBody;           // 底层发出去的http body
@property(assign, nonatomic) BOOL isLoginCancel;



/*!
 * 初始化一个API响应
 * @param httpResponseCode  http响应码
 * @param headers           http响应头
 * @param rawbody           http原始body
 * @param isFromCache       是否来自cache
 * @param request           对应的request
 * @return
 *              MtopExtResponse
 */
- (MtopExtResponse*) initWithHttp: (int) httpResponseCode headers: (NSDictionary*) headers rawbody: (NSData*) rawbody isFromCache: (BOOL) isFromCache request: (MtopExtRequest*) request;

/*!
 * 初始化一个API响应
 * @param request           底层mtop请求
 * @param erequest          对应的request
 * @return
 *              MtopExtResponse
 */
- (MtopExtResponse*) initWithRequest: (TBSDKRequest*) request erequest: (MtopExtRequest*) erequest;

/*!
 * 初始化一个API响应
 * @param error
 * @param request           对应的request
 * @return
 *              MtopExtResponse
 */
- (MtopExtResponse*) initWithError: (MtopError*) error request: (MtopExtRequest*) request;

/*!
 * 使用cache object 初始化一个API响应
 * @param co
 * @param request           对应的request
 * @return
 *              MtopExtResponse
 */
 - (MtopExtResponse*) initWithCacheObject: (TBSDKCacheObject*) co request: (MtopExtRequest*) request;

/*!
 * 将另外一个MtopExtResponse的属性复制到本MtopExtResponse
 * @param response
 * @param request           对应的request
 */
- (void) fillWithOther: (MtopExtResponse*) response;

/*!
 * 判断响应是否成功
 * @return
 *          YES     成功
 *          NO      失败
 */
- (BOOL) isSucceed;

@end
