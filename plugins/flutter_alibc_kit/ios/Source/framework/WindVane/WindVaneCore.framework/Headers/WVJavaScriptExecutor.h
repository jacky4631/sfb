/*
 * WVJavaScriptExecutor.h
 * 
 * Created by WindVane.
 * Copyright (c) 2017年 阿里巴巴-淘宝技术部. All rights reserved.
 */

#import <Foundation/Foundation.h>

/**
 * 允许执行 JavaScript 字符串的协议。
 */
@protocol WVJavaScriptExecutor <NSObject>

/**
 * 执行 JavaScript 字符串，并在执行完毕后调用指定的回调。
 * 允许在任意线程调用，并总是在主线程回调。
 */
- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id, NSError *))completionHandler;

@end
