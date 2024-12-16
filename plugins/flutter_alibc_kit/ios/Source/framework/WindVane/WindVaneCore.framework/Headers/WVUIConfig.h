//
//  WVUIConfig.h
//  Core
//
//  Created by lianyu on 2019/7/12.
//  Copyright © 2019 WindVane. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 WindVane UI 配置项目。
 */
@interface WVUIConfig : NSObject

#pragma mark - ScrollIndicator

/**
 获取默认是否显示垂直滚动条指示器。
 */
+ (BOOL)showsVerticalScrollIndicator;

/**
 设置默认是否显示垂直滚动条指示器，默认为 YES。
 */
+ (void)setShowsVerticalScrollIndicator:(BOOL)showsVerticalScrollIndicator;

@end
