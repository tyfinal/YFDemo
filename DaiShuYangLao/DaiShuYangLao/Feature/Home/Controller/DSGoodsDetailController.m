//
//  DSGoodsDetailController.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/6.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSGoodsDetailController.h"
#import <SDCycleScrollView.h>
#import "DSGoodsDetailsHeaderView.h"
#import "DSBannerModel.h"
#import "DSGoodsDetailCell.h"
#import "YYFPSLabel.h"
#import "DSGoodeDetailBottomView.h"
#import "DSGoodsDetailInfoModel.h"
#import "DSGoodsDetailPropertyChooseView.h"
#import "KLCPopup.h"
#import "DSOrderConfirmController.h"
#import "DSShopCartModel.h"
#import "DSGoodsInfoModel.h"
#import "DSShopCartEntraceController.h"
#import "DSLaunchConfigureModel.h"
#import "XHWebImageAutoSize.h"
#import <UShareUI/UShareUI.h>
#import "YJUMengShareHelper.h"
#import "DSHomeDetailParametersView.h"
#import "DSControllerHelper.h"
#import "DSServiceOrderPaymentController.h"

@interface DSGoodsDetailController ()<UITableViewDelegate,UITableViewDataSource,GoodsDetailBottomViewDelegate,GoodsDetailPropertyChooseViewDelegate,DSGoodsDetailDelegate>{
    
}

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) SDCycleScrollView * bannerScrollerView;
@property (nonatomic, strong) DSGoodsDetailsHeaderView * tableHeaderView;
@property (nonatomic, strong) DSGoodeDetailBottomView * bottomView;
@property (nonatomic, strong) DSGoodsDetailInfoModel * detailInfoModel;
@property (nonatomic, strong) KLCPopup * propertyPopUpView;
@property (nonatomic, strong) KLCPopup * parametersPopView; /**< 产品参数 */
@property (nonatomic, strong) DSGoodsDetailPropertyChooseView * propertyContentView;
@property (nonatomic, strong) GoodsDetailSaleInfo * selectSkuModel;

@end

@implementation DSGoodsDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self changeNavigationBarTransparent:YES];
    [self preferredStatusBarStyle];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginSucceedHandle) name:kLoginSucceedNotificationKey object:nil];
    
    if (self.ds_universal_params) {
        if ([self.ds_universal_params[@"previouspagetype"] isEqualToString:@"advertpage"]) {
            self.rt_disableInteractivePop = YES;
            self.backButtonHandle = ^{
                [DSAppDelegate goToHomePage];
            };
        }
    }
    
    self.rt_disableInteractivePop = NO;
    adjustsScrollViewInsets_NO(self.tableView, self);
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[ImageString(@"home_goodsdetail_back") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backToFrontPage)];
    
    UIBarButtonItem * shareItem = [[UIBarButtonItem alloc]initWithImage:[ImageString(@"public_share") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(shareEvent)];
    UIBarButtonItem * shopcartItem = [[UIBarButtonItem alloc]initWithImage:[ImageString(@"home_goodsdetail_shoppingcart") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(goToShopCartPage)];
    
    self.navigationItem.rightBarButtonItems = @[shareItem,shopcartItem];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.and.right.equalTo(self.view);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            // Fallback on earlier versions
            make.bottom.equalTo(self.view);
        }
        make.top.equalTo(self.tableView.mas_bottom);
        make.height.mas_equalTo(48).priorityLow();
    }];
    
    [self requestData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if (self.detailInfoModel) {
        //未登录用户 登录过后收藏状态 已经 领航专属商品状态可能会调整
       self.bottomView.goodsModel = self.detailInfoModel;
        _propertyContentView.goodsModel = self.detailInfoModel;
    }
}

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, boundsHeight) style:UITableViewStyleGrouped];
        tableView.backgroundColor = JXColorFromRGB(0xffffff);
        tableView.showsVerticalScrollIndicator = NO;
        tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.sectionFooterHeight = CGFLOAT_MIN;
        [tableView setTableHeaderView:self.tableHeaderView];
        [tableView setTableFooterView:[UIView new]];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView = tableView;
    }
    return _tableView;
}

