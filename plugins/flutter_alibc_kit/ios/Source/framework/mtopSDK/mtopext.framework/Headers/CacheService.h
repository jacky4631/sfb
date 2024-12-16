//
//  CacheService.h
//  mtopext
//
//  Created by sihai on 26/11/14.
//  Copyright (c) 2014 Taobao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TBSDKCacheStorage.h"
#import "MtopExtRequest.h"
#import "MtopExtResponse.h"

@interface CacheService : NSObject

/*!
 * 获取单例
 * @return CacheService
 */
+ (CacheService*) getInstance;

/*!
 * 查询cache, 直接返回MtopExtResponse (会判断当前API+V是否配置了缓存)
 * @param request
 * @return
 *                  nil                 cache 没命中
 *                  MtopExtResponse     命中cache
 */
- (MtopExtResponse*) getResponseWithRequest: (MtopExtRequest*) request;

/*!
 * 查询限流的cache响应
 * @param request
 * @return
 *                  nil                 cache中没有
 *                  MtopExtResponse     cache中有
 */
//- (MtopExtResponse*) getThresholdResponseWithRequest: (MtopExtRequest*) request;

/*!
 * 查询cache
 * @param request       Mtop请求
 * @return
 *                  nil                 cache 没命中
 *                  TBSDKCacheObject    命中cache
 */
- (TBSDKCacheObject*) getWithRequest: (MtopExtRequest*) request;

/*!
 * 缓存cache
 * @param response      Mtop响应
 */
- (void) cacheWithResponse: (MtopExtResponse*) response;

/*!
 * 删除指定request的缓存
 * @param request
 */
- (void) clearCacheWithRequest: (MtopExtRequest*) request;

@end
