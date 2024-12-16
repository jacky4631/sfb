/*
 * UIColor+WVUtility.h
 * 
 * Created by WindVane.
 * Copyright (c) 2017年 阿里巴巴-淘宝技术部. All rights reserved.
 */

#import <UIKit/UIKit.h>

/**
 * 提供 UIColor 类的扩展方法。
 */
@interface UIColor (WVUtility)

/**
 使用指定的十六进制颜色初始化 UIColor。
 */
+ (UIColor * _Nonnull)wvColorWithHex:(NSInteger)hexValue;

/**
 使用指定的十六进制颜色和透明度初始化 UIColor。
 */
+ (UIColor * _Nonnull)wvColorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;

/**
 使用指定的十六进制颜色字符串初始化 UIColor。
 */
+ (UIColor * _Nullable)wvColorWithHexString:(NSString * _Nonnull)hexString;

/**
 表示透明色。
 */
+ (UIColor * _Nonnull)wvTransparentColor;

/**
 返回当前颜色的十六进制颜色字符串（RRGGBB，不包含前导字符）。
 */
- (NSString * _Nullable)wvHexString;

@end
