//
//  CLCTCCUIConfigure.h
//  CL_ShanYanSDK
//
//  Created by wanglijun on 2018/10/30.
//  Copyright © 2018 wanglijun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class CLOrientationLayOut;
NS_ASSUME_NONNULL_BEGIN

/**⚠️⚠️ 注： 授权页一键登录按钮、运营商条款必须显示，不得隐藏，否则取号能力可能被运营商关闭 */

/// 授权页UI配置
@interface CLUIConfigure : NSObject

/// 要拉起授权页的vc [必填项] (注：SDK不持有接入方VC)
@property(nonatomic,weak) UIViewController *viewController;
/// 外部手动管理关闭界面 BOOL,default is NO
@property(nonatomic,strong) NSNumber *manualDismiss;
/// 授权页背景图片
@property(nonatomic,strong) UIImage *clBackgroundImg;
/// 授权页-背景色
@property(nonatomic,strong) UIColor *clBackgroundColor;


/****************************   导航栏相关 ***************************/

/// 导航栏 是否隐藏 BOOL default is NO, 设置优先级高于clNavigationBackgroundClear eg.@(NO)
@property(nonatomic,strong) NSNumber *clNavigationBarHidden;
/// 导航栏 背景透明 BOOL eg.@(YES)
@property(nonatomic,strong) NSNumber *clNavigationBackgroundClear;
/// 导航栏标题
@property(nonatomic,strong) NSAttributedString *clNavigationAttributesTitleText;
/// 导航栏右侧自定义按钮
@property(nonatomic,strong) UIBarButtonItem *clNavigationRightControl;
/// 导航栏左侧自定义按钮
@property(nonatomic,strong) UIBarButtonItem *clNavigationLeftControl;
/// 导航栏左侧返回按钮图片
@property(nonatomic,strong) UIImage *clNavigationBackBtnImage;
/// 导航栏自带返回按钮隐藏，默认显示 BOOL eg.@(YES)
@property(nonatomic,strong) NSNumber *clNavigationBackBtnHidden;
/// 返回按钮图片缩进 btn.imageInsets = UIEdgeInsetsMake(0, 0, 20, 20)
@property(nonatomic,strong) NSValue *clNavBackBtnImageInsets;
/**自带返回(关闭)按钮位置 默认NO 居左,设置为YES居右显示*/
@property(nonatomic,strong) NSNumber *clNavBackBtnAlimentRight;

/// 导航栏分割线 是否隐藏
/// set backgroundImage=UIImage.new && shadowImage=UIImage.new
/// BOOL, default is YES
/// eg.@(YES)
@property(nonatomic,strong) NSNumber *clNavigationBottomLineHidden;
/// 导航栏 导航栏底部分割线（图片）
@property(nonatomic,strong) UIImage *clNavigationShadowImage;
/// 导航栏 文字颜色
@property(nonatomic,strong) UIColor *clNavigationTintColor;
/// 导航栏 背景色 default is white
@property(nonatomic,strong) UIColor *clNavigationBarTintColor;
/// 导航栏 背景图片
@property(nonatomic,strong) UIImage *clNavigationBackgroundImage;
/// 导航栏 配合背景图片设置，用来控制在不同状态下导航栏的显示(横竖屏是否显示) UIBarMetrics eg.@(UIBarMetricsCompact)
@property(nonatomic,strong) NSNumber *clNavigationBarMetrics;
///// translucent 此属性已失效
//@property(nonatomic,strong) NSNumber *cl_navigation_translucent;


/****************************  状态栏相关 ***************************/

/*状态栏样式
 *Info.plist: View controller-based status bar appearance = YES
 *
 *UIStatusBarStyleDefault：状态栏显示 黑
 *UIStatusBarStyleLightContent：状态栏显示 白
 *UIStatusBarStyleDarkContent：状态栏显示 黑 API_AVAILABLE(ios(13.0)) = 3
 **eg. @(UIStatusBarStyleLightContent)
 */
@property(nonatomic,strong) NSNumber *clPreferredStatusBarStyle;
/// 状态栏隐藏 eg.@(NO)
@property(nonatomic,strong) NSNumber *clPrefersStatusBarHidden;