- (KLCPopup *)propertyPopUpView{
    if (!_propertyPopUpView) {
        _propertyContentView = [[DSGoodsDetailPropertyChooseView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, boundsHeight*0.6)];
        _propertyContentView.delegate = self;
        _propertyPopUpView = [KLCPopup popupWithContentView:_propertyContentView showType:KLCPopupShowTypeSlideInFromBottom dismissType:KLCPopupDismissTypeSlideOutToBottom maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:NO];
    }
    return _propertyPopUpView;
}

- (KLCPopup *)parametersPopView{
    if (!_parametersPopView) {
        DSHomeDetailParametersView * parametersView = [[DSHomeDetailParametersView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, boundsHeight*0.7)];
        [parametersView.closeButton addTarget:self action:@selector(closeParameterPopView) forControlEvents:UIControlEventTouchUpInside];
//        _parametersPopView.delegate = self;
        _parametersPopView = [KLCPopup popupWithContentView:parametersView showType:KLCPopupShowTypeSlideInFromBottom dismissType:KLCPopupDismissTypeSlideOutToBottom maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:NO];
    }
    return _parametersPopView;
}

- (DSGoodsDetailsHeaderView *)tableHeaderView{
    if (!_tableHeaderView) {
        _tableHeaderView = [[DSGoodsDetailsHeaderView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, boundsWidth)];
        _tableHeaderView.backgroundColor = JXColorFromRGB(0xffffff);
    }
    return _tableHeaderView;
}

- (DSGoodeDetailBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[DSGoodeDetailBottomView alloc]initWithFrame:CGRectZero];
        _bottomView.delegate = self;
    }
    return _bottomView;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

#pragma mark 网络请求及数据处理

- (void)requestData{
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [DSHttpResponseData homeGoodsDetalsInfoWithGoodsId:self.goodsId callback:^(id info, BOOL succeed, id extraInfo) {
        [HUD hideAnimated:YES];
        if (succeed) {
            if (info) {
                self.detailInfoModel = info;
                self.detailInfoModel.buyNumber = 1; //初始为1
                if (self.shopCartModel) {
                   self.detailInfoModel.buyNumber = self.shopCartModel.num.integerValue; //如过来自购物车
                }
                self.bottomView.goodsModel = self.detailInfoModel;
                self.bottomView.collectionButton.selected = self.detailInfoModel.isLike.boolValue;
                
                //banner
                if (self.detailInfoModel.pics.count>0) {
                    NSMutableArray * mu = [NSMutableArray array];
                    for (NSInteger i=0; i<self.detailInfoModel.pics.count; i++) {
                        DSBannerModel * bannerModel = [[DSBannerModel alloc]init];
                        bannerModel.pic = self.detailInfoModel.pics[i];
                        [mu addObject:bannerModel];
                    }
                    self.tableHeaderView.bannersArray = mu;
                }
                
//                if (self.detailInfoModel.contents.count>0) {
//                    [self.detailInfoModel.contents enumerateObjectsUsingBlock:^(GoodsDetailContentModel * contentModel, NSUInteger idx, BOOL * _Nonnull stop) {
//                        contentModel.cellH = 0;
//
//                        CGFloat cellW = boundsWidth-24;
//                        if (contentModel.type.integerValue==0) {
//                            if ([contentModel.content isNotBlank]) {
//                                //有网络图片 宽高等于占位图的高度
//                                contentModel.cellH = cellW+10;
//                            }
//                        }else{
//                            //1 文字
//                            if ([contentModel.content isNotBlank]) {
//                                CGFloat contentH = [contentModel.content sizeWithFont:JXFont(15) maxW:cellW].height;
//                                contentModel.cellH = ceil(contentH)+10;
//                            }
//                        }
//                    }];
//                }
                
                [self.tableView reloadData];
            }
        }
    }];
}

