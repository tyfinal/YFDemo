//
//  DSMyOrderEntranceSubController.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/1.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSMyOrderEntranceSubController.h"
#import "DSMyOrderCell.h"
#import "DSOrderInfoModel.h"
#import "DSOrderListModel.h"
#import "DSGoodsInfoModel.h"
#import "YJPayHelper.h"
#import <UIScrollView+EmptyDataSet.h>
#import "DSOrderPayResultHandleController.h"
#import "DSMyOrderDetailController.h"
#import "DSShopCartEntraceController.h"
#import "DSOrderPaymentController.h"

@interface DSMyOrderEntranceSubController ()<UITableViewDelegate,UITableViewDataSource,MyOrderCellDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>{
    
}

@property (nonatomic, assign) NSInteger pageNumber;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * dataArray;
@property (nonatomic, assign) DSLoadDataStatus loadingStatus;

@end

static NSInteger const kPageSize = 10;
@implementation DSMyOrderEntranceSubController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.tableView reloadData];
    [self addTableViewHeaderAndFooterRefresher];
//    [DSHttpData ];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

#pragma mark UI

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, boundsHeight) style:UITableViewStyleGrouped];
        tableView.backgroundColor = JXColorFromRGB(0xffffff);
        tableView.showsVerticalScrollIndicator = NO;
        tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.emptyDataSetSource = self;
        tableView.emptyDataSetDelegate = self;
        tableView.sectionFooterHeight = CGFLOAT_MIN;
        tableView.sectionHeaderHeight = 9;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView = tableView;
    }
    return _tableView;
}

#pragma mark 网络请求及数据处理

- (void)addTableViewHeaderAndFooterRefresher{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _pageNumber = 1;
        [self reqeustDataWithRefreshFlag:DSRereshHeader];
    }];
    
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _pageNumber ++;
        [self reqeustDataWithRefreshFlag:DSRereshFooter];
    }];
    self.tableView.mj_footer.hidden = YES;
    [self.tableView.mj_header beginRefreshing];
}

- (void)reqeustDataWithRefreshFlag:(DSRefreshFlag)refreshFlag{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
    self.loadingStatus = DSBeginLoadingData;
    MBProgressHUD * HUD = (refreshFlag==DSRefreshFirstTimeLoad)? [MBProgressHUD showHUDAddedTo:self.view animated:YES]:nil;
    [DSHttpResponseData orderGetOrderListByStatus:self.orderStatus pageNumber:_pageNumber pageSize:kPageSize callback:^(id info, BOOL succeed, id extraInfo) {
        if(refreshFlag==DSRefreshFirstTimeLoad) [HUD hideAnimated:YES];
        if (succeed) {
            self.loadingStatus = DSLoadDataSuccessed;
            self.tableView.mj_footer.hidden = ([info count]<kPageSize) ? YES:NO;
            if (refreshFlag==DSRereshHeader||refreshFlag==DSRefreshFirstTimeLoad) {
                self.dataArray = info;
            }else if (refreshFlag==DSRereshFooter){
                if ([info count]>0) {
                    NSMutableArray * mu = [NSMutableArray arrayWithArray:self.dataArray];
                    [mu addObjectsFromArray:info];
                    self.dataArray = mu;
                }
            }
            [self.tableView reloadData];
        }else{
            self.loadingStatus = DSLoadDataFailed;
            [self.tableView reloadData];
        }
    }];
}

