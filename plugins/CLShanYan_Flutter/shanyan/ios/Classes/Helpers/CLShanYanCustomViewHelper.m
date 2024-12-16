//
//  CLShanYanCustomViewHelper.m
//  CLShanYanSDKHbuilderPlugin
//
//  Created by wanglijun on 2019/11/12.
//  Copyright © 2019 wanglijun. All rights reserved.
//

#import "CLShanYanCustomViewHelper.h"

@implementation CLShanYanCustomViewCongifure
-(void)dealloc{
    NSLog(@"%s",__func__);
}
//- (void)setTitle:(nullable NSString *)title forState:(UIControlState)state{
//    [self.customButton setTitle:title forState:state];
//}
//- (void)setTitleColor:(nullable UIColor *)color forState:(UIControlState)state {
//    [self.customButton setTitleColor:color forState:state];
//}
//- (void)setTitleShadowColor:(nullable UIColor *)color forState:(UIControlState)state{
//    [self.customButton setTitleShadowColor:color forState:state];
//}
//- (void)setImage:(nullable UIImage *)image forState:(UIControlState)state{
//    [self.customButton setImage:image forState:state];
//}
//- (void)setBackgroundImage:(nullable UIImage *)image forState:(UIControlState)state {
//    [self.customButton setBackgroundImage:image forState:state];
//}
//- (void)setAttributedTitle:(nullable NSAttributedString *)title forState:(UIControlState)state{
//    [self.customButton setAttributedTitle:title forState:state];
//}

//UIButton通用属性
-(void)setCustonButtonProperty:(UIButton *)customButton{
        
    if (self.button_textColor) {
        [customButton setTitleColor:self.button_textColor forState:(UIControlStateNormal)];
    }
    if (self.button_textContent) {
        [customButton setTitle:self.button_textContent forState:(UIControlStateNormal)];
    }
    if (self.button_image) {
        [customButton setImage:self.button_image forState:(UIControlStateNormal)];
    }
    if (self.button_backgroundImage) {
        [customButton setBackgroundImage:self.button_backgroundImage  forState:(UIControlStateNormal)];
    }
    
    if (self.button_contentEdgeInsets) {
        [customButton setTitleEdgeInsets:self.button_contentEdgeInsets.UIEdgeInsetsValue];
    }
    if (self.button_titleEdgeInsets) {
        [customButton setTitleEdgeInsets:self.button_titleEdgeInsets.UIEdgeInsetsValue];
    }
    if (self.button_imageEdgeInsets) {
        [customButton setTitleEdgeInsets:self.button_imageEdgeInsets.UIEdgeInsetsValue];
    }
    
    if (self.button_tintColor) {
        [customButton setTintColor:self.button_tintColor];
    }
    
    if (self.button_titleLabelFont) {
        [customButton.titleLabel setFont:self.button_titleLabelFont];
    }
    
    if (self.button_enabled!=nil) {
        [customButton setEnabled:self.button_enabled.boolValue];
    }
    
    if (self.button_numberOfLines!=nil) {
        [customButton.titleLabel setNumberOfLines:self.button_numberOfLines.integerValue];
    }
    
    if (self.button_contentVerticalAlignment!=nil) {
        [customButton setContentVerticalAlignment:self.button_contentVerticalAlignment.integerValue];
    }
    if (self.button_contentHorizontalAlignment!=nil) {
        [customButton setContentHorizontalAlignment:self.button_contentHorizontalAlignment.integerValue];
    }
}

//UILabel
-(void)setCustonLabelProperty:(UILabel *)customLabel{
    if (self.label_text) {
        [customLabel setText:self.label_text];
    }
    if (self.label_font) {
        [customLabel setFont:self.label_font];
    }
    if (self.label_text) {
        [customLabel setText:self.label_text];
    }
    if (self.label_textColor) {
        [customLabel setTextColor:self.label_textColor];
    }
    if (self.label_numberOfLines!=nil) {
        [customLabel setNumberOfLines:self.label_numberOfLines.integerValue];
    }
    if (self.label_textAlignment!=nil) {
        [customLabel setTextAlignment:self.label_textAlignment.integerValue];
    }
}


