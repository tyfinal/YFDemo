//
//  DSOrderPayResultHandleController.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/7/4.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSOrderPayResultHandleController.h"
#import "YJPayHelper.h"
#import "DSMyOrderEntranceController.h"

@interface DSOrderPayResultHandleController (){
    
}

@property (nonatomic, strong) UIImageView * statusIV;
@property (nonatomic, strong) UILabel * statusLabel;
@property (nonatomic, strong) UILabel * tipsLabel;
@property (nonatomic, strong) UIButton * leftButton;
@property (nonatomic, strong) UIButton * rightButton;
@property (nonatomic, strong) UIView * contentView;

@property (nonatomic, assign) NSInteger applyStatus;

@end

@implementation DSOrderPayResultHandleController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"支付订单";
    self.navigationController.navigationBar.shadowImage = nil;
    self.rt_disableInteractivePop = YES;
    
    NSArray * viewControllers = self.rt_navigationController.rt_viewControllers;
    __weak typeof (self)weakSelf = self;
    self.backButtonHandle = ^{
        if (viewControllers.count>=weakSelf.popControllerLevel) {
            [weakSelf.navigationController popToViewController:viewControllers[viewControllers.count-weakSelf.popControllerLevel] animated:YES];
        }
    };
    
    self.contentView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.contentView];
    
    _statusIV = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:_statusIV];
    
    CGFloat statusFontSize = ceil(18*ScreenAdaptFator_W);
    _statusLabel = [[UILabel alloc]init];
    _statusLabel.font = JXFont(statusFontSize);
    _statusLabel.textColor = JXColorFromRGB(0x282828);
    _statusLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_statusLabel];
    
    CGFloat tipsFontSize = ceil(13*ScreenAdaptFator_W);
    _tipsLabel = [[UILabel alloc]init];
    _tipsLabel.font = JXFont(tipsFontSize);
    _tipsLabel.textColor = JXColorFromRGB(0x4b4b4b);
    _tipsLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_tipsLabel];
    
    for (NSInteger i=0; i<2; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = JXFont(statusFontSize);
        [button setTitleColor:@[APP_MAIN_COLOR,JXColorFromRGB(0x8c8c8c)][i] forState:UIControlStateNormal];
        [self.contentView addSubview:button];
        button.layer.cornerRadius = 5.0f;
        button.layer.masksToBounds = YES;
        button.layer.borderColor = [@[APP_MAIN_COLOR,JXColorFromRGB(0x8c8c8c)][i] CGColor];
        button.layer.borderWidth = 1.0f;
        button.tag = 10+i;
        if(i==0) self.leftButton = button;
        if(i==1) self.rightButton = button;
    }
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(self.view.mas_width);
        make.centerY.equalTo(self.view);
    }];
    
    CGFloat statusIV_W = ceil(80*ScreenAdaptFator_W);
    [self.statusIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(statusIV_W, statusIV_W));
        make.top.equalTo(self.contentView.mas_top);
        make.centerX.equalTo(self.contentView.mas_centerX);
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 24));
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.top.equalTo(self.statusIV.mas_bottom).with.offset(ceil(40*ScreenAdaptFator_W));
    }];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).with.offset(10);
        make.right.equalTo(self.contentView.mas_right).with.offset(-10);
        make.height.mas_equalTo(18);
        make.top.equalTo(self.statusLabel.mas_bottom).with.offset(10);
    }];
    
    [@[_leftButton,_rightButton] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ceil(100*ScreenAdaptFator_W), 38));
        make.top.equalTo(self.tipsLabel.mas_bottom).with.offset(ceil(30*ScreenAdaptFator_W));
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
    [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX).with.offset(-(ceil(72*ScreenAdaptFator_W)));
    }];
    
    [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX).with.offset((ceil(72*ScreenAdaptFator_W)));
    }];
    
    self.applyStatus = self.payStatus;
    
}

