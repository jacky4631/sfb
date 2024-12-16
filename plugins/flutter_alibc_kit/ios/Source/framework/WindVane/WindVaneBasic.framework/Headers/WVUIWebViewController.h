/*
 * WVUIWebViewController.h
 *
 * Created by WindVane.
 * Copyright (c) 2017年 阿里巴巴-淘宝技术部. All rights reserved.
 */

#import "WVRuleWebViewController.h"
#import "WVUIButtonItem.h"
#import "WVWebViewControllerProtocol.h"
#import <UIKit/UIKit.h>

#pragma mark - Constant

// 错误页面背景图片名称。
#define WVUIVC_ERROR_BACKGROUND_IMG @"WindVaneResource.bundle/wifi"
// WebView 背景图片名称。
#define WVUIVC_BACKGROUND_IMG @"WindVaneResource.bundle/all_bg_small"
// 顶部下拉刷新箭头图片名称。
#define WVUIVC_ARROW_IMG @"WindVaneResource.bundle/upload1"
// 工具栏最左边第一个返回按钮图片名称。
#define WVUIVC_TOOLBAR_POP_IMG @"WindVaneResource.bundle/toolbar_webview_back"
// 工具栏后退按钮图片名称。
#define WVUIVC_TOOLBAR_BACK_IMG @"WindVaneResource.bundle/toolbar_webview_pre"
// 工具栏前进按钮图片名称。
#define WVUIVC_TOOLBAR_NEXT_IMG @"WindVaneResource.bundle/toolbar_webview_next"
// 工具栏停止按钮图片名称。
#define WVUIVC_TOOLBAR_STOP_IMG @"WindVaneResource.bundle/toolbar_webview_stop"
// 工具栏刷新按钮图片名称。
#define WVUIVC_TOOLBAR_REFRESH_IMG @"WindVaneResource.bundle/toolbar_webview_refresh"
// 工具栏背景图片名称。
#define WVUIVC_TOOLBAR_BACKGROUND_IMG @"WindVaneResource.bundle/toolbar_webview_background"

#pragma mark - WVUIWebViewController

/**
 * 提供了 WindVane WebView UI 扩展的 ViewController。
 */
@interface WVUIWebViewController : WVRuleWebViewController <WVWebViewControllerProtocol>

#pragma mark - WebView

/**
 * 自定义 TabBar 高度 - 用于计算 WebView 高度。
 */
@property (nonatomic, assign) CGFloat tabBarHeight;

#pragma mark - Status Bar

/**
 状态栏的样式，默认不对状态栏样式做变更。
 */
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;

/**
 隐藏导航栏时，Status Bar 背景的颜色，默认为 nil。
 
 @discussion iOS 7 的 Status Bar 在导航栏隐藏的时候会背景透明，与 WebView 中的内容遮盖。
 如果希望为 Status Bar 添加一个不透明背景，可以设置此属性为需要的颜色。
 自 iOS11 后，iPhoneX 的机型状态栏高度变为 44pt，不再适合自动设置状态栏颜色，应当由前端主动填充合适的背景，让状态栏与背景融合起来。
 */
@property (nonatomic, strong, nullable) UIColor * statusBarColor NS_DEPRECATED_IOS(7_0, 10_0);

/**
 [iOS 7 适配] 隐藏导航栏时，为 Status Bar 添加白色背景颜色。
 
 @discussion 自 iOS11 后，iPhoneX 的机型状态栏高度变为 44pt，不再适合自动设置状态栏颜色，应当由前端主动填充合适的背景，让状态栏与背景融合起来。
 */
- (void)supportiOS7WithoutStatusBar NS_DEPRECATED_IOS(7_0, 10_0);

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
 自定义导航栏高度 - 用于计算 WebView 高度。
 */
@property (nonatomic, assign) CGFloat navBarHeight;

/**
 是否允许 H5 操纵导航栏，默认为 NO。
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

/**
 更新导航栏的前景色，可以自行覆盖以提供定制化的逻辑。
 
 @param color 导航栏的前景色，nil 表示需要重置前景色。
 */
- (void)updateNavigationBarForegroundColor:(UIColor * _Nullable)color;

/**
 更新导航栏的背景色，可以自行覆盖以提供定制化的逻辑。
 
 @param color 导航栏的背景色，nil 表示需要重置背景色。
 */
- (void)updateNavigationBarBackgroundColor:(UIColor * _Nullable)color;

/**
 更新 ViewController 的 UI（导航栏隐藏、前景色、背景色和按钮等），一般在 viewWillAppear 时调用。
 */
- (void)updateViewControllerUI;

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
 * 点击工具栏左边第一个按钮要执行的方法，默认为 pop 当前 ViewController。
 */
- (void)goFirstClicked;

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

#pragma mark - 定制错误页

/**
 * 显示错误页。
 * 允许由子类重写以自定义错误页。
 *
 * @param webView 产生错误的 WebView。
 * @param error   错误信息。
 */
- (void)showErrorView:(UIView<WVWebViewProtocol> * _Nonnull)webView didFailLoadWithError:(NSError * _Nonnull)error;

/**
 * 隐藏错误页。
 * 允许由子类重写以自定义错误页。
 */
- (void)removeErrorView;

#pragma mark - 定制加载框

/**
 * 是否显示加载框，默认为 YES。
 * 可以设置为 NO 不显示加载框，此时可以使用 KVO 监听 WebView.estimatedProgress 的改变，实现加载进度。
 */
@property (nonatomic, assign, getter=isShowLoadingBox) BOOL showLoadingBox;

/**
 * 显示加载框。
 * 允许由子类重写以自定义加载框。
 */
- (void)showLoadingBox;

/**
 * 使用指定的标题显示加载框。
 * 允许由子类重写以自定义加载框。
 */
- (void)showLoadingBoxWithTitle:(NSString * _Nullable)title;

/**
 * 隐藏加载框。
 * 允许由子类重写以自定义加载框。
 */
- (void)hiddenLoadingBox;

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
