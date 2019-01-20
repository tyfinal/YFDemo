//
//  DSHomeClassificationModel.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/15.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSBaseModel.h"

@interface DSHomeClassificationModel : DSBaseModel<NSCoding>

@property (nonatomic, copy) NSString * classification_id;
@property (nonatomic, copy) NSString * name; //名称
@property (nonatomic, copy) NSString * icon; //图标
@property (nonatomic, copy) NSString * type; // 0=栏目产品列表，1=商品，2=web,3=分类id                  ”action”:”123123”;//
@property (nonatomic, copy) NSString * action;

@property (nonatomic, strong) NSData * imageData;

@end