- (void)addToShopCartWithSkuModel:(GoodsDetailSaleInfo *)skuModel{
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [DSHttpResponseData shopCartAddGoods:self.goodsId skuId:skuModel.sku_id number:self.detailInfoModel.buyNumber callback:^(id info, BOOL succeed, id extraInfo) {
        [HUD hideAnimated:YES];
        if (succeed) {
            [MBProgressHUD showText:@"成功加入购物车" toView:self.view];
            if (self.ShouldRefreshShopCartData) {
                //如果更改了 商品的sku 需要刷新 购物车
                if (![self.shopCartModel.sku.sku_id isEqualToString:skuModel.sku_id]) {
                    self.ShouldRefreshShopCartData();
                    return ;
                }
                
                if (self.shopCartModel.num.integerValue != self.detailInfoModel.buyNumber) {
                    //更改了商品数量
                    self.ShouldRefreshShopCartData();
                    return;
                }
                
            }
        }
    }];
}

#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return (section==0) ? 0:5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section!=0) {
        UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, 5)];
        headerView.backgroundColor = JXColorFromRGB(0xffffff);
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return (indexPath.row==0) ? UITableViewAutomaticDimension : 44;
    }else if (indexPath.section==1){
        return 44;
    }else{
        if (self.detailInfoModel.contents.count>0) {
            GoodsDetailContentModel * contentModel = self.detailInfoModel.contents[indexPath.row];
            contentModel.cellH = 0;
            
            CGFloat cellW = boundsWidth-24;
            if (contentModel.type.integerValue==0) {
                if ([contentModel.content isNotBlank]) {
                    //有网络图片 宽高等于占位图的高度
                    contentModel.cellH = [XHWebImageAutoSize imageHeightForURL:[NSURL URLWithString:contentModel.content] layoutWidth:cellW estimateHeight:cellW]+10;
                }
            }else{
                //1 文字
                if ([contentModel.content isNotBlank]) {
                    CGFloat contentH = [contentModel.content sizeWithFont:JXFont(15) maxW:cellW].height;
                    contentModel.cellH = ceil(contentH)+10;
                }
            }
            return contentModel.cellH;
        }
        return 0.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return (indexPath.row==0) ? 132 : 44;
    }else if (indexPath.section==1){
        return 44;
    }else{
        return 600;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        if (self.detailInfoModel.useGold.doubleValue>0) {
            return 3;
        }
        return 2;
    }else if(section==1){
        if (self.detailInfoModel.properties.count>0) {
            return 3;
        }
        return 2;
    }else{
        return self.detailInfoModel.contents.count>0?self.detailInfoModel.contents.count:0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0&&indexPath.row==0) {
        static NSString * identifer = @"goodsbaseinfo";
        
        GoodsDetailBaseInfo * cell=[tableView dequeueReusableCellWithIdentifier:identifer];
        if(cell==nil){
            cell = [[GoodsDetailBaseInfo alloc] initWithStyle:UITableViewCellStyleDefault      reuseIdentifier:identifer];
        }
        cell.model = self.detailInfoModel;
//        if (self.selectSkuModel) {
//            cell.currentPriceLabel.text = [NSString stringWithFormat:@"%.2f",self.selectSkuModel.price.floatValue];
//        }else{
//            GoodsDetailSaleInfo * model = (self.detailInfoModel.skus.count>0)? _detailInfoModel.skus[0]:nil;
//            if (model) {
//                cell.currentPriceLabel.text = [NSString stringWithFormat:@"%.2f",model.price.floatValue];
//            }
//        }
        return cell;
    }else if (indexPath.section==2){
        static NSString * identifer = @"goodsdetailimagec";
        
        GoodsDetailImageCell * cell=[tableView dequeueReusableCellWithIdentifier:identifer];
        if(cell==nil){
            cell = [[GoodsDetailImageCell alloc] initWithStyle:UITableViewCellStyleDefault      reuseIdentifier:identifer];
        }
        
        if (self.detailInfoModel.contents.count>0) {
            GoodsDetailContentModel * model = self.detailInfoModel.contents[indexPath.item];
            cell.contentModel = model;
            cell.indexPath = indexPath;
            cell.delegate = self;
//            //图片已加载 刷新高度
//            __weak typeof (GoodsDetailImageCell *)weakCell = cell;
//            cell.ImageCellDidLoadImageCallback = ^(NSIndexPath *aindexPath, GoodsDetailContentModel *amodel) {
//                if ([self.detailInfoModel.contents containsObject:amodel]) {
//                    [UIView performWithoutAnimation:^{
//                      [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//                    }];
//
//                }else{
//                    NSLog(@"异常");
//                }
//            };
        }
    
        return cell;
    }else{
        static NSString * identifer = @"commoncell";
        
        GoodsDetailNormalCell * cell=[tableView dequeueReusableCellWithIdentifier:identifer];
        if(cell==nil){
            cell = [[GoodsDetailNormalCell alloc] initWithStyle:UITableViewCellStyleDefault      reuseIdentifier:identifer];
        }
        if(indexPath.section==0&&indexPath.row>0){
           cell.titleLabel.text = @[@"促销",@"活动"][indexPath.row-1];
            cell.descLabel.text = @"暂无活动";
            if (self.detailInfoModel.info&&indexPath.row==1) {
                cell.descLabel.text = self.detailInfoModel.info;
            }
            
            if (indexPath.row==2&&self.detailInfoModel.useGold.doubleValue>0) {
                cell.descLabel.text = [NSString stringWithFormat:@"可使用%.2f购物金",self.detailInfoModel.useGold.doubleValue];
            }
            
        }else{
            cell.titleLabel.text = @[@"服务",@"规格",@"参数"][indexPath.row];
            if(indexPath.row==0) cell.descLabel.text = @"江浙沪皖及部分地区包邮";
            
            if (indexPath.row ==1) {
                if (self.selectSkuModel) {
                    cell.descLabel.text = self.selectSkuModel.info;
                }else{
                    cell.descLabel.text = @"选择规格";
                }
            }
            
            if (indexPath.row==2) {
                cell.descLabel.text = @"产品属性";
            }
            
//            cell.descLabel.text = @[@"",@"",@"",@""];
        }
        cell.model = nil;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1&&indexPath.row==1) {
        [self.propertyPopUpView showWithLayout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutBottom)];
        _propertyContentView.goodsModel = self.detailInfoModel;
    }else if (indexPath.section==1&&indexPath.row==2){
        if (self.detailInfoModel.properties.count>0) {
            [self.parametersPopView showWithLayout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutBottom)];
            DSHomeDetailParametersView * parametersView = (DSHomeDetailParametersView *) self.parametersPopView.contentView;
            parametersView.dataArray = self.detailInfoModel.properties;
        }
    }
}

