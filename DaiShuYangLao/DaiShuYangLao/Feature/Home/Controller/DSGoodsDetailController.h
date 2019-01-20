//
//  DSGoodsDetailController.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/6.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSBaseViewController.h"

@class DSShopCartModel;
@interface DSGoodsDetailController : DSBaseViewController

@property (nonatomic, copy) NSString * goodsId;

// 只在购物车 中查看详情时需要 传递
@property (nonatomic, strong) DSShopCartModel * shopCartModel;
@property (nonatomic, copy) void(^ShouldRefreshShopCartData)(void);

@end
