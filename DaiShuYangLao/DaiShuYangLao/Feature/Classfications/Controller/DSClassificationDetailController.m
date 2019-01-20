//
//  DSClassificationDetailController.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/2.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSClassificationDetailController.h"
#import "DSClassficationDetailCell.h"
#import "DSGoodsDetailController.h"
//#import "DSGoodsDetailController."
#import "DSClassificationDetailHeaderView.h"
#import "DSParametersSignature.h"
#import "DSShopCartEntraceController.h"

#import "DSGoodsInfoModel.h"
#import "DSHomeEntranceCell.h"
#import "DSClassificationItem.h"
@interface DSClassificationDetailController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIGestureRecognizerDelegate>{
    
}

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) UIView * searchView;
@property (nonatomic, strong) DSClassificationDetailHeaderView * tableHeaderView;
@property (nonatomic, assign) NSInteger pageNumber;
@property (nonatomic, copy) NSArray * dataArray;
@property (nonatomic, assign) NSInteger sort; /**< 排序 0 销量 1 价格 2 综合 */
@property (nonatomic, copy) NSString * priceOrder; /**< 价格排序方式 asc 默认 升序 asc 降序 desc */
@property (nonatomic, assign) BOOL waterfallMode; /**< 是否以瀑布流方式呈现 */
@property (nonatomic, strong) UIBarButtonItem * shopcartItem;
@property (nonatomic, strong) UIBarButtonItem * changeListModeItem;

@end


static const NSInteger kPageSize = 10;
@implementation DSClassificationDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self commonInit];
    
    if (self.ds_universal_params) {
        if ([self.ds_universal_params[@"previouspagetype"] isEqualToString:@"advertpage"]) {
            self.rt_disableInteractivePop = YES;
            self.backButtonHandle = ^{
                [DSAppDelegate goToHomePage];
            };
        }
    }
    
    self.navigationController.navigationBar.shadowImage = nil;

    UIBarButtonItem * shopcartItem = [[UIBarButtonItem alloc]initWithImage:ImageString(@"public_navigation_shoppingcart_black") style:UIBarButtonItemStylePlain target:self action:@selector(enterShoppingcart)];
    shopcartItem.width = 22;
    _changeListModeItem = [[UIBarButtonItem alloc]initWithImage:ImageString(@"public_collection_mode") style:UIBarButtonItemStylePlain target:self action:@selector(changeCellShowMode)];
    _changeListModeItem.width = 22;
    self.navigationItem.rightBarButtonItems = @[_changeListModeItem,shopcartItem];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:ImageString(@"public_navigation_shoppingcart_black") style:UIBarButtonItemStylePlain target:self action:@selector(enterShoppingcart)];
//    self.searchView.frame = CGRectMake(0, 0, boundsWidth-80, 31);
    self.navigationItem.titleView = self.searchView;
    NSLog(@"%@",[DSParametersSignature universalParameters]);
    [self.view addSubview:self.tableView];
    [self addTableViewHeaderAndFooterRefresher];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        if (@available(iOS 11.0,*)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            make.top.equalTo(self.view.mas_top);
            make.bottom.equalTo(self.view.mas_bottom);
        }
    }];
    
}

#pragma mark 初始化

- (void)commonInit{
    self.dataArray = @[];
    _sort = 2;
    _priceOrder = @"asc";
    _waterfallMode = YES;
}


#pragma mark UI

- (UIView *)searchView{
    if (!_searchView) {
        UIView * searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth-160, 31)];
        UITextField * searchTF = [[UITextField alloc]initWithFrame:CGRectZero];
        searchTF.userInteractionEnabled = YES;
        UIView * leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 30)];
        leftView.backgroundColor = [UIColor clearColor];
        searchTF.leftView = leftView;
        searchTF.placeholder = @"搜索 袋鼠乐购 商品";
