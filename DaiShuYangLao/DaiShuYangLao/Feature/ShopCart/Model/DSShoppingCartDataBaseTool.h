//
//  DSShoppingCartDataBaseTool.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/23.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSBaseModel.h"
#import <FMDB.h>
@class DSGoodsInfoModel;
@interface DSShoppingCartDataBaseTool : DSBaseModel

@property (nonatomic, strong) FMDatabase * dataBase;

+ (instancetype)shareInstance;

/** 加入购物车 */
- (void)saveGoods:(DSGoodsInfoModel *)goodsModel;

/** 根据id查询商品 */
- (DSGoodsInfoModel *)queryGoodsWithId:(NSString *)goodsId;

/** 根据id删除商品 */
- (void)deleteGoodsFormShoppingCartByGoodsId:(NSString *)goodsid;

/** 根据用户id删除该用户所有购物车数据 */
- (void)deleteAllGoodsFromShoppingCart;

/** 根据用户id获取该用户所有购物车数据 */
- (NSArray *)getAllGoodsInShoppingCart;

/** 增加或者减少购买数量 */
- (void)updateBuyNumberWithModel:(DSGoodsInfoModel *)goodsModel;

@end