#pragma mark DSGoodsDetailDelegate
- (void)ds_goodsDetailCell:(DSGoodsDetailCell *)cell updateCellHeightWithModel:(GoodsDetailContentModel *)contentModel indexPath:(NSIndexPath *)indexPath{
    [self.tableView xh_reloadDataForURL:[NSURL URLWithString:contentModel.content]];
}

#pragma mark GoodsDetailBottomViewDelegate 底部按钮点击事件
- (void)ds_goodsDetailBottomView:(DSGoodeDetailBottomView *)bottomView clickBuyButtonAtIndex:(NSInteger)buttonIndex button:(UIButton *)button{
    //判断用户是否登录
    if ([DSAppDelegate shouldShowLoginAlertViewInController:self]) {
        return;
    }
    
    //判断是否为领航专属商品
    if ([self shouldGuidaUserToUpgradeMembershipWithGoodsModel:self.detailInfoModel]) {
        return;
    }
    
    if (!self.selectSkuModel) {
        //用户未选择规格
        [self.propertyPopUpView showWithLayout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutBottom)];
        _propertyContentView.goodsModel = self.detailInfoModel;
        return;
    }
    GoodsDetailSaleInfo * skuModel = nil;
    
    if (self.selectSkuModel) {
        skuModel = self.selectSkuModel;
    }else{
        skuModel = (self.detailInfoModel.skus.count>0)? _detailInfoModel.skus[0]:nil;
    }
    if (!skuModel) {
        return;
    }
    

    if (buttonIndex==0) {
        //MARK:加入购物车
        [self addToShopCartWithSkuModel:skuModel];
        
    }else{
         //MARK:立即购买
        if (self.detailInfoModel.serviceFlag.boolValue==1) {
            //服务类型商品
            NSString * totalPrice = [NSString stringWithFormat:@"%.2f",self.detailInfoModel.buyNumber*skuModel.price.floatValue];
            DSServiceOrderPaymentController * confirmOrder = [[DSServiceOrderPaymentController alloc]init];
            confirmOrder.totalAmount = totalPrice;
            DSShopCartModel * shopCartModel = [self getShopCartModelWithSkuModel:skuModel];
            confirmOrder.checkingOutArray = @[shopCartModel];
            [self.navigationController pushViewController:confirmOrder animated:YES];
        }else{
            //MARK:立即购买
            NSString * totalPrice = [NSString stringWithFormat:@"%.2f",self.detailInfoModel.buyNumber*skuModel.price.floatValue];
            DSOrderConfirmController * confirmOrder = [[DSOrderConfirmController alloc]init];
            confirmOrder.totalAmount = totalPrice;
            DSShopCartModel * shopCartModel = [self getShopCartModelWithSkuModel:skuModel];
            confirmOrder.checkingOutArray = @[shopCartModel];
            [self.navigationController pushViewController:confirmOrder animated:YES];
        }
    }
}

