//
//  DSOrderListModel.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/28.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSOrderListModel.h"
#import "DSOrderInfoModel.h"
@implementation DSOrderListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"order_id":@"id"};
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"products":[OrderProductInfoModel class]};
}

@end
