//
//  AlibcTradeTaskManager.h
//  AlibcTradeSDK
//
//  Created by zhongweitao on 2020/9/10.
//  Copyright © 2020 com.alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlibcTradeTaskManager : NSObject

+ (instancetype)sharedInstance;

/**
 * 获取激励任务，传taskId返回具体任务详情，不传返回任务列表
 *
 * @param pid          淘客ID
 * @param taskId       任务ID,可选参数,传taskId返回具体任务详情，不传返回任务列表
 * @param extParams    扩展参数,可选参数
*/
- (void)getInteractiveTask:(NSString *__nonnull)pid
                    taskId:(nullable NSString *)taskId
                 extParams:(nullable NSDictionary *)extParams
                   success:(nullable void (^)(id __nullable result))onSuccess
                    failed:(nullable void (^)(NSError *__nullable error))onFailure;

@end

NS_ASSUME_NONNULL_END
