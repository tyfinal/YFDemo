//
//  DSOrderPaymentController.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/4.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSOrderPaymentController.h"
#import "DSOrderPaymentCell.h"
#import "YJPayHelper.h"
#import "DSOrderPayResultHandleController.h"

@interface DSOrderPaymentController ()<UITableViewDelegate,UITableViewDataSource>{
    
}

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIButton * payButton;


@end

@implementation DSOrderPaymentController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"支付";
    self.navigationController.navigationBar.shadowImage = nil;
    self.rt_disableInteractivePop = YES;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.payButton];
    
    NSDecimalNumber * totalAmount = [NSDecimalNumber decimalNumberWithString:self.totalAmount];
    NSDecimalNumber * pensionNum = [NSDecimalNumber decimalNumberWithString:self.pensionAmount];
    NSDecimalNumber * goldNum = [NSDecimalNumber decimalNumberWithString:self.goldAmount];
    NSDecimalNumber * actutalPayNum = [NSDecimalNumber decimalNumberWithString:self.totalAmount];
    if ([pensionNum compare:[NSDecimalNumber decimalNumberWithString:@"0"]]==NSOrderedDescending) {
        actutalPayNum = [totalAmount decimalNumberBySubtracting:pensionNum];
    }else if ([goldNum compare:[NSDecimalNumber decimalNumberWithString:@"0"]]==NSOrderedDescending) {
        actutalPayNum = [totalAmount decimalNumberBySubtracting:goldNum];
    }
    if ([actutalPayNum compare:[NSDecimalNumber decimalNumberWithString:@"0"]]!=NSOrderedDescending) {
        actutalPayNum = [NSDecimalNumber decimalNumberWithString:@"0.01"];
    }
    
    self.actualPayAmount = actutalPayNum.stringValue;
    
    _pagementWay = 1;
    [self.payButton setTitle:[NSString stringWithFormat:@"支付宝支付%.2f",self.actualPayAmount.floatValue] forState:UIControlStateNormal];
    [self.payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(64);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            // Fallback on earlier versions
            make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        }
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            // Fallback on earlier versions
            make.top.equalTo(self.view.mas_top).with.offset(0);
        }
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.payButton.mas_top);
    }];
    
    __weak typeof (self)weakSelf = self;
    NSArray * viewControllers = self.rt_navigationController.rt_viewControllers;
    self.backButtonHandle = ^{
        if (viewControllers.count>=weakSelf.popControllerLevel) {
            [weakSelf.navigationController popToViewController:viewControllers[viewControllers.count-weakSelf.popControllerLevel] animated:YES];
        }
    };  
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_pagementWay-1 inSection:1] animated:YES scrollPosition:UITableViewScrollPositionNone];
    
}

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, boundsHeight) style:UITableViewStyleGrouped];
        tableView.backgroundColor = JXColorFromRGB(0xf6f7f8);
        tableView.showsVerticalScrollIndicator = NO;
        tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.sectionFooterHeight = CGFLOAT_MIN;
        [tableView setTableFooterView:[UIView new]];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView = tableView;
    }
    return _tableView;
}

