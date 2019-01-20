//
//  DSDayClockInView.m
//  DaiShuYangLao
//
//  Created by YueLiang Song on 2018/8/7.
//  Copyright © 2018年 tyfinal. All rights reserved.
//  每日签到
#import "DSDayClockInView.h"
#import "DSClockInDetailModel.h"
#import "DSBannerModel.h"

@implementation DSDayClockInView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _backgroundView = [[UIView alloc]initWithFrame:CGRectZero];
        _backgroundView.backgroundColor = [UIColor clearColor];
        [self addSubview:_backgroundView];
        
        _decorationTopIV = [[UIImageView alloc]initWithFrame:CGRectZero];
        _decorationTopIV.image = ImageString(@"mine_clockin_decoration");
        [_backgroundView addSubview:_decorationTopIV];
        
        _contentView = [[UIView alloc]initWithFrame:CGRectZero];
        _contentView.backgroundColor = [UIColor whiteColor];
        [_backgroundView addSubview:_contentView];
        
         _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:ImageString(@"mine_clockin_close") forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closePopView) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:_closeButton];
        
        _clockInDaysLab = [[UILabel alloc]init];
        _clockInDaysLab.font = JXFont(16);
        _clockInDaysLab.textColor = JXColorFromRGB(0x666666);
        _clockInDaysLab.textAlignment = NSTextAlignmentCenter;
        _clockInDaysLab.text = @"累计签到10天";
        [self.contentView addSubview:_clockInDaysLab];
        
        for (NSInteger i=0; i<2; i++) {
            UIView * line = [[UIView alloc]initWithFrame:CGRectZero];
            line.backgroundColor = JXColorFromRGB(0x999999);
            [self.contentView addSubview:line];
            if(i==0) _leftLine = line;
            if(i==1) _rightLine = line;
        }
        
        _caseIV = [[UIImageView alloc]initWithFrame:CGRectZero];
        _caseIV.image = ImageString(@"mine_clockin_case");
        [self.contentView addSubview:_caseIV];
        
        _goldBackgroundView = [[UIView alloc]initWithFrame:CGRectZero];
        _goldBackgroundView.backgroundColor = JXColorFromRGB(0xf88686);
        [self.contentView addSubview:_goldBackgroundView];
        
        _goldLabel = [[UILabel alloc]init];
        _goldLabel.font = JXFont(14);
        _goldLabel.textColor = JXColorFromRGB(0xffffff);
        _goldLabel.textAlignment = NSTextAlignmentCenter;
        _goldLabel.text = @"本次获得11购物金";
        [_goldBackgroundView addSubview:_goldLabel];
        
        for (NSInteger i=0; i<2; i++) {
            UIImageView * dashline = [[UIImageView alloc]initWithFrame:CGRectZero];
            dashline.image = ImageString(@"mine_clockin_dashline");
            [self.contentView addSubview:dashline];
            if(i==0) _firstDashlineIV = dashline;
            if(i==1) _secondDashlineIV = dashline;
        }
        
        _activityView = [[UIView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:_activityView];
        
//        for (NSInteger i=0; i<2; i++) {
//            UILabel * activityLabel = [[UILabel alloc]init];
//            activityLabel.font = JXFont(11);
//            activityLabel.textColor = JXColorFromRGB(0x5C5757);
//            activityLabel.textAlignment = NSTextAlignmentCenter;
//            [self.contentView addSubview:activityLabel];
//            if(i==0) _firstActivityLabel = activityLabel;
//            if(i==1) _secondActivityLabel = activityLabel;
//        }
//
//        _firstActivityLabel.text = @"连续签到10天，获得5购物金";
//        _secondActivityLabel.text = @"连续签到20天，获得10购物金";
        [_backgroundView bringSubviewToFront:_decorationTopIV];
        
        _bannerIV = [[UIImageView alloc]initWithFrame:CGRectZero];
        _bannerIV.userInteractionEnabled = YES;
        [_bannerIV addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickBanner)]];
        [self.contentView addSubview:_bannerIV];
        
        [_backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.and.right.equalTo(self);
            make.bottom.equalTo(self).with.offset(0).priorityLow();
        }];
        
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_backgroundView.mas_left).with.offset(0);
            make.right.equalTo(_backgroundView.mas_right).with.offset(0);
            make.top.equalTo(_decorationTopIV.mas_bottom).multipliedBy(0.6);
            make.bottom.equalTo(_backgroundView.mas_bottom).with.offset(-30);
        }];
        
        [_decorationTopIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_backgroundView.mas_left).with.offset(22);
            make.top.equalTo(_backgroundView.mas_top).with.offset(0);
            make.height.equalTo(_decorationTopIV.mas_width).multipliedBy(0.48);
        }];
        
        [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_decorationTopIV.mas_right).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(22, 22));
            make.top.equalTo(_contentView.mas_top).with.offset(0);
            make.right.equalTo(_contentView.mas_right).with.offset(0);
        }];
        
        [_clockInDaysLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.height.mas_equalTo(kLabelHeightOffset+14);
            make.top.equalTo(self.contentView.mas_top).with.offset(50-kLabelHeightOffset/2.0);
        }];
        
        [_leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(1);
            make.left.equalTo(self.contentView.mas_left).with.offset(32);
            make.centerY.equalTo(_clockInDaysLab.mas_centerY);
            make.right.equalTo(_clockInDaysLab.mas_left).with.offset(-5);
        }];
        
        [_rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.centerY.width.equalTo(_leftLine);
            make.left.equalTo(_clockInDaysLab.mas_right).with.offset(5);
        }];
        
        [_caseIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(137, 125));
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.top.equalTo(_clockInDaysLab.mas_bottom).with.offset(15-kLabelHeightOffset/2.0);
        }];
        
        [_goldBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(21);
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.top.equalTo(_caseIV.mas_bottom).with.offset(8);
        }];
        
        [_goldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(kLabelHeightOffset+14);
            make.centerY.equalTo(_goldBackgroundView.mas_centerY);
            make.left.equalTo(_goldBackgroundView.mas_left).with.offset(5);
            make.right.equalTo(_goldBackgroundView.mas_right).with.offset(-5);
        }];
        
        [_firstDashlineIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self.contentView);
            make.height.mas_equalTo(2);
            make.top.equalTo(_goldBackgroundView.mas_bottom).with.offset(6);
        }];
        
        [_activityView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_firstDashlineIV.mas_bottom).with.offset(4);
            make.height.mas_lessThanOrEqualTo(2).priorityLow();
            make.left.and.right.equalTo(self.contentView);
        }];
        
