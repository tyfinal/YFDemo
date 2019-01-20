//
//  DSCompleteInfoController.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/14.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSCompleteInfoController.h"
#import "DSLoginInputView.h"
#import "DSCompleteInfoCell.h"
#import "DSTextFieldModel.h"
#import "YJPayHelper.h"
#import "DSOrderPayResultHandleController.h"
#import "DSAddressManagerController.h"
#import "DSUserAddress.h"
#import "DSAreaModel.h"
#import "DSNewAddressController.h"
#import "KLCPopup.h"
#import "DSPaymentChooseView.h"

@interface DSCompleteInfoController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>{
    NSInteger paymentWay; /**< 1 支付宝 2 微信 */
}

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIButton * nextStepButton;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, assign) BOOL didVerified; /**< 是否已认证 */
@property (nonatomic, strong) KLCPopup * popView;
@property (nonatomic, copy) NSString * orderNo;

@end

@implementation DSCompleteInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"资料填写";

    paymentWay = 1;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.equalTo(self.view);
        if (@available(iOS 11.0,*)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        }else{
            make.top.equalTo(self.view);
        }
    }];
    
//    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
//        [self.view endEditing:YES];
//    }]];
    
    [self getDefaultAddress];
    
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        DSUserInfoModel * account = [JXAccountTool account];
        if ([account.idNo isNotBlank]) {
            //已认证
            for (NSUInteger i=0; i<2; i++) {
                DSTextFieldModel * model = [[DSTextFieldModel alloc]init];
                model.placeholder = @[@"请选择收货地址",@"请输入邀请码"][i];
                model.key = @[@"address",@"invitationCode"][i];
                model.iconName = @[@"public_address_icon",@"public_invitationcode_icon"][i];
                model.editEnable = [@[@0,@1][i] boolValue];
                model.text = @[@"",@"2020"][i];
                model.emptyWarning = @[@"请选择收货地址",@"请填写邀请码"][i];
                [_dataArray addObject:model];
            }
        }else{
            for (NSUInteger i=0; i<4; i++) {
                DSTextFieldModel * model = [[DSTextFieldModel alloc]init];
                model.placeholder = @[@"请输入身份证号",@"请输入真实姓名",@"请选择收货地址",@"请输入邀请码"][i];
                model.editEnable = [@[@1,@1,@0,@1][i] boolValue];
                model.text = @[@"",@"",@"",@"2020"][i];
                model.key = @[@"idNo",@"name",@"address",@"invitationCode"][i];
                model.iconName = @[@"public_idcart_icon",@"public_user_icon",@"public_address_icon",@"public_invitationcode_icon"][i];
                model.emptyWarning = @[@"请输入身份证号",@"请输入您的真实姓名",@"请选择收货地址",@"请填写邀请码"][i];
                [_dataArray addObject:model];
            }
        }
    }
    return _dataArray;
}

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, boundsHeight) style:UITableViewStylePlain];
        tableView.backgroundColor = JXColorFromRGB(0xffffff);
        tableView.showsVerticalScrollIndicator = NO;
        tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = ceil(70*ScreenAdaptFator_H);
        UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, 145)];
        footerView.backgroundColor = [UIColor whiteColor];
        self.nextStepButton.frame = CGRectMake(45*ScreenAdaptFator_W, footerView.frameHeight-(45+10), boundsWidth-90*ScreenAdaptFator_W, 45);
        [footerView addSubview:self.nextStepButton];
//        [self.nextStepButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.view.mas_left).with.offset(45*ScreenAdaptFator_W);
//            make.right.equalTo(self.view.mas_right).with.offset(-45*ScreenAdaptFator_W);
//            make.height.mas_equalTo(45);
//            make.bottom.equalTo(footerView.mas_bottom).with.offset(-10);
//        }];
        
        [tableView setTableFooterView:footerView];
        UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, 13)];
        headerView.backgroundColor = JXColorFromRGB(0xffffff);
        [tableView setTableHeaderView:headerView];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView = tableView;
    }
    return _tableView;
}

