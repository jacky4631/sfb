//
//  WVUserConfig+WVPrivate.h
//  Core
//
//  Created by lianyu.ysj on 2017/11/30.
//  Copyright © 2017年 WindVane. All rights reserved.
//

#import <WindVaneCore/WVUserConfig.h>
#import <Foundation/Foundation.h>

#define WVLocalizedString(KEY, VALUE) [WVUserConfig localizedStringForKey:(KEY) value:(VALUE)]
// 基本
#define WVLocalizedOK WVLocalizedString(@"WV_OK", @"确定")
#define WVLocalizedCancel WVLocalizedString(@"WV_Cancel", @"取消")
// 刷新
#define WVLocalizedPageLoading WVLocalizedString(@"WV_PageLoading", @"正在加载")
#define WVLocalizedPullToRefresh WVLocalizedString(@"WV_PullToRefresh", @"下拉即可刷新...")
#define WVLocalizedReleaseToRefresh WVLocalizedString(@"WV_ReleaseToRefresh", @"释放即可刷新...")
#define WVLocalizedPullToRefreshLoading WVLocalizedString(@"WV_PullToRefresh_Loading", @"加载中...")
// 保存图片
#define WVLocalizedAskSaveImage WVLocalizedString(@"WV_AskSaveImage", @"保存图片?")
#define WVLocalizedSaveImage WVLocalizedString(@"WV_SaveImage", @"保存")
#define WVLocalizedSaveImageSuccess WVLocalizedString(@"WV_SaveImageSuccess", @"图片保存成功")
#define WVLocalizedSaveImageFailed WVLocalizedString(@"WV_SaveImageFailed", @"图片保存失败")
// 拍照上传
#define WVLocalizedChoosePhotoSource WVLocalizedString(@"WV_ChoosePhotoSource", @"请选择照片来源")
#define WVLocalizedChooseCamera WVLocalizedString(@"WV_ChooseCamera", @"拍照")
#define WVLocalizedChoosePhotoLibrary WVLocalizedString(@"WV_ChoosePhotoLibrary", @"相册")
#define WVLocalizedChoosePhotoFromLibrary WVLocalizedString(@"WV_ChoosePhotoFromLibrary", @"选取照片")
#define WVLocalizedChoosePhotoLimit WVLocalizedString(@"WV_ChoosePhotoLimit", @"最多选择%lu张照片")
#define WVLocalizedChoosePhotoLimitConfirm WVLocalizedString(@"WV_ChoosePhotoLimit_Confirm", @"知道了")
// 错误信息
#define WVLocalizedErrorNoNetwork WVLocalizedString(@"WV_ErrorNoNetwork", @"无法连接到网络")
#define WVLocalizedErrorSSLError WVLocalizedString(@"WV_ErrorSSLError", @"SSL 连接错误")
#define WVLocalizedErrorDownloadFailed WVLocalizedString(@"WV_ErrorDownloadFailed", @"下载失败")
#define WVLocalizedErrorLoadFailed WVLocalizedString(@"WV_ErrorLoadFailed", @"加载失败")

@interface WVUserConfig (WVPrivate)

/**
 本地化指定的文本。
 */
+ (NSString * _Nonnull)localizedStringForKey:(NSString * _Nonnull)key value:(NSString * _Nonnull)value;

@end
