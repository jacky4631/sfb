/*
 * UIViewController+WVUtility.h
 *
 * Created by WindVane.
 * Copyright (c) 2017年 阿里巴巴-淘宝技术部. All rights reserved.
 */

#import <UIKit/UIKit.h>

/**
 * 提供 UIViewController 类的扩展方法。
 */
@interface UIViewController (WVUtility)

/**
 * 寻找与指定 ViewController 相关的顶层 ViewController。
 *
 * @return 顶层 ViewController。
 */
+ (UIViewController * _Nullable)wvTopViewController:(UIViewController * _Nullable)viewController;

@end
