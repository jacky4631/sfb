/*
 * WVNotiBar.h
 * 
 * Created by WindVane.
 * Copyright (c) 2017年 阿里巴巴-淘宝技术部. All rights reserved.
 */

#import <UIKit/UIKit.h>

/**
 * 从顶部滑出的通知栏。
 */
@interface WVNotiBar : UIControl

/**
 * 显示通知栏。
 */
+ (void)showNotiBar:(NSString *)text inView:(UIView *)view;

/**
 * 显示通知栏。
 */
+ (void)showNotiBar:(NSString *)text image:(UIImage *)image inView:(UIView *)view;

/**
 * 显示通知栏。
 */
+ (void)showNotiBar:(NSString *)text image:(UIImage *)image height:(CGFloat)height duration:(NSUInteger)duration inView:(UIView *)view target:(id)target action:(SEL)action;

/**
 * 通知栏的图标。
 */
@property (nonatomic, strong, readonly) UIImageView * imageView;

/**
 * 通知栏的文本。
 */
@property (nonatomic, strong, readonly) UILabel * textLabel;

/**
 * 文本颜色。
 */
@property (nonatomic, strong) UIColor * textColor;

/**
 * 提示文本。
 */
@property (nonatomic, copy) NSString * text;

/**
 * 弹出动画的持续时间。
 */
@property (nonatomic, assign) NSTimeInterval animationDuration;

/**
 * 通知栏展示的持续时间。
 */
@property (nonatomic, assign) NSTimeInterval displayDuration;

/**
 * 展示通知栏。
 */
- (void)show;

/**
 * 隐藏通知栏，隐藏后自动从父 View 移除。
 */
- (void)hide;

@end
