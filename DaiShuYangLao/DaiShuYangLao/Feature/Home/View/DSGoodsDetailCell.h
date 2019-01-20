//
//  DSGoodsDetailCell.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/6.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSGoodsDetailInfoModel.h"

@class GoodsDetailBaseInfo;
@class GoodsDetailNormalCell;
@class GoodsDetailImageCell;
@class DSGoodsDetailCell;

@protocol DSGoodsDetailDelegate<NSObject>

@optional;
- (void)ds_goodsDetailCell:(DSGoodsDetailCell *)cell updateCellHeightWithModel:(GoodsDetailContentModel *)contentModel indexPath:(NSIndexPath *)indexPath;

@end


@interface DSGoodsDetailCell : UITableViewCell

@property (nonatomic, assign) BOOL didSetUpLayout;
@property (nonatomic, assign) DSGoodsDetailInfoModel * model;
@property (nonatomic, weak) id <DSGoodsDetailDelegate> delegate;

@end


@interface GoodsDetailBaseInfo : DSGoodsDetailCell

@property (nonatomic, strong) UILabel * originalPriceLabel;
@property (nonatomic, strong) UILabel * currentPriceLabel;
@property (nonatomic, strong) UIImageView * companyNameView;
@property (nonatomic, strong) UILabel * companyNameLabel;
@property (nonatomic, strong) UILabel * goodsTitleLabel;
@property (nonatomic, strong) UIView * seperator;
@property (nonatomic, strong) UIImageView * membershipGoodsFlag;

@end


@interface GoodsDetailNormalCell : DSGoodsDetailCell

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * descLabel;

@end

@interface GoodsDetailImageCell : DSGoodsDetailCell

@property (nonatomic, strong) UIImageView * detailImageView;

@property (nonatomic, strong) UILabel * detailsLabel;

@property (nonatomic, strong) GoodsDetailContentModel * contentModel;

@property (nonatomic, strong) NSIndexPath * indexPath;

@property (nonatomic, copy) void(^ImageCellDidLoadImageCallback)(NSIndexPath * indexPath,GoodsDetailContentModel * model);

@end





