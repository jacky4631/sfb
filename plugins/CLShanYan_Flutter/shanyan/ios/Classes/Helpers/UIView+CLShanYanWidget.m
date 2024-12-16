//
//  UIView+CLShanYanWidget.m
//  CLShanYanSDKHbuilderPlugin
//
//  Created by wanglijun on 2019/11/12.
//  Copyright © 2019 wanglijun. All rights reserved.
//

#import "UIView+CLShanYanWidget.h"
#import <objc/runtime.h>

@implementation UIView (CLShanYanWidget)
-(NSString *)widgetId{
    return objc_getAssociatedObject(self, _cmd);
    //return objc_getAssociatedObject(self, &kAssociatedNewName);
}

-(void)setWidgetId:(NSString *)widgetId{
    objc_setAssociatedObject(self, @selector(widgetId), widgetId, OBJC_ASSOCIATION_COPY_NONATOMIC);
    //objc_setAssociatedObject(self, &kAssociatedNewName, newName, OBJC_ASSOCIATION_RETAIN);
}

-(BOOL)isFinish{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
    //return objc_getAssociatedObject(self, &kAssociatedNewName);
}

-(void)setIsFinish:(BOOL)isFinish{
    objc_setAssociatedObject(self, @selector(isFinish), @(isFinish), OBJC_ASSOCIATION_ASSIGN);
    //objc_setAssociatedObject(self, &kAssociatedNewName, newName, OBJC_ASSOCIATION_RETAIN);
}
@end
