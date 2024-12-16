/*
 * WVAssert.h
 * 
 * Created by WindVane.
 * Copyright (c) 2017年 阿里巴巴-淘宝技术部. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <WindVaneCore/WVCommonUtil.h>

#define WVAssert(condition, ...)                                                       \
	do {                                                                               \
		if (WV_DEBUG && (condition) == 0) {                                            \
			[[NSAssertionHandler currentHandler] handleFailureInFunction:@(__func__)   \
			                                                        file:@(__FILE__)   \
			                                                  lineNumber:__LINE__      \
			                                                 description:__VA_ARGS__]; \
		}                                                                              \
	} while (false)

/**
 * 检查参数是否存在。
 */
#define WVAssertParam(name) WVAssert(name, @"Parameter '%s' is required", #name)

/**
 * 检查实例是否满足指定类型。
 */
#define WVAssertClass(variable, className) WVAssert([variable isKindOfClass:[className class]], \
    @"Variable '%s' is not a kind of '%s' class", #variable, #className)

/**
 * 检查实例是否满足指定类型。
 */
#define WVAssertProtocol(variable, protocolName) WVAssert([variable conformsToProtocol:@protocol(protocolName)], \
    @"Variable '%s' does not conform to protocol '%s'", #variable, #protocolName)

/**
 * 检查是否是在主线程。
 */
#define WVAssertMainThread() WVAssert([NSThread isMainThread], @"Must be called on the main thread")

/**
 * 检查是否为非空字符串。
 */
#define WVAssertNotEmptyString(str) WVAssert(str && str.length, @"Parameter '%s' is nil or empty string", #str)

/**
 * 检查是否不为 nil。
 */
#define WVAssertNotNil(variable) WVAssert(variable != nil, @"Parameter '%s' is nil", #variable)
