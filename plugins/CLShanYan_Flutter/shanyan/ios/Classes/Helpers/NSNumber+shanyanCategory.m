//
//  NSNumber+shanyanCategory.m
//  CL_ShanYanSDK
//
//  Created by wanglijun on 2020/2/4.
//

#import "NSNumber+shanyanCategory.h"

@implementation NSNumber (shanyanCategory)
-(instancetype)clShanYanNegative{
    if (![self isKindOfClass:NSNumber.class]) {
        return nil;
    }
    return [NSNumber numberWithFloat:-self.floatValue];
}
@end
