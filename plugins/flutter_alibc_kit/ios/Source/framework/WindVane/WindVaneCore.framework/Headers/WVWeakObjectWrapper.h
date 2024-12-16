/*
 * WVWeakObjectWrapper.h
 * 
 * Created by WindVane.
 * Copyright (c) 2017年 阿里巴巴-淘宝技术部. All rights reserved.
 */

#import <Foundation/Foundation.h>

/**
 * 弱引用的包装类，并支持方法转发。
 */
@interface WVWeakObjectWrapper<ObjectType> : NSProxy

/**
 * 被弱引用的对象。
 */
@property (nonatomic, weak, readonly) ObjectType weakObject;

/**
 * 包装指定的弱引用对象。
 */
+ (WVWeakObjectWrapper<ObjectType> *)wrapWeakObject:(ObjectType)weakObject;

/**
 * 使用指定的弱引用对象初始化。
 */
- (instancetype)initWithWeakObject:(ObjectType)weakObject;

@end
