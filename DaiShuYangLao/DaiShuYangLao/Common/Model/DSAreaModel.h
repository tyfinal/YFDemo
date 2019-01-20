//
//  DSAreaModel.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/5/31.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSBaseModel.h"

@interface DSAreaModel : DSBaseModel

@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * code;
@property (nonatomic, copy) NSArray * child;

@end
