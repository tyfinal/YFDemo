//
//  DSBrandModel.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/21.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSBaseModel.h"

@interface DSBrandModel : DSBaseModel<NSCoding>

@property (nonatomic, copy) NSString * brand_id;
@property (nonatomic, copy) NSString * logo;
@property (nonatomic, copy) NSString * name;

@end
