//
//  DSShoppingCartCell.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/2.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShoppingCartGoodsCell;
@class ShoppingCartRecommendCell;
@class PPNumberButton;
@class DSShopCartModel;



@interface DSShoppingCartCell : UICollectionViewCell

@property (nonatomic, assign) BOOL didSetupLayout;

@end


@interface ShoppingCartGoodsCell : DSShoppingCartCell

@property (nonatomic, strong) UIButton * selectedButton;
@property (nonatomic, strong) UIImageView * moduleBackgroundIV;
@property (nonatomic, strong) UIImageView * coverImageView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * featureLabel;
@property (nonatomic, strong) UILabel * priceLabel;
@property (nonatomic, strong) PPNumberButton * goodsNumberStepperView;

@property (nonatomic, strong) DSShopCartModel * model;
@property (nonatomic, strong) NSIndexPath * indexPath;

@property (nonatomic, copy) void(^ShoppingCartCellSelectItemAtIndexPath)(NSIndexPath *indexPath,DSShopCartModel * model,ShoppingCartGoodsCell * cell);


@property (nonatomic, copy) void(^ShoppingCartCellViewDetailAtIndexPath)(NSIndexPath *indexPath,DSShopCartModel * model,ShoppingCartGoodsCell * cell);

@end


@interface ShoppingCartRecommendCell : DSShoppingCartCell

@end


//@interface




