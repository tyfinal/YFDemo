//
//  UXAccountTool.h
//  YJRRT
//
//  Created by kongxiaopeng on 15/7/13.
//  Copyright (c) 2015年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DSUserInfoModel;

@interface JXAccountTool : NSObject
/**
 *  存储账号信息
 *
 *  @param account 账号模型
 */
+ (void)saveAccount:(DSUserInfoModel *)account;

/**
 *  删除账号信息
 */
+ (void)logOutAccount;

/**
 *  返回账号信息
 */
+ (DSUserInfoModel *)account;

@end