//        [_firstActivityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(11+kLabelHeightOffset);
//            make.centerX.equalTo(self.contentView.mas_centerX);
//            make.top.equalTo(_firstDashlineIV.mas_bottom).with.offset(4-kLabelHeightOffset/2.0);
//        }];
//        
//        [_secondActivityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(11+kLabelHeightOffset);
//            make.centerX.equalTo(self.contentView.mas_centerX);
//            make.top.equalTo(_firstActivityLabel.mas_bottom).with.offset(5);
//        }];
        
        [_secondDashlineIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.and.width.equalTo(_firstDashlineIV);
            make.height.mas_equalTo(2);
            make.top.equalTo(_activityView.mas_bottom).with.offset(10);
        }];
        
        [_bannerIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.top.equalTo(_secondDashlineIV.mas_bottom);
            make.height.equalTo(_bannerIV.mas_width).multipliedBy(0.27);
            make.bottom.equalTo(_contentView.mas_bottom);
        }];
    }
    return self;
}

- (void)setModel:(DSClockInDetailModel *)model{
    _model = model;
    self.clockInDaysLab.text = NSStringFormat(@"累计签到%ld天",model.days.integerValue);
    self.goldLabel.text = NSStringFormat(@"本次获得%.2f购物金",model.gold.doubleValue);
    if (model.info.count>0) {
        if (_activityView.subviews.count>0) {
            [_activityView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }
        
        NSMutableArray * labels = @[].mutableCopy;
        for (NSInteger i=0; i<model.info.count; i++) {
            UILabel * activityLabel = [[UILabel alloc]init];
            activityLabel.font = JXFont(11);
            activityLabel.text = @"";
            if ([model.info[i] isNotBlank]) {
                activityLabel.text = _model.info[i];
            }
            activityLabel.textColor = JXColorFromRGB(0x5C5757);
            activityLabel.textAlignment = NSTextAlignmentCenter;
            [self.activityView addSubview:activityLabel];
            [labels addObject:activityLabel];
        }
        if (labels.count>0) {
            [labels mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:5 leadSpacing:0 tailSpacing:0];
            [labels mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(13);
                make.centerX.equalTo(self.activityView.mas_centerX);
            }];
        }
    }
    
    if (_model.adv.count>0) {
        DSBannerModel * bannerModel = _model.adv[0];
        [_bannerIV sd_setImageWithURL:[NSURL URLWithString:bannerModel.pic] placeholderImage:ImageString(@"public_banner_placeholder")];
    }
    
}

- (void)closePopView{
    if (self.closePopViewHandle) {
        self.closePopViewHandle(nil, self);
    }
}

- (void)clickBanner{
    if (self.model.adv.count>0) {
        if (self.clickAdertHandle) {
            self.clickAdertHandle(self.model.adv[0], YES, nil);
        }
    }
}

@end
