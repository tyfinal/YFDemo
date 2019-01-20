//
//  DSMyCollectionController.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/5.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSMyCollectionController.h"
#import "DSMyCollectionCell.h"
#import "DSSafeAreaAdaptBottomView.h"
#import "DSShopCartEntraceController.h"
#import <UIScrollView+EmptyDataSet.h>
#import "DSGoodsDetailController.h"

@interface DSMyCollectionController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>{
    
}

@property (nonatomic, assign) NSInteger pageNumber;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, assign) BOOL edited;
@property (nonatomic, strong) UIButton * operationButton;
@property (nonatomic, copy) NSArray * dataArray;
@property (nonatomic, strong) NSMutableArray * selectedGoodsArray; //选中的商品
@property (nonatomic, strong) UIBarButtonItem * rightItem;
@property (nonatomic, assign) DSLoadDataStatus loadingStatus;

@end

static NSInteger const kPageSize = 10;
@implementation DSMyCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.title = @"我的收藏";
    self.dataArray = [NSArray array];
    self.selectedGoodsArray = [NSMutableArray array];
    
    
    self.navigationController.navigationBar.shadowImage = nil;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"购物车" style:UIBarButtonItemStylePlain target:self action:@selector(enterShoppingcart)];
    self.rightItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editEvent)];
    self.navigationItem.rightBarButtonItem = self.rightItem;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.operationButton];
    
    [self.operationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(50);
        if (@available(iOS 11.0,*)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            make.bottom.equalTo(self.view.mas_bottom);
        }
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.operationButton.mas_top);
    }];
    
    self.edited = NO;
    
    [self adjustVisibleViewByDataArray:self.dataArray];
    [self addTableViewHeaderAndFooterRefresher];
}

- (void)setEdited:(BOOL)edited{
    _edited = edited;
    if (_edited) {
        //开始编辑时
        self.operationButton.backgroundColor = APP_MAIN_COLOR;
        [self.operationButton setTitle:@"删除" forState:UIControlStateNormal];
        self.rightItem.title = @"完成";
    }else{
        self.operationButton.backgroundColor = JXColorFromRGB(0xfb8022);
        [self.operationButton setTitle:@"去购物车" forState:UIControlStateNormal];
        self.rightItem.title = @"编辑";
    }
}

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, boundsHeight) style:UITableViewStylePlain];
        tableView.backgroundColor = JXColorFromRGB(0xffffff);
        tableView.showsVerticalScrollIndicator = NO;
        tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.emptyDataSetSource = self;
        tableView.emptyDataSetDelegate = self;
        tableView.rowHeight = 143;
        [tableView setTableFooterView:[UIView new]];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView = tableView;
    }
    return _tableView;
}

- (UIButton *)operationButton{
    if (!_operationButton) {
        _operationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_operationButton setTitle:@"去购物车" forState:UIControlStateNormal];
        [_operationButton addTarget:self action:@selector(operationEvent:) forControlEvents:UIControlEventTouchUpInside];
        _operationButton.titleLabel.font = JXFont(20);
        [_operationButton setTitleColor:JXColorFromRGB(0xffffff) forState:UIControlStateNormal];
    }
    return _operationButton;
}

#pragma mark 网络请求及数据处理

- (void)addTableViewHeaderAndFooterRefresher{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _pageNumber = 1;
        [self reqeustDataWithRefreshFlag:DSRereshHeader];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _pageNumber ++;
        [self reqeustDataWithRefreshFlag:DSRereshFooter];
    }];
    self.tableView.mj_footer.hidden = YES;
}

- (void)reqeustDataWithRefreshFlag:(DSRefreshFlag)refreshFlag{
    
    MBProgressHUD * HUD = nil;
    if (refreshFlag == DSRefreshFirstTimeLoad) {
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //        HUD.minShowTime = 1.5;
    }
    self.loadingStatus = DSBeginLoadingData;
    [DSHttpResponseData collectionGetAllCollectionsWithPagenum:_pageNumber pageSize:kPageSize callback:^(id info, BOOL succeed, id extraInfo) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if(refreshFlag== DSRefreshFirstTimeLoad) [HUD hideAnimated:YES];
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
            [self adjustVisibleViewByDataArray:self.dataArray];
            [self.tableView reloadData];
        }else{
            self.loadingStatus = DSLoadDataFailed;
            self.tableView.mj_footer.hidden = YES;
            [self adjustVisibleViewByDataArray:self.dataArray];
            [self.tableView reloadData];
        }
    }];
}

