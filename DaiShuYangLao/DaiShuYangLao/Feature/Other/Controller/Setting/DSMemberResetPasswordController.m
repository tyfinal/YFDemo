//
//  DSMemberResetPasswordController.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/5/31.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSMemberResetPasswordController.h"
#import "DSLoginInputView.h"
#import "DSRegistSubView.h"
#import "DSValidInfoCheck.h"
#import "DSUserInfoModel.h"

@interface DSMemberResetPasswordController (){
    
}

@property (nonatomic, strong) DSRegistSubView * resetPasswordView;
@property (nonatomic, strong) UIButton * nextStepButton;

@property (nonatomic, strong) UITextField * verficationTF;
@property (nonatomic, strong) UITextField * passwordTF;
@property (nonatomic, strong) UITextField * confirmPwdTF;
//@property (nonatomic, strong) NSTimer * timer;

@end

@implementation DSMemberResetPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"修改登录密码";
    __weak typeof (self)weakSelf = self;
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        [weakSelf.view endEditing:YES];
    }]];
    
    //验证码
    DSLoginInputView * verificationView = [[DSLoginInputView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:verificationView];
    verificationView.textField.attributedPlaceholder = [NSString applyAttributes:@{NSFontAttributeName:JXFont(14),NSForegroundColorAttributeName:JXColorFromRGB(0xd9d9d9)} forString:@"请输入验证码"];
    [verificationView.textField addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    _verficationTF = verificationView.textField;
    _verficationTF.keyboardType = UIKeyboardTypeNumberPad;
    verificationView.leftImageView.image = ImageString(@"login_verificationcode");
    
    TextFieldDefaultRightView * rightView = [[TextFieldDefaultRightView alloc]initWithFrame:CGRectMake(0, 0, 120*(ScreenAdaptFator_W), 31)];
    [rightView.button setBackgroundImage:ImageString(@"login_getverifycation") forState:UIControlStateNormal];
    [rightView.button addTarget:self action:@selector(requestVerification) forControlEvents:UIControlEventTouchUpInside];
    verificationView.rightView = rightView;
    
    //密码
    DSLoginInputView * passwordInputView = [[DSLoginInputView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:passwordInputView];
    passwordInputView.textField.attributedPlaceholder = [NSString applyAttributes:@{NSFontAttributeName:JXFont(14),NSForegroundColorAttributeName:JXColorFromRGB(0xd9d9d9)} forString:@"请输入新密码"];
    [passwordInputView.textField addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    _passwordTF = passwordInputView.textField;
    _passwordTF.secureTextEntry = YES;
    _passwordTF.keyboardType = UIKeyboardTypeNamePhonePad;
    passwordInputView.leftImageView.image = ImageString(@"login_password");
    
    //确认密码
    DSLoginInputView * confirmPasswordView = [[DSLoginInputView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:confirmPasswordView];
    confirmPasswordView.textField.attributedPlaceholder = [NSString applyAttributes:@{NSFontAttributeName:JXFont(14),NSForegroundColorAttributeName:JXColorFromRGB(0xd9d9d9)} forString:@"请再确认密码"];
    [confirmPasswordView.textField addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    _confirmPwdTF = confirmPasswordView.textField;
    _confirmPwdTF.secureTextEntry = YES;
     _confirmPwdTF.keyboardType = UIKeyboardTypeNamePhonePad;
    confirmPasswordView.leftImageView.image = ImageString(@"login_password");
    
    [verificationView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).with.offset(24);
        } else {
            // Fallback on earlier versions
            make.top.equalTo(self.view.mas_top).with.offset(24+kNavigationBarHeight);
        }
        make.left.equalTo(self.view.mas_left).with.offset(45*(ScreenAdaptFator_W));
        make.height.mas_equalTo(47);
        make.right.equalTo(self.view.mas_right).with.offset(-45*(ScreenAdaptFator_W));
    }];
    
    [passwordInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(verificationView.mas_bottom).with.offset(15);
        make.left.right.and.height.equalTo(verificationView);
    }];
    
    [confirmPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passwordInputView.mas_bottom).with.offset(15);
        make.left.right.and.height.equalTo(verificationView);
    }];
    
    [self.nextStepButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(45*ScreenAdaptFator_W);
        make.right.equalTo(self.view.mas_right).with.offset(-45*ScreenAdaptFator_W);
        make.height.mas_equalTo(45);
        make.top.equalTo(confirmPasswordView.mas_bottom).with.offset(93*ScreenAdaptFator_H);
    }];
}

