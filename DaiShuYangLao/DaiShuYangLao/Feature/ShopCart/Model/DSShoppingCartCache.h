//
//  DSShoppingCartCache.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/23.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSBaseModel.h"
#import <YYCache.h>

@class DSGoodsInfoModel;
@interface DSShoppingCartCache : DSBaseModel

@property (nonatomic, strong) YYCache * shoppingCartCache;

+ (instancetype)shareShoppingCartCache;

/**< 获取所有的购物车商品 */
- (NSArray *)getShoppingCartGoods;


- (void)addGoodsToShoppingCart:(DSGoodsInfoModel *)goodsModel;

@end
