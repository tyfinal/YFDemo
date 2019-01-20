//
//  DSServiceOrderPaymentController.m
//  DaiShuYangLao
//
//  Created by YueLiang Song on 2018/10/18.
//  Copyright © 2018 tyfinal. All rights reserved.
//

#import "DSServiceOrderPaymentController.h"
#import "DSOrderConfirmTableCell.h"
#import "DSOrderConfirmTableCell.h"
#import "DSOrderPaymentController.h"
#import "DSUserAddress.h"
#import "DSNewAddressController.h"
#import "DSAddressManagerController.h"
#import "DSShopCartModel.h"
#import "DSGoodsDetailInfoModel.h"
#import "DSGoodsInfoModel.h"
#import "XHWebImageAutoSize.h"

@interface DSServiceOrderPaymentController()<UITableViewDelegate,UITableViewDataSource,OrderConfirmCellDelegate>{
    
}

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) DSUserAddress * userAddress;
@property (nonatomic, copy) NSString * availablePoint; /**< 用户可用积分 */
@property (nonatomic, copy) NSString * actualPayAmount; /**< 实际支付金额 */
@property (nonatomic, copy) NSString * usedPointAmount;   /**< 使用积分额度 */
@property (nonatomic, strong) UIButton * checkOutButton;

@end

@implementation DSServiceOrderPaymentController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.checkOutButton];
    [self.checkOutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(45);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.checkOutButton.mas_top);
    }];
    
    [self requestData];
}

#pragma mark UI

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, boundsHeight) style:UITableViewStylePlain];
        tableView.backgroundColor = JXColorFromRGB(0xffffff);
        tableView.showsVerticalScrollIndicator = NO;
        tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        tableView.rowHeight = 110;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView setTableFooterView:[UIView new]];
        _tableView = tableView;
    }
    return _tableView;
}

- (UIButton *)checkOutButton{
    if (!_checkOutButton) {
        _checkOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkOutButton setTitle:@"立即支付" forState:UIControlStateNormal];
        [_checkOutButton setTitleColor:JXColorFromRGB(0xffffff)forState:UIControlStateNormal];
        _checkOutButton.backgroundColor = APP_MAIN_COLOR;
        _checkOutButton.titleLabel.font = JXFont(15);
        [_checkOutButton addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _checkOutButton;

}

#pragma mark 网络请求及数据处理

//请求积分 与 收货地址
- (void)requestData{
    //领航会员
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_async(group, queue, ^{
        [self requestReceivingAddressDataWtihRequestGroup:group HUD:HUD];
    });
    
    DSUserInfoModel * account = [JXAccountTool account];
    if (account.level.integerValue==2) {
        dispatch_group_enter(group);
        dispatch_group_async(group, queue, ^{
            [DSHttpResponseData mineGetUserPointAndGoldAmount:^(id info, BOOL succeed, id extraInfo) {
                if (succeed) {
                    dispatch_group_leave(group);
                    if (info) {
                        if (info[@"availablePoint"]) {
                            self.availablePoint = [NSString stringWithFormat:@"%@",info[@"availablePoint"]];
                        }
                    }
                }else{
                    [HUD hideAnimated:YES];
                }
            }];
        });
    }
    
    dispatch_group_notify(group, queue, ^{
        //执行完成
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD hideAnimated:YES];
            [self.tableView reloadData];
        });
    });
}

// MARK: 选择一个收货地址
- (void)requestReceivingAddressDataWtihRequestGroup:(dispatch_group_t)group HUD:(MBProgressHUD *)HUD{
    dispatch_group_enter(group);
    [DSHttpResponseData addressList:^(id info, BOOL succeed, id extraInfo) {
        if(HUD)[HUD hideAnimated:YES];
        if (succeed) {
            dispatch_group_leave(group);
            if ([info count]>0) {
                NSPredicate * predict = [NSPredicate predicateWithFormat:@"def=%@",@"1"];
                NSArray * array = [info filteredArrayUsingPredicate:predict];
                if (array.count>0) {
                    self.userAddress = array[0]; //选取默认地址
                }else{
                    self.userAddress = info[0]; //没有找到默认地址 选取第一个地址
                }
            }
        }
    }];
}

