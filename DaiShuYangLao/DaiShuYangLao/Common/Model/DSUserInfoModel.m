//
//  DSUserInfoModel.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/12.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSUserInfoModel.h"

@implementation DSUserInfoModel

MJCodingImplementation

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"user_id":@"id"};
}


@end
