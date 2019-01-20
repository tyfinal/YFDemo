//
//  DSWithdrawCashConfigureModel.m
//  DaiShuYangLao
//
//  Created by YueLiang Song on 2018/7/27.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSWithdrawCashConfigureModel.h"

@implementation DSWithdrawCashConfigureModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"withdrawMinimumLimit":@"withdrawHoldMinimum"};
}

@end