- (void)deleteCollections{
    NSMutableString * ids = nil;
    NSString * goodeIds = nil;
    if (self.selectedGoodsArray.count>0) {
        ids = [NSMutableString string];
        for (DSGoodsDetailInfoModel * model in self.selectedGoodsArray) {
            [ids appendFormat:@"%@,",model.goods_id];
            
        }
        
        if ([ids isNotBlank]) {
            goodeIds = [ids substringToIndex:ids.length-1]; //去除最后一个id的逗号
        }
    }
    if ([goodeIds isNotBlank]) {
        MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [DSHttpResponseData collectionDeleteGoodsByGoodsid:goodeIds callback:^(id info, BOOL succeed, id extraInfo) {
            [HUD hideAnimated:YES];
            if (succeed) {
                NSMutableArray * dataArrayMu = [NSMutableArray arrayWithArray:self.dataArray];
                [dataArrayMu removeObjectsInArray:self.selectedGoodsArray];
                self.dataArray = dataArrayMu;
                [self.selectedGoodsArray removeAllObjects];
                [self adjustVisibleViewByDataArray:self.dataArray];
                [self.tableView reloadData];
            }
        }];
    }
}

/** 根据是否存在数据来控制视图显示 */
- (void)adjustVisibleViewByDataArray:(NSArray *)dataArray{
    if (dataArray.count>0) {
        //有数据时
        self.operationButton.hidden = NO;
        self.navigationItem.rightBarButtonItem = self.rightItem;
//        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self.operationButton.mas_top);
//        }];
    }else{
        //无数据时
        self.operationButton.hidden = YES;
        self.navigationItem.rightBarButtonItem = nil;
//        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self.view.mas_bottom);
//        }];
    }
}

#pragma mark UITableViewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count>0?_dataArray.count:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifer = @"identifer";
    DSMyCollectionCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[DSMyCollectionCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.edited = _edited;
    cell.indexPath = indexPath;
    if (_dataArray.count>0) {
        cell.model = self.dataArray[indexPath.row];
        __weak typeof (self)weakSelf = self;
        cell.DidSelectCellAtIndexPath = ^(NSIndexPath *aindexPath, DSGoodsDetailInfoModel *amodel) {
            [weakSelf didSelectCollectionCellAtIndexPath:aindexPath model:amodel];
        };
        
        cell.AddGoodsToShopCart = ^(NSIndexPath * aIndexPath, DSGoodsDetailInfoModel *model) {
            [weakSelf addToShopCartWithModel:model indexPath:aIndexPath];
        };
    }
    

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DSGoodsDetailController * detailVC = [[DSGoodsDetailController alloc]init];
    DSGoodsDetailInfoModel * model = self.dataArray[indexPath.row];
    detailVC.goodsId = model.goods_id;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark DZNEmptyDataSetSource,DZNEmptyDataSetDelegate

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView{
    if (self.loadingStatus==DSLoadDataSuccessed) {
        DSEmptyDataCustomView * emptyView = [[DSEmptyDataCustomView alloc]initWithFrame:CGRectZero];
        UIImage * emptyImage = ImageString(@"mine_collection_emptydata");
        emptyView.emptyImageView.image = emptyImage;
        [emptyView.emptyImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(emptyView.emptyImageView.mas_width).multipliedBy(emptyImage.size.height/emptyImage.size.width);
        }];
        [emptyView.button setTitle:@"快去逛逛吧" forState:UIControlStateNormal];
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


- (void)editEvent{
    self.edited = !self.edited;
    //开始编辑时 移除所有选中的model
    if (self.dataArray.count>0) {
        for (DSGoodsDetailInfoModel * model in self.dataArray) {
            model.selected = NO;
        }
    }
    [self.selectedGoodsArray removeAllObjects];
    [self.tableView reloadData];
}

- (void)didSelectCollectionCellAtIndexPath:(NSIndexPath *)indexPath model:(DSGoodsDetailInfoModel *)model{
    if (model.selected) {
        [self.selectedGoodsArray addObject:model]; //将选中的model添加进数组
    }else{
        if ([self.selectedGoodsArray containsObject:model]) {
            [self.selectedGoodsArray removeObject:model]; //将取消选中的model移出数组
        }
    }
}

- (void)addToShopCartWithModel:(DSGoodsDetailInfoModel *)model indexPath:(NSIndexPath *)indexPath{
    if (model.skus.count>0) {
        if ([self shouldGuidaUserToUpgradeMembershipWithGoodsModel:model]) {
            return; //普通会员 无法购买 会员专属商品 引导用户升级会员
        }
        GoodsDetailSaleInfo * skuModel = model.skus[0];
        MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [DSHttpResponseData shopCartAddGoods:model.goods_id skuId:skuModel.sku_id number:1 callback:^(id info, BOOL succeed, id extraInfo) {
            [HUD hideAnimated:YES];
            if (succeed) {
                [MBProgressHUD showText:@"成功加入购物车" toView:self.view];
            }
        }];
    }
}

- (void)enterShoppingcart{

}

- (void)goToHomePage{
    [DSAppDelegate goToHomePage];
}


- (void)operationEvent:(UIButton *)button{
    if (_edited) {
        //删除收藏
        [self deleteCollections];
    }else{
        DSShopCartEntraceController * shopCartVC = [[DSShopCartEntraceController alloc]init];
        [self.navigationController pushViewController:shopCartVC animated:YES];
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
