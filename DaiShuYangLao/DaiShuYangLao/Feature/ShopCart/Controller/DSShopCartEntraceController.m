//
//  DSShopCartEntraceController.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/2.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSShopCartEntraceController.h"
#import "DSShoppingCartCell.h"
#import "DSCheckOutVIew.h"
#import "DSOrderConfirmController.h"
#import "DSGoodsInfoModel.h"
#import "DSShopCartModel.h"
#import "PPNumberButton.h"
#import <UIScrollView+EmptyDataSet.h>
#import "DSGoodsDetailInfoModel.h"
#import "DSGoodsDetailController.h"

@interface DSShopCartEntraceController ()<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>{
    
}

@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout  * layout;
@property (nonatomic, strong) DSCheckOutVIew * checkOutView;
@property (nonatomic, strong) NSArray * dataArray;
@property (nonatomic, assign) BOOL edited;
@property (nonatomic, strong) UIBarButtonItem * rightItem;
@property (nonatomic, copy) NSString * checkOutTotalAmount;   /**< 结算总价  */
@property (nonatomic, assign) NSInteger checkOutTotalNumber; /**< 结算总数 */
@property (nonatomic, copy) NSArray * selectedGoodsArray; /**< 选中的商品列表 */
@property (nonatomic, assign) DSLoadDataStatus loadingStatus;
//@property (nonatomic, assign) BOOL didLoad;

@end



static NSString * goodsInfoCellIdentifer = @"goodsinfocell";
static NSString * recommedGoodsIdentifer = @"recommendgoodscell";

@implementation DSShopCartEntraceController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"购物车";
    self.checkOutTotalAmount = @"0.00";
    self.checkOutTotalNumber = 0;
    self.dataArray = [NSArray array];
    self.selectedGoodsArray = [NSArray array];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateInfo:) name:@"checkoutsuccessnotification" object:nil];
    adjustsScrollViewInsets_NO(self.collectionView, self);
    self.edited = NO;
    
    self.rightItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editShoppingCart)];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.checkOutView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            // Fallback on earlier versions
            make.top.equalTo(self.view.mas_top).with.offset(kNavigationBarHeight);
        }
        make.left.right.and.equalTo(self.view);
    }];
    
    [self.checkOutView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.right.and.equalTo(self.view);
    }];
    
    [self adjustVisibleViewByDataArray:self.dataArray];
    [self reqeustDataWithRefreshFlag:DSRefreshFirstTimeLoad]; //加载购物车数据
}


- (void)setEdited:(BOOL)edited{
    _edited = edited; //开启编辑状态
    self.rightItem.title = self.edited? @"完成":@"编辑";
    self.checkOutView.edited = self.edited;
    [self calculateTotalAmount];
}

#pragma mark UI

//MARK: 结算视图
- (DSCheckOutVIew *)checkOutView{
    if (!_checkOutView) {
        _checkOutView = [[DSCheckOutVIew alloc]initWithFrame:CGRectZero];
        [_checkOutView.checkOutButton addTarget:self action:@selector(checkOutEvent) forControlEvents:UIControlEventTouchUpInside];
        __weak typeof (self)weakSelf = self;
        _checkOutView.hidden = YES;
        _checkOutView.selectAllButtonClickHandle = ^(UIButton *button, id view) {
//            button.selected = !button.selected; //选中所有 或 取消所有
            BOOL selected = !button.selected;
            [weakSelf selectAllGoods:selected]; //将所有的模型属性变为YES 或 NO
        };
        
        _checkOutView.collectionButtonClickHandle = ^(UIButton *button, id view) {
            [weakSelf collectGoods];
        };
    }
    return _checkOutView;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        self.layout = [[UICollectionViewFlowLayout alloc]init];
        self.layout.minimumLineSpacing = 0;
        self.layout.minimumInteritemSpacing = 0;
//        CGFloat itemW = (boundsWidth-(_layout.sectionInset.left+_layout.sectionInset.right+_layout.minimumInteritemSpacing*3))/4.0f;
//        self.layout.itemSize = CGSizeMake(itemW, itemH);
        self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.emptyDataSetSource = self;
        _collectionView.emptyDataSetDelegate = self;
        _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[ShoppingCartGoodsCell class] forCellWithReuseIdentifier:goodsInfoCellIdentifer];
        [_collectionView registerClass:[ShoppingCartRecommendCell class] forCellWithReuseIdentifier:recommedGoodsIdentifer];
    }
    return _collectionView;
}

