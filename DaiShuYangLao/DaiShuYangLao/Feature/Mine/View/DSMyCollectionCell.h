//
//  DSMyCollectionCell.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/5.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSMyCollectionCell : UITableViewCell

@property (nonatomic, strong) UIView * containerView;

@property (nonatomic, strong) UIButton * selectButton;

@property (nonatomic, strong) UIImageView * coverImageView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * priceLabel;
@property (nonatomic, strong) UILabel * salesAmountLabel;
@property (nonatomic, strong) UILabel * descLabel;
@property (nonatomic, strong) UIButton * shoppingcartButton;
@property (nonatomic, strong) UIButton * shopCartClearButton;

@property (nonatomic, strong) UIView * seperator;

@property (nonatomic, strong) NSIndexPath * indexPath;
@property (nonatomic, assign) DSGoodsDetailInfoModel * model;

@property (nonatomic, copy) void(^DidSelectCellAtIndexPath)(NSIndexPath * indexPath,DSGoodsDetailInfoModel * model);


@property (nonatomic, copy) void(^AddGoodsToShopCart)(NSIndexPath * indexPath,DSGoodsDetailInfoModel * model);

@property (nonatomic, assign) BOOL edited;

@end



