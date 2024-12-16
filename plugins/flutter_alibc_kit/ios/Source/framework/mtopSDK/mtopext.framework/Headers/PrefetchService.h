//
//  PrefetchService.h
//  MtopCore
//
//  Created by daoche.jb on 2019/6/10.
//  Copyright © 2019 taobao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTopPrefetch.h"

@class MtopExtRequest;
@class MtopExtResponse;

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN dispatch_queue_t  mtop_request_completion_queue(void);

//预请求信息统一管理类
@interface PrefetchRequestInfo : NSObject

@property (nonatomic, copy) NSString *key;//md5(userId+apiName+/+apiVersion+param)
@property (nonatomic, copy) NSString *noParamKey;
@property (nonatomic, strong) MtopExtRequest *prefetchRequest;
@property (nonatomic, copy)   NSArray *excludedPrefetchKeyParameters;
@property (nonatomic, assign) NSTimeInterval beginTime;//response产生时间
@property (nonatomic, assign) NSTimeInterval expiredTime;
@property (nonatomic, strong) MtopExtResponse *response;//根据response是否存在判断当前请求状态
@property (nonatomic, strong) MtopExtRequest *mergeRequest;//匹配到的可合并的非预请求

- (BOOL)isResponseExpired;

@end

@interface PrefetchService : NSObject

@property (nonatomic, strong) NSRecursiveLock *prefetchLock;

+ (PrefetchService*)getInstance;

- (PrefetchRequestInfo *)getPrefetchRequestInfoWithRequest:(MtopExtRequest *)request;
- (void)addPrefetchRequestInfoWithRequest:(MtopExtRequest *)request;
- (void)removePrefetchRequestInfoWithRequest:(PrefetchRequestInfo *)requestInfo;

@end

NS_ASSUME_NONNULL_END
