//
//  DSRegistSubView.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/5/25.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSRegistSubView.h"
#import "DSLoginInputView.h"
#import "NSTimer+YYAdd.h"
#import "DSCommonWebViewController.h"
#define kContentEdgeInset  UIEdgeInsetsMake(8, 15, 8, 15)
@interface DSRegistSubView()<UITextFieldDelegate>{
    NSInteger countSecond;
}

@property (nonatomic, strong) UIButton * VerifaicationButton;
@property (nonatomic, assign) BOOL didSetupLayout;
@property (nonatomic, strong) NSTimer * timer;

@end

@implementation DSRegistSubView



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        countSecond = kResendVerificationCodeTime;
        self.contentView = [[UIView alloc]initWithFrame:CGRectZero];
        self.contentView.mas_key = @"contentView";
        [self addSubview:self.contentView];
        NSArray * iconNames = @[@"login_phone",@"login_verificationcode",@"login_password"];
        NSArray * placeholders = @[@"请输入手机号码",@"请输入验证码",@"请输入密码"];
        NSMutableArray * inputVIewArray = @[].mutableCopy;
        for (NSInteger i=0; i<3; i++) {
            DSLoginInputView * inputView = [[DSLoginInputView alloc]initWithFrame:CGRectZero];
            inputView.leftImageView.image = ImageString(iconNames[i]);
            inputView.mas_key = [NSString stringWithFormat:@"input_%ld",i];
            inputView.textField.attributedPlaceholder = [NSString applyAttributes:@{NSFontAttributeName:JXFont(15),NSForegroundColorAttributeName:JXColorFromRGB(0xdadada)} forString:placeholders[i]];
            [self.contentView addSubview:inputView];
            [inputVIewArray addObject:inputView];
            if (i==0) {
                self.phoneInputView = inputView;
                self.phoneTextField = inputView.textField;
            }else if (i==1){
                self.verificationCodeInputView = inputView;
                self.verificationCodeTextField = inputView.textField;
                
                UIView * rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 120*ScreenAdaptFator_W, 33)];
                rightView.backgroundColor = [UIColor whiteColor];
                inputView.textField.rightView = rightView;
                inputView.textField.rightViewMode = UITextFieldViewModeAlways;
                
                _VerifaicationButton = [UIButton buttonWithType:UIButtonTypeCustom];
                _VerifaicationButton.frame = rightView.bounds;
                
                [_VerifaicationButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                [_VerifaicationButton addTarget:self action:@selector(applyForVerificationCodeEvent:) forControlEvents:UIControlEventTouchUpInside];
                _VerifaicationButton.titleLabel.font = JXFont(15*ScreenAdaptFator_W);
                [_VerifaicationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [_VerifaicationButton setBackgroundImage:ImageString(@"login_getverifycation") forState:UIControlStateNormal];
                _VerifaicationButton.layer.cornerRadius = rightView.frameHeight/2.0f;
                _VerifaicationButton.layer.masksToBounds = YES;
                
                [rightView addSubview:_VerifaicationButton];
                
            }else if (i==2){
                self.passwordInputView = inputView;
                self.passwordTextField = inputView.textField;
            }
        }
        
        _registButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _registButton.mas_key = @"registbutton";
        [_registButton setTitle:@"注册" forState:UIControlStateNormal];
        _registButton.adjustsImageWhenDisabled = NO;
        [_registButton addTarget:self action:@selector(registEvent) forControlEvents:UIControlEventTouchUpInside];
        [_registButton setBackgroundImage:ImageString(@"login_button_bg") forState:UIControlStateNormal];
        _registButton.titleLabel.font = JXFont(18);
        [_registButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.contentView addSubview:_registButton];
        
        
//        _autoLayoutView = [[DSAutoLayoutLabel alloc]initWithFrame:CGRectZero];
//        [self.contentView addSubview:_autoLayoutView];
        
        _agreementLabel = [[YYLabel alloc]init];
//        _agreementLabel.userInteractionEnabled = YES;
        [self.contentView addSubview:_agreementLabel];
        
        NSMutableAttributedString * agreementMuAttri = [[NSMutableAttributedString alloc]initWithString:@"登录/注册代表您已同意"];
        agreementMuAttri.yy_font = JXFont(floorf(13*ScreenAdaptFator_W));
        agreementMuAttri.yy_color = JXColorFromRGB(0x999999);
        
        NSMutableAttributedString * highlightText = [[NSMutableAttributedString alloc]initWithString:@"<<袋鼠乐购服务协议>>"];
        highlightText.yy_color = APP_MAIN_COLOR;
        highlightText.yy_font = JXFont(floorf(13*ScreenAdaptFator_W));
        [highlightText yy_setTextHighlightRange:NSMakeRange(0, [@"<<袋鼠乐购服务协议>>" length]) color:nil backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            DSCommonWebViewController * webVC = [[DSCommonWebViewController alloc]init];
            webVC.urlString = @"http://wap.dscs123.com/agreement/index.html";
            webVC.title = @"袋鼠乐购服务协议";
            [self.superController.navigationController pushViewController:webVC animated:YES];
        }];
        [agreementMuAttri appendAttributedString:highlightText];

        agreementMuAttri.yy_alignment = NSTextAlignmentCenter;
        _agreementLabel.attributedText = agreementMuAttri;
        
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
    }
    return self;
}



- (NSTimer *)timer{
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:1 block:^(NSTimer * _Nonnull timer) {
            countSecond--;
            if (countSecond <= 0) {
                [self stopTime]; //停止定时器
                self.VerifaicationButton.enabled = YES;
                [self.VerifaicationButton setTitle:@"获取验证码" forState:UIControlStateNormal];
            }else{
                self.VerifaicationButton.enabled = NO;
                [self.VerifaicationButton setTitle:[NSString stringWithFormat:@"%lds后重试",countSecond] forState:UIControlStateNormal];
            }
        } repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSDefaultRunLoopMode];
    }
    return _timer;
}

- (void)updateConstraints{
    if (!_didSetupLayout) {
        _didSetupLayout = YES;
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).with.insets(kContentEdgeInset);
        }];
        
        [@[_passwordInputView,_verificationCodeInputView,_phoneInputView] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self.contentView);
            make.height.mas_equalTo(38);
        }];
        
        [_phoneInputView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(0);
        }];
        
        __weak typeof (self)weakSelf = self;
        [_verificationCodeInputView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.phoneInputView.mas_bottom).with.offset(32);
        }];
        
        [_passwordInputView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.verificationCodeInputView.mas_bottom).with.offset(32);
        }];
        
        [_registButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self.phoneInputView);
            make.height.mas_equalTo(47);
            make.top.equalTo(self.passwordInputView.mas_bottom).with.offset(36);
        }];
        
        [_agreementLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self.phoneInputView);
            make.height.mas_equalTo(20);
            make.top.equalTo(weakSelf.registButton.mas_bottom).with.offset(22);
        }];
        
    }

    [super updateConstraints];
}

- (void)clearAllText{
    _phoneTextField.text = @"";
    _passwordTextField.text = @"";
    _verificationCodeTextField.text = @"";
}

- (void)applyForVerificationCodeEvent:(UIButton *)button{
    if (self.applyForVerificationCodeHandle) {
        self.applyForVerificationCodeHandle(nil, self);
    }
}

- (void)registEvent{
    if (self.nextStepHandle) {
        self.nextStepHandle(self.registButton, self);
    }
}

- (void)startTimer{
    [self.timer fire];
}

- (void)stopTime{
    if (_timer) {
        [self.timer invalidate];
        self.timer = nil;
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

