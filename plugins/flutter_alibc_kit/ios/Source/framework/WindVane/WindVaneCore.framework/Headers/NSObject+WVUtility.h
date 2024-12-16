/*
 * NSObject+WVUtility.h
 * 
 * Created by WindVane.
 * Copyright (c) 2017年 阿里巴巴-淘宝技术部. All rights reserved.
 */

#import <Foundation/Foundation.h>

/**
 * 提供 NSObject 类的扩展方法。
 */
@interface NSObject (WVUtility)

#pragma mark - Invoke

/**
 * 尝试调用指定方法，并得到返回值。
 *
 * @param selector 要调用的方法。
 *
 * @return 方法调用的返回值。
 */
- (id)wvInvoke:(SEL)selector;

/**
 * 尝试调用指定方法，并得到返回值。
 *
 * @param selector 要调用的方法。
 * @param object   方法的参数。
 *
 * @return 方法调用的返回值。
 */
- (id)wvInvoke:(SEL)selector withObject:(id)object;

/**
 * 尝试调用指定方法，并得到返回值。
 *
 * @param selector 要调用的方法。
 * @param object1  方法的第一个参数。
 * @param object2  方法的第二个参数。
 *
 * @return 方法调用的返回值。
 */
- (id)wvInvoke:(SEL)selector withObject:(id)object1 withObject:(id)object2;

/**
 * 尝试调用指定方法，并得到返回值。
 *
 * @param selector 要调用的方法。
 * @param object1  方法的第一个参数。
 * @param object2  方法的第二个参数。
 * @param object3  方法的第三个参数。
 *
 * @return 方法调用的返回值。
 */
- (id)wvInvoke:(SEL)selector withObject:(id)object1 withObject:(id)object2 withObject:(id)object3;

/**
 * 尝试调用指定方法，并得到返回值。
 *
 * @param selector 要调用的方法。
 * @param object1  方法的第一个参数。
 * @param object2  方法的第二个参数。
 * @param object3  方法的第三个参数。
 * @param object4  方法的第四个参数。
 *
 * @return 方法调用的返回值。
 */
- (id)wvInvoke:(SEL)selector withObject:(id)object1 withObject:(id)object2 withObject:(id)object3 withObject:(id)object4;

/**
 * 尝试调用指定方法，并得到返回值。
 *
 * @param selector 要调用的方法。
 *
 * @return 方法调用的返回值。
 */
- (BOOL)wvInvokeWithBOOLResult:(SEL)selector;

/**
 * 尝试调用指定方法，并得到返回值。
 *
 * @param selector 要调用的方法。
 *
 * @return 方法调用的返回值。
 */
- (NSInteger)wvInvokeWithIntegerResult:(SEL)selector;

#pragma mark - TryInvoke

/**
 * 尝试调用指定方法。
 *
 * @param selector 要调用的方法。
 *
 * @return 如果调用成功，则为 YES；否则为 NO。
 */
- (BOOL)wvTryInvoke:(SEL)selector;

/**
 * 尝试调用指定方法，并得到返回值。
 *
 * @param selector 要调用的方法。
 * @param result   方法的返回值。
 *
 * @return 如果调用成功，则为 YES；否则为 NO。
 */
- (BOOL)wvTryInvoke:(SEL)selector withResult:(id *)result;

/**
 * 尝试调用指定方法，并得到返回值。
 *
 * @param selector 要调用的方法。
 * @param result   方法的返回值。
 *
 * @return 如果调用成功，则为 YES；否则为 NO。
 */
- (BOOL)wvTryInvoke:(SEL)selector withBOOLResult:(BOOL *)result;

/**
 * 尝试调用指定方法。
 *
 * @param selector 要调用的方法。
 * @param object   方法的参数。
 *
 * @return 如果调用成功，则为 YES；否则为 NO。
 */
- (BOOL)wvTryInvoke:(SEL)selector withObject:(id)object;

/**
 * 尝试调用指定方法。
 *
 * @param selector 要调用的方法。
 * @param value    方法的 BOOL 参数。
 *
 * @return 如果调用成功，则为 YES；否则为 NO。
 */
- (BOOL)wvTryInvoke:(SEL)selector withBOOL:(BOOL)value;

/**
 * 尝试调用指定方法。
 *
 * @param selector 要调用的方法。
 * @param value    方法的 int 参数。
 *
 * @return 如果调用成功，则为 YES；否则为 NO。
 */
- (BOOL)wvTryInvoke:(SEL)selector withInt:(int)value;

/**
 * 尝试调用指定方法，并得到返回值。
 *
 * @param selector 要调用的方法。
 * @param object   方法的参数。
 * @param result   方法的返回值。
 *
 * @return 如果调用成功，则为 YES；否则为 NO。
 */
- (BOOL)wvTryInvoke:(SEL)selector withObject:(id)object withBOOLResult:(BOOL *)result;

/**
 * 尝试调用指定方法。
 *
 * @param selector 要调用的方法。
 * @param object1  方法的第一个参数。
 * @param object2  方法的第二个参数。
 *
 * @return 如果调用成功，则为 YES；否则为 NO。
 */
- (BOOL)wvTryInvoke:(SEL)selector withObject:(id)object1 withObject:(id)object2;

/**
 * 尝试调用指定方法。
 *
 * @param selector 要调用的方法。
 * @param object1  方法的第一个参数。
 * @param object2  方法的第二个参数。
 * @param object3  方法的第三个参数。
 *
 * @return 如果调用成功，则为 YES；否则为 NO。
 */
- (BOOL)wvTryInvoke:(SEL)selector withObject:(id)object1 withObject:(id)object2 withObject:(id)object3;

#pragma mark - Swizzle

/**
 * Sizzle 指定的实例方法。
 *
 * @param originalSelector 要 Swizzle 的原始方法。
 * @param swizzledSelector Swizzle 后的新方法。
 *
 * @return Sizzle 是否成功。
 */
+ (BOOL)wvSwizzleMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector;

/**
 * Sizzle 指定的实例方法。
 *
 * @param originalSelector 要 Swizzle 的原始方法。
 * @param swizzledClass    Swizzle 后的新方法所在的类。
 * @param swizzledSelector Swizzle 后的新方法。
 *
 * @return Sizzle 是否成功。
 */
+ (BOOL)wvSwizzleMethod:(SEL)originalSelector withClass:(Class)swizzledClass withMethod:(SEL)swizzledSelector;

/**
 * Sizzle 指定的类方法。
 *
 * @param originalSelector 要 Swizzle 的原始方法。
 * @param swizzledSelector Swizzle 后的新方法。
 *
 * @return Sizzle 是否成功。
 */
+ (BOOL)wvSwizzleClassMethod:(SEL)originalSelector withClassMethod:(SEL)swizzledSelector;

/**
 * Sizzle 指定的类方法。
 *
 * @param originalSelector 要 Swizzle 的原始方法。
 * @param swizzledClass    Swizzle 后的新方法所在的类。
 * @param swizzledSelector Swizzle 后的新方法。
 *
 * @return Sizzle 是否成功。
 */
+ (BOOL)wvSwizzleClassMethod:(SEL)originalSelector withClass:(Class)swizzledClass withClassMethod:(SEL)swizzledSelector;

@end
