//
//  DSGoodsDetailPropertyChooseView.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/26.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DSGoodsDetailInfoModel.h"

@class GoodsPropertyItem;
@class PropertyHeaderView;
@class PropertyItemFlowLayout;
@class DSGoodsDetailPropertyChooseView;
@class PPNumberButton;
@class PropertySectionHeaderView;
@class PropertySectionFooterView;

@protocol GoodsDetailPropertyChooseViewDelegate <NSObject>

@optional;

/** 点击关闭 已经选择某个属性 */
- (void)ds_GoodsDetailPropertyView:(DSGoodsDetailPropertyChooseView *)chooseView didSelectProperty:(GoodsDetailSaleInfo *)skuModel;

/** button index = 0 购物车 1 立即购买 */
- (void)ds_GoodsDetailPropertyView:(DSGoodsDetailPropertyChooseView *)chooseView clickButtonAtIndex:(NSInteger)buttonIndex button:(UIButton *)button skuModel:(GoodsDetailSaleInfo *)skuModel;

@end


@interface DSGoodsDetailPropertyChooseView : UIView

@property (nonatomic, strong) DSGoodsDetailInfoModel * goodsModel;

@property (nonatomic, weak) id<GoodsDetailPropertyChooseViewDelegate> delegate;

@end


@interface GoodsPropertyItem : UICollectionViewCell

@property (nonatomic, strong) UIImageView * backgroundIV;
@property (nonatomic, strong) UILabel * textLabel;

@property (nonatomic, strong) GoodsDetailSaleInfo * skuModel;

@end



@interface PropertyHeaderView : UIView

@property (nonatomic, strong) UIImageView * coverIV;
@property (nonatomic, strong) UILabel * textLabel;
@property (nonatomic, strong) UILabel * priceLabel;
@property (nonatomic, strong) UILabel * inventoryLabel;
@property (nonatomic, strong) UIButton * closeButton;

@property (nonatomic, strong) DSGoodsDetailInfoModel * goodsInfoModel;
@property (nonatomic, strong) GoodsDetailSaleInfo * skuModel;

@end



@interface PropertyItemFlowLayout : UICollectionViewFlowLayout

@end



@interface PropertySectionHeaderView : UICollectionReusableView

@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) UILabel * textLabel;

@end



@interface PropertySectionFooterView : UICollectionReusableView

@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) PPNumberButton * numberButton;
@property (nonatomic, strong) UILabel * textLabel;
@property (nonatomic, strong) DSGoodsDetailInfoModel * goodsModel;

@end






