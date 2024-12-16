//
//  WVWKWebView+WVPrivate.h
//  Basic
//
//  Created by 郑祯 on 2019/6/25.
//  Copyright © 2019 WindVane. All rights reserved.
//

#import <WindVaneCore/WVWKWebView.h>

/**
 * WVWKWebView 的私有接口。
 */
@interface WVWKWebView (WVPrivate)

/**
 是否是预创建的 WebView。
 */
@property (nonatomic, assign, getter=isPreCreate) BOOL preCreate;

/**
 是否是预渲染的 WebView。
 */
@property (nonatomic, assign, getter=isPreRender) BOOL preRender;

/**
 页面发生 JS Erorr。
 */
- (void)jsErrorOccurred;

@end
