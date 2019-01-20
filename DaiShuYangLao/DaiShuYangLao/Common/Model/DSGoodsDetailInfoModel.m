//
//  DSGoodsDetailInfoModel.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/14.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSGoodsDetailInfoModel.h"

@implementation DSGoodsDetailInfoModel
MJCodingImplementation
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"goods_id":@"id",@"isExclusive":@"newExclusive"};
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"properties":[GoodsPropertyModel class],@"skus":[GoodsDetailSaleInfo class],@"pics":[NSString class],@"contents":[GoodsDetailContentModel class]};
}

@end


@implementation GoodsDetailSaleInfo
MJCodingImplementation
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"sku_id":@"id"};
}

@end


@implementation GoodsPropertyModel
MJCodingImplementation
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"property_id":@"id"};
}

@end


@implementation GoodsDetailContentModel
MJCodingImplementation

@end

