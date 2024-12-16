/*
 * WVUILoadingBox.h
 * 
 * Created by WindVane.
 * Copyright (c) 2017年 阿里巴巴-淘宝技术部. All rights reserved.
 */

#import <UIKit/UIKit.h>

/**
 * WindVane 加载框。
 */
@interface WVUILoadingBox : UIView

/**
 * 加载框的标题。
 */
@property (nonatomic, strong) UILabel * loadingBoxTitle;

/**
 * 设置加载框的文本。
 *
 * @param title 加载框的文本。
 */
- (void)setTitle:(NSString *)title;

/**
 * 重设加载框所在 View 的 frame，会自动重新居中。
 *
 * @param frame 加载框所在 View 的 frame。
 */
- (void)resize:(CGRect)frame;

@end

