//
//  DSMembershipInfoModel.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/21.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSMembershipInfoModel.h"
#import "DSBannerModel.h"
@implementation DSMembershipInfoModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"banners":[DSBannerModel class],@"orderNum":[NSNumber class]};
}

@end