/**
 *NavigationBar.barStyle：默认UIBarStyleBlack
 *Info.plist: View controller-based status bar appearance = YES

 *UIBarStyleDefault：状态栏显示 黑
 *UIBarStyleBlack：状态栏显示 白
 *
 *eg. @(UIBarStyleBlack)
 */
@property(nonatomic,strong) NSNumber *clNavigationBarStyle;


/****************************  LOGO相关 ***************************/

/// LOGO图片
@property(nonatomic,strong) UIImage *clLogoImage;
/// LOGO圆角 CGFloat eg.@(2.0)
@property(nonatomic,strong) NSNumber *clLogoCornerRadius;
/// LOGO显隐 BOOL eg.@(NO)
@property(nonatomic,strong) NSNumber *clLogoHiden;


/****************************  手机号相关 ***************************/

/// 手机号颜色
@property(nonatomic,strong) UIColor *clPhoneNumberColor;
/// 手机号字体
@property(nonatomic,strong) UIFont *clPhoneNumberFont;
/// 手机号对齐方式 NSTextAlignment eg.@(NSTextAlignmentCenter)
@property(nonatomic,strong) NSNumber *clPhoneNumberTextAlignment;


/****************************  一键登录按钮相关 ***************************/

/// 按钮文字
@property(nonatomic,copy) NSString *clLoginBtnText;
/// 按钮文字颜色
@property(nonatomic,strong) UIColor*clLoginBtnTextColor;
/// 按钮背景颜色
@property(nonatomic,strong) UIColor*clLoginBtnBgColor;
/// 按钮文字字体
@property(nonatomic,strong) UIFont *clLoginBtnTextFont;
/// 按钮背景图片
@property(nonatomic,strong) UIImage*clLoginBtnNormalBgImage;
/// 按钮背景高亮图片
@property(nonatomic,strong) UIImage*clLoginBtnHightLightBgImage;
/// 按钮背景不可用图片
@property(nonatomic,strong) UIImage*clLoginBtnDisabledBgImage;
/// 按钮边框颜色
@property(nonatomic,strong) UIColor*clLoginBtnBorderColor;
/// 按钮圆角 CGFloat eg.@(5)
@property(nonatomic,strong) NSNumber *clLoginBtnCornerRadius;
/// 按钮边框 CGFloat eg.@(2.0)
@property(nonatomic,strong) NSNumber *clLoginBtnBorderWidth;


/****************************  隐私条款相关 ***************************/

/*隐私条款Privacy
 注： 运营商隐私条款 不得隐藏
 用户条款不限制
 **/
/// 隐私条款 下划线设置，默认隐藏，设置clPrivacyShowUnderline = @(YES)显示下划线
@property(nonatomic,strong) NSNumber *clPrivacyShowUnderline;
/// 隐私条款名称颜色：@[基础文字颜色UIColor*,条款颜色UIColor*] eg.@[[UIColor lightGrayColor],[UIColor greenColor]]
@property(nonatomic,strong) NSArray<UIColor*> *clAppPrivacyColor;
/// 隐私条款文字字体
@property(nonatomic,strong) UIFont*clAppPrivacyTextFont;
/// 隐私条款文字对齐方式 NSTextAlignment eg.@(NSTextAlignmentCenter)
@property(nonatomic,strong) NSNumber *clAppPrivacyTextAlignment;
/// 运营商隐私条款书名号 默认NO 不显示 BOOL eg.@(YES)
@property(nonatomic,strong) NSNumber *clAppPrivacyPunctuationMarks;
/// 多行时行距 CGFloat eg.@(2.0)
@property(nonatomic,strong) NSNumber*clAppPrivacyLineSpacing;
/// 是否需要sizeToFit,设置后与宽高约束的冲突请自行考虑 BOOL eg.@(YES)
@property(nonatomic,strong) NSNumber*clAppPrivacyNeedSizeToFit;
/// UITextView.textContainerInset 文字与TextView控件内边距 UIEdgeInset  eg.[NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(2, 2, 2, 2)]
@property(nonatomic,strong) NSValue*clAppPrivacyTextContainerInset;

