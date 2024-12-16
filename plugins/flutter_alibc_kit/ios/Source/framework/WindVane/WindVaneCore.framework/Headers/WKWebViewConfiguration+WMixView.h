//
//  WKWebViewConfiguration+WMixView.h
//  Basic
//
//  Created by lianyu on 2018/8/23.
//  Copyright © 2018年 WindVane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@interface WKWebViewConfiguration (WMixView)

/**
 是否允许使用 MixView，默认为 NO。
 必须在初始化 WebView 时完成设置。
 */
@property (nonatomic, assign) BOOL wvAllowsMixView;

@end
