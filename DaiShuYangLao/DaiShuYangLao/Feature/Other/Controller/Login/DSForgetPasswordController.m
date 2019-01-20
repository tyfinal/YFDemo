//
//  DSResetPasswordController.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/5/28.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSForgetPasswordController.h"
#import "DSLoginInputView.h"
#import "DSRegistSubView.h"
#import "DSResetPasswordController.h"

@interface DSForgetPasswordController (){
    
}

@property (nonatomic, strong) DSRegistSubView * resetPasswordView;

@end

@implementation DSForgetPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"忘记密码";
    
    __weak typeof (self)weakSelf = self;
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        [weakSelf.view endEditing:YES];
    }]];
    
    CGFloat viewTop = 52+kNavigationBarHeight;
    CGFloat loginLeft    = 33;
    if (boundsHeight<667) {
        viewTop = 32+kNavigationBarHeight;
        loginLeft = 15;
    }
    
    [self.resetPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(loginLeft);
        make.right.equalTo(self.view.mas_right).with.offset(-loginLeft);
        make.top.equalTo(self.view.mas_top).with.offset(viewTop);
        make.height.mas_equalTo(330).priorityLow();
    }];
    
    UIImageView * bottomImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    bottomImageView.image = ImageString(@"login_bottom_bg");
    bottomImageView.alpha = 0.5;
    [self.view addSubview:bottomImageView];
    [bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(85);
    }];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.resetPasswordView stopTime];
}

- (DSRegistSubView *)resetPasswordView{
    if (!_resetPasswordView) {
        _resetPasswordView = [[DSRegistSubView alloc]initWithFrame:CGRectZero];
//        _resetPasswordView.backgroundColor = [UIColor yellowColor];
        _resetPasswordView.passwordInputView.hidden = YES;
        _resetPasswordView.agreementLabel.hidden = YES;
        _resetPasswordView.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
        _resetPasswordView.verificationCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
        [_resetPasswordView.phoneTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [_resetPasswordView.verificationCodeTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        __weak typeof (self)weakSelf = self;
        [_resetPasswordView.registButton setTitle:@"下一步" forState:UIControlStateNormal];
        [_resetPasswordView setNextStepHandle:^(UIButton *button, id view) {
            if ([weakSelf shouldAllowContinue]) {
                DSResetPasswordController * resetPasswordVC = [[DSResetPasswordController alloc]init];
                resetPasswordVC.verificationCode = weakSelf.resetPasswordView.verificationCodeTextField.text;
                resetPasswordVC.phoneNumber = weakSelf.resetPasswordView.phoneTextField.text;
                [weakSelf.navigationController pushViewController:resetPasswordVC animated:YES];
            }
        }];
        [self.view addSubview:_resetPasswordView];
        
        
        [_resetPasswordView setApplyForVerificationCodeHandle:^(UIButton *button, id view) {
            [weakSelf reqestVerifiactionCodeWithButton:button view:view];
        }];
        
        CGFloat viewTop = 140;
        if (boundsHeight<667) {
            viewTop = 120;
        }
        [_resetPasswordView.registButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.resetPasswordView.verificationCodeInputView.mas_bottom).with.offset(viewTop);
        }];
    }
    return _resetPasswordView;
}

//请求验证码
- (void)reqestVerifiactionCodeWithButton:(UIButton *)button view:(DSRegistSubView *)view{
    UITextField * phoneTf = self.resetPasswordView.phoneTextField;
    
    if ([phoneTf.text isNotBlank]==NO||phoneTf.text.length<11) {
        [MBProgressHUD showText:@"请输入正确的手机号" toView:self.view];
        return;
    }
    button.enabled = NO;
    
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [DSHttpResponseData LoginGetVerificationCodeWithParams:@{@"phone":phoneTf.text,@"type":@(1)} callback:^(id info, BOOL succeed, id extraInfo) {
        [HUD hideAnimated:YES];
        if (succeed) {
            [view startTimer]; //开始验证码倒计时
            [MBProgressHUD showText:@"验证码已发送" toView:self.view];
        }
    }];
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == _resetPasswordView.phoneTextField) {
        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
        }
    }else if (textField == _resetPasswordView.verificationCodeTextField){
        if (textField.text.length > 6) {
            textField.text = [textField.text substringToIndex:6];
        }
    }
}

- (BOOL)shouldAllowContinue{
    UITextField * phoneTf = self.resetPasswordView.phoneTextField;
    UITextField * verifiactionTF = self.resetPasswordView.verificationCodeTextField;
    if ([phoneTf.text isNotBlank]==NO||phoneTf.text.length<11) {
        [MBProgressHUD showText:@"请输入正确的手机号" toView:self.view];
        return NO;
    }
    
    if ([verifiactionTF.text isNotBlank]==NO) {
        [MBProgressHUD showText:@"请输入验证码" toView:self.view];
        return NO;
    }
    return YES;
}

- (void)dealloc{
    JXLog(@"完成释放");
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
