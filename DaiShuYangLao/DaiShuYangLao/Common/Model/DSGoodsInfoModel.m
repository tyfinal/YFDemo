//
//  DSGoodsInfoModel.m
//  KyBook
//
//  Created by tyfinal on 2018/6/13.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "DSGoodsInfoModel.h"

@implementation DSGoodsInfoModel
MJCodingImplementation
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"goods_id" : @"id"};
}

@end


@implementation BrandModel
MJCodingImplementation

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"brand_id" : @"id"};
}

@end


