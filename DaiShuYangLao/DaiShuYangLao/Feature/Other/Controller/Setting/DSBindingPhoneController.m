//
//  DSBindingPhoneController.m
//  DaiShuYangLao
//
//  Created by YueLiang Song on 2018/9/1.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSBindingPhoneController.h"
#import "DSLoginInputView.h"

@interface DSBindingPhoneController (){
    NSInteger countSecond;
}

@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic, strong) UITextField * phoneTF;
@property (nonatomic, strong) UITextField * verificationCodeTF;
@property (nonatomic, strong) UIButton * requestVerifaicationCodeButton;
@property (nonatomic, strong) UIButton * VerifaicationButton;
@end

@implementation DSBindingPhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"联合登录绑定";
    countSecond = 60;
    __weak typeof (self)weakSelf = self;
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        [weakSelf.view endEditing:YES];
    }]];
    
    DSLoginInputView * passwordInputView = [[DSLoginInputView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:passwordInputView];
    
    passwordInputView.textField.attributedPlaceholder = [NSString applyAttributes:@{NSFontAttributeName:JXFont(14),NSForegroundColorAttributeName:JXColorFromRGB(0xd9d9d9)} forString:@"请输入手机号"];
    [passwordInputView.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _phoneTF = passwordInputView.textField;
    passwordInputView.textField.keyboardType = UIKeyboardTypeNumberPad;
    TextFiledDefaultLeftView * leftView = (TextFiledDefaultLeftView *) passwordInputView.leftView;
    [leftView.iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    passwordInputView.leftImageView.image = ImageString(@"login_phone");
    
    DSLoginInputView * confirmPasswordView = [[DSLoginInputView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:confirmPasswordView];
    confirmPasswordView.textField.attributedPlaceholder = [NSString applyAttributes:@{NSFontAttributeName:JXFont(14),NSForegroundColorAttributeName:JXColorFromRGB(0xd9d9d9)} forString:@"请输入验证码"];
    [confirmPasswordView.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _verificationCodeTF = confirmPasswordView.textField;
    confirmPasswordView.textField.keyboardType = UIKeyboardTypeNumberPad;
    confirmPasswordView.leftImageView.image = ImageString(@"login_verificationcode");
    
    leftView = (TextFiledDefaultLeftView *) confirmPasswordView.leftView;
    [leftView.iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    TextFieldDefaultRightView * rightView = [[TextFieldDefaultRightView alloc]initWithFrame:CGRectMake(0, 0, 120*(ScreenAdaptFator_W), 31)];
    _VerifaicationButton = rightView.button;
    [rightView.button setBackgroundImage:ImageString(@"login_getverifycation") forState:UIControlStateNormal];
    [rightView.button addTarget:self action:@selector(requestVerificationCode:) forControlEvents:UIControlEventTouchUpInside];
    confirmPasswordView.rightView = rightView;
    
    [passwordInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.centerY.equalTo(self.view.mas_safeAreaLayoutGuideTop).with.offset(47);
        } else {
            // Fallback on earlier versions
            make.centerY.equalTo(self.view.mas_top).with.offset(47+kNavigationBarHeight);
        }
        make.left.equalTo(self.view.mas_left).with.offset(45*ScreenAdaptFator_W);
        make.height.mas_equalTo(47);
        make.right.equalTo(self.view.mas_right).with.offset(-45*ScreenAdaptFator_W);
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

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self stopTime];
}

- (UIButton *)requestVerifaicationCodeButton{
    if (!_requestVerifaicationCodeButton) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"关联" forState:UIControlStateNormal];
        button.adjustsImageWhenDisabled = NO;
        [button addTarget:self action:@selector(bindPhone) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:ImageString(@"login_button_bg") forState:UIControlStateNormal];
        button.titleLabel.font = JXFont(18);
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.view addSubview:button];
        _requestVerifaicationCodeButton = button;
    }
    return _requestVerifaicationCodeButton;
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

////请求验证码
//- (void)reqestVerifiactionCode:(UIButton *)button view:(DSRegistSubView *)view{
//    UITextField * phoneTf = view.phoneTextField;
//
//    if ([phoneTf.text isNotBlank]==NO||phoneTf.text.length<11) {
//        [MBProgressHUD showText:@"请输入正确的手机号" toView:self.view];
//        return;
//    }
//    button.enabled = NO;
//
//    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [DSHttpResponseData LoginGetVerificationCodeWithParams:@{@"phone":phoneTf.text,@"type":@(0)} callback:^(id info, BOOL succeed, id extraInfo) {
//        [HUD hideAnimated:YES];
//        if (succeed) {
//            [view startTimer];
//            [MBProgressHUD showText:@"验证码已发送" toView:self.view];
//        }
//    }];
//}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField{
    if (textField== _phoneTF){
        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
        }
    }else if (textField==_verificationCodeTF){
        if (textField.text.length > 6) {
            textField.text = [textField.text substringToIndex:6];
        }
    }
}

- (void)requestVerificationCode:(UIButton *)button{
    if ([_phoneTF.text isNotBlank]==NO||_phoneTF.text.length<11) {
        [MBProgressHUD showText:@"请输入正确的手机号" toView:self.view];
        return;
    }
    button.enabled = NO;

    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [DSHttpResponseData LoginGetVerificationCodeWithParams:@{@"phone":_phoneTF.text,@"type":@(2  )} callback:^(id info, BOOL succeed, id extraInfo) {
        [HUD hideAnimated:YES];
        if (succeed) {
            [self startTimer];
            [_verificationCodeTF becomeFirstResponder];
            [MBProgressHUD showText:@"验证码已发送" toView:self.view];
        }
    }];
}

/* 登陆信息验证 */
- (BOOL)paramtersVadilityCheck{
    UITextField * phoneTF = _phoneTF;
    UITextField * pwdTF = _verificationCodeTF;
    
    if ([phoneTF.text isNotBlank]==NO||phoneTF.text.length<11) {
        [MBProgressHUD showText:@"请输入正确的手机号" toView:self.view];
        return NO;
    }

    if ([pwdTF.text isNotBlank]==NO) {
        [MBProgressHUD showText:@"请输入验证码" toView:self.view];
        return NO;
    }
    
    if (pwdTF.text.length<6) {
        [MBProgressHUD showText:@"请输入正确的验证码" toView:self.view];
        return NO;
    }
    
    return YES;
}

- (void)bindPhone{
    if ([self.uid isNotBlank]==NO) {
        return;
    }
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"phone"] = _phoneTF.text;
    params[@"code"] = _verificationCodeTF.text;
    params[@"type"] = @(_loginway-1);
    params[@"uid"] = self.uid;
    if ([self paramtersVadilityCheck]) {
         MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [DSHttpResponseData loginBindPhoneWithThirdPlatForm:params callback:^(id info, BOOL succeed, id extraInfo) {
            [HUD hideAnimated:YES];
            if (succeed) {
                [[NSNotificationCenter defaultCenter]postNotificationName:kLoginSucceedNotificationKey object:nil]; //登录成功的通知
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }];
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
