//
//  CLShanYanCustomViewHelper.h
//  CLShanYanSDKHbuilderPlugin
//
//  Created by wanglijun on 2019/11/12.
//  Copyright © 2019 wanglijun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLShanYanCustomViewCongifure : NSObject
@property(nonatomic,weak)UIButton * customButton;
@property(nonatomic,weak)UILabel * customLabel;
@property(nonatomic,weak)UIImageView * customImageView;

//CALayer
@property NSNumber * layer_cornerRadius;
@property NSNumber * layer_borderWidth;
@property(nullable) CGColorRef layer_borderColor;
@property float layer_opacity;
/** Shadow properties. **/
@property(nullable) CGColorRef layer_shadowColor;
@property float layer_shadowOpacity;
@property CGSize layer_shadowOffset;
@property NSNumber * layer_shadowRadius;
@property NSNumber * layer_masksToBounds;

//UIView
@property(nonatomic,getter=isUserInteractionEnabled) NSNumber * userInteractionEnabled;  // default is YES. if set to NO, user events (touch, keys) are ignored and removed from the event queue.
@property(nonatomic)                                 NSNumber * tag;
@property(nonatomic)                 NSNumber * contentMode;
@property(nullable, nonatomic,copy)            UIColor          *backgroundColor;
@property(nonatomic)                 NSNumber *              clipsToBounds;
@property(nonatomic,getter=isHidden) NSNumber *              hidden;
@property(nonatomic)                 NSNumber *           alpha;

//UIButton
@property(nonatomic)UIColor * button_textColor;
@property(nonatomic)NSString * button_textContent;
@property(nonatomic)UIImage * button_image;
@property(nonatomic)UIImage * button_backgroundImage;

@property(nonatomic)UIFont * button_titleLabelFont;
@property(nonatomic)NSNumber * button_numberOfLines;

@property(nonatomic,getter=isEnabled) NSNumber * button_enabled;
@property(nonatomic) NSNumber * button_contentVerticalAlignment;     // how to position content vertically inside control. default is center
@property(nonatomic) NSNumber * button_contentHorizontalAlignment;

@property(nonatomic)          NSValue * button_contentEdgeInsets UI_APPEARANCE_SELECTOR; // default is UIEdgeInsetsZero. On tvOS 10 or later, default is nonzero except for custom buttons.
@property(nonatomic)          NSValue * button_titleEdgeInsets;
@property(nonatomic)          NSValue * button_imageEdgeInsets;
@property(nonatomic)   UIColor     *button_tintColor;

//UIlabel
@property(nullable, nonatomic,copy)   NSString           *label_text; // default is nil
@property(nullable, nonatomic,strong) UIFont      *label_font UI_APPEARANCE_SELECTOR; // default is nil (system font 17 plain)
@property(nullable, nonatomic,strong) UIColor     *label_textColor UI_APPEARANCE_SELECTOR; // default is labelColor
@property(nullable, nonatomic,strong) UIColor            *label_shadowColor UI_APPEARANCE_SELECTOR; // default is nil (no shadow)
@property(nonatomic)        CGSize             label_shadowOffset UI_APPEARANCE_SELECTOR; // default is CGSizeMake(0, -1) -- a top shadow
@property(nonatomic)        NSNumber *    label_textAlignment;   // default is NSTextAlignmentNatural (before iOS 9, the default was NSTextAlignmentLeft)
@property(nonatomic)        NSNumber *    label_lineBreakMode;   // default is NSLineBreakByTruncatingTail. used for single and multiple lines of text

// the underlying attributed string drawn by the label, if set, the label ignores the properties above.
@property(nullable, nonatomic,copy)   NSAttributedString *label_attributedText API_AVAILABLE(ios(6.0));  // default is nil

// the 'highlight' property is used by subclasses for such things as pressed states. it's useful to make it part of the base class as a user property

@property(nullable, nonatomic,strong)               UIColor *label_highlightedTextColor UI_APPEARANCE_SELECTOR; // default is nil
@property(nonatomic,getter=isHighlighted) BOOL     label_highlighted;          // default is NO

// this determines the number of lines to draw and what to do when sizeToFit is called. default value is 1 (single line). A value of 0 means no limit
// if the height of the text reaches the # of lines or the height of the view is less than the # of lines allowed, the text will be
// truncated using the line break mode.

@property(nonatomic) NSNumber * label_numberOfLines;

// these next 3 properties allow the label to be autosized to fit a certain width by scaling the font size(s) by a scaling factor >= the minimum scaling factor
// and to specify how the text baseline moves when it needs to shrink the font.

@property(nonatomic) NSNumber * label_adjustsFontSizeToFitWidth;         // default is NO
@property(nonatomic) UIBaselineAdjustment label_baselineAdjustment; // default is UIBaselineAdjustmentAlignBaselines
@property(nonatomic) CGFloat label_minimumScaleFactor API_AVAILABLE(ios(6.0)); // default

//UIImageView
@property(nonatomic)UIImage * imageView_image;

@end


@interface CLShanYanCustomViewHelper : NSObject
+(UIButton*)customButtonWithCongifure:(CLShanYanCustomViewCongifure *)customButtonCongifure;
+(UILabel*)customLabelWithCongifure:(CLShanYanCustomViewCongifure *)customLabelCongifure;
+(UIImageView*)customImageViewWithCongifure:(CLShanYanCustomViewCongifure *)customImageViewCongifure;

+(nullable UIColor *)rgbaToUIColor:(id)rgba;
@end

NS_ASSUME_NONNULL_END
