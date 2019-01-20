//
//  DSHomeEntranceCell.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/7.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DSHomeClassificationModel;
@class HotSaleGoodsItem;
@class DSBannerModel;
#import <FLAnimatedImageView.h> 
@interface DSHomeEntranceCell : UICollectionViewCell

@property (nonatomic, assign) BOOL didSetupLayout;
@property (nonatomic, strong) id model;

@end

//Mark: vipNum 领航会员数量
@interface HomeMenbershipNumberCell : DSHomeEntranceCell

@property (nonatomic, copy) NSString * membershipNumber;
@property (nonatomic, strong) UIImageView * backgroundImageView;
//@property (nonatomic, strong) u * <#object#>;

@end

//MARK: sections 分类
@interface HomeClassificationCell : DSHomeEntranceCell

@property (nonatomic, copy) NSArray * dataArray;

@property (nonatomic, copy) void(^ClickItemHandle)(NSIndexPath * indexPath,DSHomeClassificationModel * model);

+ (CGFloat)getCellHeight; 

@end

//MARK: events 热销推荐
@interface HomeHotSaleCell : DSHomeEntranceCell

@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, strong) UIView * seperator;
@property (nonatomic, copy) void(^clickAtBannerHandle)(DSBannerModel * model);
@property (nonatomic, copy) void(^clickItemAtIndexPathHandle)(DSBannerModel * bannerModel,NSIndexPath * indexPath,DSGoodsInfoModel * productModel);

+ (CGFloat)getCellHeightWithModel:(DSBannerModel *)model;

@end

//MARK: ads 广告
@interface HomeMembershipRightIntroduceCell : DSHomeEntranceCell

@property (nonatomic, strong) FLAnimatedImageView * imageView;
@property (nonatomic, strong) UIView * topLine;
@property (nonatomic, strong) UIView * rightLine;
@property (nonatomic, strong) UIView * bottomLine;

@end

//MARK: youlike 猜你喜欢
@interface HomeGoodsCell : DSHomeEntranceCell

@property (nonatomic, strong) UIImageView * coverImageView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * priceLabel;
@property (nonatomic, strong) UILabel * salesLabel;
@property (nonatomic, strong) UIButton * shoppingCartButton;
@property (nonatomic, strong) UIImageView * rewardImageView;
@property (nonatomic, strong) UILabel * rewardLabel;


+ (CGFloat)getItemHeightWithItemWidth:(CGFloat)itemWidth;

@end


@interface ClassificationItem : UICollectionViewCell

@property (nonatomic, strong) FLAnimatedImageView * imageView;
@property (nonatomic, strong) UILabel * titleLabel;

+ (CGFloat)getClassificationItemWithWidth:(CGFloat)itemWidth;

@end


//MARK: 热销推荐 商品 item
@interface HotSaleGoodsItem : UICollectionViewCell

@property (nonatomic, strong) DSGoodsInfoModel * productModel;

+ (CGFloat)getCellHeightWithItemWidth:(CGFloat)itemWidth;



@end
