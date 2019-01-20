//
//  DSOrderConfirmController.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/4.
//  Copyright © 2018年 tyfinal. All rights reserved.
//  MARK:  确认订单
//  领航会员 才可以使用积分与购物金 ，并且购物金与积分不可同时使用


#import "DSOrderConfirmController.h"
#import "DSCheckOutVIew.h"
#import "DSOrderConfirmTableCell.h"
#import "DSOrderPaymentController.h"
#import "DSUserAddress.h"
#import "DSNewAddressController.h"
#import "DSAddressManagerController.h"
#import "DSShopCartModel.h"
#import "DSGoodsDetailInfoModel.h"
#import "DSGoodsInfoModel.h"
#import "NSString+MKExtension.h"

@interface DSOrderConfirmController ()<UITableViewDelegate,UITableViewDataSource,OrderConfirmCellDelegate,UIGestureRecognizerDelegate> {
    
}

@property (nonatomic, strong) DSCheckOutVIew * checkOutView;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) DSUserAddress * userAddress;
@property (nonatomic, copy) NSString * availablePoint; /**< 用户可用积分 */
@property (nonatomic, copy) NSString * availableGold;  /**< 用户可用购物金 */
@property (nonatomic, copy) NSString * minAmountLimit; /**< 最低额度限制 购买商品使用积分支付时，订单的最少金额限制。0=禁用使用积分支付，-1=不限制 */
@property (nonatomic, copy) NSString * carriageFee; /**< 运费 */
@property (nonatomic, assign) BOOL usePointEnabled;     /**< 是否使用积分 */
@property (nonatomic, assign) BOOL userGoldEnabled;   /**< 使用购物金 */
@property (nonatomic, copy) NSString * allowToUseGoldAmout; /**< 允许使用的购物金总额 */
@property (nonatomic, copy) NSString * userGoldAmout; /**< 使用的积分总量 */
@property (nonatomic, copy) NSString * actualPayAmount; /**< 实际支付金额 */
@property (nonatomic, copy) NSString * usedPointAmount;   /**< 使用积分额度 */


@end

@implementation DSOrderConfirmController
static NSString * kEmptyCarriage = @"--";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"确定订单";
    adjustsScrollViewInsets_NO(self.tableView, self);
    self.navigationController.navigationBar.shadowImage = nil; //显示导航条下面的阴影
    
    UITapGestureRecognizer * ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endEditingEvent)];
    ges.delegate = self;
    [self.view addGestureRecognizer:ges];
    
    [self commonInit];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.checkOutView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            // Fallback on earlier versions
            make.top.equalTo(self.view).with.offset(kNavigationBarHeight);
        }
    }];
    
    [self.checkOutView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.bottom.equalTo(self.view);
        make.top.equalTo(self.tableView.mas_bottom);
    }];
    
    [self requestData]; //请求收货地址 与 用户可用积分额度
}

#pragma mark 初始化

- (void)commonInit{
    self.actualPayAmount = self.totalAmount;
    self.usedPointAmount = @"0.0";
    self.availablePoint = @"0.0";
    self.availableGold = @"0.0";
    self.minAmountLimit = @"0";
    self.userGoldAmout = @"0.0";
//    self.allowToUseGoldAmout = @"0.0";
    self.usePointEnabled = NO;
    self.userGoldEnabled = NO;
    self.userAddress = nil;
    self.carriageFee = kEmptyCarriage; //初始化运费的值
}

//设置运费
- (void)setCarriageFee:(NSString *)carriageFee{
    _carriageFee = carriageFee;
    if ([carriageFee isEqualToString:kEmptyCarriage]) {
        self.checkOutView.checkOutButton.enabled = NO;
    }else{
        self.checkOutView.checkOutButton.enabled = YES;
    }
}

//设置结算总价
- (void)setActualPayAmount:(NSString *)actualPayAmount{
    _actualPayAmount = actualPayAmount;
    self.checkOutView.priceLabel.attributedText = [self applyPriceLabelAttribureWithActualAmount:_actualPayAmount];
}