#pragma mark UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section==1) {
        return self.checkingOutArray.count>0?self.checkingOutArray.count:0;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 100;
    }else if (indexPath.section==1){
        return 150;
    }else if (indexPath.section==2){
        return boundsWidth*0.338;
    }else{
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section>=2) {
        return 30;
    }
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section>=2) {
        UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, 30)];
        headerView.backgroundColor = [UIColor whiteColor];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(16, (30-20)/2.0, 120, 20)];
        label.font = JXFont(14);
        label.text = @[@"购买须知",@"袋鼠乐购"][section-2];
        label.textColor = JXColorFromRGB(0x232323);
        label.textAlignment = NSTextAlignmentLeft;
        [headerView addSubview:label];
        return headerView;
    }
    return nil;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        static NSString * identifer = @"identifer";
        OrderConfirmAddressCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer];
        if (!cell) {
            cell = [[OrderConfirmAddressCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
        }
        cell.model = self.userAddress;
        cell.delegate = self;
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
        
        return cell;
    }else if (indexPath.section==1){
        static NSString * identifer = @"goodsinfocell";
        OrderConfirmGoodsInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer];
        if (!cell) {
            cell = [[OrderConfirmGoodsInfoCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
        }
        if (self.checkingOutArray.count>0) {
            cell.model = self.checkingOutArray[indexPath.row];
            [cell setNeedsUpdateConstraints];
            [cell updateConstraintsIfNeeded];
        }
        
        return cell;
    }else if (indexPath.section==2){
        static NSString * identifer = @"imagecell";
        OrderConfirmImageCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer];
        if (!cell) {
            cell = [[OrderConfirmImageCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
        }
        cell.promptIV.image = ImageString(@"orderpayment_prompt");
        return cell;
    }else if (indexPath.section==3){
        static NSString * identifer = @"normalcell";
        DSOrderConfirmTableCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer];
        if (!cell) {
            cell = [[DSOrderConfirmTableCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
        }
        cell.textLabel.textColor = JXColorFromRGB(0x999999);
        cell.textLabel.font = JXFont(12);
        cell.detailTextLabel.textColor = JXColorFromRGB(0x000000);
        cell.detailTextLabel.font = JXFont(15);
        cell.textLabel.text = @"养老备用金兑换数额";
        cell.detailTextLabel.text = NSStringFormat(@"￥%.2f",self.totalAmount.floatValue);
        
        return cell;
    }
    return nil;
}

#pragma mark OrderConfirmCellDelegate

/** MARK: 新建地址 */
- (void)ds_orderConfirmCell:(OrderConfirmAddressCell *)addressCell createNewAddress:(UIButton *)button{
    DSNewAddressController * newAddressVC = [[DSNewAddressController alloc]init];
    __weak typeof (self)weakSelf = self;
    newAddressVC.needRefreshBlock = ^(id info, BOOL succeed, id extraInfo) {
        weakSelf.userAddress = info;
        [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
//        [weakSelf requestCarriageWithAddressId:self.userAddress.address_id]; //请求运费
    };
    [self.navigationController pushViewController:newAddressVC animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if (self.userAddress) {
            //重新选择地址
            DSAddressManagerController * managerAddressVC = [[DSAddressManagerController alloc]init];
            __weak typeof (self)weakSelf = self;
            managerAddressVC.DidSelectedAddressHandle = ^(DSUserAddress *addressModel) {
                weakSelf.userAddress = addressModel;
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
            };
            [self.navigationController pushViewController:managerAddressVC animated:YES];
        }
    }
}

#pragma mark UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view.superview class])isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}

- (void)endEditingEvent{
    [self.view endEditing:YES];
}


- (void)clickEvent:(UIButton *)button{
    
    NSDecimalNumber * totalAmountNumber = [NSDecimalNumber decimalNumberWithString:self.totalAmount];
    NSDecimalNumber * availableAmountNumber = [NSDecimalNumber decimalNumberWithString:self.availablePoint];
    if ([availableAmountNumber compare:totalAmountNumber]>=NSOrderedDescending) {
        self.actualPayAmount = @"0.01";
        self.usedPointAmount = self.totalAmount;
        //拥有的积分大于或者等于时才可以购买该商品
        NSMutableArray * mu = nil;
        if (self.checkingOutArray.count>0) {
            mu = [NSMutableArray array];
            
            for (DSShopCartModel * cartModel in self.checkingOutArray) {
                NSMutableDictionary * params = [NSMutableDictionary dictionary];
                params[@"productId"] = cartModel.product.goods_id;
                params[@"num"] = cartModel.num;
                params[@"skuId"] = cartModel.sku.sku_id;
                params[@"price"] = cartModel.sku.price;
                params[@"remarks"] = cartModel.remarks;
                [mu addObject:params];
            }
        }
        
        if (mu) {
            if (mu.count>0) {
                [self submitOrderInfoWithParams:mu];
            }
        }
    }else{
        [MBProgressHUD showText:@"您的养老备用金不足，无法购买此服务！" toView:self.view];
    }

}

//MARK: 提交订单
- (void)submitOrderInfoWithParams:(NSArray *)params{
    if (!self.userAddress) {
        [MBProgressHUD showText:@"请选择收货地址" toView:self.view];
        return;
    }
    NSString * jsonStr = params.mj_JSONString;
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [DSHttpResponseData OrderSubmitOrderwithProductInfo:jsonStr addressId:self.userAddress.address_id callback:^(id info, BOOL succeed, id extraInfo) {
        [HUD hideAnimated:YES];
        if (succeed) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"checkoutsuccessnotification" object:nil];
            DSOrderPaymentController * paymentController = [[DSOrderPaymentController alloc]init];
            NSString * totalAmount = [NSString stringWithFormat:@"%.2f",self.totalAmount.floatValue];
            paymentController.totalAmount = totalAmount;
            paymentController.orderNumber = info;
            paymentController.actualPayAmount = self.actualPayAmount;
            paymentController.pensionAmount = self.usedPointAmount;
            paymentController.popControllerLevel = 3; /**< 返回上两层 跳过确认订单页面 */
            [self.navigationController pushViewController:paymentController animated:YES];
        }
    }];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    
}

@end
