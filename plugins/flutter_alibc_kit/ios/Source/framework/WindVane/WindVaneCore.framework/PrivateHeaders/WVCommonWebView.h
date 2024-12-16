//
//  WVCommonWebView.h
//  WindVaneBasic
//
//  Created by lianyu.ysj on 15/3/19.
//  Copyright (c) 2015年 WindVane. All rights reserved.
//

#import <WindVaneCore/WVNavigation.h>
#import <WindVaneCore/WVPageMeta.h>
#import <WindVaneCore/WVWebViewProtocol.h>
#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import <WindVaneCore/WVJSONKit.h>

// WVWebView 通过 loadRequest 加载的请求的键，这样的请求总是认为主页面。
FOUNDATION_EXPORT NSString * const WVWebViewLoadRequestKey;
// WVWebView 中表示是 mainFrame 的键，用于与 swizzle 失效的情况区分开来。
FOUNDATION_EXPORT NSString * const WVWebViewMainFrameKey;

@interface WVCommonWebView : NSObject <WKNavigationDelegate>

#pragma mark - Init

/**
 * 使用指定的 WebView 初始化。
 */
- (instancetype)initWithWebView:(UIView<WVWebViewProtocol> *)webview;

#pragma mark - Configuration

/**
 * WebView 标识符。
 */
@property (nonatomic, copy) NSString * identifier;

/**
 * 关联到的 ViewController。
 */
@property (nonatomic, weak) UIViewController * sourceViewController;

/**
 * WebView 在 ViewController 中的可见性。
 */
@property (nonatomic, assign) WVWebViewVisiblity visibleInViewController;

/**
 WKWebView 的NavigationDelegate 模式。
 */
@property (nonatomic, assign) BOOL navigationDelegateMode;

/**
 * 是否允许 WebKit 长按事件（选择、弹出菜单），默认为 YES。
 */
@property (nonatomic, assign, getter=isOpenWebKitLongPress) BOOL openWebKitLongPress;

/**
 * 是否允许长按保存图片，默认为 YES。
 */
@property (nonatomic, assign, getter=isOpenLongPressSaveImage) BOOL openLongPressSaveImage;

/**
 * 是否启用下拉刷新，默认为 NO。
 */
@property (nonatomic, assign, getter=isUsePullToRefresh) BOOL usePullToRefresh;

/**
 * 是否具有弹性效果。
 */
@property (nonatomic, assign) BOOL bounces;

#pragma mark - Content

/**
 * 当前 frame 标识，供 WVWebView 设置使用。
 * 如果状态未知，则为 nil；如果是主页面，则使用 WVWebViewMainFrameKey 表示。
 */
@property (nonatomic, copy) NSString * frameId;

/**
 * 当前导航信息，仅在 WVWebViewDelegate 的回调中生效。
 */
@property (nonatomic, strong, readonly) WVNavigation * navigation;

/**
 首次加载的请求，用于在首次加载失败后 reload 时使用。
 */
@property (nonatomic, strong, readonly) NSURLRequest * firstLoadRequest;

/**
 * 主页面导航信息，页面可能未加载、加载中或已加载。
 */
@property (nonatomic, strong, readonly) WVNavigation * mainNavigation;

/**
 * WebView 的可见性，会由 ViewController 的可见性和 WebView 在 ViewController 中的可见性综合计算得到。
 *
 * @discussion 该属性支持 KVO。
 */
@property (nonatomic, assign, readonly) WVWebViewVisiblity visiblity;

/**
 * WebView 当前页面内容是否为空，该属性并不会实时反应页面的白屏状况，实时信息请使用 [WebView isPageEmpty:] 方法。
 */
@property (nonatomic, assign, getter=isPageEmpty) WVTristate pageEmpty;

/**
 * 检查 WebView 的页面是否为空。
 *
 * @param callback 检查结果的回调。
 */
- (void)isPageEmpty:(void (^)(BOOL isPageEmpty))callback;

/**
 当前页面的 viewport-fit 设置。
 */
@property (nonatomic, assign, readonly) WVWebViewViewportFit viewportFit;

#pragma mark - Delegate

/**
 * WindVane 代理。
 */
@property (nonatomic, weak) id<WVWebViewDelegate> windVaneDelegate;

#pragma mark - Request

/**
 * 估计的加载进度。
 */
@property (nonatomic, assign, readonly) double estimatedProgress;

#pragma mark - WVWebViewDelegate

/**
 * 在加载指定请求之前调用。
 *
 * @return 如果要加载指定的请求，则返回 YES；否则返回 NO。
 */
- (BOOL)webView:(UIView<WVWebViewProtocol> *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(WKNavigationType)navigationType;

/**
 * 在开始加载新页面前调用。
 */
- (void)webViewDidStartLoad:(UIView<WVWebViewProtocol> *)webView;

/**
 * 在页面加载完毕后调用。
 */
- (void)webViewDidFinishLoad:(UIView<WVWebViewProtocol> *)webView;

/**
 * 在页面加载失败时调用。
 */
- (void)webView:(UIView<WVWebViewProtocol> *)webView didFailLoadWithError:(NSError *)error;

#pragma mark - Life cycle

/**
 * [注意：必须在 ViewController 的 viewWillDisappear 中调用!!!] 释放 WebView 的服务。
 */
- (void)releaseWebViewService;

/**
 * [注意：必须在 ViewController 的 viewWillAppear 中调用!!!] 重新绑定 WebView 的服务。
 */
- (void)bindingWebViewService;

#pragma mark - Navigation

/**
 * 发送 WindVaneReady 事件。
 */
+ (void)sendWindVaneReadyEvent:(UIView<WVWebViewBasicProtocol> *)webview;

#pragma mark - View

/**
 * 返回是否支持 SVPullToRefresh。
 */
+ (BOOL)isSupportSVPullToRefresh;

/**
 SafeArea 发生变化后，重新调整 contentInset。
 */
- (void)safeAreaInsetsDidChange;

@end