- (UIButton *)nextStepButton{
    if (!_nextStepButton) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"确定" forState:UIControlStateNormal];
        button.adjustsImageWhenDisabled = NO;
        [button addTarget:self action:@selector(nextStepEvent) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:ImageString(@"login_button_bg") forState:UIControlStateNormal];
        button.titleLabel.font = JXFont(18);
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.view addSubview:button];
        _nextStepButton = button;
    }
    return _nextStepButton;
}

//获取验证码
- (void)requestVerification{
    DSUserInfoModel * account = [JXAccountTool account];
    if ([account.phone isNotBlank]==NO) return;
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"phone"] = account.phone;
    params[@"type"] =  @(1);
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [DSHttpResponseData LoginGetVerificationCodeWithParams:params callback:^(id info, BOOL succeed, id extraInfo) {
        [HUD hideAnimated:YES];
        if (succeed) {
            [MBProgressHUD showText:@"验证码发送成功" toView:self.view];
        }
    }];
}

//修改棉麻
- (void)nextStepEvent{
    if ([self inputInfoValidity]==YES) {
        DSUserInfoModel * account = [JXAccountTool account];
        if ([account.phone isNotBlank]==NO) return;
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        params[@"phone"] = account.phone;
        params[@"code"] = _verficationTF.text;
        params[@"newPassword"] = [[NSString stringWithFormat:@"%@daishu@2018",_passwordTF.text] md5String];
        MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [DSHttpResponseData LoginResetPasswordWithParams:params callback:^(id info, BOOL succeed, id extraInfo) {
            if (succeed) {
                [self startLoginWithPhone:account.phone password:_passwordTF.text HUD:HUD];
            }else{
                [HUD hideAnimated:YES];
            }
        }];
    }
}

//开始登陆
- (void)startLoginWithPhone:(NSString *)phone password:(NSString *)password HUD:(MBProgressHUD *)hud{
    NSString * pwd = [[NSString stringWithFormat:@"%@daishu@2018",password] md5String];
    if (!hud) {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    [DSHttpResponseData LoginWithParams:@{@"phone":phone,@"password":pwd} callback:^(id info, BOOL succeed, id extraInfo) {
        [hud hideAnimated:YES];
        if (succeed) {
            [DSAppDelegate goToHomePageWithIndex:2];
        }
    }];
}

- (void)textFieldDidChanged:(UITextField *)textField{
    if (textField == self.verficationTF) {
        if (self.verficationTF.text.length>6) {
            self.verficationTF.text = [self.verficationTF.text substringToIndex:6];
        }
    }
}

/** 输入有效性验证 */
- (BOOL)inputInfoValidity{
    self.verficationTF.text = [self.verficationTF.text stringByTrim];
    self.passwordTF.text    = [self.passwordTF.text stringByTrim];
    self.confirmPwdTF.text  = [self.confirmPwdTF.text stringByTrim];
    
    if ([self.verficationTF.text isNotBlank]==NO) {
        [MBProgressHUD showText:@"请输入验证码" toView:self.view];
         return NO;
    }
    
    if ([DSValidInfoCheck isValidVerificationCode:self.verficationTF.text]==NO) {
        [MBProgressHUD showText:@"请输入有效的验证码" toView:self.view];
         return NO;
    }
    
    if ([self.passwordTF.text isNotBlank]==NO) {
        [MBProgressHUD showText:@"请输入新密码" toView:self.view];
        return NO;
    }
    
    if ([DSValidInfoCheck iSValidPassword:self.passwordTF.text]==NO) {
        [MBProgressHUD showText:@"密码只能由6位以上的字母与数字组成" toView:self.view];
        return NO;
    }
    
    if ([self.confirmPwdTF.text isNotBlank]==NO) {
        [MBProgressHUD showText:@"请再次输入密码" toView:self.view];
        return NO;
    }
    
    if ([self.passwordTF.text isEqualToString:self.confirmPwdTF.text]==NO) {
         [MBProgressHUD showText:@"两次输入的密码不一致" toView:self.view];
        return NO;
    }
    
    return YES;
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
