/*
 * UIScrollView+WVPullToRefresh.h
 * 
 * Created by WindVane.
 * Copyright (c) 2017年 阿里巴巴-淘宝技术部. All rights reserved.
 */

#import <UIKit/UIKit.h>

// 下拉刷新的状态。
typedef NS_ENUM (NSUInteger, WVPullToRefreshState) {
	WVPullToRefreshStateStopped,
	WVPullToRefreshStateTriggered,
	WVPullToRefreshStateLoading,
	WVPullToRefreshStateAll = 10,
};

/**
 下拉刷新的指示器协议。
 */
@protocol WVPullToRefreshIndicatorProtocol <NSObject>

@optional

/**
 设置指示器的状态。
 */
- (void)setState:(WVPullToRefreshState)state;

/**
 设置指示器的进度。
 */
- (void)setProgress:(double)progress;

@end

#pragma mark- WVPullToRefreshView

/**
 * WindVane 的下拉刷新视图。
 */
@interface WVPullToRefreshView : UIView

/**
 * 文本颜色。
 */
@property (nonatomic, strong) UIColor * textColor;

/**
 * 活动指示器样式。
 */
@property (nonatomic, assign) UIActivityIndicatorViewStyle activityIndicatorViewStyle;

/**
 * 下拉刷新视图状态。
 */
@property (nonatomic, assign) WVPullToRefreshState state;

/**
 * 标题标签。
 */
@property (nonatomic, strong, readonly) UILabel * titleLabel;

/**
 * 副标题标签。
 */
@property (nonatomic, strong, readonly) UILabel * subtitleLabel;

/**
 * 底部 URL 标签。
 */
@property (nonatomic, strong, readonly) UILabel * bottomLabel;

/**
 * 下拉刷新指示器，默认使用 WVActivityIndicatorView。
 */
@property (nonatomic, strong) UIView<WVPullToRefreshIndicatorProtocol> * indicator;

/**
 * 设置标题。
 */
- (void)setTitle:(NSString *)title forState:(WVPullToRefreshState)state;

/**
 * 设置副标题。
 */
- (void)setSubtitle:(NSString *)subtitle forState:(WVPullToRefreshState)state;

/**
 * 设置自定义视图。
 */
- (void)setCustomView:(UIView *)view forState:(WVPullToRefreshState)state;

/**
 * 开始动画。
 */
- (void)startAnimating;

/**
 * 停止动画。
 */
- (void)stopAnimating;

@end

#pragma mark- UIScrollView (WVPullToRefresh)

/**
 * WindVane 的下拉刷新支持。
 */
@interface UIScrollView (WVPullToRefresh)

/**
 * 是否显示下拉刷新。
 */
@property (nonatomic, assign) BOOL wvShowsPullToRefresh;

/**
 * 下拉刷新视图。
 */
@property (nonatomic, strong, readonly) WVPullToRefreshView * wvPullToRefreshView;

/**
 * 添加下拉刷新。
 *
 * @param actionHandler 下拉刷新的行为。
 */
- (void)wvAddPullToRefreshWithActionHandler:(void (^)(void))actionHandler;

/**
 * 触发下拉刷新。
 */
- (void)wvTriggerPullToRefresh;

@end
