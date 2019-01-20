//
//  YJAccountTool.m
//  YJRRT
//
//  Created by kongxiaopeng on 15/7/13.
//  Copyright (c) 2015年 ky. All rights reserved.
//

//账号的存储路径
#define JXAccountPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.archive"]
#import "JXAccountTool.h"
#import "DSUserInfoModel.h"

@implementation JXAccountTool
/**
 *  存储账号信息
 *
 *  @param account 账号模型
 */
+ (void)saveAccount:(DSUserInfoModel *)account{
    // 自定义对象的存储必须用NSKeyedArchiver，不再有什么writeToFile方法
    [NSKeyedArchiver archiveRootObject:account toFile:JXAccountPath];
}

/**
 *  删除账号信息
 *
 *  @param account 账号模型
 */
+ (void)logOutAccount{
    DSUserInfoModel * account = [self account];
    if (account) {
        DSUserInfoModel * freeAccount = [[DSUserInfoModel alloc]init];
        freeAccount.phone = account.phone;
        [self saveAccount:freeAccount];
    }
}

/**
 *  返回账号信息
 */
+ (DSUserInfoModel *)account{
    //加载模型
    DSUserInfoModel* account = [NSKeyedUnarchiver unarchiveObjectWithFile:JXAccountPath];
    return account;
}

@end
