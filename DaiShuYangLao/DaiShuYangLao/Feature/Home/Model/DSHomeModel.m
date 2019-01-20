//
//  DSHomeModel.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/15.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSHomeModel.h"
#import "DSBannerModel.h"
#import "DSHomeClassificationModel.h"
#import "DSGoodsInfoModel.h"
@implementation DSHomeModel
MJCodingImplementation
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"banners":[DSBannerModel class],@"sections":[DSHomeClassificationModel class],@"popupAds":[DSBannerModel class]};
}

@end

@implementation HomeAdvertModel

MJCodingImplementation

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"banners":[DSBannerModel class]};
}

@end

@implementation HomeProductModel

MJCodingImplementation

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"products":[DSGoodsInfoModel class]};
}

@end