- (void)ds_goodsDetailBottomView:(DSGoodeDetailBottomView *)bottomView clickOperationbuttonAtIndex:(NSInteger)buttonIndex button:(UIButton *)button{
    if (buttonIndex==0) {
        //MARK: 回首页
        [DSAppDelegate goToHomePage];
    }else if(buttonIndex==1) {
        
        DSLaunchConfigureModel * configureModel = [DSLaunchConfigureModel configureModel];
        
        if ([configureModel.serviceTel isNotBlank]) {
            NSString * telStr = [NSString stringWithFormat:@"telprompt:%@",configureModel.serviceTel];
            //MARK: 客服
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:telStr] options:@{} completionHandler:nil];
            } else {
                // Fallback on earlier versions
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telStr]];
            }
        }

    }else{
        if ([DSAppDelegate shouldShowLoginAlertViewInController:self]) {
            return;
        }
        
        //MARK: 收藏
        if (button.selected==NO) {
            MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [DSHttpResponseData collectionGoodsByGoodsid:self.goodsId callback:^(id info, BOOL succeed, id extraInfo) {
                [HUD hideAnimated:YES];
                if (succeed) {
                    self.detailInfoModel.isLike = @"1";
                    button.selected = YES;
                }
            }];
        }else{
            MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [DSHttpResponseData collectionDeleteGoodsByGoodsid:self.goodsId callback:^(id info, BOOL succeed, id extraInfo) {
                [HUD hideAnimated:YES];
                if (succeed) {
                    self.detailInfoModel.isLike = @"0";
                    button.selected = NO;
                }
            }];
        }
    }
}

#pragma mark GoodsDetailPropertyChooseViewDelegate 弹出康点击事件

/** 点击关闭 已经选择某个属性 已经选择某个属性 */
- (void)ds_GoodsDetailPropertyView:(DSGoodsDetailPropertyChooseView *)chooseView didSelectProperty:(GoodsDetailSaleInfo *)skuModel{
    if (skuModel) {
        self.selectSkuModel = skuModel;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0],[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
    }
    [self.propertyPopUpView dismiss:YES];
}

/** button index = 0 购物车 1 立即购买  在弹出框内点击购买和加入购物车 */
- (void)ds_GoodsDetailPropertyView:(DSGoodsDetailPropertyChooseView *)chooseView clickButtonAtIndex:(NSInteger)buttonIndex button:(UIButton *)button skuModel:(GoodsDetailSaleInfo *)skuModel{
    [self.propertyPopUpView dismiss:YES];

    if ([DSAppDelegate shouldShowLoginAlertViewInController:self]) {
        return; //判断用户是否需要登录
    }
    
    if ([self shouldGuidaUserToUpgradeMembershipWithGoodsModel:self.detailInfoModel]) {
        return; //判断是否为领航会员专属商品
    }
    
    if (!skuModel) {
        return; //没有规格不能购买
    }
    
    if (buttonIndex==0) {
        //MARK:加入购物车
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0],[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
        [self addToShopCartWithSkuModel:skuModel];
    }else{
        //MARK:立即购买
        if (self.detailInfoModel.serviceFlag.boolValue==1) {
            //是服务类型商品
            NSString * totalPrice = [NSString stringWithFormat:@"%.2f",self.detailInfoModel.buyNumber*skuModel.price.floatValue];
            DSServiceOrderPaymentController * confirmOrder = [[DSServiceOrderPaymentController alloc]init];
            confirmOrder.totalAmount = totalPrice;
            DSShopCartModel * shopCartModel = [self getShopCartModelWithSkuModel:skuModel];
            confirmOrder.checkingOutArray = @[shopCartModel];
            [self.navigationController pushViewController:confirmOrder animated:YES];
        }else{
            NSString * totalPrice = [NSString stringWithFormat:@"%.2f",self.detailInfoModel.buyNumber*skuModel.price.floatValue];
            DSOrderConfirmController * confirmOrder = [[DSOrderConfirmController alloc]init];
            confirmOrder.totalAmount = totalPrice;
            DSShopCartModel * shopCartModel = [self getShopCartModelWithSkuModel:skuModel];
            confirmOrder.checkingOutArray = @[shopCartModel];
            [self.navigationController pushViewController:confirmOrder animated:YES];
        }
    }
}


