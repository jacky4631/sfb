/*
 * WVUIIconFontServiceProtocol.h
 *
 * Created by WindVane.
 * Copyright (c) 2018年 阿里巴巴-淘宝技术部. All rights reserved.
 */

#import <UIKit/UIKit.h>

/**
 表示 IconFont 的服务接口。
 */
@protocol WVUIIconFontServiceProtocol <NSObject>

@required

/**
 返回指定尺寸的 IconFont 字体。
 */
- (UIFont * _Nonnull)iconFontOfSize:(CGFloat)fontSize;

@optional

/**
 返回与指定 IconFont 名称对应的 Unicode 文本。
 
 @param name IconFont 名称。
 @return 相应的 Unicode 文本。
 */
- (NSString * _Nullable)iconFontUnicodeWithName:(NSString * _Nonnull)name;

@end