- (KLCPopup *)popView{
    if (!_popView) {
        DSPaymentChooseView * paymentChooseView = [[DSPaymentChooseView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth-30, 0)];
        paymentChooseView.title = @"支付方式";
        
        __weak typeof (self)weakSelf = self;
        paymentChooseView.DidSelectRowAtIndex = ^(NSInteger index) {
            [weakSelf.popView dismiss:YES];
            paymentWay = index+1;
            
            NSMutableDictionary * params = [NSMutableDictionary dictionary];
            params[@"orderNo"] = weakSelf.orderNo;
            MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
            if (paymentWay==1) {
                [self payByAlipayWithParams:params HUD:HUD]; //调用支付宝支付
            }else{
                [self payByWechatWithParams:params HUD:HUD]; //调用微信支付
            }
        };
        [paymentChooseView layoutIfNeeded];
        paymentChooseView.frameHeight = paymentChooseView.contentView.frameBottom;
        _popView = [KLCPopup popupWithContentView:paymentChooseView showType:KLCPopupShowTypeGrowIn dismissType:KLCPopupDismissTypeGrowOut maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:NO];
        
    }
    return _popView;
}


- (UIButton *)nextStepButton{
    if (!_nextStepButton) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"立即开通" forState:UIControlStateNormal];
        button.adjustsImageWhenDisabled = NO;
        [button addTarget:self action:@selector(nextStepEvent) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:ImageString(@"login_button_bg") forState:UIControlStateNormal];
        button.titleLabel.font = JXFont(18);
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _nextStepButton = button;
    }
    return _nextStepButton;
}

#pragma mark 网络请求

- (void)getDefaultAddress{
    for (DSTextFieldModel * model in self.dataArray) {
        if ([model.key isEqualToString:@"address"]) {
            MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [DSHttpResponseData addressList:^(id info, BOOL succeed, id extraInfo) {
                if (succeed) {
                    [HUD hideAnimated:YES];
                    if ([info count]>0) {
                        NSPredicate * predict = [NSPredicate predicateWithFormat:@"def=%@",@"1"];
                        NSArray * array = [info filteredArrayUsingPredicate:predict];
                        DSUserAddress * addressModel = nil;
                        if (array.count>0) {
                            addressModel = array[0]; //选取默认地址
                        }else{
                            addressModel = info[0]; //没有找到默认地址 选取第一个地址
                        }
                        if (addressModel) {
                            model.text = [self getCompleteAddressInfoWithAddressModel:addressModel];
                            model.extraInfo = addressModel.address_id;
                            [self.tableView reloadData];
                        }
                    }
                }
            }];
            break;
        }
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count>0?_dataArray.count:0; // _dataArray.count>0?_dataArray.count:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifer = @"identifer";
    DSCompleteInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[DSCompleteInfoCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (_dataArray.count>0) {
        DSTextFieldModel * model = self.dataArray[indexPath.row];
        cell.model = model;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DSTextFieldModel * model = self.dataArray[indexPath.row];
    if ([model.key isEqualToString:@"address"]) {
        if ([model.text isNotBlank]==NO) {
            DSNewAddressController * newAddressVC = [[DSNewAddressController alloc]init];
            newAddressVC.needRefreshBlock = ^(id info, BOOL succeed, id extraInfo) {
                DSUserAddress * userAddress = info;
                model.text = [self getCompleteAddressInfoWithAddressModel:userAddress];
                model.extraInfo = userAddress.address_id;
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
            };
            [self.navigationController pushViewController:newAddressVC animated:YES];
        }else{
            DSAddressManagerController * managerAddressVC = [[DSAddressManagerController alloc]init];
            __weak typeof (self)weakSelf = self;
            managerAddressVC.DidSelectedAddressHandle = ^(DSUserAddress *addressModel) {
                DSUserAddress * userAddress = addressModel;
                model.text = [weakSelf getCompleteAddressInfoWithAddressModel:userAddress];
                model.extraInfo = userAddress.address_id;
                [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            [self.navigationController pushViewController:managerAddressVC animated:YES];
        }
    }
}

- (NSString *)getCompleteAddressInfoWithAddressModel:(DSUserAddress *)aModel{
    NSMutableString * muAreaString = [NSMutableString string];
    if ([aModel.province.name isNotBlank]) {
        [muAreaString appendFormat:@"%@ ",aModel.province.name];
    }
    if ([aModel.city.name isNotBlank]) {
        [muAreaString appendFormat:@"%@ ",aModel.city.name];
    }
    
    if ([aModel.district.name isNotBlank]) {
        [muAreaString appendFormat:@"%@ ",aModel.district.name];
    }
    
    if ([aModel.address isNotBlank]) {
        [muAreaString appendString:aModel.address];
    }
    if ([muAreaString isNotBlank]) {
        return muAreaString.copy;
    }
    return @"";
}

////防止点击collectionview时触发手势
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
//    if (![touch.view isKindOfClass:[UITableView class]]){
//        return NO;
//    }
//    return YES;
//}


- (BOOL)infoValidityCheck{
    __block BOOL validInfo = YES;
    [self.dataArray enumerateObjectsUsingBlock:^(DSTextFieldModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.text isNotBlank]==NO) {
            [MBProgressHUD showText:obj.emptyWarning toView:self.view];
            validInfo = NO;
            *stop = YES;
            return ;
        }
    }];
    return validInfo;
}

//会员升级
- (void)nextStepEvent{
    [self.view endEditing:YES];
    if ([self infoValidityCheck]==NO) {
        return;
    }
    
    [self sendRequestToPayApp];
    
//
}

//调用支付app
- (void)sendRequestToPayApp{

    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [self.dataArray enumerateObjectsUsingBlock:^(DSTextFieldModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.key isEqualToString:@"address"]) {
            params[@"shippingAddressId"] = obj.extraInfo;
        }else{
            params[obj.key] = obj.text;
        }
    }];
    
    DSUserInfoModel * account = [JXAccountTool account];
    if ([account.idNo isNotBlank]) {
        params[@"idNo"] = account.idNo;
        params[@"name"] = account.name;
    }
    
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [DSHttpResponseData mineUpgradeMembershipWithParams:params callback:^(id orderNo, BOOL succeed, id extraInfo) {
        [HUD hideAnimated:YES];
        if (succeed) {
            if ([extraInfo integerValue]==0) {
                if ([orderNo isNotBlank]) {
                    _orderNo = orderNo;
                     [self.popView showWithLayout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutCenter)];
                }
            }else if([extraInfo integerValue]==9){
                //支付成功
                [DSAppDelegate goToHomePageWithIndex:2 params:@{@"upgradesucceed":@"1"}];
            }
        }
    }];
}