//设置购买商品
- (void)setCheckingOutArray:(NSArray *)checkingOutArray{
    _checkingOutArray = checkingOutArray;
    self.allowToUseGoldAmout = [self calculateAllowedUseGoldTotalAmountWithGoodsArray:checkingOutArray].stringValue;
}

//MARK: 计算可使用购物金总额
- (NSDecimalNumber *)calculateAllowedUseGoldTotalAmountWithGoodsArray:(NSArray *)array{
    __block NSDecimalNumber * totalAmount = [NSDecimalNumber decimalNumberWithString:@"0.0"];
    DSUserInfoModel * account = [JXAccountTool account];
    if (array.count>0&&account.level.integerValue==2) {
        [array enumerateObjectsUsingBlock:^(DSShopCartModel * model, NSUInteger idx, BOOL * _Nonnull stop) {
            if (model.product.useGold.doubleValue>0) {
                NSDecimalNumber * singleProductGoldAmount = [NSDecimalNumber decimalNumberWithString:model.product.useGold]; //单件商品可用购物金额度
                NSDecimalNumber * productGoldAmount = [singleProductGoldAmount decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:model.num.stringValue]]; //单种商品可允许使用购物金总额
                totalAmount = [totalAmount decimalNumberByAdding:productGoldAmount]; //累加所有商品允许使用购物金的总额
            }
        }];
    }
    return totalAmount;
}

#pragma mark UI

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, boundsHeight) style:UITableViewStylePlain];
        tableView.backgroundColor = JXColorFromRGB(0xffffff);
        tableView.showsVerticalScrollIndicator = NO;
        tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = 100;
        tableView.estimatedRowHeight = 0;
        [tableView setTableFooterView:[UIView new]];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView = tableView;
    }
    return _tableView;
}

- (DSCheckOutVIew *)checkOutView{
    if (!_checkOutView) {
        _checkOutView = [[DSCheckOutVIew alloc]initWithFrame:CGRectZero];
        [_checkOutView.checkOutButton addTarget:self action:@selector(payForOrder) forControlEvents:UIControlEventTouchUpInside];
        _checkOutView.selectAllButton.hidden = YES;
        _checkOutView.edited = NO;
        [_checkOutView.checkOutButton setTitle:@"立即支付" forState:UIControlStateNormal];
        if (boundsWidth<375) {
            [_checkOutView.checkOutButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(120);
            }];
        }
       
        [_checkOutView.priceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_checkOutView.contentView.mas_left).with.offset(15);
            make.right.equalTo(_checkOutView.checkOutButton.mas_left).with.offset(-10);
        }];
    }
    return _checkOutView;
}

/**< MARK: 实际支付  应用富文本样式 */
- (NSAttributedString *)applyPriceLabelAttribureWithActualAmount:(NSString *)actualAmount{
    NSAttributedString * attri = [NSString applyAttributes:@{NSFontAttributeName:JXFont(15),NSForegroundColorAttributeName:JXColorFromRGB(0x303030)} forString:@"合计："];
    NSMutableAttributedString * muAttri = [[NSMutableAttributedString alloc]initWithAttributedString:attri];
    NSAttributedString * subAttri = [NSString applyAttributes:@{NSFontAttributeName:JXFont(15),NSForegroundColorAttributeName:APP_MAIN_COLOR} forString:[NSString stringWithFormat:@"￥%.2f",actualAmount.doubleValue]];
    [muAttri appendAttributedString:subAttri];
    return muAttri;
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
                    
                        
                        if (info[@"orderUsePointMinAmountLimit"]) {
                            self.minAmountLimit = [NSString stringWithFormat:@"%@",info[@"orderUsePointMinAmountLimit"]];
                        }
                        
                        if (info[@"gold"]) {
                            self.availableGold = [NSString stringWithFormat:@"%@",info[@"gold"]];
                        }
                        
                    }
                }else{
                    [HUD hideAnimated:YES];
                }
            }];