/** 根据是否存在数据来控制视图显示 */
- (void)adjustVisibleViewByDataArray:(NSArray *)dataArray{
    if (dataArray.count>0) {
        //有数据时
        self.checkOutView.hidden = NO;
        self.navigationItem.rightBarButtonItem = self.rightItem;
    }else{
        //无数据时
        self.checkOutView.hidden = YES;
        self.navigationItem.rightBarButtonItem = nil;
    }
}

#pragma mark 网路请求及数据处理

- (void)showViewWithDataArray:(NSArray *)array{
    if (array.count>0) {
        self.navigationItem.rightBarButtonItem = self.rightItem;
        self.checkOutView.hidden = NO;
    }else{
        self.navigationItem.rightBarButtonItem = nil;
        self.checkOutView.hidden = YES;
    }
}

- (void)addCollectionViewHeaderAndFooterRefresher{
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self reqeustDataWithRefreshFlag:DSRereshHeader];
    }];
    [self.collectionView.mj_header beginRefreshing];
}

- (void)reqeustDataWithRefreshFlag:(DSRefreshFlag)refreshFlag{
    MBProgressHUD * HUD = nil;
    if(refreshFlag==DSRefreshFirstTimeLoad) HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.loadingStatus = DSBeginLoadingData;
    [DSHttpResponseData shopCartGetAllGoods:^(id info, BOOL succeed, id extraInfo) {
        if(refreshFlag==DSRefreshFirstTimeLoad) {
            [HUD hideAnimated:YES];
        }
        [self.collectionView.mj_header endRefreshing];
        if (succeed) {
            self.loadingStatus = DSLoadDataSuccessed;
            if (info) {
                self.dataArray = info;
                [self showViewWithDataArray:info]; //数据存在时显示控件
            }
            [self adjustVisibleViewByDataArray:self.dataArray];
             [self.collectionView reloadData];
        }else{
            self.loadingStatus = DSLoadDataFailed;
            [self adjustVisibleViewByDataArray:self.dataArray];
            [self.collectionView reloadData];
        }
    }];
}

//收藏物品
- (void)collectGoods{
    NSMutableString * muStr = [NSMutableString string];
    NSMutableArray * collectionArray = [NSMutableArray array];
    if (self.selectedGoodsArray.count>0) {
        [self.selectedGoodsArray enumerateObjectsUsingBlock:^(DSShopCartModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.selected) {
                [muStr appendFormat:@"%@,",obj.product.goods_id];
                [collectionArray addObject:obj];
            }
        }];
    }
    if ([muStr isNotBlank]) {
        NSString * ids = [muStr substringToIndex:muStr.length-1];
        MBProgressHUD *  HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [DSHttpResponseData collectionGoodsByGoodsid:ids callback:^(id info, BOOL succeed, id extraInfo) {
            [HUD hideAnimated:YES];
            if (succeed) {
                [MBProgressHUD showText:@"收藏成功" toView:self.view];
            }
        }];
    }
    
}

//MARK: 删除商品
- (void)deleteGoods{
    NSMutableString * muStr = [NSMutableString string];
    NSMutableArray * deleteingArray = [NSMutableArray array];
    if (self.selectedGoodsArray.count>0) {
        [self.selectedGoodsArray enumerateObjectsUsingBlock:^(DSShopCartModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.selected) {
                [muStr appendFormat:@"%@,",obj.goods_id];
                [deleteingArray addObject:obj];
            }
        }];
    }
    if ([muStr isNotBlank]) {
        MBProgressHUD *  HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSString * ids = [muStr substringToIndex:muStr.length-1];
        [DSHttpResponseData shopCartDeleteGoods:ids callback:^(id info, BOOL succeed, id extraInfo) {
            [HUD hideAnimated:YES];
            if (succeed) {
                if (deleteingArray.count>0) {
                    NSMutableArray * dataArrayMu = [NSMutableArray arrayWithArray:self.dataArray];
                    [dataArrayMu removeObjectsInArray:deleteingArray];
                    self.dataArray = dataArrayMu;
                    [self adjustVisibleViewByDataArray:self.dataArray];
                    [self.collectionView reloadData];
                    [self calculateTotalAmount];
                }
            }
        }];
    }
}