- (DSShopCartModel *)getShopCartModelWithSkuModel:(GoodsDetailSaleInfo *)skuModel{
    DSShopCartModel * shopCartModel = [[DSShopCartModel alloc]init];
    shopCartModel.goods_id = self.detailInfoModel.goods_id;
    shopCartModel.sku = skuModel;
    shopCartModel.product = [self getGoodsInfoModel];
    shopCartModel.num = @(self.detailInfoModel.buyNumber);
    return shopCartModel;
}

- (DSGoodsInfoModel *)getGoodsInfoModel{
    DSGoodsInfoModel * goodsInfoModel = [[DSGoodsInfoModel alloc]init];
    goodsInfoModel.goods_id = self.detailInfoModel.goods_id;
    goodsInfoModel.name = self.detailInfoModel.name;
    goodsInfoModel.price = self.detailInfoModel.price;
    goodsInfoModel.minPic = self.detailInfoModel.minPic;
    goodsInfoModel.sellNum = self.detailInfoModel.sellNum;
    goodsInfoModel.status = self.detailInfoModel.status;
    goodsInfoModel.inventoryNum = self.detailInfoModel.inventoryNum;
    goodsInfoModel.specification = self.detailInfoModel.specification;
    goodsInfoModel.useGold = self.detailInfoModel.useGold;
    return goodsInfoModel;
}

- (void)backToFrontPage{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)goToShopCartPage{
    if ([DSAppDelegate shouldShowLoginAlertViewInController:self]) {
        return;
    }
    //验证token
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [DSHttpResponseData PublicCheckValidityOfToken:^(id info, BOOL succeed, id extraInfo) {
        [HUD hideAnimated:YES];
        if (succeed) {
            DSShopCartEntraceController * shopCartVC = [[DSShopCartEntraceController alloc]init];
            [self.navigationController pushViewController:shopCartVC animated:YES];
        }
    }];
}

- (void)shareEvent{
    DSLaunchConfigureModel * configure = [DSLaunchConfigureModel configureModel];
    if (configure.shareProduct.boolValue==0) {
        [MBProgressHUD showText:@"分享功能还在完善  请截屏分享一下啦" toView:nil];
        return;
    }
    if ([self.goodsId isNotBlank]==NO) {
        return;
    }
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [DSHttpResponseData homeGetShareGoodsContentsWithParmas:@{@"productId":self.goodsId} callback:^(id info, BOOL succeed, id extraInfo) {
        [HUD hideAnimated:YES];
        if (succeed) {
            if (info) {
                [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
                    [[YJUMengShareHelper shareUMengHelper]shareToPlatform:platformType Params:info shareType:0];
                }];
            }
        }
    }];

}

- (void)closeParameterPopView{
    [self.parametersPopView dismiss:YES];
    
}

- (void)loginSucceedHandle{
    UIWindow * window = [DSAppDelegate window];
    UIViewController * controller = [window visibleViewController];

//    UIViewController * controller = [DSControllerHelper getCurrentViewController];
    if ([controller isKindOfClass:[DSGoodsDetailController class]]) {
        //在当前页面登录的时候才请求
        [self requestData];
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
