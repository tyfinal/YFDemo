//
//  DSOrderInfoModel.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/14.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSOrderInfoModel.h"

@implementation DSOrderInfoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"order_id":@"id"};
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"products":[OrderProductInfoModel class]};
}

@end


@implementation OrderProductInfoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"goods_id":@"id"};
}

@end



@implementation OrderLogisticsModel


@end



@implementation OrderShippingAddressModel

@end

@implementation OrderMerchantModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"merchant_id" : @"id"};
}


@end

@implementation OrderSkuModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"sku_id" : @"id"};
}

@end