/// 隐私条款--APP名称简写 默认取CFBundledisplayname 设置描述文本四后此属性无效
@property(nonatomic,copy) NSString *clAppPrivacyAbbreviatedName;
/*
 *隐私条款Y一:需同时设置Name和UrlString eg.@[@"条款一名称",条款一URL]
 *@[NSSting,NSURL];
 */
@property(nonatomic,strong) NSArray *clAppPrivacyFirst;
/*
 *隐私条款二:需同时设置Name和UrlString eg.@[@"条款一名称",条款一URL]
 *@[NSSting,NSURL];
 */
@property(nonatomic,strong) NSArray *clAppPrivacySecond;
/*
 *隐私条款三:需同时设置Name和UrlString eg.@[@"条款一名称",条款一URL]
 *@[NSSting,NSURL];
 */
@property(nonatomic,strong) NSArray *clAppPrivacyThird;

/**
 *用户自己隐私协议大于3条时，
 *可使用：@[@{@"decollator": @"、",               // 隐私协议拼接内容
 *        @"lastDecollator": @"YES",            // 拼接内容是否放隐私条款后
 *        @"privacyName": @"《自定义隐私协议》",   // 隐私条款名称
 *        @"privacyURL": @"https://"}           // 隐私条款URL
 *       ];
 *ps：数组中字典的key不可更改
 */
@property(nonatomic,strong) NSArray *clAppMorePrivacyArray;

/*
 隐私协议文本拼接: DesTextFirst+运营商条款+DesTextSecond+隐私条款一+DesTextThird+隐私条款二+DesTextFourth+隐私条款三+DesTextLast
 **/
/// 描述文本 首部 default:"同意"
@property(nonatomic,copy) NSString *clAppPrivacyNormalDesTextFirst;
/// 描述文本二 default:"和"
@property(nonatomic,copy) NSString *clAppPrivacyNormalDesTextSecond;
/// 描述文本三 default:"、"
@property(nonatomic,copy) NSString *clAppPrivacyNormalDesTextThird;
/// 描述文本四 default:"、"
@property(nonatomic,copy) NSString *clAppPrivacyNormalDesTextFourth;
/// 描述文本 尾部 default: "并授权AppName使用认证服务"
@property(nonatomic,copy) NSString *clAppPrivacyNormalDesTextLast;
/// 运营商协议后置 默认@(NO)
@property(nonatomic,strong) NSNumber *clOperatorPrivacyAtLast;

/// 协议跳转自定义webview，值为@(YES)时，SDK内部webview跳转失效，在下面代理中跳转自定义webview。默认跳转SDK内部webview
/// - (void)clShanYanPrivacyListener:(NSString *_Nonnull)privacyName privacyURL:(NSString *_Nonnull)URLString authPage:(UIViewController *_Nonnull)authPageVC
@property (nonatomic,strong)NSNumber *clAppPrivacyCustomWeb;

/// 用户隐私协议WEB页面导航栏标题 默认显示用户条款名称
@property(nonatomic,strong) NSAttributedString *clAppPrivacyWebAttributesTitle;
/// 运营商隐私协议WEB页面导航栏标题 默认显示运营商条款名称
@property(nonatomic,strong) NSAttributedString *clAppPrivacyWebNormalAttributesTitle;
/// 自定义协议标题-按自定义协议对应顺序
@property(nonatomic,strong) NSArray<NSString*> *clAppPrivacyWebTitleList;
/// 隐私协议标题文本属性（用户协议&&运营商协议）
@property(nonatomic,strong) NSDictionary *clAppPrivacyWebAttributes;
/// 隐私协议WEB页面导航返回按钮图片
@property(nonatomic,strong) UIImage *clAppPrivacyWebBackBtnImage;
/// 协议页状态栏样式 默认：UIStatusBarStyleDefault
@property(nonatomic,strong) NSNumber *clAppPrivacyWebPreferredStatusBarStyle;
/// UINavigationTintColor
@property(nonatomic,strong) UIColor*clAppPrivacyWebNavigationTintColor;
/// UINavigationBarTintColor
@property(nonatomic,strong) UIColor*clAppPrivacyWebNavigationBarTintColor;
/// UINavigationBackgroundImage
@property(nonatomic,strong) UIImage*clAppPrivacyWebNavigationBackgroundImage;
/// UINavigationBarMetrics
@property(nonatomic,strong) NSNumber *clAppPrivacyWebNavigationBarMetrics;
/// UINavigationShadowImage
@property(nonatomic,strong) UIImage*clAppPrivacyWebNavigationShadowImage;
/// UINavigationBarStyle
@property(nonatomic,strong) NSNumber *clAppPrivacyWebNavigationBarStyle;


