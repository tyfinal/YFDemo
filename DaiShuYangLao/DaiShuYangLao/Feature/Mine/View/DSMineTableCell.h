//
//  DSMineTableCell.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/5/29.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSControllableRoundedCell.h"


@class DSUserInfoModel;
@class MinePensionCell;
@class MineIdentityCodeCell;
@class MineMenbershipInfoCell;
@class MineOrderInfoCell;
@class MineAdvertisementCell;
@class OrderItemView;


//@class order
@interface DSMineTableCell : DSControllableRoundedCell


@end


@interface MinePensionCell : DSControllableRoundedCell

@property (nonatomic, strong) UILabel * totalPensionLabel;
@property (nonatomic, strong) UILabel * workingAgeLabel;
@property (nonatomic, strong) UILabel * expenseAmountLabel;

@property (nonatomic, strong) UIButton * pensionDetailButton;
@property (nonatomic, strong) OrderItemView * withdrawCashItem; /**< 提现 */

@property (nonatomic, assign) NSInteger section;

@end


@interface MineIdentityCodeCell : DSControllableRoundedCell

@property (nonatomic, strong) UILabel * identityCodeLabel;
@property (nonatomic, strong) UIImageView * arrowIV;
@property (nonatomic, strong) UILabel * inviteLabel;
@property (nonatomic, strong) UILabel * rewardLabel;
@property (nonatomic, strong) UIImageView * gifImageView;


@end

@interface MineOptionsCell : DSControllableRoundedCell

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * detailLabel;
@property (nonatomic, strong) UIButton * regulationButton;


@end

@interface MineMenbershipInfoCell : DSControllableRoundedCell

@property (nonatomic, strong) UILabel * firstLevelLabel;
@property (nonatomic, strong) UILabel * secondLevelLabel;
@property (nonatomic, strong) UIButton * regulationButton;

@end


@interface MineOrderInfoCell : DSControllableRoundedCell

@property (nonatomic, strong) UIButton * allOrdersButton; /**< 查看所有订单 */
//@property (nonatomic, strong) <#Class#> * <#object#>;

@property (nonatomic, copy) ButtonClickHandle viewAllOrderHandle;

@property (nonatomic, copy) void(^OrderClickHandle)(NSInteger index);

@end


@interface MineAdvertisementCell : UITableViewCell

@property (nonatomic, strong) UIImageView * adverImageView;

@end



@interface OrderItemView : UIView

@property (nonatomic, strong) UIImageView * iconIV;
@property (nonatomic, strong) UILabel * itemNameLabel;
@property (nonatomic, strong) UILabel * badgeLabel;


@end


