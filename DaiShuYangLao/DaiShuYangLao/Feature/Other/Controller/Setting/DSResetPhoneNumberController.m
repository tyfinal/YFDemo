//
//  DSResetPhoneNumberController.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/5/31.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSResetPhoneNumberController.h"
#import "DSCheckVerificationCodeController.h"
#import "DSLoginInputView.h"

@interface DSResetPhoneNumberController ()<UITextFieldDelegate>{
    
}

@property (nonatomic, strong) UITextField * textField;
@property (nonatomic, strong) UIButton * requestVerifaicationCodeButton;

@end

@implementation DSResetPhoneNumberController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"绑定新手机";
    
    __weak typeof (self)weakSelf = self;
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        [weakSelf.view endEditing:YES];
    }]];
    
    UILabel * countryTipsLabel = [[UILabel alloc]init];
    countryTipsLabel.font = JXFont(15);
    countryTipsLabel.textColor = JXColorFromRGB(0x231c12);
    countryTipsLabel.textAlignment = NSTextAlignmentLeft;
    countryTipsLabel.text = @"国家地区";
    [self.view addSubview:countryTipsLabel];

    UILabel * countryLabel = [[UILabel alloc]init];
    countryLabel.font = JXFont(16);
    countryLabel.textColor = JXColorFromRGB(0x231c12);
    countryLabel.textAlignment = NSTextAlignmentLeft;
    countryLabel.text = @"中国大陆  +0086";
    [self.view addSubview:countryLabel];
    
    UILabel * line = [[UILabel alloc]initWithFrame:CGRectZero];
    line.backgroundColor = JXColorFromRGB(0xd9d9d9);
    [self.view addSubview:line];
    
    DSLoginInputView * passwordInputView = [[DSLoginInputView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:passwordInputView];
    
    passwordInputView.textField.attributedPlaceholder = [NSString applyAttributes:@{NSFontAttributeName:JXFont(14),NSForegroundColorAttributeName:JXColorFromRGB(0xd9d9d9)} forString:@"请输入新手机号"];
    TextFiledDefaultLeftView * leftView = (TextFiledDefaultLeftView *) passwordInputView.leftView;
    leftView.frameWidth = 71;
    [leftView.iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftView.contentView.mas_left).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(25, 25));
        
    }];
    passwordInputView.leftImageView.image = ImageString(@"login_password");
    
    DSLoginInputView * confirmPasswordView = [[DSLoginInputView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:confirmPasswordView];
    confirmPasswordView.textField.attributedPlaceholder = [NSString applyAttributes:@{NSFontAttributeName:JXFont(14),NSForegroundColorAttributeName:JXColorFromRGB(0xd9d9d9)} forString:@"请输入验证码"];
    confirmPasswordView.leftImageView.image = ImageString(@"login_password");
    
    leftView = (TextFiledDefaultLeftView *) confirmPasswordView.leftView;
    leftView.frameWidth = 71;
    [leftView.iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(leftView.contentView.mas_left).with.offset(22);
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.left.equalTo(leftView.contentView.mas_left).with.offset(15);
//        make.right.equalTo(leftView.contentView.mas_right).with.offset(-35);
    }];
    
    TextFieldDefaultRightView * rightView = [[TextFieldDefaultRightView alloc]initWithFrame:CGRectMake(0, 0, 120*(ScreenAdaptFator_W), 31)];
    [rightView.button setBackgroundImage:ImageString(@"login_getverifycation") forState:UIControlStateNormal];
    confirmPasswordView.rightView = rightView;
    
    [countryTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(75,15+kLabelHeightOffset));
        make.left.equalTo(self.view.mas_left).with.offset(15);
        if (@available(iOS 11.0, *)) {
            make.centerY.equalTo(self.view.mas_safeAreaLayoutGuideTop).with.offset(47);
        } else {
            // Fallback on earlier versions
            make.centerY.equalTo(self.view.mas_top).with.offset(47+kNavigationBarHeight);
        }
    }];
    
    [countryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).with.offset(-15);
        make.left.equalTo(countryTipsLabel.mas_right).with.offset(32*(ScreenAdaptFator_W));
        make.height.mas_equalTo(16+kLabelHeightOffset);
        make.centerY.equalTo(countryTipsLabel.mas_centerY);
    }];

    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view.mas_right).with.offset(-45*(ScreenAdaptFator_W));
        make.height.mas_equalTo(1.0f);
        make.centerY.equalTo(countryTipsLabel.mas_centerY).with.offset(22.5);
    }];
    
    [passwordInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).with.offset(15);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.height.mas_equalTo(47);
        make.right.equalTo(self.view.mas_right).with.offset(-45*(ScreenAdaptFator_W));
    }];
    
    [confirmPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passwordInputView.mas_bottom).with.offset(15);
        make.left.right.and.height.equalTo(passwordInputView);
    }];
    
    [self.requestVerifaicationCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(45*ScreenAdaptFator_W);
        make.right.equalTo(self.view.mas_right).with.offset(-45*ScreenAdaptFator_W);
        make.height.mas_equalTo(45);
        make.top.equalTo(confirmPasswordView.mas_bottom).with.offset(124*(ScreenAdaptFator_H));
    }];
}

- (UIButton *)requestVerifaicationCodeButton{
    if (!_requestVerifaicationCodeButton) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"发送验证码" forState:UIControlStateNormal];
        button.adjustsImageWhenDisabled = NO;
        [button addTarget:self action:@selector(requestVerificationCode) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:ImageString(@"login_button_bg") forState:UIControlStateNormal];
        button.titleLabel.font = JXFont(18);
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.view addSubview:button];
        _requestVerifaicationCodeButton = button;
    }
    return _requestVerifaicationCodeButton;
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

- (void)requestVerificationCode{
    DSCheckVerificationCodeController * checkVerificationCodeVC = [[DSCheckVerificationCodeController alloc]init];
    checkVerificationCodeVC.phoneNumber = @"18756252939";
    [self.navigationController pushViewController:checkVerificationCodeVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
