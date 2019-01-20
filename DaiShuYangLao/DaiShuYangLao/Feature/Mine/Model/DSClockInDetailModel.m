//
//  DSClockInDetailModel.m
//  DaiShuYangLao
//
//  Created by YueLiang Song on 2018/8/8.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSClockInDetailModel.h"
#import "DSBannerModel.h"
@implementation DSClockInDetailModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"info":[NSString class],@"adv":[DSBannerModel class]};
}

@end