- (UIButton *)payButton{
    if (!_payButton) {
        _payButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _payButton.backgroundColor = APP_MAIN_COLOR;
        [_payButton setTitle:@"支付宝支付0.00元" forState:UIControlStateNormal];
        [_payButton addTarget:self action:@selector(payEvent) forControlEvents:UIControlEventTouchUpInside];
        _payButton.titleLabel.font = JXFont(18);
        [_payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _payButton;
}

- (void)setPagementWay:(NSInteger)pagementWay{
    if (pagementWay!=_pagementWay) {
        _pagementWay = pagementWay;
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_pagementWay-1 inSection:1] animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
}

#pragma mark UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        NSDecimalNumber * pensionNum = [NSDecimalNumber decimalNumberWithString:self.pensionAmount];
        NSDecimalNumber * goldNum = [NSDecimalNumber decimalNumberWithString:self.goldAmount];
        if ([pensionNum compare:[NSDecimalNumber decimalNumberWithString:@"0"]]==NSOrderedDescending||[goldNum compare:[NSDecimalNumber decimalNumberWithString:@"0"]]==NSOrderedDescending) {
            return 3;
        }
        return 2;
    }else{
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 30;
    }else{
        return 45;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, 30)];
        headerView.backgroundColor = JXColorFromRGB(0xe5e5e5);
        
        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, (30-20)/2.0, boundsWidth-20, 20)];
        titleLabel.text = [NSString stringWithFormat:@"订单编号：%@",self.orderNumber];
        titleLabel.font = JXFont(13);
        titleLabel.textColor = JXColorFromRGB(0x898989);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:titleLabel];
    
        return headerView;
    }else{
        UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, 45)];
        headerView.backgroundColor = JXColorFromRGB(0xf6f7f8);
        
        UIView * contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, 35)];
        contentView.backgroundColor = [UIColor whiteColor];
        [headerView addSubview:contentView];
        
        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(14, (30-20)/2.0, boundsWidth-28, 20)];
        titleLabel.font = JXFont(15);
        titleLabel.text = @"支付方式";
        titleLabel.textColor = JXColorFromRGB(0xa3a3a3);
        titleLabel.textAlignment = NSTextAlignmentLeft;
        [contentView addSubview:titleLabel];
        
        return headerView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 40;
    }else{
        return 86;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        static NSString * identifer = @"paymentordercell";
        PaymentOrderInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer];
        if (!cell) {
            cell = [[PaymentOrderInfoCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
        }
        UIColor * themeColor = (indexPath.row<2) ? JXColorFromRGB(0x5f5f5f) : APP_MAIN_COLOR;
        cell.titleLabel.textColor  = themeColor;
        cell.amountLabel.textColor = themeColor;
        UIImage * image = [UIImage imageWithColor:themeColor size:CGSizeMake(10, 10)];
        cell.dotImageView.image = [image imageByRoundCornerRadius:5];
        
        NSInteger count = [tableView numberOfRowsInSection:0];
        if (indexPath.row==0) {
            cell.titleLabel.text = @"合计金额:";
            cell.amountLabel.text = [NSString stringWithFormat:@"￥%@",self.totalAmount];
        }
        
        NSDecimalNumber * pensionNum = [NSDecimalNumber decimalNumberWithString:self.pensionAmount];
        NSDecimalNumber * goldNum = [NSDecimalNumber decimalNumberWithString:self.goldAmount];
        if ([pensionNum compare:[NSDecimalNumber decimalNumberWithString:@"0"]]==NSOrderedDescending&&indexPath.row==1) {
            cell.titleLabel.text = @"养老备用金抵扣:";
            cell.amountLabel.text = [NSString stringWithFormat:@"￥%.2f",self.pensionAmount.doubleValue];
        }else if ([goldNum compare:[NSDecimalNumber decimalNumberWithString:@"0"]]==NSOrderedDescending&&indexPath.row==1){
            cell.titleLabel.text = @"购物金抵扣:";
            cell.amountLabel.text = [NSString stringWithFormat:@"￥%.2f",self.goldAmount.doubleValue];
        }
        
        if (indexPath.row==count-1) {
            cell.titleLabel.text = @"实付金额:";
            cell.amountLabel.text = [NSString stringWithFormat:@"￥%.2f",self.actualPayAmount.floatValue];
        }
        
         return cell;
    }else{
        static NSString * identifer = @"paymentwaycell";
        
        PaymentWayCell * cell=[tableView dequeueReusableCellWithIdentifier:identifer];
        if(cell==nil){
            cell = [[PaymentWayCell alloc] initWithStyle:UITableViewCellStyleDefault      reuseIdentifier:identifer];
        }
        UIImage * backgroundImage = [UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(50, 50)];
        if (indexPath.row==0) {
            cell.titleLabel.text = @"支付宝";
            cell.backgroundImageView.image = [[backgroundImage imageByRoundCornerRadius:8 corners:UIRectCornerTopLeft|UIRectCornerTopRight borderWidth:0 borderColor:[UIColor clearColor] borderLineJoin:kCGLineJoinRound] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10) resizingMode:UIImageResizingModeStretch];
            cell.payemntImageView.image = ImageString(@"public_payment_alipay");
            cell.seperator.hidden = NO;
//            cell.selected = _pagementWay == 1? YES:NO;
        }else{
            cell.titleLabel.text = @"微信";
            cell.backgroundImageView.image = [[backgroundImage imageByRoundCornerRadius:8 corners:UIRectCornerBottomLeft|UIRectCornerBottomRight borderWidth:0 borderColor:[UIColor clearColor] borderLineJoin:kCGLineJoinRound]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10) resizingMode:UIImageResizingModeStretch];
            cell.payemntImageView.image = ImageString(@"public_payment_wechatpay");
            cell.seperator.hidden = YES;
//            cell.selected = _pagementWay == 2? YES:NO;
        }
        

        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1) {
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        _pagementWay = indexPath.row+1;
        NSString * payWay = @"支付宝支付";
        if (indexPath.row==1) {
            payWay = @"微信支付";
        }
         [self.payButton setTitle:[NSString stringWithFormat:@"%@%.2f",payWay,self.actualPayAmount.floatValue] forState:UIControlStateNormal];
    }
}