-(void)setCustonImageViewProperty:(UIImageView *)customImageView{
    if (self.imageView_image) {
        customImageView.image = self.imageView_image;
    }
}

//UIView通用属性
-(void)setCustonViewProperty:(UIView *)customView{
    if (self.userInteractionEnabled!=nil) {
        [customView setUserInteractionEnabled:self.userInteractionEnabled.boolValue];
    }
    if (self.tag!=nil) {
        [customView setTag:self.tag.integerValue];
    }
    if (self.contentMode!=nil) {
        [customView setContentMode:self.contentMode.integerValue];
    }
    if (self.backgroundColor) {
        [customView setBackgroundColor:self.backgroundColor];
    }
    if (self.clipsToBounds!=nil) {
        [customView setClipsToBounds:self.clipsToBounds.integerValue];
    }
    if (self.hidden!=nil) {
        [customView setHidden:self.hidden.boolValue];
    }
    if (self.alpha!=nil) {
        [customView setAlpha:self.alpha.floatValue];
    }
}
//CALayer通用属性
-(void)setCustonLayerProperty:(UIView *)customView{
    if (self.layer_cornerRadius!=nil) {
        customView.layer.cornerRadius = self.layer_cornerRadius.floatValue;
    }
    
    if (self.layer_borderWidth!=nil) {
        customView.layer.borderWidth = self.layer_borderWidth.floatValue;
    }
    
    if (self.layer_borderColor) {
        customView.layer.borderColor = self.layer_borderColor;
        
    }
    
    if (self.layer_masksToBounds!=nil) {
        customView.layer.masksToBounds = self.layer_masksToBounds.boolValue;
    }
}
@end

@implementation CLShanYanCustomViewHelper
+(UIButton*)customButtonWithCongifure:(CLShanYanCustomViewCongifure *)customButtonCongifure{
    if (customButtonCongifure == nil) {
        return nil;
    }
    
    UIButton * customButton = [[UIButton alloc]init];
    customButtonCongifure.customButton = customButton;
    
    [customButtonCongifure setCustonButtonProperty:customButton];
    
    [customButtonCongifure setCustonViewProperty:customButton];
    [customButtonCongifure setCustonLayerProperty:customButton];

    return customButton;
}
+(UILabel*)customLabelWithCongifure:(CLShanYanCustomViewCongifure *)customLabelCongifure{
    UILabel * customLabel = [[UILabel alloc]init];
    customLabelCongifure.customLabel = customLabel;
    
    [customLabelCongifure setCustonLabelProperty:customLabel];
    
    [customLabelCongifure setCustonViewProperty:customLabel];
    [customLabelCongifure setCustonLayerProperty:customLabel];
    return customLabel;
}
+(UIImageView*)customImageViewWithCongifure:(CLShanYanCustomViewCongifure *)customImageViewCongifure{
    UIImageView * imageView = [[UIImageView alloc]init];
    
    customImageViewCongifure.customImageView = imageView;
    
    [customImageViewCongifure setCustonImageViewProperty:imageView];
    
    [customImageViewCongifure setCustonViewProperty:imageView];
    [customImageViewCongifure setCustonLayerProperty:imageView];
    
    return imageView;
}


+(UIColor *)rgbaToUIColor:(id)rgba{
    if (rgba == nil) {
        return nil;
    }
    if (![rgba isKindOfClass:[NSArray class]]) {
        return nil;
    }
    if ([(NSArray *)rgba count] != 4) {
        return nil;
    }
    
    return [UIColor colorWithRed:[rgba[0] floatValue] green:[rgba[1] floatValue] blue:[rgba[2] floatValue] alpha:[rgba[3] floatValue]];
}
@end