- (void)payByAlipayWithParams:(NSDictionary *)params HUD:(MBProgressHUD *)HUD{
    [DSHttpResponseData orderGetAlipayPayOrderInfoWithParams:params callback:^(id orderInfo, BOOL succeed, id extraInfo){
        if (succeed) {
            if ([orderInfo isNotBlank]) {
                //调用支付宝
                [[YJPayHelper sharePayHelper]payOrder:orderInfo paymentMode:Payment_ALiPay];
                //支付宝回调
                [[YJPayHelper sharePayHelper] setAlipayPayResultCallback:^(id aInfo, BOOL succeed, id extraInfo) {
                    if (succeed==NO) {
                        //支付失败
                        DSOrderPayResultHandleController * resultVC = [[DSOrderPayResultHandleController alloc]init];
                        resultVC.popControllerLevel = 3;
                        resultVC.orderNumber = params[@"orderNo"];
                        resultVC.payStatus = -1;
                        resultVC.isMembershipUpgrade = YES;
                        [self.navigationController pushViewController:resultVC animated:YES];
                    }else{
                        //支付成功
                        [DSAppDelegate goToHomePageWithIndex:2 params:@{@"upgradesucceed":@"1"}];
                    }
                }];
            }
        }
    }];

}

- (void)payByWechatWithParams:(NSDictionary *)params HUD:(MBProgressHUD *)HUD{
    NSMutableDictionary * muParams = [NSMutableDictionary dictionaryWithDictionary:params];
    //微信
    muParams[@"type"] = @"1";
    [DSHttpResponseData orderGetWechatPayOrderInfoWithParams:muParams callback:^(id info, BOOL succeed, id extraInfo) {
        if (succeed) {
            if (info) {
                YJPayHelper * payHelper = [YJPayHelper sharePayHelper];
                [payHelper payOrder:info paymentMode:Payment_WeChatPay]; //调用微信支付
                [payHelper setWechatPayResultCallback:^(id info, BOOL succeed, id extraInfo) {
                    if (succeed==NO) {
                        //支付失败
                        DSOrderPayResultHandleController * resultVC = [[DSOrderPayResultHandleController alloc]init];
                        resultVC.popControllerLevel = 3;
                        resultVC.orderNumber = muParams[@"orderNo"];
                        resultVC.payStatus = -1;
                        resultVC.isMembershipUpgrade = YES;
                        [self.navigationController pushViewController:resultVC animated:YES];
                    }else{
                        //支付成功
                        [DSAppDelegate goToHomePageWithIndex:2 params:@{@"upgradesucceed":@"1"}];
                    }
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
