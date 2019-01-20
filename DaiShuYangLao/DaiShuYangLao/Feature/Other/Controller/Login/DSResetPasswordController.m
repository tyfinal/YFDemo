//
//  DSResetPasswordController.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/5/28.
//  Copyright © 2018年 tyfinal. All rights reserved.
//  未登录用户修改密码

#import "DSResetPasswordController.h"
#import "DSLoginSubView.h"
#import "DSLoginInputView.h"
#import "DSValidInfoCheck.h"

@interface DSResetPasswordController (){
    
}

@property (nonatomic, strong) DSLoginSubView * resetPasswordView;

@end

@implementation DSResetPasswordController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改密码";
    
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

- (DSLoginSubView *)resetPasswordView{
    if (!_resetPasswordView) {
        _resetPasswordView = [[DSLoginSubView alloc]initWithFrame:CGRectZero];
        //        _resetPasswordView.backgroundColor = [UIColor yellowColor];
        _resetPasswordView.resetPasswordButton.hidden = YES;
        _resetPasswordView.phoneTextField.secureTextEntry = YES;
        _resetPasswordView.passwordTextField.secureTextEntry = YES;
        _resetPasswordView.phoneTextField.placeholder = @"请输入新密码";
        _resetPasswordView.phoneInputView.leftImageView.image = ImageString(@"login_password");
        _resetPasswordView.passwordTextField.placeholder = @"请再确认密码";
        [_resetPasswordView.loginButton setTitle:@"下一步" forState:UIControlStateNormal];
        [self.view addSubview:_resetPasswordView];
        __weak typeof (self)weakSelf = self;
        CGFloat viewTop = 140;
        if (boundsHeight<667) {
            viewTop = 120;
        }
        [_resetPasswordView.loginButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.resetPasswordView.passwordInputView.mas_bottom).with.offset(viewTop);
        }];
        
        
        _resetPasswordView.loginButtonHandle = ^(UIButton *button, id view) {
            [weakSelf resetPassword];
        };
        
    }
    return _resetPasswordView;
}

//是否允许注册
- (BOOL)shouldResetPassword{
    UITextField * pwdTF = self.resetPasswordView.phoneTextField;
    UITextField * confirmPwdTF = self.resetPasswordView.passwordTextField;
    if ([pwdTF.text isNotBlank]==NO) {
        [MBProgressHUD showText:@"请输入新密码" toView:self.view];
        return NO;
    }
    
    if ([confirmPwdTF.text isNotBlank]==NO) {
        [MBProgressHUD showText:@"请确认新密码" toView:self.view];
        return NO;
    }
    
    if (![confirmPwdTF.text isEqualToString:pwdTF.text]) {
        [MBProgressHUD showText:@"两次输入的密码不一致" toView:self.view];
        return NO;
    }
    
    if ([DSValidInfoCheck iSValidPassword:pwdTF.text]==NO) {
        [MBProgressHUD showText:@"密码只能由6位以上的字母与数字组成" toView:self.view];
        return NO;
    }
    return YES;
}

//重设密码
- (void)resetPassword{
    if ([self shouldResetPassword]==YES) {
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        params[@"phone"] = self.phoneNumber;
        params[@"code"] = self.verificationCode;
        params[@"newPassword"] = [[NSString stringWithFormat:@"%@daishu@2018",self.resetPasswordView.passwordTextField.text] md5String];
        MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [DSHttpResponseData LoginResetPasswordWithParams:params callback:^(id info, BOOL succeed, id extraInfo) {
            [HUD hideAnimated:YES];
            if (succeed) {
                [self startLoginWithPhone:self.phoneNumber password:self.resetPasswordView.passwordTextField.text HUD:HUD];
            }else{
//                [MBProgressHUD showText:@"密码修改失败，请重试" toView:self.view]; 
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
