/*
 * AlibcAlertView.h 
 *
 * 阿里百川电商
 * 项目名称：阿里巴巴电商 AlibcTradeBiz 
 * 版本号：4.0.0.9
 * 发布时间：2019-10-31
 * 开发团队：阿里巴巴商家服务引擎团队
 * 阿里巴巴电商SDK答疑群号：1488705339  2071154343(阿里旺旺)
 * Copyright (c) 2016-2020 阿里巴巴-淘宝-百川. All rights reserved.
 */

#import <UIKit/UIKit.h>

@protocol ALiAlertViewDelegate;

@interface AlibcAlertView : UIView

@property(nonatomic, readonly, copy) NSString *title;
@property(nonatomic, strong) UIFont *titleFont;
@property(nonatomic, strong) UIColor *titleColor;

@property(nonatomic, readonly, copy) NSString *message;
@property(nonatomic, strong) UIFont *messageFont;
@property(nonatomic, strong) UIColor *messageColor;

/** 遮罩颜色 */
@property(nonatomic, strong) UIColor *maskColor;

/** 取消按钮的index，默认为0，可以通过设置该值来改变取消按钮的位置 */
@property(nonatomic, assign) NSInteger cancelButtonIndex;

/** 同一行中，最多能摆放的按钮数，默认为2，当button总数超过该值时，会将button分行显示、且每行只显示一个 */
@property(nonatomic, assign) NSInteger rowMaxButtonNumber;
@property(nonatomic, assign) BOOL isContentCenter; //内容是否居中显示

//通过delegate或block来实现按钮点击事件的回调
@property(nonatomic, weak) id <ALiAlertViewDelegate> delegate;
@property(nonatomic, copy) void (^dismissBlock)(NSInteger clickIndex);

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                contentCenter:(BOOL)bCenter
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSString *)otherButtonTitles, ...NS_REQUIRES_NIL_TERMINATION;

- (void)show;

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;

/**
 *  添加一个自定义的button到指定的位置
 *
 *  @param button      自定义的按钮
 *  @param buttonIndex 插入的位置，越界时会自动做处理成最大值或最小值
 */
- (void)addCustomButton:(UIButton *)button toIndex:(NSInteger)buttonIndex;

@end


@protocol ALiAlertViewDelegate <NSObject>

@required
- (void)alertView:(AlibcAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface UIImage (Expand)

+ (UIImage *)imageWithColor:(UIColor *)color;

@end