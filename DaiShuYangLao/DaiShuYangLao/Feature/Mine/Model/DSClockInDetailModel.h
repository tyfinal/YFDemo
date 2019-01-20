//
//  DSClockInDetailModel.h
//  DaiShuYangLao
//
//  Created by YueLiang Song on 2018/8/8.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSBaseModel.h"

@interface DSClockInDetailModel : DSBaseModel

@property (nonatomic, copy) NSString * status;
@property (nonatomic, copy) NSString * gold;
@property (nonatomic, copy) NSString * days;
@property (nonatomic, copy) NSArray * info;
@property (nonatomic, strong) NSArray * adv;

@end
