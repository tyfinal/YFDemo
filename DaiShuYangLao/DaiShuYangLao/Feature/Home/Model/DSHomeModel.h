//
//  DSHomeModel.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/15.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSBaseModel.h"

@class HomeAdvertModel;
@class HomeProductModel;
@interface DSHomeModel : DSBaseModel<NSCoding>

@property (nonatomic, copy) NSArray * banners;
@property (nonatomic, copy) NSArray * sections;
@property (nonatomic, copy) NSArray * popupAds;

@property (nonatomic, strong) HomeAdvertModel * ads;
@property (nonatomic, strong) HomeAdvertModel * recommendAds;
@property (nonatomic, strong) HomeAdvertModel * events;
@property (nonatomic, strong) HomeProductModel * youLike;


@end


@interface HomeAdvertModel : DSBaseModel

@property (nonatomic, copy) NSString * titleImg;
@property (nonatomic, copy) NSArray * banners;

@end

@interface HomeProductModel : DSBaseModel

@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * titleImg;
@property (nonatomic, copy) NSArray * products;

@end

