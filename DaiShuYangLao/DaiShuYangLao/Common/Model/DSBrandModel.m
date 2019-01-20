//
//  DSBrandModel.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/21.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSBrandModel.h"

@implementation DSBrandModel
MJCodingImplementation
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"brand_id":@"id"};
}

@end
