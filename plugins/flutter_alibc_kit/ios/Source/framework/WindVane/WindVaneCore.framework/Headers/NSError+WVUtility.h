/*
 * NSError+WVUtility.h
 * 
 * Created by WindVane.
 * Copyright (c) 2017年 阿里巴巴-淘宝技术部. All rights reserved.
 */

#import <Foundation/Foundation.h>

/**
 * 常见错误的分类。
 */
typedef NS_ENUM(NSInteger, WVErrorKind) {
	/**
	 * 未分类错误。
	 */
	WVErrorKindUnknown,
	/**
	 * 可忽略的错误（被用户取消）。
	 */
	WVErrorKindIgnorable,
	/**
	 * 无网络错误。
	 */
	WVErrorKindNoNetwork,
	/**
	 * SSL 错误。
	 */
	WVErrorKindSSL,
	/**
	 * 下载错误。
	 */
	WVErrorKindDownload,
};

/**
 * 提供 NSError 类的扩展方法。
 */
@interface NSError (WVUtility)

/**
 * 返回当前错误的类型。
 */
- (WVErrorKind)wvErrorKind;

@end