//MARK:更新结算视图状态
- (void)updateCheckOutViewStatus{
    if (_edited==NO) {
        self.checkOutView.priceLabel.text = [NSString stringWithFormat:@"合计：￥%@",self.checkOutTotalAmount];
        if (self.checkOutTotalNumber>0 ) {
            [self.checkOutView.checkOutButton setTitle:[NSString stringWithFormat:@"去结算(%ld)",(long)self.checkOutTotalNumber] forState:UIControlStateNormal];
        }else{
            [self.checkOutView.checkOutButton setTitle:@"去结算" forState:UIControlStateNormal];
        }
    }
    
    if (self.checkOutTotalNumber==self.dataArray.count&&self.checkOutTotalNumber>0) {
        self.checkOutView.selectAllButton.selected = YES; //选中的数量与数据总数相等则勾选全选按钮
    }else{
        self.checkOutView.selectAllButton.selected = NO;
    }
}

//MARK:计算商品总价 以及 商品总数
- (void)calculateTotalAmount{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"selected=YES"];
    self.selectedGoodsArray = [self.dataArray filteredArrayUsingPredicate:predicate]; //获取所有选中的
    if (_selectedGoodsArray.count>0) {
        //将选择的商品参与计算
        //每次计算时 清空之前的记录的值
        self.checkOutTotalNumber = 0;
        self.checkOutTotalAmount = @"0.00";
        [_selectedGoodsArray enumerateObjectsUsingBlock:^(DSShopCartModel * shopCartModel, NSUInteger idx, BOOL * _Nonnull stop) {
            if (shopCartModel.selected) {
                self.checkOutTotalNumber+=1;
                NSString * singleProductAmount = [NSString stringWithFormat:@"%f",(shopCartModel.sku.price.floatValue)*(shopCartModel.num.integerValue)];
                self.checkOutTotalAmount = [NSString stringWithFormat:@"%.2f",self.checkOutTotalAmount.floatValue+singleProductAmount.floatValue];
            }
        }];
    }else{
        //未选择任何商品
        self.checkOutTotalNumber = 0;
        self.checkOutTotalAmount = @"0.00";
    }
    [self updateCheckOutViewStatus];
}

#pragma mark UIColletionViewDelegate && UICollectionViewDataSource && UICollectionIVewFlowLayoutDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count>0? self.dataArray.count:0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(boundsWidth, 177);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsZero;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ShoppingCartGoodsCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:goodsInfoCellIdentifer forIndexPath:indexPath];
    if (self.dataArray.count>0) {
        cell.indexPath = indexPath;
        cell.model = self.dataArray[indexPath.item];
    }
    
    __weak typeof (ShoppingCartGoodsCell *)weakCell = cell;
    cell.goodsNumberStepperView.resultBlock = ^(PPNumberButton *ppBtn, CGFloat number, BOOL increaseStatus) {
        MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.minShowTime = 0.5f;
        [DSHttpResponseData shopCartUpdateGoods:weakCell.model.goods_id number:number callback:^(id info, BOOL succeed, id extraInfo) {
            [HUD hideAnimated:YES];
            if (succeed) {
                weakCell.model.num = @(number);
                [self calculateTotalAmount];
//                [self calculateWithCheckOutTotalPrice];
            }else{
                ppBtn.currentNumber = (increaseStatus) ? number-1:number+1;
            }
        }];
    };
    
    __weak typeof (self)weakSelf = self;

    cell.ShoppingCartCellSelectItemAtIndexPath = ^(NSIndexPath *aindexPath, DSShopCartModel *amodel, ShoppingCartGoodsCell * acell) {
        [weakSelf selectGoodsCellAtIndexPath:aindexPath model:amodel cell:acell]; //勾选商品
    };
    
    cell.ShoppingCartCellViewDetailAtIndexPath = ^(NSIndexPath *indexPath, DSShopCartModel *model, ShoppingCartGoodsCell *cell) {
        [weakSelf enterGoodesDetailPageWithModel:model];
    };
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
}

