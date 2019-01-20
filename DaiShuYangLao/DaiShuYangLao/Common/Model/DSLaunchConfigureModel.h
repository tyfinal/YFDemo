//
//  DSLaunchConfigureModel.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/12.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DSBannerModel;
@class LaunchConfigureAreaModel;
@class LaunchConfigureUpgradeModel;
@interface DSLaunchConfigureModel : DSBaseModel<NSCoding>

@property (nonatomic, strong) DSBannerModel * bootPic; /** 广告图 <*/
@property (nonatomic, copy) NSString * serverTimestamp;
@property (nonatomic, copy) NSString * vip;        /**< 领航会员入口 0关闭 1开启 */
@property (nonatomic, copy) NSString * serviceTel; /**< 客服电话 */
@property (nonatomic, copy) NSString * orderUsePointMinAmountLimit;
@property (nonatomic, copy) NSString * shareProduct;
@property (nonatomic, copy) NSString * inviteFirstRewardPointMsg;
@property (nonatomic, strong) LaunchConfigureAreaModel * area;

+ (void)saveConfigureModel:(DSLaunchConfigureModel *)configureModel;

+ (DSLaunchConfigureModel *)configureModel;

@end

@interface LaunchConfigureAreaModel : DSBaseModel<NSCoding>

@property (nonatomic, copy) NSString * url;
@property (nonatomic, copy) NSString * updateTime;

@end


@interface LaunchConfigureUpgradeModel : DSBaseModel<NSCoding>

@property (nonatomic, copy) NSString * version; //app版本
@property (nonatomic, copy) NSString * versionCode; //版本号,判断这个值是否大于当前应用的内的值升级
@property (nonatomic, copy) NSString * desc; //升级说明
@property (nonatomic, copy) NSString * downloadUrl; //下载地址
@property (nonatomic, copy) NSString * force;       //是否强制更新，true=是


@end