/****************************  SLOGAN相关 ***************************/

/*SLOGAN
 注： 运营商品牌标签("中国**提供认证服务")，不得隐藏
 **/
/// slogan文字字体
@property(nonatomic,strong) UIFont *clSloganTextFont;
/// slogan文字颜色
@property(nonatomic,strong) UIColor*clSloganTextColor;
/// slogan文字对齐方式 NSTextAlignment eg.@(NSTextAlignmentCenter)
@property(nonatomic,strong) NSNumber *clSlogaTextAlignment;
/// slogan默认不隐藏 eg.@(NO)
@property(nonatomic,strong) NSNumber *clSloganTextHidden;

/*闪验SLOGAN
 注： 供应商品牌标签("闪验提供认技术支持")
 **/
/// slogan文字字体
@property(nonatomic,strong) UIFont *clShanYanSloganTextFont;
/// slogan文字颜色
@property(nonatomic,strong) UIColor*clShanYanSloganTextColor;
/// slogan文字对齐方式 NSTextAlignment eg.@(NSTextAlignmentCenter)
@property(nonatomic,strong) NSNumber *clShanYanSloganTextAlignment;
/// slogan默认隐藏 eg.@(YES)
@property(nonatomic,strong) NSNumber*clShanYanSloganHidden;


/****************************  CheckBox相关 ***************************/

/*CheckBox
 *协议勾选框，默认选中且在协议前显示
 *可在sdk_oauth.bundle中替换checkBox_unSelected、checkBox_selected图片
 *也可以通过属性设置选中和未选择图片
 **/
/// 协议勾选框（默认显示,放置在协议之前）BOOL eg.@(YES)
@property(nonatomic,strong) NSNumber *clCheckBoxHidden;
/// 协议勾选框默认值（默认选中）BOOL eg.@(YES)
@property(nonatomic,strong) NSNumber *clCheckBoxValue;
/// 协议勾选框 尺寸 NSValue->CGSize eg.[NSValue valueWithCGSize:CGSizeMake(25, 25)]
@property(nonatomic,strong) NSValue *clCheckBoxSize;
/// 协议勾选框 UIButton.image图片缩进 UIEdgeInset eg.[NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(2, 2, 2, 2)]
@property(nonatomic,strong) NSValue *clCheckBoxImageEdgeInsets;
/// 协议勾选框 设置CheckBox顶部与隐私协议控件顶部对齐 YES或大于0生效 eg.@(YES)
@property(nonatomic,strong) NSNumber *clCheckBoxVerticalAlignmentToAppPrivacyTop;
/// 协议勾选框 设置CheckBox对齐后的偏移量,相对于对齐后的中心距离在当前垂直方向上的偏移
@property(nonatomic,strong) NSNumber *clCheckBoxVerticalAlignmentOffset;

/// 协议勾选框 设置CheckBox顶部与隐私协议控件竖向中心对齐 YES或大于0生效 eg.@(YES)
@property(nonatomic,strong) NSNumber *clCheckBoxVerticalAlignmentToAppPrivacyCenterY;
/// 协议勾选框 非选中状态图片
@property(nonatomic,strong) UIImage*clCheckBoxUncheckedImage;
/// 协议勾选框 选中状态图片
@property(nonatomic,strong) UIImage*clCheckBoxCheckedImage;

/**授权页自定义 "请勾选协议"提示框
 - containerView为loading的全屏蒙版view
 - 请自行在containerView添加自定义提示
 */