//        searchTF.text = @"sou'suo";
        searchTF.textColor = JXColorFromRGB(0xa39b99);
        searchTF.font = JXFont(15);
        searchTF.delegate = self;
        searchTF.returnKeyType = UIReturnKeySearch;
        searchTF.leftViewMode = UITextFieldViewModeAlways;
        searchTF.backgroundColor = JXColorFromRGB(0xeeeeee);
        [searchView addSubview:searchTF];
        
        searchTF.frame = CGRectMake(0, 0, searchView.frameWidth, searchView.frameHeight);
        searchTF.layer.cornerRadius = searchTF.frameHeight/2.0;
        
        searchTF.layer.masksToBounds = YES;
        _searchView = searchView;
    }
    return _searchView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, boundsHeight) style:UITableViewStylePlain];
        tableView.backgroundColor = JXColorFromRGB(0xffffff);
        tableView.showsVerticalScrollIndicator = NO;
        tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        tableView.delegate = self;
        tableView.dataSource = self;
//        [tableView setTableHeaderView:self.tableHeaderView];
        [tableView setTableFooterView:[UIView new]];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView = tableView;
    }
    return _tableView;
}

- (DSClassificationDetailHeaderView *)tableHeaderView{
    if (!_tableHeaderView) {
        _tableHeaderView = [[DSClassificationDetailHeaderView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, 45)];
        __weak typeof (self)weakSelf = self;
        _tableHeaderView.filterHandle = ^(NSString *filterString) {
            NSLog(@"%@",filterString);
            [weakSelf.view endEditing:YES];
            if ([filterString isEqualToString:@"comprehensive"]) {
                //综合
                weakSelf.sort = 2;
                weakSelf.priceOrder = @"asc";
            }else if ([filterString isEqualToString:@"sales"]){
                //销量
                weakSelf.sort = 0;
                weakSelf.priceOrder = @"desc";
            }else{
                weakSelf.sort = 1;
                if ([filterString isEqualToString:@"descend"]) {
                    weakSelf.priceOrder = @"desc";
                }else{
                    weakSelf.priceOrder = @"asc";
                }
            }
            weakSelf.pageNumber = 1;
            [weakSelf reqeustDataWithRefreshFlag:DSRefreshFirstTimeLoad];
        };
    }
    return _tableHeaderView;
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
    if ([self.searchWord isNotBlank]==NO&&[self.classificationId isNotBlank]==NO) {
         [self.tableView.mj_header endRefreshing];
        return;
    }
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    if (_sort!=2) {
        params[@"sort"] = @(_sort);
    }
    if ([_searchWord isNotBlank]) {
        NSString * searchWord = [_searchWord stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        params[@"keyword"] = searchWord;
    }
    params[@"order"] = _priceOrder;
    params[@"page"] = @(_pageNumber);
    params[@"max"] = @(kPageSize);
    
    MBProgressHUD * HUD = nil;
    if (refreshFlag == DSRefreshFirstTimeLoad) {
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        HUD.minShowTime = 1.5;
    }
    
    completeBlock block = ^(id info ,BOOL succeed,id extraInfo){
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if(refreshFlag== DSRefreshFirstTimeLoad) [HUD hideAnimated:YES];
        if (succeed) {
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
            self.tableView.mj_footer.hidden = YES;
        }
    };
    
    if ([_classificationId isNotBlank]) {
        if ([self.specialClassfication isEqualToString:@"1"]) {
            params[@"specialclass"] = self.specialClassfication;
            params[@"sectionId"] = _classificationId;  // 获取栏目下的所有分类
        }else if ([self.specialClassfication isEqualToString:@"2"]){
            params[@"specialclass"] = self.specialClassfication;
            params[@"bannerId"] = _classificationId;  // 获取栏目下的所有分类
        }else{
            params[@"categoryId"] = _classificationId; // 根据分类 id 获取子分类
        }

        [DSHttpResponseData classificationGetGoodsListWithParams:params callback:block];
    }else{
        //调用搜索接口
        [DSHttpResponseData classificationSearchGoodsListWithParams:params callback:block];
    }
}


#pragma mark UITableViewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataArray.count>0) {
        if (_waterfallMode) {
            //瀑布流呈现方式
            NSInteger rowCount = ceil(_dataArray.count/2.0);
            return rowCount;
        }
        return _dataArray.count; //列表呈现方式
    }
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.tableHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_waterfallMode) {
        CGFloat rowHeight = [HomeGoodsCell getItemHeightWithItemWidth:floor((boundsWidth-5)/2.0)];
        return rowHeight+5;
    }
    return 143.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_waterfallMode) {
        static NSString * identifer = @"waterfall";
        DSClassificationItem * cell = [tableView dequeueReusableCellWithIdentifier:identifer];
        if (!cell) {
            cell = [[DSClassificationItem alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.rightCell.hidden = YES;
        if (self.dataArray.count>2*indexPath.row) {
            DSGoodsInfoModel * goodsModel = _dataArray[2*indexPath.row];
            cell.leftCell.model = goodsModel;
            if (self.dataArray.count>2*indexPath.row+1){
                cell.rightCell.hidden = NO;
                DSGoodsInfoModel * goodsModel = _dataArray[2*indexPath.row+1];
                cell.rightCell.model = goodsModel;
            }
        }
        
        __weak typeof (self)weakSelf = self;
        cell.DidSelectedItemAtIndexPath = ^(NSInteger itemIndex, DSGoodsInfoModel *model) {
            DSGoodsDetailController * goodsDetailVC = [[DSGoodsDetailController alloc]init];
            goodsDetailVC.goodsId = model.goods_id;
            [weakSelf.navigationController pushViewController:goodsDetailVC animated:YES];
        };
        
        return cell;
    }else{
        static NSString * identifer = @"identifer";
        DSClassficationDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer];
        if (!cell) {
            cell = [[DSClassficationDetailCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.dataArray.count>0) {
            DSGoodsInfoModel * model = self.dataArray[indexPath.row];
            cell.model = model;
        }
        __weak typeof (self)weakSelf = self;
        cell.SaveGoodsToShoppingCartHandle = ^(NSIndexPath *indexPath, DSGoodsInfoModel *model) {
            [weakSelf saveGoodsToShoppingcartWithModel:model];
        };
        //    if (_dataArray.count>0) {
        //        [cell configureCellWithModel:_dataArray[indexPath.row]];
        //    }
        return cell;
    }

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_waterfallMode==NO) {
        DSGoodsInfoModel * model = self.dataArray[indexPath.row];
        DSGoodsDetailController * goodsDetailVC = [[DSGoodsDetailController alloc]init];
        goodsDetailVC.goodsId = model.goods_id;
        [self.navigationController pushViewController:goodsDetailVC animated:YES];
    }
    
}


- (void)saveGoodsToShoppingcartWithModel:(DSGoodsInfoModel *)goodsModel{
//    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    HUD.userInteractionEnabled = NO;
//    [DSHttpResponseData shopCartAddGoods:goodsModel.goods_id number:1 callback:^(id info, BOOL succeed, id extraInfo) {
//        [HUD hideAnimated:YES];
//        if (succeed) {
//            [MBProgressHUD showText:@"成功加入购物车" toView:self.view];
//        }
//    }];
}

- (void)enterShoppingcart{
    if ([DSAppDelegate shouldShowLoginAlertViewInController:self]) {
        return;
    }
    //验证token
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [DSHttpResponseData PublicCheckValidityOfToken:^(id info, BOOL succeed, id extraInfo) {
        [HUD hideAnimated:YES];
        if (succeed) {
            DSShopCartEntraceController * shopCartVC = [[DSShopCartEntraceController alloc]init];
            shopCartVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:shopCartVC animated:YES];
        }
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    textField.text = [textField.text stringByTrim];
    if ([textField.text isNotBlank]) {
        self.searchWord = textField.text;
        self.pageNumber = 1;
        [self reqeustDataWithRefreshFlag:DSRefreshFirstTimeLoad];
    }
    return YES;
}

//改变视图呈现方式
- (void)changeCellShowMode{
    self.waterfallMode = !self.waterfallMode;
    if (self.waterfallMode) {
        _changeListModeItem.image = ImageString(@"public_collection_mode");
    }else{
        _changeListModeItem.image = ImageString(@"public_list_mode");
    }
}

#pragma mark Setter & Getter

- (void)setWaterfallMode:(BOOL)waterfallMode{
    _waterfallMode = waterfallMode;
    if (_waterfallMode) {
        self.tableView.backgroundColor = JXColorFromRGB(0xf2f2f2);
    }else{
        self.tableView.backgroundColor = [UIColor whiteColor];
    }
    [self.tableView reloadData];
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