//            [DSHttpResponseData mineGetUserInfo:^(id info, BOOL succeed, id extraInfo) {
//                dispatch_group_leave(group);
//                if (succeed) {
//                    DSUserInfoModel * infoModel = info;
//                    self.availablePoint = infoModel.availablePoint;
//                }
//            }];
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
                [self requestCarriageWithAddressId:self.userAddress.address_id]; //获取运费
            }
        }
    }];
}

//MARK: 根据地址请求运费
- (void)requestCarriageWithAddressId:(NSString *)addressId{
    if ([addressId isNotBlank]==NO) {
        return;
    }
    __block MBProgressHUD * HUD = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
      HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    });
    
    self.carriageFee = kEmptyCarriage;
    [DSHttpResponseData addressGetCarriageByAddressId:addressId callback:^(id info, BOOL succeed, id extraInfo) {
        dispatch_async(dispatch_get_main_queue(), ^{
             [HUD hideAnimated:YES];
        });
        if (succeed) {
            if (info) {
                self.carriageFee = NSStringFormat(@"%@",info);
            }
        }
        [self controlPensionPointUsageWithMeaasage:nil]; //控制积分使用
        [self calculateActualAmount];    //计算结算总价
        
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
    }];
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
            NSString * totalAmount = [NSString stringWithFormat:@"%.2f",self.totalAmount.floatValue+self.carriageFee.floatValue];
            paymentController.totalAmount = totalAmount;
            paymentController.orderNumber = info;
            paymentController.actualPayAmount = self.actualPayAmount;
            paymentController.goldAmount = self.userGoldAmout;
            paymentController.pensionAmount = self.usedPointAmount;
            paymentController.popControllerLevel = 3; /**< 返回上两层 跳过确认订单页面 */
            [self.navigationController pushViewController:paymentController animated:YES];
        }
    }];
}

//MARK:计算结算总价
- (void)calculateActualAmount{
    NSDecimalNumber * carriageFee = [self.carriageFee isEqualToString:kEmptyCarriage] ?[NSDecimalNumber decimalNumberWithString:@"0.0"] : [NSDecimalNumber decimalNumberWithString:self.carriageFee]; //运费
    NSDecimalNumber * productTotalAmout = [NSDecimalNumber decimalNumberWithString:self.totalAmount];  //商品总价
    NSDecimalNumber * actualAmount = [productTotalAmout decimalNumberByAdding:carriageFee]; //实际支付总价
    NSDecimalNumber * pensionAmount = [NSDecimalNumber decimalNumberWithString:self.usedPointAmount]; //使用的积分
    NSDecimalNumber * goldAmount = [NSDecimalNumber decimalNumberWithString:self.userGoldAmout]; //使用的购物金
    if (self.usePointEnabled) {
       actualAmount = [actualAmount decimalNumberBySubtracting:pensionAmount]; //使用了积分
    }
    if (self.userGoldEnabled) {
       actualAmount = [actualAmount decimalNumberBySubtracting:goldAmount]; //使用了购物金
    }
    
    if ([actualAmount compare:@(0)]==kCFCompareGreaterThan) {
        //商品价格加运费大于 大于使用的的积分量 则为混合支付
        self.actualPayAmount = actualAmount.stringValue;
    }else{
        //纯积分支付
        self.actualPayAmount = @"0.01";
    }
}