@property(nonatomic,copy)void(^checkBoxTipView)(UIView *containerView);
/// checkBox 未勾选时 提示文本，默认："请勾选协议"
@property(nonatomic,copy) NSString *clCheckBoxTipMsg;
/// 使用sdk内部“一键登录”按钮点击时的吐丝提示("请勾选协议") - NO:默认使用sdk内部吐丝 YES:禁止使用
@property(nonatomic,strong) NSNumber *clCheckBoxTipDisable;


/****************************  Loading相关 ***************************/

/// Loading 大小 CGSize eg.[NSValue valueWithCGSize:CGSizeMake(50, 50)]
@property(nonatomic,strong) NSValue *clLoadingSize;
/// Loading 圆角 float eg.@(5)
@property(nonatomic,strong) NSNumber *clLoadingCornerRadius;
/// Loading 背景色 UIColor eg.[UIColor colorWithRed:0.8 green:0.5 blue:0.8 alpha:0.8];
@property(nonatomic,strong) UIColor *clLoadingBackgroundColor;
/// UIActivityIndicatorViewStyle eg.@(UIActivityIndicatorViewStyleWhiteLarge)
@property(nonatomic,strong) NSNumber *clLoadingIndicatorStyle;
/// Loading Indicator渲染色 UIColor eg.[UIColor greenColor];
@property(nonatomic,strong) UIColor *clLoadingTintColor;
/// 授权页自定义Loading
/// - containerView为loading的全屏蒙版view
/// - 请自行在containerView添加自定义loading
/// - 设置block后，上述loading属性将无效
@property(nonatomic,copy)void(^loadingView)(UIView *containerView);

/**添加自定义控件*/
/// 可设置背景色及添加控件
@property(nonatomic,copy)void(^customAreaView)(UIView *customAreaView);
/// 设置隐私协议弹窗
//@property(nonatomic,copy)void(^customPrivacyAlertView)(UIViewController *authPageVC);

/**横竖屏*/
/// 是否支持自动旋转 BOOL
@property(nonatomic,strong) NSNumber *shouldAutorotate;

/// 支持方向 UIInterfaceOrientationMask
/// - 如果设置只支持竖屏，只需设置clOrientationLayOutPortrait竖屏布局对象
/// - 如果设置只支持横屏，只需设置clOrientationLayOutLandscape横屏布局对象
/// - 横竖屏均支持，需同时设置clOrientationLayOutPortrait和clOrientationLayOutLandscape
@property(nonatomic,strong) NSNumber *supportedInterfaceOrientations;
/// 默认方向 UIInterfaceOrientation
@property(nonatomic,strong) NSNumber *preferredInterfaceOrientationForPresentation;

/**以窗口方式显示授权页
 */
/// 以窗口方式显示 BOOL, default is NO
@property(nonatomic,strong) NSNumber *clAuthTypeUseWindow;
/// 窗口圆角 float
@property(nonatomic,strong) NSNumber *clAuthWindowCornerRadius;

/// clAuthWindowModalTransitionStyle系统自带的弹出方式 仅支持以下三种
/// - UIModalTransitionStyleCoverVertical 底部弹出
/// - UIModalTransitionStyleCrossDissolve 淡入
/// - UIModalTransitionStyleFlipHorizontal 翻转显示
@property(nonatomic,strong) NSNumber *clAuthWindowModalTransitionStyle;

/**UIModalPresentationStyle
 *若使用窗口模式，请设置为UIModalPresentationOverFullScreen 或不设置
 *iOS13强制全屏，请设置为UIModalPresentationFullScreen
 *UIModalPresentationAutomatic API_AVAILABLE(ios(13.0)) = -2
 *默认UIModalPresentationFullScreen
 *eg. @(UIModalPresentationOverFullScreen)
 */
/// 授权页 ModalPresentationStyle
@property(nonatomic,strong) NSNumber *clAuthWindowModalPresentationStyle;
/// 协议页 ModalPresentationStyle （授权页使用窗口模式时，协议页强制使用模态弹出）
@property(nonatomic,strong) NSNumber *clAppPrivacyWebModalPresentationStyle;

/**UIUserInterfaceStyle
 *UIUserInterfaceStyleUnspecified - 不指定样式，跟随系统设置进行展示
 *UIUserInterfaceStyleLight       - 明亮
 *UIUserInterfaceStyleDark,       - 暗黑 仅对iOS13+系统有效
 */
