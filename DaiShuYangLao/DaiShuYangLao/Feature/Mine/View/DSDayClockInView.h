//
//  DSDayClockInView.h
//  DaiShuYangLao
//
//  Created by YueLiang Song on 2018/8/7.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DSClockInDetailModel;
@interface DSDayClockInView : UIView

@property (nonatomic, strong) UIView * backgroundView;
@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) UIImageView * decorationTopIV;
@property (nonatomic, strong) UIButton * closeButton;
@property (nonatomic, strong) UILabel * clockInDaysLab;
@property (nonatomic, strong) UIView * leftLine;
@property (nonatomic, strong) UIView * rightLine;
@property (nonatomic, strong) UIImageView * caseIV;
@property (nonatomic, strong) UIView * goldBackgroundView;
@property (nonatomic, strong) UILabel * goldLabel;
@property (nonatomic, strong) UIImageView * firstDashlineIV;
@property (nonatomic, strong) UIImageView * secondDashlineIV;
@property (nonatomic, strong) UIView * activityView;
//@property (nonatomic, strong) UILabel * firstActivityLabel;
//@property (nonatomic, strong) UILabel * secondActivityLabel;
@property (nonatomic, copy) ButtonClickHandle closePopViewHandle;
@property (nonatomic, copy) completeBlock clickAdertHandle;

@property (nonatomic, strong) UIImageView * bannerIV;

@property (nonatomic, strong) DSClockInDetailModel * model;

@end
