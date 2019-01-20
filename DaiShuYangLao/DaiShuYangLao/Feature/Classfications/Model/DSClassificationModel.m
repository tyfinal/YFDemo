//
//  DSClassificationModel.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/13.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSClassificationModel.h"

@implementation DSClassificationModel

MJCodingImplementation

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"subClassifications":[DSClassificationModel class]};
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"classification_id" : @"id",@"subClassifications":@"child"};
}

@end