/// 授权页 UIUserInterfaceStyle,默认:UIUserInterfaceStyleLight,eg. @(UIUserInterfaceStyleLight)
@property(nonatomic,strong) NSNumber *clAuthWindowOverrideUserInterfaceStyle;
/// 授权页面present弹出时animate动画设置，默认带动画，eg. @(YES)
@property(nonatomic,strong) NSNumber *clAuthWindowPresentingAnimate;
/// sdk自带返回键：授权页面dismiss时animate动画设置，默认带动画，eg. @(YES)
@property(nonatomic,strong) NSNumber *clAuthWindowDismissAnimate;
/// 弹窗的MaskLayer，用于自定义窗口形状
@property(nonatomic,strong) CALayer *clAuthWindowMaskLayer;

/// 竖屏布局配置对象 -->创建一个布局对象，设置好控件约束属性值，再设置到此属性中
/**竖屏：UIInterfaceOrientationPortrait|UIInterfaceOrientationPortraitUpsideDown
 *eg.   CLUIConfigure *baseUIConfigure = [CLUIConfigure new];
 *     CLOrientationLayOut *clOrientationLayOutPortrait = [CLOrientationLayOut new];
 *     clOrientationLayOutPortrait.clLayoutPhoneCenterY = @(0);
 *     clOrientationLayOutPortrait.clLayoutPhoneLeft = @(50*screenScale);
 *     ...
 *     baseUIConfigure.clOrientationLayOutPortrait = clOrientationLayOutPortrait;
 */
@property(nonatomic,strong) CLOrientationLayOut *clOrientationLayOutPortrait;

/// 横屏布局配置对象 -->创建一个布局对象，设置好控件约束属性值，再设置到此属性中
/**横屏：UIInterfaceOrientationLandscapeLeft|UIInterfaceOrientationLandscapeRight
 *eg.   CLUIConfigure *baseUIConfigure = [CLUIConfigure new];
 *     CLOrientationLayOut *clOrientationLayOutLandscape = [CLOrientationLayOut new];
 *     clOrientationLayOutLandscape.clLayoutPhoneCenterY = @(0);
 *     clOrientationLayOutLandscape.clLayoutPhoneLeft = @(50*screenScale);
 *     ...
 *     baseUIConfigure.clOrientationLayOutLandscape = clOrientationLayOutLandscape;
 */
@property(nonatomic,strong) CLOrientationLayOut *clOrientationLayOutLandscape;

/// 默认界面配置
+ (CLUIConfigure *)clDefaultUIConfigure;

@end



/**横竖屏布局配置对象
 配置页面布局相关属性
 */
@interface CLOrientationLayOut : NSObject
/**LOGO图片*/
/// 约束均相对vc.view
@property(nonatomic,strong) NSNumber *clLayoutLogoLeft;
@property(nonatomic,strong) NSNumber *clLayoutLogoTop;
@property(nonatomic,strong) NSNumber *clLayoutLogoRight;
@property(nonatomic,strong) NSNumber *clLayoutLogoBottom;
@property(nonatomic,strong) NSNumber *clLayoutLogoWidth;
@property(nonatomic,strong) NSNumber *clLayoutLogoHeight;
@property(nonatomic,strong) NSNumber *clLayoutLogoCenterX;
@property(nonatomic,strong) NSNumber *clLayoutLogoCenterY;

/**手机号显示控件*/
/// layout 约束均相对vc.view
@property(nonatomic,strong) NSNumber *clLayoutPhoneLeft;
@property(nonatomic,strong) NSNumber *clLayoutPhoneTop;
@property(nonatomic,strong) NSNumber *clLayoutPhoneRight;
@property(nonatomic,strong) NSNumber *clLayoutPhoneBottom;
@property(nonatomic,strong) NSNumber *clLayoutPhoneWidth;
@property(nonatomic,strong) NSNumber *clLayoutPhoneHeight;
@property(nonatomic,strong) NSNumber *clLayoutPhoneCenterX;
@property(nonatomic,strong) NSNumber *clLayoutPhoneCenterY;

