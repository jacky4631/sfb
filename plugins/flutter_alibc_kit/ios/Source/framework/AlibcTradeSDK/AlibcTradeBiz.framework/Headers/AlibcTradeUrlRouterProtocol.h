//
//  AlibcTradeUrlRouterProtocol.h
//  AlibcTradeBiz
//
//  Created by zhongweitao on 2020/11/9.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol AlibcTradeUrlRouterProtocol <NSObject>

- (void)openURL:(NSString *)urlStr onViewController:(UIViewController *)vc withParam:(NSDictionary *)param;

@end
