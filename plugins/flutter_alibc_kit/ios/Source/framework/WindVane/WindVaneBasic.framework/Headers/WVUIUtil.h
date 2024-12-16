/*
 * WVUIUtil.h
 *
 * Created by WindVane.
 * Copyright (c) 2017年 阿里巴巴-淘宝技术部. All rights reserved.
 */

#import "WVUIButtonItem.h"
#import "WVUIIconFontServiceProtocol.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 包含与 UI 相关的实用方法。
 */
@interface WVUIUtil : NSObject

#pragma mark - IconFont

/**
 获取已注册的 IconFont 服务。
 */
+ (id<WVUIIconFontServiceProtocol> _Nullable)registeredIconFontService;

/**
 获取已注册的 IconFont 服务。
 */
+ (void)registerIconFontService:(id<WVUIIconFontServiceProtocol> _Nullable)iconFontService;

/**
 返回指定尺寸的 IconFont 图片。

 @param text IconFont 的文本，如果 iconFontService 支持名称翻译，则会额外尝试将文本作为名称翻译。
 @param size 图片的尺寸。
 @param color 图片的前景色。
 @return IconFont 图片。
 */
+ (UIImage * _Nullable)imageWithIconFontText:(NSString * _Nonnull)text size:(CGFloat)size color:(UIColor * _Nonnull)color;

#pragma mark - WVUIButtonItem

/**
 使用指定的参数创建按钮项。
 
 @param params    按钮项的配置
 @param maxHeight 按钮项的最大高度
 @param callback  点击事件的回调
 */
+ (WVUIButtonItem * _Nullable)createNavigationBarItem:(NSDictionary * _Nullable)params maxHeight:(CGFloat)maxHeight callback:(void(^ _Nullable)(void))callback;

/**
 压缩图片至合适的大小。
 */
+ (UIImage * _Nullable)scaleImage:(UIImage * _Nonnull)image maxHeight:(CGFloat)maxHeight;

@end
