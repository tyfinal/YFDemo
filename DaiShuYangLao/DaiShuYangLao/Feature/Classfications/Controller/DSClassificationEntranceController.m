//
//  DSClassificationEntranceController.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/7/23.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSClassificationEntranceController.h"
#import "DSClassficationSelectView.h"
#import "DSClassificationContentView.h"
#import "DSClassificationModel.h"
#import "SwipeView.h"
#import "DSClassificationDetailController.h"
#import "DSEmptyDataCustomView.h"

@interface DSClassificationEntranceController ()<ClassificationSelectViewDelegate,SwipeViewDelegate,SwipeViewDataSource,ClassificationContentViewDelegate>{
    
}

@property (nonatomic, strong) UIView * searchView;
@property (nonatomic, strong) DSClassficationSelectView * selectView;
@property (nonatomic, strong) DSClassificationContentView * contentVIew;
@property (nonatomic, strong) SwipeView * swipeView;
@property (nonatomic, copy) NSArray * dataArray;
@property (nonatomic, strong) DSEmptyDataCustomView * emptyView;
@property (nonatomic, assign) BOOL isFirstLoad;

@end

@implementation DSClassificationEntranceController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"商品分类";
    

    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.dataArray = [NSArray array];
    [self.view addSubview:self.searchView];
    self.searchView.frame = CGRectMake(0, 0, boundsWidth, 38.5);
    self.selectView = [[DSClassficationSelectView alloc]initWithFrame:CGRectMake(0,self.searchView.frameBottom, ceil(90*ScreenAdaptFator_W), boundsHeight-KTabbarHeight-self.searchView.frameHeight-kNavigationBarHeight)];
    self.selectView.itemHeight = ceil(54*ScreenAdaptFator_W);
    self.selectView.delegate = self;
    [self.view addSubview:self.selectView];
    
    self.swipeView = [[SwipeView alloc]initWithFrame:CGRectMake(self.selectView.frameRight, self.searchView.frameBottom, boundsWidth-self.selectView.frameRight, boundsHeight-KTabbarHeight-self.searchView.frameHeight-kNavigationBarHeight)];
    self.swipeView.delegate = self;
    self.swipeView.vertical = YES;
    self.swipeView.dataSource = self;
    self.swipeView.scrollEnabled = NO;
    self.swipeView.truncateFinalPage = YES;
    self.swipeView.alignment = SwipeViewAlignmentCenter;
    self.swipeView.bounces = NO;
    self.swipeView.wrapEnabled = NO;
    self.swipeView.pagingEnabled = YES;
    [self.view addSubview:self.swipeView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.isFirstLoad==NO) {
        self.isFirstLoad = YES;
        [self reqeustDataWithRefreshFlag:DSRefreshFirstTimeLoad];
    }else{
        [self reqeustDataWithRefreshFlag:DSRereshHeader];
    }
    
    
    
}

#pragma mark UI视图

- (UIView *)searchView{
    if (!_searchView) {
        UIView * searchView = [[UIView alloc]initWithFrame:CGRectZero];
        UITextField * searchTF = [[UITextField alloc]initWithFrame:CGRectZero];
        searchTF.enabled = NO;
        searchTF.userInteractionEnabled = YES;
        searchTF.text = @"输入您需要查询的商品";
        searchTF.textColor = JXColorFromRGB(0xa39b99);
        searchTF.font = JXFont(15);
        searchTF.leftViewMode = UITextFieldViewModeAlways;
        searchTF.backgroundColor = JXColorFromRGB(0xeeeeee);
        [searchView addSubview:searchTF];
        
        UIImageView * iconLeftView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 31, 31)];
        //        iconLeftView.image = [UIColor colorfulImage];
        searchTF.leftView = iconLeftView;
        
        [searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(searchView).with.offset(15);
            make.right.equalTo(searchView.mas_right).with.offset(-15);
            make.height.mas_equalTo(31);
            make.top.equalTo(searchView.mas_top);
//            make.centerY.equalTo(searchView.mas_centerY);
        }];
        
        [searchView layoutIfNeeded];
        searchTF.layer.cornerRadius = searchTF.frameHeight/2.0;
        searchTF.layer.masksToBounds = YES;
        
        UIView * seperator = [[UIView alloc]initWithFrame:CGRectZero];
        seperator.backgroundColor = JXColorFromRGB(0xe0e0e0);
        [searchView addSubview:seperator];
        
        [seperator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(searchView);
            make.height.mas_equalTo(0.5);
            make.bottom.equalTo(searchView.mas_bottom);
        }];
        
        __weak __typeof(self)weakSelf = self;
        [searchView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            //            DSSearchHistoryController * searchVC = [[DSSearchHistoryController alloc]init];
            //            searchVC.hidesBottomBarWhenPushed = YES;
            //            [weakSelf.navigationController pushViewController:searchVC animated:YES];
            DSClassificationDetailController * detailVC = [[DSClassificationDetailController alloc]init];
            detailVC.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:detailVC animated:YES];
        }]];
        _searchView = searchView;
    }
    return _searchView;
}

