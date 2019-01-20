//
//  DSBannerModel.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/6.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSBaseModel.h"

@interface DSBannerModel : DSBaseModel<NSCoding>

@property (nonatomic, copy) NSString * banner_id;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * pic;
@property (nonatomic, copy) NSString * type;   // 0=无，1=商品id跳转到商品详情，2=web,3=分类,跳转到分类产品列表  4 根据bannerId.配置的商品列表
@property (nonatomic, copy) NSString * action; //0=无，1=商品id跳转到商品详情，2=web,3=分类,跳转到分类产品列表 4 bannerId 

@property (nonatomic, copy) NSString * orderValue;
@property (nonatomic, copy) NSArray * products;

@end
