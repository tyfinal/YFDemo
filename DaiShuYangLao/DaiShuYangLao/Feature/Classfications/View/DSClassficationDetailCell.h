//
//  DSClassficationDetailCell.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/2.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DSGoodsInfoModel;
@class ClassificationDetailProgressView;
@interface DSClassficationDetailCell : UITableViewCell

@property (nonatomic, strong) UIView * containerView;

@property (nonatomic, strong) UIButton * selectButton;

@property (nonatomic, strong) UIImageView * coverImageView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * priceLabel;
@property (nonatomic, strong) UILabel * salesAmountLabel;
@property (nonatomic, strong) UILabel * descLabel;
@property (nonatomic, strong) ClassificationDetailProgressView * progressView;
@property (nonatomic, strong) UIButton * shoppingcartButton;
@property (nonatomic, strong) UIImageView * rewardImageView;
@property (nonatomic, strong) UILabel * rewardLabel;

@property (nonatomic, assign) DSGoodsInfoModel * model;

@property (nonatomic, copy) void(^SaveGoodsToShoppingCartHandle)(NSIndexPath * indexPath,DSGoodsInfoModel * model);

@end


@interface ClassificationDetailProgressView : UIView

@property (nonatomic, strong) UIProgressView * progressView;
@property (nonatomic, strong) UILabel * progressLabel;
@property (nonatomic, strong) UILabel * tipsLabel;

@property (nonatomic, strong) DSGoodsInfoModel * goodsModel;

@end
