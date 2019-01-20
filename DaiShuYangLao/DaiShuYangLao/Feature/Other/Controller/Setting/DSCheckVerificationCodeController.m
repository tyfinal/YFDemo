//
//  DSResetPhoneNumberController.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/5/31.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSCheckVerificationCodeController.h"
#import "DSLoginInputView.h"
#import <IQKeyboardManager.h>
#import "DSResetPhoneNumberController.h"
#import "UICKeyChainStore.h"
@interface DSCheckVerificationCodeController (){
    
}

@property (nonatomic, strong) DSLoginInputView * inputView;
@property (nonatomic, strong) UIButton * nextStepButton;

@end

@implementation DSCheckVerificationCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"绑定手机修改";

    [self.view addSubview:self.inputView];
    [self.view addSubview:self.nextStepButton];
    [self.inputView.textField becomeFirstResponder];
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(40*ScreenAdaptFator_W);
        make.right.equalTo(self.view.mas_right).with.offset(-40*ScreenAdaptFator_W);
        make.height.mas_equalTo(47);
        if (@available(iOS 11.0 ,*)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).with.offset(24);
        }else{
            make.top.equalTo(self.view.mas_top).with.offset(24+kNavigationBarHeight);
        }
    }];
    
    [self.nextStepButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(45*ScreenAdaptFator_W);
        make.right.equalTo(self.view.mas_right).with.offset(-45*ScreenAdaptFator_W);
        make.height.mas_equalTo(45);
        make.top.equalTo(self.inputView.mas_bottom).with.offset(230*ScreenAdaptFator_H);
    }];
}

- (DSLoginInputView *)inputView{
    if (!_inputView) {
        DSLoginInputView * inputView = [[DSLoginInputView alloc]initWithFrame:CGRectZero];
        inputView.leftImageView.image = ImageString(@"login_pwd");
        inputView.textField.placeholder = @"请输入验证码";
        
        UIView * rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 120*ScreenAdaptFator_W, 33)];
        rightView.backgroundColor = [UIColor whiteColor];
        inputView.textField.rightView = rightView;
        inputView.textField.rightViewMode = UITextFieldViewModeAlways;
        
        UIButton * VerifaicationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        VerifaicationButton.frame = rightView.bounds;
        [VerifaicationButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [VerifaicationButton addTarget:self action:@selector(regainVerificaitonCode) forControlEvents:UIControlEventTouchUpInside];
        VerifaicationButton.titleLabel.font = JXFont(15*ScreenAdaptFator_W);
        [VerifaicationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [VerifaicationButton setBackgroundImage:ImageString(@"login_getverifycation") forState:UIControlStateNormal];
        VerifaicationButton.layer.cornerRadius = rightView.frameHeight/2.0f;
        VerifaicationButton.layer.masksToBounds = YES;
        
        [rightView addSubview:VerifaicationButton];
        
        _inputView = inputView;
    }
    return _inputView;
}


- (UIButton *)nextStepButton{
    if (!_nextStepButton) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"下一步" forState:UIControlStateNormal];
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

- (void)regainVerificaitonCode{
    
    DSUserInfoModel * account = [JXAccountTool account];
    if ([account.phone isNotBlank]==NO)return;
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"phone"] = account.phone;
    params[@"type"] = @(1);
    [DSHttpResponseData LoginGetVerificationCodeWithParams:params callback:^(id info, BOOL succeed, id extraInfo) {
        if (succeed) {
            [MBProgressHUD showText:@"验证码发送成功" toView:self.view];
        }
    }];
}

- (void)nextStepEvent{
    DSResetPhoneNumberController * resetPhoneNumberVC = [[DSResetPhoneNumberController alloc]init];
    [self.navigationController pushViewController:resetPhoneNumberVC animated:YES];
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
