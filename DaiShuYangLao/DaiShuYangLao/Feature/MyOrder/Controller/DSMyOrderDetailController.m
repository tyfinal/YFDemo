//
//  DSMyOrderDetailController.m
//  DaiShuYangLao
//
//  Created by YueLiang Song on 2018/7/10.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSMyOrderDetailController.h"
#import "DSOrderInfoModel.h"
#import "DSMyOrderCell.h"
#import "DSMyOrderDetailCell.h"
#import "YJPayHelper.h"
#import "DSOrderPayResultHandleController.h"
#import "DSGoodsDetailController.h"
#import "DSShopCartEntraceController.h"
#import "DSOrderPaymentController.h"
@interface DSMyOrderDetailController ()<UITableViewDelegate,UITableViewDataSource,DSMyOrderDetailCellDelegate>{
    
}
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, assign) NSInteger pageNumber;
@property (nonatomic, strong) NSArray * dataArray;
@property (nonatomic, strong) DSOrderInfoModel * orderInfoModel;

@end

@implementation DSMyOrderDetailController
//static NSInteger const kPageSize = 10;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"订单详情";
    [self.view addSubview:self.tableView];
    adjustsScrollViewInsets_NO(self.tableView, self);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(kNavigationBarHeight);
        make.left.right.and.bottom.equalTo(self.view);
    }];
    
    [self requestOrderDetailInfoData];
}

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, boundsHeight) style:UITableViewStyleGrouped];
        tableView.backgroundColor = JXColorFromRGB(0xf6f6f6);
        tableView.showsVerticalScrollIndicator = NO;
        tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.sectionFooterHeight = CGFLOAT_MIN;
        [tableView setTableFooterView:[UIView new]];
        _tableView = tableView;
    }
    return _tableView;
}

#pragma mark 网络请求及数据处理
- (void)requestOrderDetailInfoData{
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [DSHttpResponseData orderGetOrderDetailInfoByOrderId:self.orderId callback:^(id info, BOOL succeed, id extraInfo) {
        [HUD hideAnimated:YES];
        if (succeed) {
            if (info) {
               self.orderInfoModel = info;
                if (boundsHeight>=812) {
                    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, 34)];
                    footerView.backgroundColor = JXColorFromRGB(0xf6f6f6);
                    [self.tableView setTableFooterView:footerView];
                } 
                [self.tableView reloadData];
            }
        }
    }];
}

