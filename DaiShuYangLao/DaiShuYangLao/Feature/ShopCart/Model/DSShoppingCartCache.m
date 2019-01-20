//
//  DSShoppingCartCache.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/23.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSShoppingCartCache.h"
#import <YYCache.h>
#import "DSGoodsInfoModel.h"
#import "DSUserInfoModel.h"

//#import "<#header#>"
static DSShoppingCartCache * shoppingCart = nil;

static NSString * const kShoppingCartCacheName = @"ShoppingCartCache";

static NSString * const kShoopingCartKeyPrefixString = @"shop_";

@implementation DSShoppingCartCache

+ (instancetype)shareShoppingCartCache{
    if (!shoppingCart) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            shoppingCart = [[DSShoppingCartCache alloc]init];
        });
    }
    return shoppingCart;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _shoppingCartCache = [YYCache cacheWithName:kShoppingCartCacheName];
    }
    return self;
}

/**< 获取所有的购物车商品 */
- (NSArray *)getShoppingCartGoods{
    DSUserInfoModel * account = [JXAccountTool account];
    NSArray * array = (NSArray *)[self.shoppingCartCache objectForKey:account.user_id];
    return array;
}

- (void)addGoodsToShoppingCart:(DSGoodsInfoModel *)goodsModel{
    [self.shoppingCartCache.diskCache setObject:goodsModel forKey:goodsModel.goods_id];
}


@end
