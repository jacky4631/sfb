//
//  WVViewControllerProtocol.h
//  Basic
//
//  Created by lianyu.ysj on 2018/1/25.
//  Copyright © 2018年 WindVane. All rights reserved.
//

#import <WindVaneCore/WVWKWebView.h>
#import <WindVaneCore/WVWebViewProtocol.h>
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, WVUseWKWebView) {
	WVUseWKWebViewNever,  // 从不使用 WKWebView
	WVUseWKWebViewAlways, // 总是使用 WKWebView
	WVUseWKWebViewCustom  // 由 decideIsUseWKWebView 方法的结果决定是否使用 WKWebView
};

/**
 WindVane ViewController 协议。
 */
@protocol WVViewControllerProtocol <NSObject>

@required

/**
 是否使用 WKWebView，默认为 WVUseWKWebViewNever。
 */
@property (nonatomic, assign, getter=isUseWKWebView) WVUseWKWebView useWKWebView;

#pragma mark - WebView

/**
 当前 ViewController 包含的 WebView，不存在时会自动创建。
 */
@property (nonatomic, strong, readonly, nonnull) UIView<WVWebViewProtocol> * webView;

/**
 当前 ViewController 包含的 WebView，不存在时会返回 nil，而不是自动创建。
 */
@property (nonatomic, strong, readonly, nullable) UIView<WVWebViewProtocol> * internalWebView;

/**
 WebView 的 UIScrollView 对象。
 */
@property (nonatomic, weak, readonly, nullable) UIScrollView * webViewScrollView;

/**
 WebView 的内容是否允许拖拽超过边缘再回弹，默认为 YES。
 需要禁止拖拽效果时，请使用本属性，不要对 ScrollView 的 bounces 属性进行设置。
 与 forbiddenPullScroll 属性作用相同，但值恰好相反。
 */
@property (nonatomic, assign) BOOL bounces;

#pragma mark - WebView Content

/**
 WebView 是否正在加载内容。
 */
@property (nonatomic, assign, readonly, getter=isWebViewLoading) BOOL webViewLoading;

/**
 WebView 当前加载的请求，是主页面的请求，而非 iframe。
 */
@property (nonatomic, copy, readonly, nullable) NSURLRequest * webViewRequest;

/**
 WebView 当前加载的 URL，是主页面的 URL，而非 iframe。
 */
@property (nonatomic, copy, readonly, nullable) NSURL * webViewURL;

/**
 是否允许 WebKit 长按事件（选择、弹出菜单），默认为 NO。
 */
@property (nonatomic, assign, getter=isOpenWebKitLongPress) BOOL openWebKitLongPress;

/**
 是否开启长按保存图片，默认为 YES
 */
@property (nonatomic, assign, getter=isOpenLongPressSaveImage) BOOL openLongPressSaveImage;

/**
 是否允许内联播放媒体，默认为 YES。

 @discussion 对于 WKWebView，WebView 初始化之后再设置可能无法生效。
 */
@property (nonatomic, assign) BOOL allowsInlineMediaPlayback;

/**
 媒体是否需要用户交互才能自动播放，默认为 NO。

 @discussion 对于 WKWebView，WebView 初始化之后再设置可能无法生效。
 */
@property (nonatomic, assign) BOOL mediaPlaybackRequiresUserAction;

/**
 获取 WebView 是否可以回退。
 */
@property (nonatomic, assign, readonly) BOOL webViewCanGoBack;

/**
 获取 WebView 是否可以前进。
 */
@property (nonatomic, assign, readonly) BOOL webViewCanGoForward;

#pragma mark - WVWebViewDelegate

/**
 在加载指定页面之前执行的行为。
 会在 webView:shouldStartLoadWithRequest:navigationType: 方法中调用，根据子类具体实现的不同，可能不会调用此 Block。
 */
@property (nonatomic, copy, nullable) BOOL (^shouldStartLoadAction)(UIView<WVWebViewProtocol> * _Nonnull, NSURLRequest * _Nonnull, WKNavigationType);

/**
 在开始加载新页面前执行的行为。
 会在 webViewDidStartLoad: 方法中调用，根据子类具体实现的不同，可能不会调用此 Block。
 */
@property (nonatomic, copy, nullable) void (^didStartLoadAction)(UIView<WVWebViewProtocol> * _Nonnull);

