//
//  WVSafeAreaAdaptor.h
//  Basic
//
//  Created by lianyu.ysj on 2017/10/2.
//  Copyright © 2017年 WindVane. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 包含对安全域区域的适配逻辑。
 */
@interface WVSafeAreaAdaptor : NSObject

/**
 判断是否是 iOS 11。
 貌似有越狱机系统是 iOS11，但调用任何 iOS11 方法都会 Crash，所以需要再额外主动检测一下 API 是否存在。
 */
+ (BOOL)isIOS11;

/**
 返回指定 UIScrollView 的 adjustedContentInset。
 */
+ (UIEdgeInsets)adjustedContentInset:(UIScrollView *)scrollView;

/**
 返回当前是否是异形屏。
 */
+ (BOOL)hasNotch;

/**
 返回当前 UI 方向下的设备 SafeArea 间距，只考虑状态栏和 Home Bar。
 
 @return 设备 SafeArea 间距，只考虑状态栏和 Home Bar。
 */
+ (UIEdgeInsets)currentSafeAreaInsets;

@end

