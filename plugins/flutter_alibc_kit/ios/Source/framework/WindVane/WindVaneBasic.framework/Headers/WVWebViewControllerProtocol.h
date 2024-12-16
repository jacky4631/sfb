/*
 * WVWebViewControllerProtocol.h
 *
 * Created by WindVane.
 * Copyright (c) 2017年 阿里巴巴-淘宝技术部. All rights reserved.
 */

#import "WVViewControllerProtocol.h"
#import "WVWebViewControllerUIProtocol.h"
#import "WVWebViewToolbar.h"
#import <Foundation/Foundation.h>

/**
 * 表示基本的 WindVane WebView ViewController 协议，包含 ViewController 额外提供的功能。
 */
@protocol WVWebViewControllerProtocol <WVViewControllerProtocol, WVWebViewControllerUIProtocol>

#pragma mark - WebView

/**
 * 需要在 viewDidLoad 时自动加载的页面请求，会与 loadUrl 同步变化。
 */
@property (nonatomic, copy, nullable) NSURLRequest * loadRequest;

/**
 * 需要在 viewDidLoad 时自动加载的页面地址，会与 loadRequest 同步变化。
 */
@property (nonatomic, copy, nullable) NSString * loadUrl;

/**
 * 自定义导航栏高度 - 用于计算 WebView 高度。
 */
@property (nonatomic, assign) CGFloat navBarHeight;

/**
 * 自定义 TabBar 高度 - 用于计算 WebView 高度。
 */
@property (nonatomic, assign) CGFloat tabBarHeight;

#pragma mark - Status Bar

/**
 隐藏导航栏时，Status Bar 背景的颜色，默认为 nil。
 
 @discussion iOS 7 的 Status Bar 在导航栏隐藏的时候会背景透明，与 WebView 中的内容遮盖。
 如果希望为 Status Bar 添加一个不透明背景，可以设置此属性为需要的颜色。
 自 iOS11 后，iPhoneX 的机型状态栏高度变为 44pt，不再适合自动设置状态栏高度，应当由前端主动填充合适的背景，让状态栏与背景融合起来。
 */
@property (nonatomic, strong, nullable) UIColor * statusBarColor NS_DEPRECATED_IOS(7_0, 10_0);

/**
 [iOS 7 适配] 隐藏导航栏时，为 Status Bar 添加白色背景颜色。
 
 @discussion 自 iOS11 后，iPhoneX 的机型状态栏高度变为 44pt，不再适合自动设置状态栏高度，应当由前端主动填充合适的背景，让状态栏与背景融合起来。
 */
- (void)supportiOS7WithoutStatusBar NS_DEPRECATED_IOS(7_0, 10_0);

#pragma mark - Toolbar

/**
 * 是否使用带有前进、后退、刷新、停止基本浏览器功能的默认工具栏，默认为 NO。
 */
@property (nonatomic, assign, getter=isUseToolbar) BOOL useToolbar;

/**
 * 工具栏。
 */
@property (nonatomic, strong, readonly, nullable) WVWebViewToolbar * toolbar;

/**
 * 工具栏的高度，默认为 40px。
 */
@property (nonatomic, assign) CGFloat toolbarHeight;

/**
 * 是否动态显示工具栏。
 */
@property (nonatomic, assign) BOOL showToolBarDynamic;

/**
 * 是否仅在发生错误的时候，才使用工具栏，无错误发生的时候，一直隐藏起来。
 * 仅在 useToolbar=YES 时候生效。
 */
@property (nonatomic, assign, getter=isUseToolbarOnlyError) BOOL useToolbarOnlyError;

/**
 * 隐藏默认的工具栏。
 */
- (void)hiddenToolBar;

/**
 * 显示默认的工具栏。
 */
- (void)showToolBar;

/**
 * 如果需要提供自己的工具栏，请设置 useToolbar=NO，然后自行提供工具栏，并设置以下的属性。
 * 会自动根据当前 WebView 状态，设置按钮的 enabled。
 */
/**
 * 自定义的回退按钮。
 */
@property (nonatomic, weak, nullable) id customToolBarGoBackButton;

/**
 * 自定义的前进按钮。
 */
@property (nonatomic, weak, nullable) id customToolBarGoForwardButton;

/**
 * 自定义的停止按钮。
 */
@property (nonatomic, weak, nullable) id customToolBarStopLoadingButton;

/**
 * 自定义的刷新按钮。
 */
@property (nonatomic, weak, nullable) id customToolBarRefreshButton;

#pragma mark - 定制加载框

/**
 * 是否显示加载框，默认为 YES。
 * 可以设置为 NO 不显示加载框，此时可以使用 KVO 监听 WebView.estimatedProgress 的改变，实现加载进度。
 */
@property (nonatomic, assign, getter=isShowLoadingBox) BOOL showLoadingBox;

/**
 * 使用指定的标题显示加载框。
 * 允许由子类重写以自定义加载框。
 */
- (void)showLoadingBoxWithTitle:(NSString * _Nullable)title;

#pragma mark - 设备旋转

/**
 * 支持的设备旋转方向。
 * 设置为 0 会使用系统默认的设备旋转方向，客户端可能需要自行重写设置方法，才能实现完整的转屏适配。
 */
@property (nonatomic, assign) UIInterfaceOrientationMask interfaceOrientationMask;

/**
 * 首选的设备旋转方向。
 */
@property (nonatomic, assign) UIInterfaceOrientation preferredInterfaceOrientation;

@end