/** 一键登录按钮 控件
 注： 一键登录授权按钮 不得隐藏
 */
/// layout 约束均相对vc.view
@property(nonatomic,strong) NSNumber *clLayoutLoginBtnLeft;
@property(nonatomic,strong) NSNumber *clLayoutLoginBtnTop;
@property(nonatomic,strong) NSNumber *clLayoutLoginBtnRight;
@property(nonatomic,strong) NSNumber *clLayoutLoginBtnBottom;
@property(nonatomic,strong) NSNumber *clLayoutLoginBtnWidth;
@property(nonatomic,strong) NSNumber *clLayoutLoginBtnHeight;
@property(nonatomic,strong) NSNumber *clLayoutLoginBtnCenterX;
@property(nonatomic,strong) NSNumber *clLayoutLoginBtnCenterY;

/** 隐私条款Privacy
 注： 运营商隐私条款 不得隐藏， 用户条款不限制
 */
/// layout 约束均相对vc.view
@property(nonatomic,strong) NSNumber *clLayoutAppPrivacyLeft;
@property(nonatomic,strong) NSNumber *clLayoutAppPrivacyTop;
@property(nonatomic,strong) NSNumber *clLayoutAppPrivacyRight;
@property(nonatomic,strong) NSNumber *clLayoutAppPrivacyBottom;
@property(nonatomic,strong) NSNumber *clLayoutAppPrivacyWidth;
@property(nonatomic,strong) NSNumber *clLayoutAppPrivacyHeight;
@property(nonatomic,strong) NSNumber *clLayoutAppPrivacyCenterX;
@property(nonatomic,strong) NSNumber *clLayoutAppPrivacyCenterY;

/** Slogan 运营商品牌标签："认证服务由中国移动/联通/电信提供" label
 注： 运营商品牌标签，不得隐藏
 */
/// layout 约束均相对vc.view
@property(nonatomic,strong) NSNumber *clLayoutSloganLeft;
@property(nonatomic,strong) NSNumber *clLayoutSloganTop;
@property(nonatomic,strong) NSNumber *clLayoutSloganRight;
@property(nonatomic,strong) NSNumber *clLayoutSloganBottom;
@property(nonatomic,strong) NSNumber *clLayoutSloganWidth;
@property(nonatomic,strong) NSNumber *clLayoutSloganHeight;
@property(nonatomic,strong) NSNumber *clLayoutSloganCenterX;
@property(nonatomic,strong) NSNumber *clLayoutSloganCenterY;

/** 闪验Slogan 供应商品牌标签："闪验提供技术支持" label */
/// layout 约束均相对vc.view
@property(nonatomic,strong) NSNumber *clLayoutShanYanSloganLeft;
@property(nonatomic,strong) NSNumber *clLayoutShanYanSloganTop;
@property(nonatomic,strong) NSNumber *clLayoutShanYanSloganRight;
@property(nonatomic,strong) NSNumber *clLayoutShanYanSloganBottom;
@property(nonatomic,strong) NSNumber *clLayoutShanYanSloganWidth;
@property(nonatomic,strong) NSNumber *clLayoutShanYanSloganHeight;
@property(nonatomic,strong) NSNumber *clLayoutShanYanSloganCenterX;
@property(nonatomic,strong) NSNumber *clLayoutShanYanSloganCenterY;

/** 窗口模式 */
/// 窗口中心：CGPoint X Y
@property(nonatomic,strong) NSValue *clAuthWindowOrientationCenter;
/// 窗口左上角：frame.origin：CGPoint X Y
@property(nonatomic,strong) NSValue *clAuthWindowOrientationOrigin;
/// 窗口大小：宽 float
@property(nonatomic,strong) NSNumber *clAuthWindowOrientationWidth;
/// 窗口大小：高 float
@property(nonatomic,strong) NSNumber *clAuthWindowOrientationHeight;

/// 默认布局配置 - 用于快速展示默认界面。定制UI时，请重新创建CLOrientationLayOut对象再设置属性，以避免和默认约束冲突
+ (CLOrientationLayOut *)clDefaultOrientationLayOut;

@end

NS_ASSUME_NONNULL_END
