//
//  DSWithdrawCashTableAndFooterView.h
//  DaiShuYangLao
//
//  Created by YueLiang Song on 2018/7/19.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DSWithdrawCashConfigureModel;
@interface DSWithdrawCashTableHeaderFooterView : UIView

@property (nonatomic, strong) UIImageView * contentView;
@property (nonatomic, copy) void(^DidSelectedItemAtIndexPath)(NSIndexPath * indexPath,NSNumber * number);

@end


@interface WithdrawCashTableHeaderView : DSWithdrawCashTableHeaderFooterView

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * availablePointLabel;
@property (nonatomic, strong) UILabel * tipsLabel;
@property (nonatomic, strong) UIImageView * coinIV;

@end


@interface WithdrawCashTableFooterView : DSWithdrawCashTableHeaderFooterView

@property (nonatomic, strong) UIView * tipsView;
@property (nonatomic, strong) UILabel * tipsLabel;

@property (nonatomic, strong) UIButton * withdrawDetailButton;
@property (nonatomic, strong) UIButton * withdrawRegulationButton;

@property (nonatomic, strong) DSWithdrawCashConfigureModel * configureModel;

@end
