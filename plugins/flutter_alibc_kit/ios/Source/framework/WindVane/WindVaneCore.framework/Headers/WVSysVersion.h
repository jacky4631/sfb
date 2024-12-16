/*
 * WVSysVersion.h
 * 
 * Created by WindVane.
 * Copyright (c) 2017年 阿里巴巴-淘宝技术部. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 * 返回当前系统版本是否等于指定的值。
 */
NS_INLINE BOOL sysVersionEqualTo(NSString * version) {
	return [[[UIDevice currentDevice] systemVersion] compare:version options:NSNumericSearch] == NSOrderedSame;
}

/**
 * 返回当前系统版本是否大于指定的值。
 */
NS_INLINE BOOL sysVersionGreaterThan(NSString * version) {
	return [[[UIDevice currentDevice] systemVersion] compare:version options:NSNumericSearch] == NSOrderedDescending;
}

/**
 * 返回当前系统版本是否大于等于指定的值。
 */
NS_INLINE BOOL sysVersionGreaterThanOrEqualTo(NSString * version) {
	return [[[UIDevice currentDevice] systemVersion] compare:version options:NSNumericSearch] != NSOrderedAscending;
}

/**
 * 返回当前系统版本是否小于指定的值。
 */
NS_INLINE BOOL sysVersionLessThan(NSString * version) {
	return [[[UIDevice currentDevice] systemVersion] compare:version options:NSNumericSearch] == NSOrderedAscending;
}

/**
 * 返回当前系统版本是否小于等于指定的值。
 */
NS_INLINE BOOL sysVersionLessThanOrEqualTo(NSString * version) {
	return [[[UIDevice currentDevice] systemVersion] compare:version options:NSNumericSearch] != NSOrderedDescending;
}

// 用来判断系统版本的宏，相对来说更建议使用内联函数。
#define SYS_VERSION_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYS_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYS_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYS_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYS_VERSION_LESS_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
#define SYS_LESS_THAN_OR_EQUAL_TO(v) SYS_VERSION_LESS_THAN_OR_EQUAL_TO(v)