#pragma mark UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count>0?self.dataArray.count:0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataArray.count>section) {
        DSOrderInfoModel * orderModel = self.dataArray[section];
        return 3+orderModel.products.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return CGFLOAT_MIN;
    }
    return 9.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * sectionHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, 9)];
    sectionHeaderView.backgroundColor = JXColorFromRGB(0xf4f4f4);
    return sectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count>0) {
        DSOrderListModel * model = self.dataArray[indexPath.section];
        if (indexPath.row==0) {
            return 40.0f;
        }else if (indexPath.row>0&&indexPath.row<=model.products.count){
            return 90.0f;
        }else if (indexPath.row==model.products.count+1){
            return 30.0f;
        }else{
            return 40.0f;
        }
    }
    return 0.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    DSMyOrderCell * cell = nil;
    DSOrderListModel * orderModel = nil;
    if (self.dataArray.count>indexPath.section) {
        orderModel = self.dataArray[indexPath.section];
    }
    
    if (orderModel) {
        if (indexPath.row==0) {
            static NSString * identifer = @"statuscell";
            cell=[tableView dequeueReusableCellWithIdentifier:identifer];
            if(cell==nil){
                cell = [[OrderStatusCell alloc] initWithStyle:UITableViewCellStyleDefault      reuseIdentifier:identifer];
            }
        }else if (indexPath.row>0&&indexPath.row<=orderModel.products.count){
            static NSString * identifer = @"goodsinfocell";
            cell = [tableView dequeueReusableCellWithIdentifier:identifer];
            if (!cell) {
                cell = [[OrderGoodsInfoCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
            }
            if (orderModel.products.count>indexPath.row-1) {
               OrderGoodsInfoCell * goodsCell = (OrderGoodsInfoCell *)cell;
                goodsCell.seperator.hidden = (orderModel.products.count==indexPath.row) ? YES : NO;
                OrderProductInfoModel * goodsModel = orderModel.products[indexPath.row-1];
                goodsModel.remark = @"";  //将备注置空;
                goodsCell.goodsModel = goodsModel;
            }
        }else if (indexPath.row==orderModel.products.count+1) {
            static NSString * identifer = @"settlementinfocell";
            cell = [tableView dequeueReusableCellWithIdentifier:identifer];
            if (!cell) {
                cell = [[OrderSettlementCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
            }
        }else{
            static NSString * identifer = @"operationcell";
            cell=[tableView dequeueReusableCellWithIdentifier:identifer];
            if(cell==nil){
                cell = [[OrderOperationCell alloc] initWithStyle:UITableViewCellStyleDefault      reuseIdentifier:identifer];
            }
        }
        cell.model = orderModel;
        cell.delegate = self;
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
    }else{
        static NSString * identifer = @"defaultcell";
        cell=[tableView dequeueReusableCellWithIdentifier:identifer];
        if(cell==nil){
            cell = [[DSMyOrderCell alloc] initWithStyle:UITableViewCellStyleDefault      reuseIdentifier:identifer];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([DSAppDelegate netStatus]==AFNetworkReachabilityStatusNotReachable) {
        [MBProgressHUD showText:@"网络不可用，请检查您的网络连接" toView:self.view];
        return;
    }
    DSOrderListModel * model = self.dataArray[indexPath.section];
    DSMyOrderDetailController * orderDetailVC = [[DSMyOrderDetailController alloc]init];
    orderDetailVC.orderId = model.order_id;
    orderDetailVC.hidesBottomBarWhenPushed = YES;
    __weak typeof (self)weakSelf = self;
    orderDetailVC.DidUpdateOrderStatus = ^(DSOrderRequestType status) {
        [weakSelf.tableView.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:orderDetailVC animated:YES];
}

#pragma mark DZNEmptyDataSetSource,DZNEmptyDataSetDelegate

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView{
    if (self.loadingStatus==DSLoadDataSuccessed) {
        DSEmptyDataCustomView * emptyView = [[DSEmptyDataCustomView alloc]initWithFrame:CGRectZero];
        UIImage * emptyImage = ImageString(@"myorder_emptyset");
        emptyView.emptyImageView.image = emptyImage;
        emptyView.button.hidden = YES;
        [emptyView.emptyImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(120);
            make.height.mas_equalTo(emptyView.emptyImageView.mas_width).multipliedBy(emptyImage.size.height/emptyImage.size.width);
        }];
//        __weak typeof (self)weakSelf = self;
//        emptyView.EmptyDataButtonClickHandle = ^(UIButton *button, id view) {
//            [weakSelf reqeustDataWithRefreshFlag:DSRefreshFirstTimeLoad];
//        };
        return emptyView;
    }else if (self.loadingStatus == DSLoadDataFailed){
        DSEmptyDataCustomView * emptyView = [[DSEmptyDataCustomView alloc]initWithFrame:CGRectZero];
        __weak typeof (self)weakSelf = self;
        emptyView.EmptyDataButtonClickHandle = ^(UIButton *button, id view) {
            [weakSelf reqeustDataWithRefreshFlag:DSRefreshFirstTimeLoad];
        };
        return emptyView;
    }
    return nil;
}

#pragma mark MyOrderCellDelegate

/** 取消订单 */
- (void)ds_myOrderCell:(DSMyOrderCell *)cell cancelOrder:(DSOrderListModel *)orderInfo{
    if ([self.tableView.visibleCells containsObject:cell]) {
//        NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
//        [DSHttpResponseData orderOperationWithOperationType:<#(NSInteger)#> orderId:<#(NSString *)#> callback:<#^(id info, BOOL succeed, id extraInfo)block#>];
    }
}

- (void)ds_myOrderCell:(DSMyOrderCell *)cell model:(DSOrderListModel *)orderInfo buuttonClickHandle:(NSString *)buttonHandle{
    if ([buttonHandle isNotBlank]) {
        if ([buttonHandle isEqualToString:@"deleteorder"]) {
            //删除订单
            UIAlertController * alertController = [YJAlertView presentAlertWithTitle:@"确定删除该订单" message:nil actionTitles:@[@"取消",@"确定"] preferredStyle:UIAlertControllerStyleAlert actionHandler:^(NSUInteger buttonIndex, NSString *buttonTitle) {
                if (buttonIndex==1) {
                    [DSHttpResponseData orderOperationWithOperationType:2 orderId:orderInfo.order_id callback:^(id info, BOOL succeed, id extraInfo) {
                        if (succeed) {
                            [self.tableView.mj_header beginRefreshing];
                        }
                    }];
                }
            }];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }else if ([buttonHandle isEqualToString:@"cancelorder"]){
            //取消订单
            UIAlertController * alertController = [YJAlertView presentAlertWithTitle:@"确定取消该订单" message:nil actionTitles:@[@"取消",@"确定"] preferredStyle:UIAlertControllerStyleAlert actionHandler:^(NSUInteger buttonIndex, NSString *buttonTitle) {
                if (buttonIndex==1) {
                    [DSHttpResponseData orderOperationWithOperationType:1 orderId:orderInfo.order_id callback:^(id info, BOOL succeed, id extraInfo) {
                        if (succeed) {
                            [self.tableView.mj_header beginRefreshing];
                        }
                    }];
                }
            }];
            [self presentViewController:alertController animated:YES completion:nil];
        }else if ([buttonHandle isEqualToString:@"remind"]){
            //提醒发货
            [DSHttpResponseData orderOperationWithOperationType:4 orderId:orderInfo.order_id callback:^(id info, BOOL succeed, id extraInfo) {
                if (succeed) {
                    [MBProgressHUD showText:@"您的发货提醒已提交，我们会尽快安排发货" toView:self.view];
                }
            }];
        }else if ([buttonHandle isEqualToString:@"confirm"]){
            //待收货 确认收货
            [DSHttpResponseData orderOperationWithOperationType:3 orderId:orderInfo.order_id callback:^(id info, BOOL succeed, id extraInfo) {
                if (succeed) {
                    [MBProgressHUD showText:@"养老备用金已到账，请到我的界面查看" toView:self.view];
                    [self.tableView.mj_header beginRefreshing];
                }
            }];
        }else if ([buttonHandle isEqualToString:@"paynow"]){
            DSOrderPaymentController * orderPaymentController = [[DSOrderPaymentController alloc]init];
            orderPaymentController.pagementWay = orderInfo.payChannel.integerValue;
            orderPaymentController.pensionAmount = orderInfo.point;
            orderPaymentController.goldAmount = orderInfo.gold;
            orderPaymentController.orderNumber = orderInfo.orderNo;
            orderPaymentController.actualPayAmount = orderInfo.payAmount;
            orderPaymentController.popControllerLevel = 2;
            orderPaymentController.totalAmount = orderInfo.amount;
            [self.navigationController pushViewController:orderPaymentController animated:YES];
            return;
//            //立即支付
//            if ([orderInfo.orderNo isNotBlank]) {
//                MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                NSMutableDictionary * params = [NSMutableDictionary dictionary];
//                params[@"orderNo"] = orderInfo.orderNo;
//                if (orderInfo.point.doubleValue>0) {
//                    params[@"point"] = orderInfo.point;
//                }
//                
//                if (orderInfo.gold.doubleValue>0) {
//                    params[@"gold"] = orderInfo.gold;
//                }
//                
//                NSLog(@"%@",orderInfo.point);
//                [DSHttpResponseData orderGetAlipayPayOrderInfoWithParams:params callback:^(id info, BOOL succeed, id extraInfo){
//                    [HUD hideAnimated:YES];
//                    if (succeed) {
//                        if (info) {
//                            YJPayHelper * payHelper = [YJPayHelper sharePayHelper];
//                            [payHelper payOrder:info paymentMode:Payment_ALiPay];
//                            [payHelper setAlipayPayResultCallback:^(id info, BOOL succeed, id extraInfo) {
//                                DSOrderPayResultHandleController * resultHandleController = [[DSOrderPayResultHandleController alloc]init];
//                                resultHandleController.pensionAmount = orderInfo.point;
//                                resultHandleController.popControllerLevel = 2;
//                                resultHandleController.orderNumber = orderInfo.orderNo;
//                                resultHandleController.payStatus = [extraInfo integerValue];
//                                [self.navigationController pushViewController:resultHandleController animated:YES];
//                            }];
//                        }
//                    }
//                }];
//            }
        }else if ([buttonHandle isEqualToString:@"buyagain"]){
            //再次购买
            NSMutableArray * muParams = [NSMutableArray array];
            if (orderInfo.products.count>0 ) {
                [orderInfo.products enumerateObjectsUsingBlock:^(OrderProductInfoModel * productModel, NSUInteger idx, BOOL * _Nonnull stop) {
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

/** 根据orderinfo中的status判断 按钮操作  */
- (void)ds_myOrderCell:(DSMyOrderCell *)cell operationButtonClickHandle:(DSOrderListModel *)orderInfo{
    
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
