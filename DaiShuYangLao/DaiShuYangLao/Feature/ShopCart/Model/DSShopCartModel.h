//
//  DSShopCartModel.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/25.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSBaseModel.h"
@class DSGoodsInfoModel;
@class GoodsDetailSaleInfo;
@interface DSShopCartModel : DSBaseModel

@property (nonatomic, copy) NSString * goods_id;
@property (nonatomic, strong) DSGoodsInfoModel * product;
@property (nonatomic, strong) NSNumber * num;
@property (nonatomic, strong) GoodsDetailSaleInfo * sku;
@property (nonatomic, assign) BOOL selected;

//自定义
@property (nonatomic, copy) NSString * remarks; /**< 备注 */

@end
