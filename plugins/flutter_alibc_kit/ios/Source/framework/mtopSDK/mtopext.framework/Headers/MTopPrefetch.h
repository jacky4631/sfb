//
//  MTopPrefetch.h
//  MtopCore
//
//  Created by daoche.jb on 2019/7/12.
//  Copyright © 2019 taobao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger,PrefetchHitType) {
    PrefetchHit_ValidCache,//命中，走prefetch缓存
    PrefetchHit_MergeRequest,//prefetch请求未完成，走合并请求
    PrefetchHit_CacheInvalid,//未命中，prefetch有缓存但过期了或是失败的缓存，自行请求
    PrefetchHit_MergeRequestErrorByOther,//prefetch请求未完成，走合并请求，但被别的请求强行合并了，自行请求
    PrefetchHit_PrefetchOverLimit,//prefetch请求超限被删除
    PrefetchHit_BackGroudCheckExpired//切后台检查发现过期
};

NS_ASSUME_NONNULL_BEGIN

@interface MTopPrefetch : NSObject

@property(assign, nonatomic) NSTimeInterval prefetchTimeout;//prefetch请求超时时间,默认5000ms
@property(copy, nonatomic)  void(^prefetchHitCallback)(PrefetchHitType hitType);//被预取时的回调
@property(copy, nonatomic) NSArray* excludedPrefetchKeyParameters;//判断请求是否相同时的参数排除名单

@end

NS_ASSUME_NONNULL_END
