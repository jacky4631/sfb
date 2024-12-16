//
//  PersistentStorage.h
//  mtopsdk
//
//  Created by sihai on 19/5/15.
//  Copyright (c) 2015 mtop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TBSDKPersistentStorage: NSObject

/*!
 * 获取类似NSUserDefaults的standardUserDefaults, 该存储会被icloud备份和恢复
 *
 * @return
 *              NSUserDefaults
 */
+ (NSUserDefaults*) standardStorage;

/*!
 * 获取存储实例该存储不会被icloud备份和恢复
 * @return
 *              NSUserDefaults子类
 */
+ (TBSDKPersistentStorage*) storageWithoutICloudBackup;

/*!
 * 获取指定key的值
 * @param key
 * @return
 *
 */
- (id) objectForKey:(NSString*) key;

/*!
 * 获取指定key的值
 * @param key
 * @return
 *
 */
- (id) valueForKey: (NSString*) key;

/*!
 * 获取double值
 *
 */
- (BOOL) boolForKey: (NSString*) key;

/*!
 * 获取double值
 *
 */
- (double) doubleForKey: (NSString*) key;

/*!
 * 获取int值
 *
 */
- (int) integerForKey: (NSString*) key;

/*!
 * 获取long值
 *
 */
- (long) longForKey: (NSString*) key;

/*!
 * 获取long long值
 *
 */
- (long long) longLongForKey: (NSString*) key;

/*!
 * 设置指定key的值
 * @param value
 * @param key
 * @return
 *
 */
- (void) setObject: (id) value forKey: (NSString*) key;

/*!
 * 删除指定key的值
 * @param key
 *
 */
- (void) removeObjectForKey: (NSString*) key;

/*!
 * 刷新内存中的改动到磁盘
 * @param key
 *
 */
- (void) flush;

@end
