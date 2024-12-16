//
//  WVUIWebViewController+CustomizeUI.h
//  Basic
//
//  Created by lianyu.ysj on 2018/1/31.
//  Copyright © 2018年 WindVane. All rights reserved.
//

#import "WVUIButtonItem.h"
#import "WVUIWebViewController.h"
#import <UIKit/UIKit.h>

@interface WVUIWebViewController (CustomizeUI)

/**
 更新导航栏的标题项，可以自行覆盖以提供定制化的逻辑。
 
 @param navigationBarTitleItem 导航栏的标题项，nil 表示需要重置标题。
 */
- (void)updateNavigationBarTitleItem:(WVUIButtonItem * _Nullable)navigationBarTitleItem;

/**
 设置是否允许通过手势关闭当前 ViewController，可以自行覆盖以提供定制化的逻辑。
 
 @param allowsNavigationGestures 是否允许通过手势关闭当前 ViewController，使用 WVTristateNotSure 表示恢复默认值。
 */
- (void)updateAllowsNavigationGestures:(WVTristate)allowsNavigationGestures;

/**
 设置导航栏是否被隐藏，可以自行覆盖以提供定制化的逻辑。
 */
- (void)updateNavigationBarHidden:(WVTristate)navigationBarHidden animated:(BOOL)animated;

/**
 更新导航栏的右侧按钮项，可以自行覆盖以提供定制化的逻辑。
 */
- (void)updateNavigationBarRightItems:(NSArray<WVUIButtonItem *> * _Nullable)rightItems;

/**
 从指定的 WVUIButtonItem 创建 UIBarButtonItem 实例。
 */
- (UIBarButtonItem * _Nullable)createBarButtonItem:(WVUIButtonItem * _Nonnull)buttonItem;

@end
