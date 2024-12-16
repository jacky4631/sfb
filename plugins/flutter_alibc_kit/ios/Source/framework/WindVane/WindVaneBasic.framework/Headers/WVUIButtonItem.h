/*
 * WVUIButtonItem.h
 *
 * Created by WindVane.
 * Copyright (c) 2017年 阿里巴巴-淘宝技术部. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 表示一个按钮项。
 */
@interface WVUIButtonItem : NSObject

/**
 按钮项的标题。
 */
@property (nonatomic, copy, nullable) NSString * title;

/**
 直接使用按钮项的标题时，点击事件的回调。
 */
@property (nonatomic, copy, nullable) void (^callback)(void);

/**
 按钮项的自定义 View。
 */
@property (nonatomic, strong, nullable) UIView * customView;

/**
 与按钮项关联的参数。
 */
@property (nonatomic, strong, nullable) NSDictionary * params;

/**
 使用指定的标题和点击回调初始化。
 */
+ (WVUIButtonItem * _Nullable)itemWithTitle:(NSString * _Nonnull)title withCallback:(void (^_Nullable)(void))callback;

/**
 使用指定的自定义 View 初始化。
 */
+ (WVUIButtonItem * _Nullable)itemWithCustomView:(UIView * _Nonnull)customView;

@end