#pragma mark DZNEmptyDataSetSource,DZNEmptyDataSetDelegate

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView{
    if (self.loadingStatus==DSLoadDataSuccessed) {
        DSEmptyDataCustomView * emptyView = [[DSEmptyDataCustomView alloc]initWithFrame:CGRectZero];
        UIImage * emptyImage = ImageString(@"shopcart_emptyset");
        emptyView.emptyImageView.image = emptyImage;
        [emptyView.button setTitle:@"快去逛逛吧" forState:UIControlStateNormal];
        [emptyView.emptyImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(emptyView.emptyImageView.mas_width).multipliedBy(emptyImage.size.height/emptyImage.size.width);
        }];
        emptyView.EmptyDataButtonClickHandle = ^(UIButton *button, id view) {
            [DSAppDelegate goToHomePage];
        };
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

#pragma mark 按钮点击事件

//单选 一个商品
- (void)selectGoodsCellAtIndexPath:(NSIndexPath *)indexPath model:(DSShopCartModel *)model cell:(ShoppingCartGoodsCell *)cell{
    cell.selectedButton.selected = !cell.selectedButton.selected;
    model.selected = !model.selected;
    [self calculateTotalAmount];
}

//结算
- (void)checkOutEvent{
    if (_edited) {
        //删除
        if (self.checkOutTotalNumber>0) {
            UIAlertController * alert = [YJAlertView presentAlertWithTitle:@"确定删除" message:nil actionTitles:@[@"取消",@"确定"] preferredStyle:UIAlertControllerStyleAlert actionHandler:^(NSUInteger buttonIndex, NSString *buttonTitle) {
                if (buttonIndex==1) {
                    [self deleteGoods];
                }
            }];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }else{
        if (self.selectedGoodsArray.count>0) {
            if ([DSAppDelegate netStatus]!=AFNetworkReachabilityStatusNotReachable) {
                //结算
                DSOrderConfirmController * orderConfirmVC = [[DSOrderConfirmController alloc]init];
                orderConfirmVC.checkingOutArray = self.selectedGoodsArray;
                orderConfirmVC.totalAmount = self.checkOutTotalAmount;
                [self.navigationController pushViewController:orderConfirmVC animated:YES];
            }else{
                [MBProgressHUD showText:@"网络不可用，请检查您的网络连接" toView:nil];
            }
        }
    }

}

/** selected YES 选中  selected NO 取消选中 */
- (void)selectAllGoods:(BOOL)selected{
    if (self.dataArray.count>0) {
        [self.dataArray enumerateObjectsUsingBlock:^(DSShopCartModel * shopCartModel, NSUInteger idx, BOOL * _Nonnull stop) {
            shopCartModel.selected = selected;
        }];
    }
    [self.collectionView reloadData]; //更改选中状态时 刷新所有布局
    
    [self calculateTotalAmount];
}


//点击编辑按钮触发事件
- (void)editShoppingCart{
    self.edited = !self.edited;
}

- (void)enterGoodesDetailPageWithModel:(DSShopCartModel *)model{
    //否则 创建
    DSGoodsDetailController * detailVC = [[DSGoodsDetailController alloc]init];
    detailVC.goodsId = model.product.goods_id;
    detailVC.shopCartModel = model;
    detailVC.ShouldRefreshShopCartData = ^{
        [self reqeustDataWithRefreshFlag:DSRefreshFirstTimeLoad];
    };
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark 通知

- (void)updateInfo:(NSNotification *)notify{
    if ([notify.name isEqualToString:@"checkoutsuccessnotification"]) {
        [self deleteGoods];
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
