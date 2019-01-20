//
//  DSWithdrawCashTableAndFooterView.m
//  DaiShuYangLao
//
//  Created by YueLiang Song on 2018/7/19.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSWithdrawCashTableHeaderFooterView.h"
#import "DSWithdrawCashConfigureModel.h"

@implementation DSWithdrawCashTableHeaderFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.contentView.userInteractionEnabled = YES;
        [self addSubview:self.contentView];
        
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

@implementation WithdrawCashTableHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentView.image = ImageString(@"mine_headerbg");
        
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = JXFont(12);
        _titleLabel.textColor = JXColorFromRGB(0xffffff);
        _titleLabel.text = @"可提袋鼠乐购养老备用金";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleLabel];
        
        CGFloat fontSize = ceil(ScreenAdaptFator_W*31);
        _availablePointLabel = [[UILabel alloc]init];
        _availablePointLabel.font = JXFont(fontSize);
        _availablePointLabel.textColor = JXColorFromRGB(0xffffff);
        _availablePointLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_availablePointLabel];
        
        _coinIV = [[UIImageView alloc]initWithFrame:CGRectZero];
        _coinIV.image = ImageString(@"public_coinicon");
        [self.contentView addSubview:_coinIV];
        
        _tipsLabel = [[UILabel alloc]init];
        _tipsLabel.font = JXFont(12);
        _tipsLabel.textColor = JXColorFromRGB(0xffffff);
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.hidden = YES;
        [self.contentView addSubview:_tipsLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(12+kLabelHeightOffset);
            make.top.equalTo(self.contentView.mas_top).with.offset(26-kLabelHeightOffset/2.0);
            make.left.equalTo(self.contentView.mas_left).with.offset(15);
            make.right.equalTo(self.contentView.mas_right).with.offset(-15);
        }];
        
        [_coinIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(25, 23));
            make.centerY.equalTo(_availablePointLabel.mas_centerY);
            make.right.equalTo(_availablePointLabel.mas_left).with.offset(-10);
        }];
        
        [_availablePointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView.mas_centerX).with.offset(10);
            make.width.mas_greaterThanOrEqualTo(50);
            make.height.mas_equalTo(fontSize+kLabelHeightOffset);
            make.top.equalTo(_titleLabel.mas_bottom).with.offset(15-kLabelHeightOffset);
        }];
        
        
        
        [_tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(_titleLabel);
            make.height.mas_equalTo(12+kLabelHeightOffset);
            make.top.equalTo(_availablePointLabel.mas_bottom).with.offset(12);
        }];
        
    }
    return self;
}

@end


@implementation WithdrawCashTableFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _tipsView = [[UIView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:_tipsView];
        
        _tipsLabel = [[UILabel alloc]init];
        _tipsLabel.font = JXFont(13);
        _tipsLabel.textColor = APP_MAIN_COLOR;
        _tipsLabel.textAlignment = NSTextAlignmentLeft;
        [self.tipsView addSubview:_tipsLabel];
        
        _withdrawDetailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_withdrawDetailButton setTitle:@"申请提现" forState:UIControlStateNormal];
        _withdrawDetailButton.adjustsImageWhenDisabled = NO;
        [_withdrawDetailButton setBackgroundImage:ImageString(@"login_button_bg") forState:UIControlStateNormal];
        _withdrawDetailButton.titleLabel.font = JXFont(18);
        [_withdrawDetailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.contentView addSubview:_withdrawDetailButton];
        
        _withdrawRegulationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_withdrawRegulationButton setTitle:@"提现规则" forState:UIControlStateNormal];
        [_withdrawRegulationButton setImage:ImageString(@"mine_regulation") forState:UIControlStateNormal];
        [_withdrawRegulationButton setTitleColor:JXColorFromRGB(0x696969)forState:UIControlStateNormal];
        _withdrawRegulationButton.titleLabel.font = JXFont(13.0f);
        [_withdrawRegulationButton setImagePosition:LXMImagePositionRight spacing:6];
//        [_withdrawRegulationButton addTarget:self action:@selector(withdrawRegulationEvent) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_withdrawRegulationButton];

        [_tipsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(32);
            make.height.mas_equalTo(22);
            make.top.equalTo(self.contentView.mas_top).with.offset(10);
        }];
        
        [_tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.tipsView.mas_left).with.offset(5);
            make.right.equalTo(self.tipsView.mas_right).with.offset(-15);
            make.height.mas_equalTo(17);
            make.centerY.equalTo(self.tipsView.mas_centerY);
        }];
        
        [_withdrawDetailButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(45*ScreenAdaptFator_W);
            make.right.equalTo(self.contentView.mas_right).with.offset(-45*ScreenAdaptFator_W);
            make.height.mas_equalTo(45);
            make.top.equalTo(_tipsView.mas_bottom).with.offset(100);
        }];
        
        [_withdrawRegulationButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(120, 30));
            make.centerY.equalTo(_withdrawDetailButton.mas_bottom).with.offset(34);
        }];
        
        _tipsLabel.text =  @"每笔提现额外收取4%的手续费";

        
        [self.contentView layoutIfNeeded];
        
        _tipsView.layer.cornerRadius = 3.0f;
        _tipsView.layer.masksToBounds = YES;
        _tipsView.layer.borderColor = APP_MAIN_COLOR.CGColor;
        _tipsView.layer.borderWidth = 1.0f;
    }
    return self;
}

- (void)setConfigureModel:(DSWithdrawCashConfigureModel *)configureModel{
    _configureModel = configureModel;
    if ([_configureModel.withdrawServiceFee isNotBlank]) {
        _tipsLabel.text = [NSString stringWithFormat:@"每笔提现额外收取%.f%%的手续费",_configureModel.withdrawServiceFee.floatValue];
    }
}


@end