//MARK:控制积分使用 包括积分使用开关 以及 积分使用量
- (void)controlPensionPointUsageWithMeaasage:(NSString *)message{
    //用户勾选了使用积分 变更运费后需要重新计算是否具备使用积分的资格
    NSDecimalNumber * carriageFee = [self.carriageFee isEqualToString:kEmptyCarriage] ?[NSDecimalNumber decimalNumberWithString:@"0.0"] : [NSDecimalNumber decimalNumberWithString:self.carriageFee]; //运费
    NSDecimalNumber * productTotalAmout = [NSDecimalNumber decimalNumberWithString:self.totalAmount];  //商品总价
    NSDecimalNumber * totalAmount = [productTotalAmout decimalNumberByAdding:carriageFee]; //运费 与 商品总价之和
    if (self.usePointEnabled) {
        //商品总价 与 运费总价之和大于等于 积分使用阈值时 才可使用积分
        double minimumPrice = self.minAmountLimit.doubleValue;
        NSDecimalNumber * minimumPriceNum = [NSDecimalNumber decimalNumberWithString:NSStringFormat(@"%.2f",minimumPrice)];
        if ([totalAmount compare:minimumPriceNum]==kCFCompareGreaterThan) {
            //总价 大于 阈值
            NSDecimalNumber * payAmount = [totalAmount decimalNumberBySubtracting:[NSDecimalNumber decimalNumberWithString:self.availablePoint]];
            if ([payAmount compare:@(0)]==kCFCompareGreaterThan) {
                //总价大于拥有的积分数 则使用所有存在的积分
                self.usedPointAmount = self.availablePoint;
            }else{
                //拥有的积分总数 大于 商品总价
//                payAmount = [NSDecimalNumber decimalNumberWithString:@"0.01"];  //全部使用积分进行支付时 需要支付0.01元
                self.usedPointAmount = totalAmount.stringValue;
            }
        }else{
            //未达到使用积分的资格
            if ([message isNotBlank]) {
                NSString * msg = [NSString stringWithFormat:@"支付金额满%.2f元才可以使用养老备用金支付",minimumPrice];
                [MBProgressHUD showText:msg toView:nil];
            }
            self.usePointEnabled = NO;
            self.usedPointAmount = @"0.0";
        }
        NSLog(@"%@",self.usedPointAmount);
    }else if (self.userGoldEnabled){
        
        NSDecimalNumber * allowedUseGoldAmount = [NSDecimalNumber decimalNumberWithString:self.allowToUseGoldAmout]; //最多允许使用的购物金额度
        NSDecimalNumber * availableGoldAmount = [NSDecimalNumber decimalNumberWithString:self.availableGold]; //用户拥有的购物金额度
        NSDecimalNumber * canUsedGoldAmount = allowedUseGoldAmount;  //可供使用的购物金总额 在用户拥有的购物金 与 用户允许使用的购物金额中 取 最小值
        if ([allowedUseGoldAmount compare:availableGoldAmount]==NSOrderedDescending) {
            canUsedGoldAmount = availableGoldAmount;
        }
        
        //使用购物金
        NSDecimalNumber * payAmount = [totalAmount decimalNumberBySubtracting:canUsedGoldAmount];
        if ([payAmount compare:@(0)]==kCFCompareGreaterThan) {
            //总价大于拥有的可用购物金数
            self.userGoldAmout = canUsedGoldAmount.stringValue;
        }else{
            //拥有的购物金总数 大于 商品总价 ( 注：正常情况下不会出现)
            self.userGoldAmout = totalAmount.stringValue;
        }
    }else{
        //用户未使用积分 则无需变动
        self.usePointEnabled = NO;
        self.usedPointAmount = @"0.0";
        self.userGoldEnabled = NO;
        self.userGoldAmout = @"0.0";
    }
}


