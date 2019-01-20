//
//  DSClassificationModel.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/13.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSBaseModel.h"

@interface DSClassificationModel : DSBaseModel<NSCoding>

@property (nonatomic, copy) NSString * classification_id;
@property (nonatomic, copy) NSString * icon;
@property (nonatomic, copy) NSString * name;

@property (nonatomic, strong) NSArray * subClassifications;

@end
