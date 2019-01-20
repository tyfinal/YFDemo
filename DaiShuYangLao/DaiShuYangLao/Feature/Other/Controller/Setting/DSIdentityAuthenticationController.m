//
//  DSIdentityAuthenticationController.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/5/31.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSIdentityAuthenticationController.h"
#import "DSLoginInputView.h"
#import "DSRegistSubView.h"

@interface DSIdentityAuthenticationController ()

@property (nonatomic, strong) UIButton * nextStepButton;
@property (nonatomic, strong) UITextField * idNoTF;
@property (nonatomic, strong) UITextField * realNameTF;

@end

@implementation DSIdentityAuthenticationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"完善个人信息";
    self.rt_disableInteractivePop = YES;
    
    DSUserInfoModel *account = [JXAccountTool account];
    
    if (self.popControllerLevel==0||!self.popControllerLevel) {
        self.popControllerLevel = 2;
    }
    
    __weak typeof (self)weakSelf = self;
    self.backButtonHandle = ^{
        NSArray * viewControllers = weakSelf.rt_navigationController.rt_viewControllers;
        if (viewControllers.count>=weakSelf.popControllerLevel) {
            [weakSelf.navigationController popToViewController:viewControllers[viewControllers.count-weakSelf.popControllerLevel] animated:YES];
        }
    };
    
    DSLoginInputView * realNameView = [[DSLoginInputView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:realNameView];
    realNameView.textField.attributedPlaceholder = [NSString applyAttributes:@{NSFontAttributeName:JXFont(14),NSForegroundColorAttributeName:JXColorFromRGB(0xd9d9d9)} forString:@"真实姓名"];
    _realNameTF = realNameView.textField;
    realNameView.leftImageView.image = ImageString(@"public_user_icon");
    
    DSLoginInputView * IDNumberView = [[DSLoginInputView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:IDNumberView];
    _idNoTF = IDNumberView.textField;
    
    IDNumberView.textField.attributedPlaceholder = [NSString applyAttributes:@{NSFontAttributeName:JXFont(14),NSForegroundColorAttributeName:JXColorFromRGB(0xd9d9d9)} forString:@"身份证号"];
    IDNumberView.leftImageView.image = ImageString(@"setting_id");
    
    [realNameView mas_makeConstraints:^(MASConstraintMaker *make) {
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
    
    [IDNumberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(realNameView.mas_bottom).with.offset(15);
        make.left.right.and.height.equalTo(realNameView);
    }];
    
    [self.nextStepButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(45*ScreenAdaptFator_W);
        make.right.equalTo(self.view.mas_right).with.offset(-45*ScreenAdaptFator_W);
        make.height.mas_equalTo(45);
        make.top.equalTo(IDNumberView.mas_bottom).with.offset(93*ScreenAdaptFator_H);
    }];
    
    
    if (account.isCertification.boolValue==1) {
        _idNoTF.enabled = NO;
        _realNameTF.enabled = NO;
        _nextStepButton.enabled = NO;
        [_nextStepButton setTitle:@"已认证" forState:UIControlStateNormal];
    }
    
    if ([account.idNo isNotBlank]) {
        _idNoTF.text = account.idNo;
        _realNameTF.text = account.name;
    }
    
    
}

- (UIButton *)nextStepButton{
    if (!_nextStepButton) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"完成认证" forState:UIControlStateNormal];
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

- (void)nextStepEvent{
    if ([_realNameTF.text isNotBlank]==NO) {
        [MBProgressHUD showText:@"请输入您的真实姓名" toView:self.view];
        return;
    }
    if ([_idNoTF.text isNotBlank]==NO) {
        [MBProgressHUD showText:@"身份证号码不能为空" toView:self.view];
        return;
    }
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"name"] = _realNameTF.text;
    params[@"idNo"] = _idNoTF.text;
    
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [DSHttpResponseData mineEditUserInfoWtihParams:params imageModel:nil callback:^(id info, BOOL succeed, id extraInfo) {
        [HUD hideAnimated:YES];
        if (succeed) {
            if (self.popControllerLevel==3) {
                [self.navigationController popViewControllerAnimated:YES]; //在提现页面完成认证 直接返回提现页面
            }else{
                if (self.rt_navigationController.rt_viewControllers.count>=3) {
                    [self.navigationController popToViewController:self.rt_navigationController.rt_viewControllers[self.rt_navigationController.rt_viewControllers.count-3] animated:YES];
                }else{
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
        }
    }];
    
}


- (void)dealloc{
    
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
