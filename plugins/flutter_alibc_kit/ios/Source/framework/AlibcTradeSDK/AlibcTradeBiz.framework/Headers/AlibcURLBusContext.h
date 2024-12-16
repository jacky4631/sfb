/*
 * AlibcURLBusContext.h 
 *
 * 阿里百川电商
 * 项目名称：阿里巴巴电商 AlibcTradeBiz 
 * 版本号：4.0.0.9
 * 发布时间：2019-10-31
 * 开发团队：阿里巴巴商家服务引擎团队
 * 阿里巴巴电商SDK答疑群号：1488705339  2071154343(阿里旺旺)
 * Copyright (c) 2016-2020 阿里巴巴-淘宝-百川. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface AlibcURLBusContext : NSObject
@property(nonatomic,assign)BOOL isLoadedUrl;// 是否已经完成一次页面加载
@property(nonatomic,assign)BOOL isConvertUrl;// 是否加载前被转链
@property(nonatomic, copy)NSString *originalUrl;// 原始URL
@property(nonatomic, copy)NSString *convertUrl;// 被转链之后的url
@property(nonatomic, weak) WKWebView *webview;
@property(nonatomic, assign) BOOL bFiltered; //标记本次加载是通过filter触发的
@property(nonatomic, weak) UIViewController *sourceViewController;

@property(nonatomic, strong) NSMutableDictionary *extraData; //附加数据,各个业务可以自己塞,注意key冲突
@property(nonatomic, strong) id tradeData; //电商业务专用附加数据

// 由于需要押后处理h5的context 存储param参数
@property (nonatomic,strong)id  param;


- (void)setWebviewAndViewController:(WKWebView *)webview controller:(UIViewController *)vc;

//webview触发load事件
- (void)setLoadWithRequest:(NSURLRequest *)request;

//绑定webview点击事件
- (void)bindGesture;




/****   辅助函数,方便后续修改UIWebView到UIWebViewProxy的情况.   ***/
//放在这里是因为bus上的拦截到处都可以用..其实都是工具函数,为了复用
- (void)loadRequest:(NSURLRequest *)request;

- (void)reload;  //刷新webview
- (void)goBack;  //浏览器回退或者无堆栈时pop vc,
- (void)popView;

- (void)smartGoBack;// 根据跳转类型决定是否goback,主要用在取消登陆的场景
@end
