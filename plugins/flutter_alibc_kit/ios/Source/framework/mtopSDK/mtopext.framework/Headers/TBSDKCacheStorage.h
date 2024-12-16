//
//  TBSDKCacheStorage.h
//  TBSDKNetworkSDK
//
//  Created by 石勇慧 on 14-7-23.
//  Modified by sihai on 2014-12-01
//  Copyright (c) 2014年 ZhuoLaiQiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBSDKConfiguration.h"

/*!
 *
 */
typedef void (^cache_callback_t)(NSString *, NSString *, bool);


@interface TBSDKCacheObject : NSObject<NSCoding>

@property (nonatomic, strong) NSString*			version;		// result
@property (nonatomic, strong) NSString*			lastModified;	// result
@property (nonatomic, strong) NSString*			eTag;			// result
@property (nonatomic, assign) int				maxAge;			// result
@property (nonatomic, assign) BOOL				offline;		// 控制是否能返回失效的cache数据
@property (nonatomic, strong) NSString*			header;			// result
@property (nonatomic, strong) NSString*			body;			// result
@property (nonatomic, assign) int               responseStatusCode;
@property (nonatomic, strong) NSString*         mtopXEtag;// result(自定义扩展etag类型缓存)
/*!
 * 判断cache是否失效
 */
- (BOOL) isExpired;

@end


@interface TBSDKCacheStorage : NSObject

+ (id)sharedInstance;

- (void) setConfig:(NSDictionary*) cacheDict;

- (void) addConfig:(NSDictionary*) dict;

- (NSArray *)getExcludeQueryListByKey:(NSString *)url;

- (bool)isCacheEnable:(NSString*) url;

- (id)getConfigByURL:(NSString *)url key:(NSString *)key;

/*!
 * 依据API Name 和 API Version 和指定的key 获取配置信息
 * @param apiName
 * @param apiVersion
 * @param key
 * @return
 *              配置值
 */
- (id) getConfigWithApiName: (NSString*) apiName apiVersion: (NSString*) apiVersion key: (NSString*) key;

- (NSString *)getBlock:(NSString*) url;

- (NSString *)getBlockByAPI:(NSString *)api ver:(NSString *)v;

/*!
 * 根据apiName + apiVersion获取cache区块
 * @param apiName
 * @param apiVersion
 * @return
 *                  cache区块名字
 *                  nil
 */
- (NSString*) getBlockByApiName: (NSString*) apiName apiVersion: (NSString*) apiVersion;

/*!
 * 保存cache数据
 * @param block     cache区块名称
 * @param key       cache key
 * @param value     cache 数据
 * @param callback  回调
 */
- (void) insert: (NSString*) block key: (NSString*) key value: (TBSDKCacheObject*) value callback: (cache_callback_t) callback;

/*!
 * 保存cache数据
 * @param block     cache区块名称
 * @param key       cache key
 * @param value     cache 数据
 */
- (bool) insert: (NSString *) block key: (NSString*) key value: (TBSDKCacheObject *) value;

/*!
 * 删除cache数据
 * @param block     cache区块名称
 * @param key       cache key
 * @param callback  回调
 */
- (void) delete: (NSString *) block key: (NSString *) key callback: (cache_callback_t) callback;

/*!
 * 删除整个block
 * @param block     cache区块名称
 * @param callback  回调
 */
- (void) delete: (NSString *) block callback: (cache_callback_t) callback;

/*!
 * 查询缓存
 * @param block     cache区块名称
 * @param key       cache key
 * @return          
 *                  TBSDKCacheObject        cache命中
 *                  nil                     cache没命中
 */
- (TBSDKCacheObject*) select: (NSString*) block key: (NSString*) key;

/*!
 * put value for key
 * @param block
 * @param key
 * @param value
 * @return
 *          true
 *          false
 */
- (bool) put: (NSString*) block key: (NSString*) key value: (NSData*) value;

/*!
 * get value for key
 * @param block
 * @param key
 * @return value for the key
 */
- (id) get: (NSString *) block key: (NSString*) key;


//下次启动清理cache
- (void)nextStartupCleanCache;

@end
