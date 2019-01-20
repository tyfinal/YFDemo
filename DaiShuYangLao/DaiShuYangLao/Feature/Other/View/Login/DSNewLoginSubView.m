//
//  DSNewLoginSubView.m
//  DaiShuYangLao
//
//  Created by YueLiang Song on 2018/8/31.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSNewLoginSubView.h"
#import "DSLoginInputView.h"

#define kContentEdgeInset  UIEdgeInsetsMake(8, 15, 8, 15)

@interface DSNewLoginSubView(){
    NSInteger countSecond;
}

@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic, strong) TextFieldDefaultRightView * resetRightView;
@property (nonatomic, strong) TextFieldDefaultRightView * verificationRightView;

@end


@implementation DSNewLoginSubView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        countSecond = 60;
        self.contentView = [[UIView alloc]initWithFrame:CGRectZero];
        [self addSubview:self.contentView];
        
        NSArray * placeholders = @[@"请输入手机号码",@"请输入短信验证码"];
        NSArray * iconImageNames = @[@"login_phone",@"login_verificationcode"];
        NSMutableArray * inputArray = @[].mutableCopy;
        for (NSInteger i=0; i<2; i++) {
            DSLoginInputView * inputView = [[DSLoginInputView alloc]initWithFrame:CGRectZero];
            inputView.textField.attributedPlaceholder = [NSString applyAttributes:@{NSFontAttributeName:JXFont(15),NSForegroundColorAttributeName:JXColorFromRGB(0xdadada)} forString:placeholders[i]];
            inputView.leftImageView.image = ImageString(iconImageNames[i]);
            
            if(i==0) {
                inputView.textField.keyboardType = UIKeyboardTypeNumberPad;
               self.phoneInputView = inputView;
            }else{
                self.passwordInputView = inputView;
                
            }
            [self.contentView addSubview:inputView];
            [inputArray addObject:inputView];
        }
        
        self.loginWay = 1;
        
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        _loginButton.adjustsImageWhenDisabled = NO;
        [_loginButton addTarget:self action:@selector(loginEvent) forControlEvents:UIControlEventTouchUpInside];
        [_loginButton setBackgroundImage:ImageString(@"login_button_bg") forState:UIControlStateNormal];
        _loginButton.titleLabel.font = JXFont(18);
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.contentView addSubview:_loginButton];

        NSArray * buttonTitles = @[@"账号密码登录",@"新用户注册"];
        for (NSInteger i=0; i<2; i++) {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:buttonTitles[i] forState:UIControlStateNormal];
            [button setTitleColor:JXColorFromRGB(0x5d5d5d)forState:UIControlStateNormal];
            button.titleLabel.font = JXFont(15.0f);
            [button addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:button];
            if(i==0) {
                _changeLoginWayButton = button;
                _changeLoginWayButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            }else{
                _registButton = button;
                _registButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            }
        }
        
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (boundsHeight<=480) {
                make.top.left.and.right.equalTo(self);
                make.bottom.equalTo(self).with.offset(0).priorityLow();
            }else{
                make.left.equalTo(self).with.offset(kContentEdgeInset.left);
                make.top.equalTo(self).with.offset(kContentEdgeInset.top);
                make.bottom.equalTo(self).with.offset(-kContentEdgeInset.bottom).priorityLow();
                make.right.equalTo(self).with.offset(-kContentEdgeInset.right);
            }
        }];

        [inputArray mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(47*ScreenAdaptFator_W);
            make.right.equalTo(self.contentView.mas_right).with.offset(-47*ScreenAdaptFator_W);
            make.height.mas_equalTo(38);
        }];
        
        [self.phoneInputView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(0);
        }];
        
        [self.passwordInputView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (boundsHeight<=480) {
                make.top.equalTo(self.phoneInputView.mas_bottom).with.offset(10);
            }else{
                make.top.equalTo(self.phoneInputView.mas_bottom).with.offset(32);
            }
        }];
        
        [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(27*ScreenAdaptFator_W);
            make.right.equalTo(self.contentView.mas_right).with.offset(-17*ScreenAdaptFator_W);
            make.height.mas_equalTo(39*ScreenAdaptFator_H);
            if (boundsHeight<=480) {
                make.top.equalTo(self.passwordInputView.mas_bottom).with.offset(20);
            }else{
               make.top.equalTo(self.passwordInputView.mas_bottom).with.offset(45);
            }
            
        }];
        
        [@[_changeLoginWayButton ,_registButton] mas_makeConstraints:^(MASConstraintMaker *make) {
            if (boundsHeight<=480) {
                make.top.equalTo(_loginButton.mas_bottom).with.offset(10);
            }else{
                make.top.equalTo(_loginButton.mas_bottom).with.offset(24*ScreenAdaptFator_H);
            }
            
            make.height.mas_equalTo(30);
        }];
        
        [_changeLoginWayButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.loginButton.mas_left).with.offset(0);
            make.width.mas_equalTo(120);
        }];
        
        [_registButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(85);
            make.right.equalTo(_loginButton.mas_right);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10);
        }];
        
    }
    return self;
}

- (UIButton *)sendVerificationCodeButton{
    if (!_sendVerificationCodeButton) {
        _sendVerificationCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendVerificationCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_sendVerificationCodeButton addTarget:self action:@selector(applyForVerificationCodeEvent) forControlEvents:UIControlEventTouchUpInside];
        _sendVerificationCodeButton.titleLabel.font = JXFont(15*ScreenAdaptFator_W);
        [_sendVerificationCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendVerificationCodeButton setBackgroundImage:ImageString(@"login_getverifycation") forState:UIControlStateNormal];
    }
    return _sendVerificationCodeButton;
}

