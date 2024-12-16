/*
 * NSMutableArray+WVUtility.h
 * 
 * Created by WindVane.
 * Copyright (c) 2017年 阿里巴巴-淘宝技术部. All rights reserved.
 */

#import <Foundation/Foundation.h>

/**
 * 包含 NSMutableArray 的扩展方法。
 */
@interface NSMutableArray (WVUtility)

/**
 将指定可能为空的元素添加到数组中。

 @param value 可为空的元素。
 */
- (void)wvAddNullable:(id _Nullable)value;

@end
