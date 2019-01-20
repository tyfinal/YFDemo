//
//  DSMineHeaderView.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/5/28.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSMineHeaderView.h"
#import "DSUserInfoModel.h"

@interface DSMineHeaderView (){
    
}

@property (nonatomic, assign) BOOL didSetupLayout;

@end

static NSString * collectionButtonPrefixTitle = @"商品关注";

@implementation DSMineHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //内容视图 方便autolayout自动算高
        self.contentView = [[UIView alloc]initWithFrame:CGRectZero];
        _contentView.mas_key = @"contentviewkey";
        [self addSubview:self.contentView];
        
        //topview 登录状态下 上方显示的视图
        self.topView = [[UIView alloc]initWithFrame:CGRectZero];
        _topView.mas_key = @"topviewkey";
        [self.contentView addSubview:self.topView];
        
        //用户iocn
        self.userIcon = [[UIImageView alloc]initWithFrame:CGRectZero];
        _userIcon.mas_key = @"usericonkey";
        [self.topView addSubview:self.userIcon];
        
        //用户名
        _userNameLabel = [[UILabel alloc]init];
        _userNameLabel.font = JXFont(15);
        _userNameLabel.textColor = JXColorFromRGB(0xffffff);
        _userNameLabel.textAlignment = NSTextAlignmentLeft;
        _userNameLabel.mas_key = @"usernamekey";
        [self.topView addSubview:_userNameLabel];
        
        _workAgeLabel = [[UILabel alloc]init];
        _workAgeLabel.font = JXFont(15);
        _workAgeLabel.textColor = JXColorFromRGB(0xffffff);
        _workAgeLabel.textAlignment = NSTextAlignmentLeft;
        [self.topView addSubview:_workAgeLabel];
        
        //用户角色
        _roleLabel = [[UILabel alloc]init];
        _roleLabel.font = JXFont(13);
        _roleLabel.textColor = JXColorFromRGB(0xffffff);
        _roleLabel.textAlignment = NSTextAlignmentCenter;
        _roleLabel.backgroundColor = JXColorAlpha(0, 0, 0, 0.4);
        _roleLabel.mas_key = @"rolekey";
        [self.topView addSubview:_roleLabel];
        
        //用户角色
        _extraRoleLabel = [[UILabel alloc]init];
        _extraRoleLabel.font = JXFont(13);
        _extraRoleLabel.textColor = JXColorFromRGB(0xffffff);
        _extraRoleLabel.textAlignment = NSTextAlignmentCenter;
        _extraRoleLabel.backgroundColor = JXColorAlpha(0, 0, 0, 0.4);
        _extraRoleLabel.mas_key = @"extrarolekey";
        [self.topView addSubview:_extraRoleLabel];
        
        //非登录状态下显示 登录按钮
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginButton setTitle:@"登录/注册" forState:UIControlStateNormal];
        _loginButton.titleLabel.font = JXFont(15.0);
        [_loginButton setTitleColor:JXColorFromRGB(0xffffff) forState:UIControlStateNormal];
        _loginButton.mas_key = @"loginkey";
        _loginButton.hidden = YES;
        [self.contentView addSubview:_loginButton];

        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
        [self layoutIfNeeded];
        self.userIcon.layer.cornerRadius = _userIcon.frameWidth/2.0f;
        _userIcon.layer.masksToBounds = YES;
        
        self.roleLabel.layer.cornerRadius = 3.0f;
        self.roleLabel.layer.masksToBounds = YES;
        
        _extraRoleLabel.layer.cornerRadius = 3.0f;
        _extraRoleLabel.layer.masksToBounds = YES;
        
        _loginButton.layer.borderColor = JXColorFromRGB(0xffffff).CGColor;
        _loginButton.layer.borderWidth = 1.5f;
        _loginButton.layer.cornerRadius = 5.0f;
        _loginButton.layer.masksToBounds = YES;
        
        NSLog(@"完成布局");
    }
    return self;
}

- (void)updateConstraints{
    if (!_didSetupLayout) {
        _didSetupLayout = YES;
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.and.top.equalTo(self);
            make.bottom.equalTo(self).priorityLow();
        }];
        
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self.contentView);
            make.top.equalTo(self.contentView.mas_top).with.offset(kNavigationBarHeight+2);
            make.height.mas_equalTo(50);
        }];
        
        __weak typeof (self)weakSelf = self;
        [_userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.topView.mas_left).with.offset(15);
            make.size.mas_equalTo(CGSizeMake(50, 50));
            make.centerY.equalTo(self.topView.mas_centerY);
        }];
        
        [_userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(kLabelHeightOffset+15);
            make.left.equalTo(weakSelf.userIcon.mas_right).with.offset(15);
            make.top.equalTo(weakSelf.topView.mas_top).with.offset(5-kLabelHeightOffset/2.0);
        }];
        
        [_workAgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_userNameLabel.mas_right).with.offset(20);
            make.height.mas_equalTo(kLabelHeightOffset+15);
            make.centerY.equalTo(_userNameLabel.mas_centerY);
            make.right.lessThanOrEqualTo(self.topView.mas_right).with.offset(-14);
        }];
        
        [_roleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.userNameLabel.mas_left);
            make.height.mas_equalTo(21);
            make.bottom.equalTo(weakSelf.userIcon.mas_bottom).with.offset(-2);
            make.width.mas_equalTo(103);
        }];
        
        [_extraRoleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.roleLabel.mas_right).with.offset(17);
            make.height.mas_equalTo(21);
            make.bottom.equalTo(weakSelf.userIcon.mas_bottom).with.offset(-2);
            make.width.mas_equalTo(60);
        }];
        
        [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(120, 30));
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        
//        [_settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.topView.mas_right).with.offset(-37);
//            make.centerY.equalTo(weakSelf.userNameLabel.mas_centerY);
//            make.height.mas_equalTo(15+kLabelHeightOffset);
//            make.width.mas_equalTo(38+kLabelHeightOffset);
//        }];
//        
//        [_collectionButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.settingButton.mas_right);
//            make.centerY.equalTo(weakSelf.roleLabel.mas_centerY);
//            make.height.mas_equalTo(15+kLabelHeightOffset);
//            make.left.equalTo(weakSelf.roleLabel.mas_right).with.offset(10);
//        }];
    }
    [super updateConstraints];
}

- (void)setModel:(DSUserInfoModel *)model{
    _model = model;
    if (model) {
        self.topView.hidden = NO;
        self.loginButton.hidden = YES;
        [self.userIcon sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:ImageString(@"public_avatar_placeholder")];
        if ([model.nickname isNotBlank]) {
            self.userNameLabel.text = model.nickname;
        }else{
            self.userNameLabel.text = [model.phone encodePhoneNumber];
        }
        
        if ([model.workYears isNotBlank]) {
            self.workAgeLabel.text = [NSString stringWithFormat:@"工龄%ld年",(long)model.workYears.integerValue];
        }
        
        if (model.level.integerValue>0) {
            self.roleLabel.text = @[@"普通会员",@"领航会员"][model.level.integerValue-1];
        }

        self.extraRoleLabel.hidden = YES;
        if (model.level.integerValue==2) {
            //只有领航会员 才会展示额外的角色信息
            if ([model.jobTitle isNotBlank]) {
                self.extraRoleLabel.hidden = NO;
                self.extraRoleLabel.text = model.jobTitle;
            }
        }
    }else{
        self.topView.hidden = YES;
        self.loginButton.hidden = NO;
    }

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