- (DSEmptyDataCustomView *)emptyView{
    if (!_emptyView) {
        DSEmptyDataCustomView * emptyView = [[DSEmptyDataCustomView alloc]initWithFrame:CGRectZero];
        [self.view addSubview:emptyView];
        [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(boundsWidth);
            make.height.equalTo(emptyView.contentView.mas_height);
            make.centerY.equalTo(self.view);
            make.centerX.equalTo(self.view);
        }];
        
        __weak typeof (self)weakSelf = self;
        emptyView.EmptyDataButtonClickHandle = ^(UIButton *button, id view) {
            [weakSelf reqeustDataWithRefreshFlag:DSRefreshFirstTimeLoad];
        };
        _emptyView = emptyView;
    }
    return _emptyView;
}

- (void)controlViewVisible:(BOOL)show{
    if (show) {
        self.selectView.hidden = NO;
        self.swipeView.hidden = NO;
        self.emptyView.hidden = YES;
    }else{
        self.selectView.hidden = YES;
        self.swipeView.hidden = YES;
        self.emptyView.hidden = NO;
    }
}

#pragma mark 网络请求及数据处理

- (void)reqeustDataWithRefreshFlag:(DSRefreshFlag)refreshFlag {
//    MBProgressHUD * HUD = (refreshFlag==DSRefreshFirstTimeLoad) ? [MBProgressHUD showHUDAddedTo:self.view animated:YES] : Nil;
//    if (HUD) [self.view bringSubviewToFront:HUD];
    [DSHttpResponseData classificationsDataLoad:^(id info, BOOL succeed, id extraInfo) {
//        if(refreshFlag==DSRefreshFirstTimeLoad) [HUD hideAnimated:YES];
        if (succeed) {
            self.dataArray = info;
            self.selectView.dataArray = self.dataArray;
            [self.swipeView reloadData];
            [self controlViewVisible:YES];
//            self.contentVIew.dataArray = self.dataArray;
        }else{
            if (self.dataArray.count==0) {
                [self controlViewVisible:NO];
            }
        }
    }cacheBlock:^(id info, BOOL succeed, id extraInfo) {
        if (info) {
            [self controlViewVisible:YES];
            self.dataArray = info;
            self.selectView.dataArray = self.dataArray;
            [self.swipeView reloadData];
//            self.contentVIew.dataArray = self.dataArray;
        }
    }];
}

#pragma mark SwipeViewDelegate,SwipeViewDataSource

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView{
    return self.dataArray.count>0 ? _dataArray.count:0;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    if (!view) {
//        view = [[UIView alloc]initWithFrame:swipeView.bounds];
//        view.backgroundColor = [UIColor getBackgroundColor];
        
        view = [[DSClassificationContentView alloc]initWithFrame:swipeView.bounds];
    }
    if ([view isKindOfClass:[DSClassificationContentView class]]) {
        DSClassificationContentView * contentView = (DSClassificationContentView *)view;
        contentView.delegate = self;
        DSClassificationModel * classificationModel = self.dataArray[index];
        contentView.dataArray = classificationModel.subClassifications;;
    }
    
    return view;
}

//- (CGSize)swipeViewItemSize:(SwipeView *)swipeView{
//    return CGSizeMake(swipeView.frameWidth, swipeView.frameHeight);
//}

- (void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeView{
    
}

#pragma mark ClassificationSelectViewDelegate 左侧分类视图点击代理事件

- (void)ds_classificationSelectView:(DSClassficationSelectView *)selectView didSelectRowAtIndexPath:(NSIndexPath *)indexPath withClassificationModel:(DSClassificationModel *)classificationModel{
//    self.contentVIew.currentSelectSection = indexPath.row;
    [self.swipeView scrollToPage:indexPath.row duration:0.0];
}


#pragma mark ClassificationContentViewDelegate 右侧内容视图代理事件

//MARK: 滑动翻页
- (void)ds_classificationContentView:(DSClassificationContentView *)contentView loadPage:(NSInteger)page{
    if (self.selectView.currentSelectRow==0&&page==-1) {
        //没有上一页
        return;
    }else if (self.selectView.currentSelectRow==self.dataArray.count-1&&page==1){
        //没有下一页
        return;
    }
    
    self.selectView.currentSelectRow += page; //左侧分类视图跟随滚动
    [self.swipeView scrollToPage:self.selectView.currentSelectRow duration:0.4]; //滑动翻页
}

- (void)ds_classificationContentView:(DSClassificationContentView *)contentView didSelectItemaAtIndexPath:(NSIndexPath *)indexPath model:(DSClassificationModel *)model{
    DSClassificationDetailController * detailVC = [[DSClassificationDetailController alloc]init];
    detailVC.classificationId = model.classification_id;
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
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