- (void)setLoginWay:(NSInteger)loginWay{
    if (_loginWay!=loginWay) {
        _loginWay = loginWay;
        _passwordInputView.textField.rightViewMode = UITextFieldViewModeAlways;
        if (loginWay==1) {
            //验证码登录
            _passwordInputView.leftImageView.image = ImageString(@"login_verificationcode");
            _passwordInputView.textField.placeholder = @"请输入短信验证码";
            [_changeLoginWayButton setTitle:@"账号密码登录" forState:UIControlStateNormal];
            _passwordInputView.textField.secureTextEntry = NO;
            _passwordInputView.textField.keyboardType = UIKeyboardTypeNumberPad;
            
            if (!_verificationRightView) {
                _verificationRightView = [[TextFieldDefaultRightView alloc]initWithFrame:CGRectMake(0, 0, ceil(90*(ScreenAdaptFator_W)), 31)];
                [_verificationRightView.button setBackgroundImage:ImageString(@"login_getverifycation") forState:UIControlStateNormal];
                _verificationRightView.button.titleLabel.font = JXFont(12.0);
                [_verificationRightView.button mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(30);
                    make.centerY.equalTo(_verificationRightView.contentView.mas_centerY);
                    make.right.equalTo(_verificationRightView.contentView.mas_right).with.offset(0);
                    make.width.mas_equalTo(_verificationRightView.button.mas_height).multipliedBy(6);
                }];
                [_verificationRightView.button addTarget:self action:@selector(applyForVerificationCodeEvent) forControlEvents:UIControlEventTouchUpInside];
                _sendVerificationCodeButton = _verificationRightView.button;
            }
            _passwordInputView.rightView = _verificationRightView;
            
        }else{
            //账号登录
            _passwordInputView.leftImageView.image = ImageString(@"login_password");
            _passwordInputView.textField.placeholder = @"请输入密码";
            [_changeLoginWayButton setTitle:@"验证码登录" forState:UIControlStateNormal];
            _passwordInputView.textField.secureTextEntry = YES;
            _passwordInputView.textField.keyboardType = UIKeyboardTypeDefault;
            
            if (!_resetRightView) {
                
                _resetRightView = [[TextFieldDefaultRightView alloc]initWithFrame:CGRectMake(0, 0, ceil(70*(ScreenAdaptFator_W)), 31)];
                UIView * line = [[UIView alloc]initWithFrame:CGRectZero];
                line.backgroundColor = JXColorFromRGB(0x999999);
                [_resetRightView.contentView addSubview:line];
                
                [line mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(_resetRightView.contentView.mas_left).with.offset(5);
                    make.size.mas_equalTo(CGSizeMake(2, 15));
                    make.centerY.equalTo(_resetRightView.contentView);
                }];
                
                [_resetRightView.button setTitle:@"忘记密码" forState:UIControlStateNormal];
                _resetRightView.button.titleLabel.font = JXFont(14.0*ScreenAdaptFator_W);
                [_resetRightView.button setTitleColor:JXColorFromRGB(0x999999) forState:UIControlStateNormal];
                _resetRightView.button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                [_resetRightView.button mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(30);
                    make.left.equalTo(_resetRightView.contentView.mas_left).with.offset(11);
                    make.right.equalTo(_resetRightView.contentView.mas_right).with.offset(0);
                    make.centerY.equalTo(_resetRightView.contentView);
                }];
                [_resetRightView.button addTarget:self action:@selector(resetPasswordEvent) forControlEvents:UIControlEventTouchUpInside];
                _resetPasswordButton = _resetRightView.button;
            }
            _passwordInputView.rightView = _resetRightView;
        }
    }
}

- (NSTimer *)timer{
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:1 block:^(NSTimer * _Nonnull timer) {
            countSecond--;
            if (countSecond <= 0) {
                [self stopTime]; //停止定时器
                self.sendVerificationCodeButton.enabled = YES;
                [self.sendVerificationCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
            }else{
                self.sendVerificationCodeButton.enabled = NO;
                [self.sendVerificationCodeButton setTitle:[NSString stringWithFormat:@"%lds后重试",countSecond] forState:UIControlStateNormal];
            }
        } repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSDefaultRunLoopMode];
    }
    return _timer;
}

- (void)loginEvent{
    [self endEditing:YES];
    if (self.loginHandle) {
        self.loginHandle(self.loginButton, self);
    }
}

//点击注册
- (void)buttonEvent:(UIButton *)button{
    [self endEditing:YES];
    if (button==_changeLoginWayButton) {
        _passwordInputView.textField.text = nil;
        self.loginWay = 3-self.loginWay;
    }else{
        if (self.registHandle) {
            self.registHandle(button, self);
        }
    }
}

- (void)resetPasswordEvent{
    if (self.resetPasswordHandle) {
        self.resetPasswordHandle(self.resetPasswordButton, self);
    }
}

//获取短信验证码
- (void)applyForVerificationCodeEvent{
    if (self.applyForVerificationCodeHandle) {
        self.applyForVerificationCodeHandle(self.sendVerificationCodeButton, self);
    }
}


- (void)startTimer{
    [self.timer fire];
}

- (void)stopTime{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)removeFromSuperview{
    [super removeFromSuperview];
    [self stopTime];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
