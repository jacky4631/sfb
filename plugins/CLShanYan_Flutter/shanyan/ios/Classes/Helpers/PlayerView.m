//
//  PlayerView.m
//  ShanYanSDK_Demo
//
//  Created by ydong on 2021/12/10.
//  Copyright © 2021 yadong. All rights reserved.
//

#import "PlayerView.h"
#import <AVFoundation/AVPlayerLayer.h>

@implementation PlayerView

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