/**
 在页面加载完毕后执行的行为。
 会在 webViewDidStartLoad: 方法中调用，根据子类具体实现的不同，可能不会调用此 Block。
 */
@property (nonatomic, copy, nullable) void (^didFinishLoadAction)(UIView<WVWebViewProtocol> * _Nonnull);

/**
 在页面加载失败时执行的行为。
 会在 webView:didFailLoadWithError: 方法中调用，根据子类具体实现的不同，可能不会调用此 Block。
 */
@property (nonatomic, copy, nullable) void (^didFailLoadAction)(UIView<WVWebViewProtocol> * _Nonnull, NSError * _Nonnull);

/**
 在接收到 JS 的 console 日志或错误信息时的行为。
 会在 webView:didReceiveJSLog:level: 方法中调用，根据子类具体实现的不同，可能不会调用此 Block。
 需要 WebView 主动开启 JSLog 级别，才能接收 console 日志。
 */
@property (nonatomic, copy, nullable) void (^didReceiveJSLogAction)(UIView<WVWebViewProtocol> * _Nonnull, NSString * _Nonnull, WVLogLevel);

/**
 WKWebView 的独立进程崩溃时的行为。
 */
@property (nonatomic, copy, nullable) void (^webContentProcessDidTerminateAction)(WVWKWebView * _Nonnull);

#pragma mark - LoadPage

/**
 加载指定的请求

 @param request 要加载的请求。
 */
- (void)loadPageByRequest:(NSURLRequest * _Nonnull)request;

/**
 加载指定的 URL。
 
 @param url 要加载的 URL。
 */
- (void)loadPageByUrl:(NSString * _Nonnull)url;

/**
 使用 POST 请求加载指定的 URL。
 
 @param url      要加载的 URL。
 @param postBody POST 请求内容。
 */
- (void)loadPageByUrl:(NSString * _Nonnull)url postBody:(NSString * _Nullable)postBody;

/**
 在 isUseWKWebView 为 WVUseWKWebViewCustom 时，决定是否使用 WKWebView。
 */
- (BOOL)decideIsUseWKWebView;

/**
 WebView 回退历史记录。
 */
- (void)webViewGoBack;

/**
 WebView 前进历史记录。
 */
- (void)webViewGoForward;

/**
 WebView 停止加载。
 */
- (void)webViewStopLoading;

/**
 WebView 刷新页面。
 */
- (void)webViewReload;

/**
 表示当前 ViewController 将要从指定来源唤起，会在下一次发送 WV.Event.APP.Active 事件时附上相关信息。
 
 @param activeFrom 唤起的来源。
 @param data       唤起时传递的数据。
 */
- (void)h5ActiveFrom:(NSString * _Nullable)activeFrom withData:(id _Nullable)data;

#pragma mark - 下拉刷新 & 上拉加载

/**
 是否启用下拉刷新，默认为 YES。
 启用下拉刷新之后，才允许自定义下拉刷新的视图样式。
 
 @discussion
 由于 iOS7 支持透明导航栏，需要在 viewDidLayoutSubviews 中配置下拉刷新，才可以正确处理 UIScrollView 的 contentInset。
 因此对于透明导航栏，下拉刷新会延迟到 viewDidLayoutSubviews 中初始化。
 对于不透明导航，下拉刷新仍然会在 loadView 中初始化。
 为了统一这一点，我们额外提供了 configPullToRefreshStyle 方法，供子方法重写下拉刷新的样式配置。
 */
@property (nonatomic, assign, getter=isUsePullToRefresh) BOOL usePullToRefresh;

/**
 是否启用上拉加载，默认为 YES。
 启用上拉加载之后，才允许自定义上拉加载的视图样式。
 */
@property (nonatomic, assign, getter=isUseInfiniteScrolling) BOOL useInfiniteScrolling;

/**
 是否使用自定义的下拉刷新组件（仅支持 SVPullToRefresh 开源库），默认为 NO，会使用 WVPullToRefresh 和 WVInfiniteScrolling。
 请在使用任何下拉刷新或上拉加载前设置，并且不要在中途修改，否则会发生错误。
 */
@property (nonatomic, assign, getter=isUseCustomPullToRefresh) BOOL useCustomPullToRefresh;

@end
