//
//  DSLoginEntranceController.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/5/24.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSLoginEntranceController.h"
#import "DSLoginSegmentView.h"
#import "DSLoginSubView.h"
#import "DSRegistSubView.h"
#import "DSForgetPasswordController.h"
#import "DSValidInfoCheck.h"
#import <UMShare/UMShare.h>
#import "DSNewLoginSubView.h"
#import "DSLoginInputView.h"
#import "DSThirdPartyLoginView.h"
#import "DSRegistViewController.h"
#import "DSBindingPhoneController.h"

@interface DSLoginEntranceController ()<UIGestureRecognizerDelegate>{
    
}

@property (nonatomic, strong) UIImageView * logoIV;
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) DSNewLoginSubView * loginSubView;

@property (nonatomic, strong) DSThirdPartyLoginView * thirdPartyLoginView;

@end

@implementation DSLoginEntranceController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.mas_key = @"selfview";
    [self changeNavigationBarTransparent:YES];
    NSLog(@"%.2f--->%.2f",boundsWidth,boundsHeight);
//    self.title = @"登录/注册";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[ImageString(@"public_back")imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backToPreviosPage)];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    __weak typeof (self)weakSelf = self;
    UITapGestureRecognizer * tapGes = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        [weakSelf.view endEditing:YES];
    }];
    tapGes.delegate = self;
    [self.view addGestureRecognizer:tapGes];
    
    CGFloat loginViewTop = 25;
    if (boundsHeight<667) {
        loginViewTop = 20;
    }else if (boundsHeight<=480){
        loginViewTop = 10;
    }
    
    UIImage * logo = ImageString(@"login_logo");
    _logoIV = [[UIImageView alloc]initWithFrame:CGRectZero];
    _logoIV.image = logo;
    [self.view addSubview:_logoIV];
    
    [_logoIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).with.offset(kStatusBarHegiht+25);
        make.width.mas_equalTo(ScreenAdaptFator_W*logo.size.width);
        make.height.mas_equalTo(_logoIV.mas_width).multipliedBy(logo.size.height/logo.size.width);
    }];

    [self.loginSubView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.top.equalTo(weakSelf.logoIV.mas_bottom).with.offset(loginViewTop);
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
    
    [self.view addSubview:self.thirdPartyLoginView];
    [self.thirdPartyLoginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(bottomImageView.mas_top).with.offset(5);
    }];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

#pragma mark UI

- (DSNewLoginSubView *)loginSubView{
    if (!_loginSubView) {
        
        _loginSubView = [[DSNewLoginSubView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, 0)];
        _loginSubView.hidden = NO;
        DSUserInfoModel * account = [JXAccountTool account];
        if ([account.phone isNotBlank]) {
            _loginSubView.phoneInputView.textField.text = account.phone;
        }
        [_loginSubView.passwordInputView.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [_loginSubView.phoneInputView.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        __weak typeof (self)weakSelf = self;
        [_loginSubView setResetPasswordHandle:^(UIButton *button, id view) {
            [weakSelf.view endEditing:YES];
            DSForgetPasswordController * forgetPasswordVC = [[DSForgetPasswordController alloc]init];
            [weakSelf.navigationController pushViewController:forgetPasswordVC animated:YES];
        }];
        
        //获取登录验证码
        _loginSubView.applyForVerificationCodeHandle = ^(UIButton *button, id view) {
            [weakSelf reqestVerifiactionCode:button view:view];
        };
        
        
        _loginSubView.registHandle = ^(UIButton *button, id view) {
            DSRegistViewController * registVC = [[DSRegistViewController alloc]init];
            [weakSelf.navigationController pushViewController:registVC animated:YES];
        };
        
        //开始登录
        _loginSubView.loginHandle = ^(UIButton *button, id view) {
            [weakSelf.view endEditing:YES];
            DSNewLoginSubView * subView = (DSNewLoginSubView *)view;
            
            if ([weakSelf shouldAllowLogin]==NO) {
                return ;
            }
            //登录
            [weakSelf startLoginWithPhone:weakSelf.loginSubView.phoneInputView.textField.text password:subView.passwordInputView.textField.text HUD:nil];
        };
        [self.view addSubview:_loginSubView];
        [_loginSubView layoutIfNeeded];
        _loginSubView.frameHeight = _loginSubView.contentView.frameBottom;
    }
    return _loginSubView;
}

- (DSThirdPartyLoginView *)thirdPartyLoginView{
    if (!_thirdPartyLoginView) {
        _thirdPartyLoginView = [[DSThirdPartyLoginView alloc]initWithFrame:CGRectZero];
        __weak typeof (self)weakSelf = self;
        _thirdPartyLoginView.ThirdPartyLoginWay = ^(NSInteger index) {
            [weakSelf thirdPartyLoginWithIndex:index];
        };
    }
    return _thirdPartyLoginView;
}


#pragma mark 按钮点击 及 事件处理

/* 登陆信息验证 */
- (BOOL)shouldAllowLogin{
    UITextField * phoneTF = self.loginSubView.phoneInputView.textField;
    UITextField * pwdTF = self.loginSubView.passwordInputView.textField;
    
    if ([phoneTF.text isNotBlank]==NO||phoneTF.text.length<11) {
        [MBProgressHUD showText:@"请输入正确的手机号" toView:self.view];
        return NO;
    }
    if (self.loginSubView.loginWay==1) {
        //验证码登录
        if ([pwdTF.text isNotBlank]==NO) {
            [MBProgressHUD showText:@"请输入验证码" toView:self.view];
            return NO;
        }
        
        if (pwdTF.text.length<6) {
            [MBProgressHUD showText:@"请输入正确的验证码" toView:self.view];
            return NO;
        }
    }else{
        //账号登录
        if ([pwdTF.text isNotBlank]==NO) {
            [MBProgressHUD showText:@"请输入密码" toView:self.view];
            return NO;
        }
        
        if ([DSValidInfoCheck iSValidPassword:pwdTF.text]==NO) {
            [MBProgressHUD showText:@"用户名或密码错误" toView:self.view];
            return NO;
        }
    }

    return YES;
}

//开始登陆
- (void)startLoginWithPhone:(NSString *)phone password:(NSString *)password HUD:(MBProgressHUD *)hud{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"phone"] = phone;
    if (self.loginSubView.loginWay==1) {
        //验证码登录
        params[@"code"] = password;
    }else{
        //密码登录
        NSString * pwd = [[NSString stringWithFormat:@"%@daishu@2018",password] md5String];
        params[@"password"] = pwd;
    }
    
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
                    if (self.DidLoginSucceed) {
                        self.DidLoginSucceed();
                    }
                    [self dismissViewControllerAnimated:YES completion:^{
                        [self postLoginSucceedNotification];
                    }];
                }
            }];
        }else{
            [hud hideAnimated:YES];
        }
    }];
}

