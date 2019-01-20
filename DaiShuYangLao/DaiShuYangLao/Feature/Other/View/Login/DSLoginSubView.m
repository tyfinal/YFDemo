//
//  DSLoginSubView.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/5/25.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSLoginSubView.h"
#import "NSString+MKExtension.h"
#import "DSLoginInputView.h"

#define kContentEdgeInset  UIEdgeInsetsMake(8, 15, 8, 15)

@interface DSLoginSubView(){
    
}



@end

@implementation DSLoginSubView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView = [[UIView alloc]initWithFrame:CGRectZero];
        [self addSubview:self.contentView];
        self.contentView.mas_key = @"contentviewkey";
        
        NSArray * placeholders = @[@"请输入手机号码",@"请输入密码"];
        NSArray * iconImageNames = @[@"login_phone",@"login_password"];
        NSMutableArray * inputArray = @[].mutableCopy;

        for (NSInteger i=0; i<2; i++) {
            DSLoginInputView * inputView = [[DSLoginInputView alloc]initWithFrame:CGRectZero];
            inputView.textField.attributedPlaceholder = [NSString applyAttributes:@{NSFontAttributeName:JXFont(15),NSForegroundColorAttributeName:JXColorFromRGB(0xdadada)} forString:placeholders[i]];
            inputView.leftImageView.image = ImageString(iconImageNames[i]);
            if(i==0) {
                self.phoneTextField = inputView.textField;
                self.phoneInputView = inputView;
            }
            if(i==1) {
                self.passwordTextField = inputView.textField;
                self.passwordInputView = inputView;
            }
            inputView.mas_key = [NSString stringWithFormat:@"inputkey_%ld",i];
            [self.contentView addSubview:inputView];
            [inputArray addObject:inputView];
        }
        
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        _loginButton.adjustsImageWhenDisabled = NO;
        [_loginButton addTarget:self action:@selector(loginEvent) forControlEvents:UIControlEventTouchUpInside];
        [_loginButton setBackgroundImage:ImageString(@"login_button_bg") forState:UIControlStateNormal];
        _loginButton.titleLabel.font = JXFont(18);
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.contentView addSubview:_loginButton];

        _resetPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_resetPasswordButton setTitle:@"忘记密码 ?" forState:UIControlStateNormal];
        [_resetPasswordButton setTitleColor:JXColorFromRGB(0xe0e0e0) forState:UIControlStateNormal];
        [_resetPasswordButton addTarget:self action:@selector(resetPasswordEvent) forControlEvents:UIControlEventTouchUpInside];
        _resetPasswordButton.titleLabel.font = JXFont(15);
        [self.contentView addSubview:_resetPasswordButton];
        
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self).with.insets(kContentEdgeInset);
            make.left.equalTo(self).with.offset(kContentEdgeInset.left);
            make.top.equalTo(self).with.offset(kContentEdgeInset.top);
            make.bottom.equalTo(self).with.offset(-kContentEdgeInset.bottom).priorityLow();
            make.right.equalTo(self).with.offset(-kContentEdgeInset.right).priorityLow();
        }];
        
        [inputArray mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(0);
            make.right.equalTo(self.contentView.mas_right).with.offset(0);
            make.height.mas_equalTo(38);
        }];
        
        [self.phoneInputView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(0);
        }];
        
        [self.passwordInputView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.phoneInputView.mas_bottom).with.offset(32);
        }];
        
        __weak typeof (self)weakSelf = self;
        [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(weakSelf.phoneInputView);
            make.height.mas_equalTo(47);
            make.top.equalTo(weakSelf.passwordInputView.mas_bottom).with.offset(45);
        }];
        
        CGFloat resetButtonTop = 67;
        if (boundsHeight<667) {
            resetButtonTop = 30;
        }
        [_resetPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.loginButton.mas_bottom).with.offset(resetButtonTop);
            make.centerX.equalTo(self.contentView);
            make.height.mas_equalTo(18);
        }];
        
        [self.contentView layoutIfNeeded];
        _loginButton.layer.cornerRadius = _loginButton.frameHeight/2.0f;
        _loginButton.layer.masksToBounds = YES;

    }
    return self;
}

- (NSAttributedString *)applyPlaceholderAttributeWithString:(NSString *)string{
    if ([string isNotBlank]) {
        NSMutableAttributedString * mutableAttributeString = [[NSMutableAttributedString alloc]initWithString:string];
        [mutableAttributeString addAttributes:@{NSFontAttributeName:JXFont(15),NSForegroundColorAttributeName:JXColorFromRGB(0xdadada)} range:NSRangeFromString(string)];
        return mutableAttributeString;
    }
    return nil;
}

- (void)loginEvent{
    if (self.loginButtonHandle) {
        self.loginButtonHandle(self.loginButton, self);
    }
}

- (void)resetPasswordEvent{
    if (self.forgetPasswordButtonHandle) {
        self.forgetPasswordButtonHandle(self.resetPasswordButton, self);
    }
}

- (void)clearAllText{
    _phoneTextField.text = @"";
    _passwordTextField.text = @"";
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
