//
//  DSShoppingCartDataBaseTool.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/23.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSShoppingCartDataBaseTool.h"
#import <FMDB.h>
#import "DSGoodsInfoModel.h"
#import "DSUserInfoModel.h"

static DSShoppingCartDataBaseTool * tool = nil;

static NSString * kShoppingCartPath = @"shoppingcart.sqlite";

static NSString * kShoppingCartTableName = @"shoppingcarttable";

@implementation DSShoppingCartDataBaseTool

+ (instancetype)shareInstance;{
    if (!tool) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            tool = [[DSShoppingCartDataBaseTool alloc]init];
        });
    }
    return tool;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString * filePath = [DS_PATH_CACHE stringByAppendingString:kShoppingCartPath];
        _dataBase = [[FMDatabase alloc]initWithPath:filePath];
        BOOL openSucess = [_dataBase open];
        if (!openSucess) {
            JXLog(@"数据库打开失败");
        }
        [self createTable];
    }
    return self;
}

- (void)createTable{
    if (![_dataBase open]) JXLog(@"OPEN FAIL");
    [_dataBase executeUpdate:@"CREATE TABLE IF NOT EXISTS shoppingcarttable(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE,userid TEXT,productid TEXT,goodsmodel BOLB)"];
    [_dataBase close];
}


- (void)saveGoods:(DSGoodsInfoModel *)goodsModel{
    if(!goodsModel) return;
    //将物品保存进购物车 如果已经添加过该商品 则 该商品数量加 1 如果加1后该购买数大于 库存数则不予添加
    DSGoodsInfoModel * existModel = [self queryGoodsWithId:goodsModel.goods_id];
    if (![_dataBase open]) return;
    if (existModel!=nil) {
        if (existModel.buynumber+1<=goodsModel.inventoryNum.integerValue) {
            //商品的购买数不能大于库存总量
            existModel.buynumber++;
            [self updateBuyNumberWithModel:existModel];
        }
    }else{
        NSData * data = [NSKeyedArchiver archivedDataWithRootObject:goodsModel];
        if(!data) JXLog(@"归档失败");
        [_dataBase executeUpdateWithFormat:@"INSERT INTO shoppingcarttable(userid,productid,goodsmodel) VALUES(%@,%@,%@)",[[JXAccountTool account]user_id],goodsModel.goods_id,data];
    }
}

/** 根据id查询商品 */
- (DSGoodsInfoModel *)queryGoodsWithId:(NSString *)goodsId{
    if (![_dataBase open]) return nil;
    
    DSGoodsInfoModel * goodsInfoModel = nil;
    FMResultSet *rs=[_dataBase executeQueryWithFormat:@"SELECT * FROM shoppingcarttable WHERE userid = %@ AND productid = %@",[JXAccountTool account].user_id,goodsId];
    while ([rs next])
    {
        NSData * data = [rs dataForColumn:@"goodsmodel"];
        if (data) {
            goodsInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
    }
    [rs close];
    [_dataBase close];
    
    return goodsInfoModel;
}

/** 根据id删除商品 */
- (void)deleteGoodsFormShoppingCartByGoodsId:(NSString *)goodsid{
    if (![_dataBase open]) return ;
    [_dataBase executeUpdateWithFormat:@"DELETE FROM shoppingcarttable WHERE productid=%@ AND userid=%@",goodsid,[JXAccountTool account].user_id];
    [_dataBase close];
}

/** 根据用户id删除该用户所有购物车数据 */
- (void)deleteAllGoodsFromShoppingCart{
    if (![_dataBase open]) return ;
    [_dataBase executeUpdateWithFormat:@"DELETE FROM shoppingcarttable WHERE userid=%@",[JXAccountTool account].user_id];
    [_dataBase close];
}

/** 根据用户id获取该用户所有购物车数据 */
- (NSArray *)getAllGoodsInShoppingCart{
    if (![_dataBase open]) return nil;
    
    FMResultSet *rs=[_dataBase executeQueryWithFormat:@"SELECT * FROM shoppingcarttable WHERE userid = %@ ORDER BY id DESC",[JXAccountTool account].user_id];
    NSMutableArray * dataArray = [NSMutableArray array];
    while ([rs next])
    {
        NSData * data = [rs dataForColumn:@"goodsmodel"];
        if (data) {
            DSGoodsInfoModel * goodsInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            if (goodsInfoModel) {
                [dataArray addObject:goodsInfoModel];
            }
        }
    }
    [rs close];
    [_dataBase close];
    
    return dataArray;
}

/** 增加或者减少购买数量 */
- (void)updateBuyNumberWithModel:(DSGoodsInfoModel *)goodsModel{
    if(!goodsModel) return;
    if (![_dataBase open]) return ;
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:goodsModel];
    if(!data) JXLog(@"归档失败");
    [_dataBase executeUpdateWithFormat:@"UPDATE shoppingcarttable SET goodsmodel = %@ WHERE userid = %@ AND productid = %@",data,[JXAccountTool account].user_id,goodsModel.goods_id];
    [_dataBase close];
}

@end
