//
//  DSRegistViewController.m
//  DaiShuYangLao
//
//  Created by YueLiang Song on 2018/9/1.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSRegistViewController.h"
#import "DSRegistSubView.h"
@interface DSRegistViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) DSRegistSubView * registSubView;

@end

@implementation DSRegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"注册";
    
    __weak typeof (self)weakSelf = self;
    UITapGestureRecognizer * tapGes = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        [weakSelf.view endEditing:YES];
    }];
    tapGes.delegate = self;
    [self.view addGestureRecognizer:tapGes];
    
    CGFloat loginViewTop = kNavigationBarHeight+30;
    CGFloat loginLeft = 20;
    if (boundsHeight<667) {
        loginLeft = 10;
    }
    [self.view addSubview:self.registSubView];
    [self.registSubView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(loginLeft);
        make.right.equalTo(self.view.mas_right).with.offset(-loginLeft);
        make.top.equalTo(self.view.mas_top).with.offset(loginViewTop);
        make.height.mas_equalTo(330).priorityLow();
    }];
    
    UIImageView * bottomImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    UIImage * bottomImage = ImageString(@"login_bottom_bg");
    bottomImageView.image = bottomImage;
    bottomImageView.alpha = 0.5;
    [self.view addSubview:bottomImageView];
    [bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.and.right.equalTo(self.view);
        make.height.equalTo(self.view.mas_width).multipliedBy(bottomImage.size.height/bottomImage.size.width);
    }];
}

- (DSRegistSubView *)registSubView{
    if (!_registSubView) {
        _registSubView = [[DSRegistSubView alloc]initWithFrame:CGRectZero];
        _registSubView.clipsToBounds = YES;
        _registSubView.passwordTextField.secureTextEntry = YES;
        _registSubView.superController = self;
        _registSubView.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
        _registSubView.verificationCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
        _registSubView.passwordTextField.keyboardType = UIKeyboardTypeNamePhonePad;
        _registSubView.passwordTextField.placeholder = @"6位以上数字与字母的组合";
        __weak typeof (self)weakSelf = self;
        [_registSubView.verificationCodeTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [_registSubView.phoneTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [_registSubView.passwordTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        _registSubView.applyForVerificationCodeHandle = ^(UIButton *button, id view) {
            [weakSelf.view endEditing:YES];
            [weakSelf reqestVerifiactionCode:button view:view]; //获取验证码
        };
        
        _registSubView.nextStepHandle = ^(UIButton *button, id view) {
            [weakSelf.view endEditing:YES];
            [weakSelf startRegist]; //开始注册
        };
        
        [self.view addSubview:_registSubView];
    }
    return _registSubView;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == _registSubView.phoneTextField) {
        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
        }
    }else if (textField == _registSubView.verificationCodeTextField){
        if (textField.text.length > 6) {
            textField.text = [textField.text substringToIndex:6];
        }
    }
}

//是否允许注册
- (BOOL)shouldAllowRegist{
    UITextField * phoneTf = self.registSubView.phoneTextField;
    UITextField * verifiactionTF = self.registSubView.verificationCodeTextField;
    UITextField * pwdTF = self.registSubView.passwordTextField;
    if ([phoneTf.text isNotBlank]==NO||phoneTf.text.length<11) {
        [MBProgressHUD showText:@"请输入正确的手机号" toView:self.view];
        return NO;
    }
    if ([verifiactionTF.text isNotBlank]==NO) {
        [MBProgressHUD showText:@"请输入验证码" toView:self.view];
        return NO;
    }
    if (verifiactionTF.text.length<6) {
        [MBProgressHUD showText:@"请输入正确的验证码" toView:self.view];
        return NO;
    }
    
    if ([pwdTF.text isNotBlank]==NO) {
        [MBProgressHUD showText:@"请输入密码" toView:self.view];
        return NO;
    }
    
    if ([DSValidInfoCheck iSValidPassword:pwdTF.text]==NO) {
        [MBProgressHUD showText:@"密码须是6位以上数字与字母的组合" toView:self.view];
        return NO;
    }
    return YES;
}

//开始注册
- (void)startRegist{
    UITextField * phoneTf = self.registSubView.phoneTextField;
    UITextField * verifiactionTF = self.registSubView.verificationCodeTextField;
    UITextField * pwdTF = self.registSubView.passwordTextField;
    
    if ([self shouldAllowRegist]==NO) {
        return;
    }
    
    NSString * pwd = [[NSString stringWithFormat:@"%@daishu@2018",pwdTF.text] md5String];
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [DSHttpResponseData LoginStartRegistWithParams:@{@"code":verifiactionTF.text,@"phone":phoneTf.text,@"password":pwd} callback:^(id info, BOOL succeed, id extraInfo) {
        if (succeed) {
            [self startLoginWithPhone:phoneTf.text password:pwdTF.text HUD:HUD];
        }else{
            [HUD hideAnimated:YES];
        }
    }];
}

//请求验证码
- (void)reqestVerifiactionCode:(UIButton *)button view:(DSRegistSubView *)view{
    UITextField * phoneTf = view.phoneTextField;
    
    if ([phoneTf.text isNotBlank]==NO||phoneTf.text.length<11) {
        [MBProgressHUD showText:@"请输入正确的手机号" toView:self.view];
        return;
    }
    button.enabled = NO;
    
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [DSHttpResponseData LoginGetVerificationCodeWithParams:@{@"phone":phoneTf.text,@"type":@(0)} callback:^(id info, BOOL succeed, id extraInfo) {
        [HUD hideAnimated:YES];
        if (succeed) {
            [view startTimer];
            [MBProgressHUD showText:@"验证码已发送" toView:self.view];
        }
    }];
}

//开始登陆
- (void)startLoginWithPhone:(NSString *)phone password:(NSString *)password HUD:(MBProgressHUD *)hud{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"phone"] = phone;
    //密码登录
    NSString * pwd = [[NSString stringWithFormat:@"%@daishu@2018",password] md5String];
    params[@"password"] = pwd;
    
    if (!hud) {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    [DSHttpResponseData LoginWithParams:params callback:^(id info, BOOL succeed, id extraInfo) {
        if (succeed) {

            [DSHttpResponseData mineGetUserInfo:^(id userInfo, BOOL userSucceed, id userExtraInfo) {
                [hud hideAnimated:YES];
                if (userSucceed) {
                    DSUserInfoModel * account = [JXAccountTool account];
                    DSUserInfoModel * newAccountInfo = (DSUserInfoModel *)userInfo;
                    newAccountInfo.phone = account.phone;
                    newAccountInfo.access_token = account.access_token;
                    [JXAccountTool saveAccount:newAccountInfo];
//                    if (self.DidLoginSucceed) {
//                        self.DidLoginSucceed();
//                    }
                    [self dismissViewControllerAnimated:YES completion:^{
                        [[NSNotificationCenter defaultCenter]postNotificationName:kLoginSucceedNotificationKey object:nil]; //登录成功的通知
                    }];
                }
            }];
        }else{
            [hud hideAnimated:YES];
        }
    }];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[YYLabel class]]) {
        return NO;
        //        YYLabel *label = (YYLabel *)touch.view;
        //        NSRange highlightRange;
        //        YYTextHighlight *highlight = [label _getHighlightAtPoint:[touch locationInView:label] range:&highlightRange];
        //        if (highlight) {
        //            return NO;
        //        }
        //        return YES;
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