//请求验证码
- (void)reqestVerifiactionCode:(UIButton *)button view:(DSNewLoginSubView *)view{
    UITextField * phoneTf = view.phoneInputView.textField;
    
    if ([phoneTf.text isNotBlank]==NO||phoneTf.text.length<11) {
        [MBProgressHUD showText:@"请输入正确的手机号" toView:self.view];
        return;
    }
    button.enabled = NO;
   
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [DSHttpResponseData LoginGetVerificationCodeWithParams:@{@"phone":phoneTf.text,@"type":@(2)} callback:^(id info, BOOL succeed, id extraInfo) {
        [HUD hideAnimated:YES];
        if (succeed) {
            [view startTimer];
            [MBProgressHUD showText:@"验证码已发送" toView:self.view];
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

#pragma mark

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField== _loginSubView.phoneInputView.textField){
        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
        }
    }else if (textField==_loginSubView.passwordInputView.textField&&_loginSubView.loginWay==1){
        if (textField.text.length > 6) {
            textField.text = [textField.text substringToIndex:6];
        }
    }
}

- (void)backToPreviosPage{
    [self dismissViewControllerAnimated:YES completion:nil];
}


//MARK: 调第三方登录
- (void)thirdPartyLoginWithIndex:(NSInteger)index{
    if (index==1) {
        [self getUserInfoForPlatform:UMSocialPlatformType_WechatSession index:1]; //微信
    }else if (index==2){
        [self getUserInfoForPlatform:UMSocialPlatformType_QQ index:2]; //QQ
    }else if(index==3){
         [self getUserInfoForPlatform:UMSocialPlatformType_Sina index:3]; //微博
    }
}

- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType index:(NSInteger)index
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:nil completion:^(id result, NSError *error) {
        
        UMSocialUserInfoResponse *resp = result;
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        if ([resp.uid isNotBlank]==NO) {
            return ;  //不存在uid直接返回
        }
        params[@"uid"] = resp.uid;
        params[@"nickname"] = resp.name;
        params[@"gender"] = resp.unionGender;
        params[@"avatar"] = resp.iconurl;
        params[@"type"] = @(index-1);
        
        MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [DSHttpResponseData loginWithThirdPartyAccount:params callback:^(id info, BOOL succeed, id extraInfo) {
            [HUD hideAnimated:YES];
            if (succeed) {
                if (extraInfo) {
                    BOOL bindedPhone = [extraInfo[@"isBindingPhone"] boolValue];
                    if (bindedPhone) {
                        [self dismissViewControllerAnimated:YES completion:^{
                            [self postLoginSucceedNotification];
                        }];
                    }else{
                        DSBindingPhoneController * bindPhoneVC = [[DSBindingPhoneController alloc]init];
                        bindPhoneVC.loginway = index;
                        bindPhoneVC.uid = resp.uid;
                        [self.navigationController pushViewController:bindPhoneVC animated:YES];
                    }
                }
            }
        }];
        
    }];
}

- (void)postLoginSucceedNotification{
    [[NSNotificationCenter defaultCenter]postNotificationName:kLoginSucceedNotificationKey object:nil];
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
