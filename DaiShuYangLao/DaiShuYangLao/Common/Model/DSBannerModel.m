//
//  DSBannerModel.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/6.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSBannerModel.h"
@class DSGoodsInfoModel;
@implementation DSBannerModel

MJCodingImplementation

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"banner_id":@"id"};
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"products":[DSGoodsInfoModel class]};
}

@end
