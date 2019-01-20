//
//  DSHomeClassificationModel.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/15.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSHomeClassificationModel.h"

@implementation DSHomeClassificationModel
MJCodingImplementation
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"classification_id":@"id"};
}

@end
