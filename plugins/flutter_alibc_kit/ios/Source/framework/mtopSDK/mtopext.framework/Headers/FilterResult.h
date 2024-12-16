//
//  FilterResult.h
//  mtopext
//
//  Created by sihai on 12/12/14.
//  Copyright (c) 2014 taobao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MtopExtResponse.h"

/*!
 * Filter执行后应该采取的动作
 */
typedef NS_ENUM(NSUInteger,FilterResultAction) {
    CONTINUE                = 0,                // 继续
    STOP                    = 1,                // 停止
    CALLBACK_THEN_REQUEST   = 2,                // 回调, 然后发起请求, 比如异步有cache命中, 先回调, 然后再发起网络请求
};

@interface FilterResult : NSObject

@property(assign, nonatomic) FilterResultAction action;         // 后续需要执行的动作
@property(strong, nonatomic) MtopExtResponse* response;         // 请求的响应, 可能来自cache

@end