#pragma mark UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.orderInfoModel? 5:0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.orderInfoModel) {
        if (section==0||section==3) {
            return 1;
        }else if (section==1){
            NSArray * goodsArray = self.orderInfoModel.products;
            return goodsArray.count>0? goodsArray.count:0;
        }else if (section==2){
            if (self.orderInfoModel.status.integerValue==DSOrderRequestTradeCaceled||self.orderInfoModel.status.integerValue==DSOrderRequestWaitForPayment) {
                return 2;  //交易取消 与 代付款
            }else if (self.orderInfoModel.status.integerValue==DSOrderRequestWaitForDelivery){
                return 4;  //待发货
            }
            return 5;
        }else{
            if (self.orderInfoModel.point.doubleValue>0||self.orderInfoModel.gold.doubleValue>0) {
                return 6;
            }
            return 5;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.orderInfoModel) {
        if (indexPath.section==0) {
            return 53.0f;
        }else if (indexPath.section==1){
            NSArray * products = self.orderInfoModel.products;
            if (products.count>indexPath.row) {
                OrderProductInfoModel * productInfo = products[indexPath.row];
                if ([productInfo.remark isNotBlank]) {
                    return 90+20;
                }else{
                    return 90;
                }
            }
            return 0.0;
        }else if (indexPath.section==2){
            return 44;
        }else if (indexPath.section==3){
            return UITableViewAutomaticDimension;;
        }else{
            if (indexPath.row==5||indexPath.row==4) {
                return 50.0f;
            }else{
                return 30.0f;
            }
        }
    }
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.orderInfoModel) {
        if(indexPath.section==3) return 85;
    }
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.orderInfoModel) {
        if (section!=1) {
            return 10;
        }
    }
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.orderInfoModel) {
        if (section!=1) {
            UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, 10)];
            headerView.backgroundColor = JXColorFromRGB(0xf6f6f6);
            return headerView;
        }
    }
    return Nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        static NSString *identifer = @"orderstatuscell";
        MyOrderDetailStatusCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer];
        if (!cell) {
            cell = [[MyOrderDetailStatusCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        }
        if (self.orderInfoModel) {
            cell.orderModel = self.orderInfoModel;
        }
        return cell;
    }else if (indexPath.section==1){
        static NSString *identifer = @"goodscell";
        OrderGoodsInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer];
        if (!cell) {
            cell = [[OrderGoodsInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        }
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
        [cell.goodsCoverIV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView.mas_left).with.offset(14);
        }];
        
        [cell.priceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell.contentView.mas_right).with.offset(-11);
        }];
        
        if (self.orderInfoModel&&self.orderInfoModel.products.count>0) {
            cell.seperator.hidden = (self.orderInfoModel.products.count-1==indexPath.row) ? YES:NO;
            cell.goodsModel = self.orderInfoModel.products[indexPath.row];
        }
        return cell;
    }else if (indexPath.section==2){
        static NSString *identifer = @"orderinfocell";
        MyOrderDetailCommonCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer];
        if (!cell) {
            cell = [[MyOrderDetailCommonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        }
        if (self.orderInfoModel) {
            cell.cellKey = @[@"orderNo",@"orderTime",@"payChannel",@"payTime",@"expressNo"][indexPath.row];
            cell.orderModel = self.orderInfoModel;
            cell.titleLabel.text = @[@"订单编号：",@"下单时间：",@"支付方式：",@"支付时间：",@"物流单号："][indexPath.row];
        }
        return cell;
    }else if (indexPath.section==3){
        static NSString *identifer = @"addresscell";
        MyOrderDetailAddressCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer];
        if (!cell) {
            cell = [[MyOrderDetailAddressCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        } 
        if (self.orderInfoModel) {
            cell.orderModel = self.orderInfoModel;
        }
        return cell;
    }else{
        NSInteger count = [tableView numberOfRowsInSection:4];
        if (indexPath.row<count-1) {
            static NSString *identifer = @"checkoutcell";
            MyOrderDetailCheckOutCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer];
            if (!cell) {
                cell = [[MyOrderDetailCheckOutCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
            }
            if (self.orderInfoModel) {
                
                if (self.orderInfoModel.point.doubleValue>0) {
                    cell.cellKey = @[@"productNum",@"amount",@"point",@"logisticsFee",@"payAmount"][indexPath.row];
                    cell.titleLabel.text = @[@"商品数量",@"商品总额",@"养老备用金抵扣",@"运费",@""][indexPath.row];
                }else if (self.orderInfoModel.gold.doubleValue>0){
                    cell.cellKey = @[@"productNum",@"amount",@"gold",@"logisticsFee",@"payAmount"][indexPath.row];
                    cell.titleLabel.text = @[@"商品数量",@"商品总额",@"购物金抵扣",@"运费",@""][indexPath.row];
                }else{
                    cell.cellKey = @[@"productNum",@"amount",@"logisticsFee",@"payAmount"][indexPath.row];
                    cell.titleLabel.text = @[@"商品数量",@"商品总额",@"运费",@""][indexPath.row];
                }
                cell.orderModel = self.orderInfoModel;
            }
            return cell;
        }else{
            static NSString *identifer = @"operationcell";
            MyOrderDetailOperationCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer];
            if (!cell) {
                cell = [[MyOrderDetailOperationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
            }
            cell.delegate = self;
            if (self.orderInfoModel) {
                cell.orderModel = self.orderInfoModel;
            }
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1) {
        DSGoodsDetailController * goodsDetailVC = [[DSGoodsDetailController alloc]init];
        OrderProductInfoModel * model = self.orderInfoModel.products[indexPath.row];
        goodsDetailVC.goodsId = model.goods_id;
        [self.navigationController pushViewController:goodsDetailVC animated:YES];
    }
}

#pragma mark DSMyOrderDetailCellDelegate 操作按钮点击事件处理
- (void)ds_myOrderDetailCell:(DSMyOrderDetailCell *)cell buttonClickHandle:(NSString *)buttonHandle{
    if ([buttonHandle isNotBlank]) {
        if ([buttonHandle isEqualToString:@"deleteorder"]) {
            //删除订单
            UIAlertController * alertController = [YJAlertView presentAlertWithTitle:@"确定删除该订单" message:nil actionTitles:@[@"取消",@"确定"] preferredStyle:UIAlertControllerStyleAlert actionHandler:^(NSUInteger buttonIndex, NSString *buttonTitle) {
                if (buttonIndex==1) {
                    [DSHttpResponseData orderOperationWithOperationType:2 orderId:self.orderInfoModel.order_id callback:^(id info, BOOL succeed, id extraInfo) {
                        if (succeed) {
                            if (self.DidUpdateOrderStatus) {
                                self.DidUpdateOrderStatus(DSOrderRequestOrderDidDelete);
                            }
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                    }];
                }
            }];
            [self presentViewController:alertController animated:YES completion:nil];

        }else if ([buttonHandle isEqualToString:@"cancelorder"]){
            //取消订单
            UIAlertController * alertController = [YJAlertView presentAlertWithTitle:@"确定取消该订单" message:nil actionTitles:@[@"取消",@"确定"] preferredStyle:UIAlertControllerStyleAlert actionHandler:^(NSUInteger buttonIndex, NSString *buttonTitle) {
                if (buttonIndex==1) {
                    [DSHttpResponseData orderOperationWithOperationType:1 orderId:self.orderInfoModel.order_id callback:^(id info, BOOL succeed, id extraInfo) {
                        if (succeed) {
                            if (self.DidUpdateOrderStatus) {
                                self.DidUpdateOrderStatus(DSOrderRequestTradeCaceled);
                            }
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                    }];
                }
            }];
            [self presentViewController:alertController animated:YES completion:nil];
        }else if ([buttonHandle isEqualToString:@"remind"]){
            //提醒发货
            [DSHttpResponseData orderOperationWithOperationType:4 orderId:self.orderInfoModel.order_id callback:^(id info, BOOL succeed, id extraInfo) {
                if (succeed) {
                    [MBProgressHUD showText:@"您的发货提醒已提交，我们会尽快安排发货" toView:nil];
                }
            }];
        }else if ([buttonHandle isEqualToString:@"confirm"]){
            //待收货 确认收货
            [DSHttpResponseData orderOperationWithOperationType:3 orderId:self.orderInfoModel.order_id callback:^(id info, BOOL succeed, id extraInfo) {
                if (succeed) {
                    if (self.DidUpdateOrderStatus) {
                        self.DidUpdateOrderStatus(DSOrderRequestTradeSuccess);
                    }
                    [MBProgressHUD showText:@"养老备用金已到账，请到我的界面查看" toView:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        }else if ([buttonHandle isEqualToString:@"paynow"]){
            
            DSOrderPaymentController * orderPaymentController = [[DSOrderPaymentController alloc]init];
            orderPaymentController.pagementWay = _orderInfoModel.payChannel.integerValue;
            orderPaymentController.orderNumber = _orderInfoModel.orderNo;
            orderPaymentController.actualPayAmount = _orderInfoModel.payAmount;
            orderPaymentController.popControllerLevel = 2;
            orderPaymentController.totalAmount = _orderInfoModel.amount;
            [self.navigationController pushViewController:orderPaymentController animated:YES];
            return;
            //立即支付
//            if ([self.orderInfoModel.orderNo isNotBlank]) {
//                MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                NSMutableDictionary * params = [NSMutableDictionary dictionary];
//                params[@"orderNo"] = self.orderInfoModel.orderNo;
//                if (self.orderInfoModel.point.doubleValue>0) {
//                    params[@"point"] = self.orderInfoModel.point;
//                }
//                
//                if (self.orderInfoModel.gold.doubleValue>0) {
//                    params[@"gold"] = self.orderInfoModel.gold;
//                }
//                
//                [DSHttpResponseData orderGetAlipayPayOrderInfoWithParams:params callback:^(id info, BOOL succeed, id extraInfo) {
//                    [HUD hideAnimated:YES];
//                    if (succeed) {
//                        if (info) {
//                            YJPayHelper * payHelper = [YJPayHelper sharePayHelper];
//                            [payHelper payOrder:info paymentMode:Payment_ALiPay];
//                            [payHelper setAlipayPayResultCallback:^(id info, BOOL succeed, id extraInfo) {
//                                DSOrderPayResultHandleController * resultHandleController = [[DSOrderPayResultHandleController alloc]init];
//                                resultHandleController.pensionAmount = self.orderInfoModel.point;
//                                resultHandleController.popControllerLevel = 2;
//                                resultHandleController.orderNumber = self.orderInfoModel.orderNo;
//                                resultHandleController.payStatus = [extraInfo integerValue];
//                                [self.navigationController pushViewController:resultHandleController animated:YES];
//                            }];
//                        }
//                    }
//                }];
//            }
        }else if ([buttonHandle isEqualToString:@"buyagain"]){
            
            NSMutableArray * muParams = [NSMutableArray array];
            if (self.orderInfoModel.products.count>0 ) {
                [self.orderInfoModel.products enumerateObjectsUsingBlock:^(OrderProductInfoModel * productModel, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSMutableDictionary * produectParas = [NSMutableDictionary dictionary];
                    produectParas[@"productId"] = productModel.goods_id;
                    produectParas[@"num"] = productModel.num;
                    produectParas[@"skuId"] = productModel.sku.sku_id;
                    [muParams addObject:produectParas];
                }];
            }
            if (muParams.count>0) {
                NSString * productsInfoJson = muParams.mj_JSONString;
                if ([productsInfoJson isNotBlank]) {
                    //再次购买 加入购物车
                    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
                    [DSHttpResponseData shopCartAddManyGoods:productsInfoJson callback:^(id info, BOOL succeed, id extraInfo) {
                        [HUD hideAnimated:YES];
                        if (succeed) {
                            DSShopCartEntraceController * shopCartEntranceVC = [[DSShopCartEntraceController alloc]init];
                            [self.navigationController pushViewController:shopCartEntranceVC animated:YES];
                        }
                    }];
                }
            }
        }
    }
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
