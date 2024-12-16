/*
 * WVWebViewToolbar.h
 * 
 * Created by WindVane.
 * Copyright (c) 2017年 阿里巴巴-淘宝技术部. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 * 表示 WebView 的工具栏。
 */
@interface WVWebViewToolbar : UIToolbar

/**
 * 是否使用工具栏最左边的第一个按钮，默认是一个大箭头返回按钮，行为是 pop ViewController，默认为 YES。
 */
@property (nonatomic, assign, getter=isUseFirstButton) BOOL useFirstButton;

/**
 * 工具栏左边第一个按钮的图片。
 */
@property (nonatomic, strong) UIImage * firstButtonImage;

/**
 * 回退按钮的图片。
 */
@property (nonatomic, strong) UIImage * backButtonImage;

/**
 * 前进按钮的图片。
 */
@property (nonatomic, strong) UIImage * forwardButtonImage;

/**
 * 停止按钮的图片。
 */
@property (nonatomic, strong) UIImage * stopButtonImage;

/**
 * 刷新按钮的图片。
 */
@property (nonatomic, strong) UIImage * refreshButtonImage;

/**
 * 工具栏背景图片。
 */
@property (nonatomic, strong) UIImage * backgroundImage;

/**
 * 是否启用回退按钮。
 */
@property (nonatomic, assign) BOOL backButtonEnabled;

/**
 * 是否启用前进按钮。
 */
@property (nonatomic, assign) BOOL forwardButtonEnabled;

/**
 * 是否启用停止按钮。
 */
@property (nonatomic, assign) BOOL stopButtonEnabled;

/**
 * 是否启用刷新按钮。
 */
@property (nonatomic, assign) BOOL refreshButtonEnabled;

/**
 * 使用视图大小和动作目标初始化。
 */
- (instancetype)initWithFrame:(CGRect)frame withTarget:(id)target;

@end