- (void)setApplyStatus:(NSInteger)payStatus{
    _applyStatus = payStatus;
    NSArray * images = @[@"public_payresult_failure",@"public_payresult_success",@"public_payresult_handle"];
    self.statusIV.image = ImageString(images[payStatus+1]);
    self.statusLabel.text = @[@"支付失败",@"支付成功",@"订单处理中"][payStatus+1];
    self.tipsLabel.text = @[@"支付遇到问题，请您重新支付",@"我们将尽快安排发货，请保持手机畅通",@"系统正在处理请耐心等待"][payStatus+1];
    if (payStatus==-1) {
        [_leftButton setTitle:@"重新支付" forState:UIControlStateNormal];
        [_rightButton setTitle:@"返回订单" forState:UIControlStateNormal];
    }else if (payStatus==0){
        [_leftButton setTitle:@"继续购物" forState:UIControlStateNormal];
        [_rightButton setTitle:@"查看订单" forState:UIControlStateNormal];
    }else{
         [_leftButton setTitle:@"继续购物" forState:UIControlStateNormal];
        _rightButton.hidden = YES;
    }
    
}

- (void)buttonClick:(UIButton *)button{
    NSInteger index = button.tag - 10;
    if (self.payStatus==-1) {
        //支付失败
        if (index==0) {
            //继续支付
            [self repay];
        }else{
            DSMyOrderEntranceController * orderEntraceVC = [[DSMyOrderEntranceController alloc]init];
            orderEntraceVC.hidesBottomBarWhenPushed = YES;
            orderEntraceVC.popControllerLevel = self.popControllerLevel+1;
            orderEntraceVC.selectIndex = 1;
            [self.navigationController pushViewController:orderEntraceVC animated:YES];
        }
    }else if (self.payStatus==0){
        //支付成功
        if (index==0) {
            //继续购物
            [DSAppDelegate goToHomePage];
        }else{
            DSMyOrderEntranceController * orderEntraceVC = [[DSMyOrderEntranceController alloc]init];
            orderEntraceVC.hidesBottomBarWhenPushed = YES;
            orderEntraceVC.popControllerLevel = self.popControllerLevel+1;
            orderEntraceVC.selectIndex = 2;
            [self.navigationController pushViewController:orderEntraceVC animated:YES];
        }
    }else{
        //订单处理中
        if (index==0) {
            //继续购物
             [DSAppDelegate goToHomePage];
        }
    }
}

//重新支付
- (void)repay{
    [self.navigationController popViewControllerAnimated:YES];
//    if ([self.orderNumber isNotBlank]) {
//        MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        NSMutableDictionary * params = [NSMutableDictionary dictionary];
//        params[@"orderNo"] = self.orderNumber;
//        if (self.pensionAmount.doubleValue>0) {
//            params[@"point"] = self.pensionAmount;
//        }
//        
//        if (self.goldAmount.doubleValue>0) {
//            params[@"gold"] = self.goldAmount;
//        }
//        
//        [DSHttpResponseData orderGetAlipayPayOrderInfoWithParams:params callback:^(id info, BOOL succeed, id extraInfo) {
//            [HUD hideAnimated:YES];
//            if (succeed) {
//                if ([info isNotBlank]) {
//                    //调用支付宝进行支付
//                    YJPayHelper * payHelper = [YJPayHelper sharePayHelper];
//                    [payHelper payOrder:info paymentMode:Payment_ALiPay]; //调用支付宝支付
//                    [payHelper setAlipayPayResultCallback:^(id info, BOOL succeed, id extraInfo) {
//                        if (self.isMembershipUpgrade&&succeed) {
//                            //会员支付成功后 跳转我的
//                            [DSAppDelegate goToHomePageWithIndex:2 params:@{@"upgradesucceed":@"1"}];
//                        }else{
//                            self.payStatus = [extraInfo integerValue];
//                            self.applyStatus = self.payStatus;
//                        }
//                    }];
//                }
//            }
//        }];
//    }
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
