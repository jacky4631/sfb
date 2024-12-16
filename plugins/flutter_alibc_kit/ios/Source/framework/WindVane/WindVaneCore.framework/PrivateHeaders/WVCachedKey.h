//
//  WVCachedKey.h
//  Basic
//
//  Created by lianyu.ysj on 2018/1/18.
//  Copyright © 2018年 WindVane. All rights reserved.
//

#import <Foundation/Foundation.h>

// 将一些用到的私有 API 统一加密

// 锁屏的事件，为了在 iOS8 上对 WebGL 做保护，需要监听锁屏事件
#define WV_CACHEDKEY_SCREENLOCK (wvGetKey(0))
// WKBrowsingContextController 类，为了另 WKWebView 支持 NSURLProtocol 拦截，需要用到这个类
#define WV_CACHEDKEY_WKBROWSINGCONTEXTCONTROLLER (wvGetKey(1))
// 注册自定义 scheme 到 WKWebView
#define WV_CACHEDKEY_REGISTERWKSCHEME (wvGetSelector(2))
// 反注册自定义 scheme 到 WKWebView
#define WV_CACHEDKEY_UNREGISTERWKSCHEME (wvGetSelector(3))
// 设置 WKWebView 的 SafeArea 行为
#define WV_CACHEDKEY_WKSAFEAREAEDGE (wvGetSelector(4))
// 获取 UIWebView 的内部 WebView
#define WV_CACHEDKEY_UIINTERNALWEBVIEW (wvGetKey(5))
// 获取 WebView 是否开启 WebGL
#define WV_CACHEDKEY_GETWEBGLENABLED (wvGetSelector(6))
// 设置 WebView 是否开启 WebGL
#define WV_CACHEDKEY_SETWEBGLENABLED (wvGetSelector(7))
// 设置 WebView 是否记录历史记录
#define WV_CACHEDKEY_SETMAINTAINSBACKFORWARDLIST (wvGetSelector(8))
// UIWebOverflowScrollView 类，为了清空内容以避免 crash
#define WV_CACHEDKEY_UIWEBVIEWSCROLLVIEW (wvGetKey(9))
// WebView 的导航方法
#define WV_CACHEDKEY_WEBVIEW_DECIDEACTION (wvGetSelector(10))
// WebView 开始加载
#define WV_CACHEDKEY_WEBVIEW_STARTLOAD (wvGetSelector(11))
// WebView 结束加载
#define WV_CACHEDKEY_WEBVIEW_FINISHLOAD (wvGetSelector(12))
// WebView 加载失败
#define WV_CACHEDKEY_WEBVIEW_FAILPROVISIONALLOAD (wvGetSelector(13))
// WebView 加载失败
#define WV_CACHEDKEY_WEBVIEW_FAILLOAD (wvGetSelector(14))
// WebView title 发生改变
#define WV_CACHEDKEY_WEBVIEW_RECEIVETITLE (wvGetSelector(15))
// UIWebViewWebViewDelegate 类
#define WV_CACHEDKEY_UIWEBVCIEWDELEGATE (wvGetKey(16))
// WebView 创建 JavaScriptContext
#define WV_CACHEDKEY_WEBVIEW_CREATEJSCONTEXT (wvGetSelector(17))
// 发送同步 XHR 时，NSURLProtocol 的线程 RunLoopMode，为了避免 WebThread 没有响应
#define WV_CACHEDKEY_SYNC_RUNLOOPMODE (wvGetKey(18))
// WKWebView 的 NSURLProtocol 拦截加载器。
#define WV_CACHEDKEY_WK_CUSTOM_PROTOCOL_LOADER (wvGetKey(19))
// WKWebView 的 ScrollView 类型。
#define WV_CACHEDKEY_WKSCROLLVIEW (wvGetKey(20))
// WKWebView 的内容 View。
#define WV_CACHEDKEY_WKCONTENTVIEW (wvGetKey(21))
// 唤起键盘前的校验方法。
#define WV_CACHEDKEY_WEBVIEW_KEYBOARD (wvGetSelector(22))
// 唤起键盘前的旧校验方法。
#define WV_CACHEDKEY_WEBVIEW_KEYBOARD_OLD (wvGetSelector(23))
// iOS 12.2 唤起键盘的方法。
#define WV_CACHEDKEY_WEBVIEW_KEYBOARD_12_2 (wvGetSelector(24))

/**
 返回指定索引的 Key。
 
 @param index CachedKey 的索引。
 @return 指定索引的 CachedKey。
 */
NSString * _Nullable wvGetKey(NSUInteger index);

/**
 返回指定索引的 CachedKey 对应的 SEL。
 
 @param index CachedKey 的索引。
 @return 指定索引的 CachedKey 对应的 SEL。
 */
SEL _Nullable wvGetSelector(NSUInteger index);
