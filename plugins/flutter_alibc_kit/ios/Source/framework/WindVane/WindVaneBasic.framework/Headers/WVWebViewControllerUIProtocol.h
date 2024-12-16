/*
 * WVWebViewControllerUIProtocol.h
 *
 * Created by WindVane.
 * Copyright (c) 2017年 阿里巴巴-淘宝技术部. All rights reserved.
 */

#import "WVUIButtonItem.h"
#import <Foundation/Foundation.h>
#import <WindVaneCore/WindVaneCore.h>

/**
 表示 WebView ViewController UI 协议，通过该协议中的方法，实现 UI 相关的 JSBridge。
 */
@protocol WVWebViewControllerUIProtocol <NSObject>

@optional

#pragma mark - Status Bar

/**
 状态栏的样式，默认不对状态栏样式做变更。
 */
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;

#pragma mark - Title

/**
 是否允许 H5 title 发生变更后是否更新导航栏的标题，默认为 YES。
 不受 allowsControlNavigationBar 的影响。
 */
@property (nonatomic, assign, getter=isAutoLoadTitle) BOOL autoLoadTitle;

/**
 导航栏的标题项，注意标题默认不支持为文本标题设置点击回调，默认为 nil。
 */
@property (nonatomic, strong, nullable) WVUIButtonItem * navigationBarTitleItem;

#pragma mark - Navigation Bar

/**
 是否允许 H5 操纵导航栏，默认为 YES。
 请在创建 WebView 之前完成设置。
 包括通过 JSBridge 或 meta 设置隐藏、透明等功能，但标题不受影响（仅由 autoLoadTitle 控制）。
 */
@property (nonatomic, assign) BOOL allowsControlNavigationBar;

/**
 是否允许通过手势关闭当前 ViewController，默认为 WVTristateNotSure，表示未设置。
 */
@property (nonatomic, assign) WVTristate allowsNavigationGestures;

/**
 导航栏是否被隐藏，默认为 WVTristateNotSure，表示未设置。
 */
@property(nonatomic, assign, getter=isNavigationBarHidden) WVTristate navigationBarHidden;

/**
 设置导航栏是否被隐藏。
 
 @param navigationBarHidden 是否隐藏导航栏，使用 WVTristateNotSure 表示恢复客户端默认值。
 */
- (void)setNavigationBarHidden:(WVTristate)navigationBarHidden animated:(BOOL)animated;

/**
 导航栏的右侧按钮，默认为 nil。
 */
@property (nonatomic, copy, nullable) NSArray<WVUIButtonItem *> * navigationBarRightItems;

/**
 导航栏的前景色，默认为 nil，表示不设置。
 */
@property (nonatomic, strong, nullable) UIColor * navigationBarForegroundColor;

/**
 导航栏的背景色，默认为 nil，表示不设置。
 如果希望指定透明背景，请设置为 [UIColor wvTransparentColor]。
 */
@property (nonatomic, strong, nullable) UIColor * navigationBarBackgroundColor;

#pragma mark - LoadingBox

/**
 显示加载框。
 */
- (void)showLoadingBox;

/**
 隐藏加载框。
 */
- (void)hiddenLoadingBox;

#pragma mark - Navigation

/**
 关闭当前 ViewController。
 
 @param historyBack 是否优先回退历史记录。
 @param data        要传递给前一个 WebView 的数据。
 
 @return 是否关闭了当前 ViewController。在回退了历史记录，或当前 ViewController 不在 NavigationController 的最顶层时返回 NO。
 */
- (BOOL)pop:(BOOL)historyBack withData:(id _Nullable)data;

@end