#pragma mark UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else if (section==1){
        return self.checkingOutArray.count>0?self.checkingOutArray.count:0;
    }else{
        DSUserInfoModel * account = [JXAccountTool account];
        if (account.level.integerValue==2) {
            return 3; //领航会员 可以使用积分 或 购物金
        }
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 100;
    }else if (indexPath.section==1){
        return 150;
    }else{
        if (indexPath.row==0) {
             return 50;
        }
       return 75;
    }
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
    }else{
        if(indexPath.row==0){
            static NSString * identifer = @"carriagecell";

            OrderConfirmCarriageCell * cell=[tableView dequeueReusableCellWithIdentifier:identifer];
            if(cell==nil){
            cell = [[OrderConfirmCarriageCell alloc] initWithStyle:UITableViewCellStyleDefault      reuseIdentifier:identifer];
        }
            if ([self.carriageFee isEqualToString:kEmptyCarriage]) {
                cell.carriageLabel.text = kEmptyCarriage;
            }else{
               cell.carriageLabel.text = [NSString stringWithFormat:@"￥%.2f",self.carriageFee.floatValue];
            }
            return cell;
        }else{
            static NSString * identifer = @"pointscell";
            OrderConfirmPointsExchangeCell * cell=[tableView dequeueReusableCellWithIdentifier:identifer];
            if(cell==nil){
            cell = [[OrderConfirmPointsExchangeCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:identifer];
            }
            if (indexPath.row==1) {
                cell.titleLabel.text = @"养老备用金:";
                cell.seprator.hidden = NO;
                cell.enablePointsPayment.enabled = YES;
                if (self.minAmountLimit.doubleValue==0) {
                    cell.enablePointsPayment.enabled = NO;  //禁用积分支付
                    cell.limitTipsLabel.text = @" 暂不可使用养老备用金进行支付";
                }else{
                   cell.enablePointsPayment.on = self.usePointEnabled;
                   NSString * limitTips = [NSString stringWithFormat:@" 支付金额满%.f元才可以使用养老备用金支付",self.minAmountLimit.doubleValue];
                    cell.limitTipsLabel.text = limitTips;
                }
                cell.PointsExchangeLabel.text = [NSString stringWithFormat:@"可抵扣%.2f元",self.availablePoint.doubleValue];
            }else{
                cell.seprator.hidden = YES;
                cell.titleLabel.text = @"购物金:";
                cell.enablePointsPayment.on = self.userGoldEnabled;
                cell.PointsExchangeLabel.text = [NSString stringWithFormat:@"最多可抵扣%.2f元",self.allowToUseGoldAmout.doubleValue];
                cell.limitTipsLabel.text = @" 购物金不可与养老备用金同时使用";
            }
            [cell.enablePointsPayment addTarget:self action:@selector(pointPaymentEnableEvent:) forControlEvents:UIControlEventValueChanged];

            return cell;
        }
    }
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
                [weakSelf requestCarriageWithAddressId:self.userAddress.address_id];
            };
            [self.navigationController pushViewController:managerAddressVC animated:YES];
        }
    }
}

#pragma mark OrderConfirmCellDelegate

/** MARK: 新建地址 */
- (void)ds_orderConfirmCell:(OrderConfirmAddressCell *)addressCell createNewAddress:(UIButton *)button{
    DSNewAddressController * newAddressVC = [[DSNewAddressController alloc]init];
    __weak typeof (self)weakSelf = self;
    newAddressVC.needRefreshBlock = ^(id info, BOOL succeed, id extraInfo) {
        weakSelf.userAddress = info;
        [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        [weakSelf requestCarriageWithAddressId:self.userAddress.address_id]; //请求运费
    };
    [self.navigationController pushViewController:newAddressVC animated:YES];
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

#pragma mark  按钮点击事件

//MARK:构建提交订单的 productinfo 参数
- (void)payForOrder{
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

}

- (void)pointPaymentEnableEvent:(UISwitch *)aSwitch{
    //网络连接错误时 不允许勾选积分
    if ([DSAppDelegate netStatus]==AFNetworkReachabilityStatusNotReachable) {
        aSwitch.on = NO;
        self.usePointEnabled = NO;
        self.usedPointAmount = @"0.0";
        self.userGoldEnabled = NO;
        
        return;
    }
    OrderConfirmPointsExchangeCell * cell = (OrderConfirmPointsExchangeCell *)aSwitch.superview.superview;
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    OrderConfirmPointsExchangeCell * oldCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3-indexPath.row inSection:2]];
    if (oldCell) {
        oldCell.enablePointsPayment.on = NO;
    }
    aSwitch.on = !aSwitch.on;
    if (indexPath.row==1) {
        //使用积分
        self.usePointEnabled = aSwitch.on;
        self.userGoldEnabled = NO; //不能使用购物金
        self.userGoldAmout = @"0.0";
        [self controlPensionPointUsageWithMeaasage:@"need"];
        aSwitch.on = self.usePointEnabled;
    }else{
        //使用购物金
        self.userGoldEnabled = aSwitch.on;
        self.usePointEnabled = NO; //不能使用积分
        self.usedPointAmount = @"0.0";
        [self controlPensionPointUsageWithMeaasage:@""];
        aSwitch.on = self.userGoldEnabled;
    }
    [self calculateActualAmount]; //计算总价
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