//支付
- (void)payEvent{
    if ([self.orderNumber isNotBlank]) {
        
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        params[@"orderNo"] =  self.orderNumber;
        NSDecimalNumber * pensionNum = [NSDecimalNumber decimalNumberWithString:self.pensionAmount];
        NSDecimalNumber * goldNum = [NSDecimalNumber decimalNumberWithString:self.goldAmount];
        if ([pensionNum compare:[NSDecimalNumber decimalNumberWithString:@"0"]]==NSOrderedDescending) {
            params[@"point"] = pensionNum;
        }
        
        if ([goldNum compare:[NSDecimalNumber decimalNumberWithString:@"0"]]==NSOrderedDescending) {
            params[@"gold"] = goldNum;
        }
        
        if (_pagementWay == 1) {
            //支付宝
            [self requestAlipayWithParams:params];
        }else{
            //微信
            params[@"type"] = @"1";
            [self requestWechatPayWithParams:params];
        }
    }
}

- (void)requestAlipayWithParams:(NSDictionary *)params{
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [DSHttpResponseData orderGetAlipayPayOrderInfoWithParams:params callback:^(id info, BOOL succeed, id extraInfo) {
        [HUD hideAnimated:YES];
        if (succeed) {
            if ([info isNotBlank]) {
                //调用支付宝进行支付
                YJPayHelper * payHelper = [YJPayHelper sharePayHelper];
                [payHelper payOrder:info paymentMode:Payment_ALiPay]; //调用支付宝支付
                [payHelper setAlipayPayResultCallback:^(id info, BOOL succeed, id extraInfo) {
                    DSOrderPayResultHandleController * resultHandleController = [[DSOrderPayResultHandleController alloc]init];
                    resultHandleController.orderNumber = self.orderNumber;
                    resultHandleController.pagementWay = 1;
                    resultHandleController.pensionAmount = self.pensionAmount;
                    resultHandleController.goldAmount = self.goldAmount;
                    resultHandleController.payStatus = [extraInfo integerValue];
                    resultHandleController.popControllerLevel = self.popControllerLevel+1;
                    [self.navigationController pushViewController:resultHandleController animated:YES];
                }];
            }
        }
    }];
}

- (void)requestWechatPayWithParams:(NSDictionary *)params{
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [DSHttpResponseData orderGetWechatPayOrderInfoWithParams:params callback:^(id info, BOOL succeed, id extraInfo) {
        [HUD hideAnimated:YES];
        if (succeed) {
            if (info) {
                YJPayHelper * payHelper = [YJPayHelper sharePayHelper];
                [payHelper payOrder:info paymentMode:Payment_WeChatPay]; //调用微信支付
                [payHelper setWechatPayResultCallback:^(id info, BOOL succeed, id extraInfo) {
                    DSOrderPayResultHandleController * resultHandleController = [[DSOrderPayResultHandleController alloc]init];
                    resultHandleController.orderNumber = self.orderNumber;
                    resultHandleController.pensionAmount = self.pensionAmount;
                    resultHandleController.goldAmount = self.goldAmount;
                    resultHandleController.pagementWay = 2;
                    resultHandleController.payStatus = [extraInfo integerValue];
                    resultHandleController.popControllerLevel = self.popControllerLevel+1;
                    [self.navigationController pushViewController:resultHandleController animated:YES];
                }];
            }
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
