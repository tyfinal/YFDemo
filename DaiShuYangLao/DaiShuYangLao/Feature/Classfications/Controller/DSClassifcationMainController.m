//
//  DSClassifcationMainController.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/7/27.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSClassifcationMainController.h"
#import "DSClassficationSelectView.h"
#import "DSClassificationContentView.h"
#import "DSClassificationModel.h"
#import "DSClassificationDetailController.h"
#import "DSClassificationMainView.h"
#import "DSCommonWebViewController.h"
@interface DSClassifcationMainController ()<ClassificationSelectViewDelegate,ClassificationContentViewDelegate,ClassificationMainViewDelegate>{
    
}
@property (nonatomic, strong) UIView * searchView;
@property (nonatomic, strong) DSClassficationSelectView * selectView;
@property (nonatomic, strong) DSClassificationMainView * contentVIew;
@property (nonatomic, copy) NSArray * dataArray;
@property (nonatomic, strong) DSEmptyDataCustomView * emptyView;


@end

@implementation DSClassifcationMainController

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
    
    self.contentVIew = [[DSClassificationMainView alloc]initWithFrame:CGRectMake(self.selectView.frameRight, self.selectView.frameY, boundsWidth-self.selectView.frameRight, self.selectView.frameHeight)];
    self.contentVIew.delegate = self;
    [self.view addSubview:self.contentVIew];
    [self reqeustDataWithRefreshFlag:DSRefreshFirstTimeLoad];
    [self addTableViewRefreshHeaderAndFooter];
    
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
        self.contentVIew.hidden = NO;
        self.emptyView.hidden = YES;
    }else{
        self.selectView.hidden = YES;
        self.contentVIew.hidden = YES;
        self.emptyView.hidden = NO;
    }
}

#pragma mark 网络请求及数据处理

//添加头部刷新 与 底部刷新
- (void)addTableViewRefreshHeaderAndFooter{
    self.contentVIew.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self reqeustDataWithRefreshFlag:DSRereshHeader];
    }];
}

- (void)reqeustDataWithRefreshFlag:(DSRefreshFlag)refreshFlag {
    //    MBProgressHUD * HUD = (refreshFlag==DSRefreshFirstTimeLoad) ? [MBProgressHUD showHUDAddedTo:self.view animated:YES] : Nil;
    //    if (HUD) [self.view bringSubviewToFront:HUD];
    [DSHttpResponseData classificationsDataLoad:^(id info, BOOL succeed, id extraInfo) {
        //        if(refreshFlag==DSRefreshFirstTimeLoad) [HUD hideAnimated:YES];
        [self.contentVIew.collectionView.mj_header endRefreshing];
        if (succeed) {
            self.dataArray = info;
            self.selectView.dataArray = self.dataArray;
            self.contentVIew.dataArray = self.dataArray;
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
            self.contentVIew.dataArray = self.dataArray;
        }
    }];
}

#pragma mark ClassificationMainViewDelegate 左侧分类视图点击代理事件
- (void)ds_classificationMainView:(DSClassificationMainView *)contentView selectSection:(NSInteger)section{
    if (self.dataArray.count>section) {
       self.selectView.currentSelectRow = section; //左侧分类视图跟随滚动
    }
}

- (void)ds_classificationMainView:(DSClassificationMainView *)contentView didSelectItemaAtIndexPath:(NSIndexPath *)indexPath model:(DSClassificationModel *)model{
    DSClassificationDetailController * detailVC = [[DSClassificationDetailController alloc]init];
    detailVC.classificationId = model.classification_id;
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark ClassificationSelectViewDelegate 左侧分类视图点击代理事件

- (void)ds_classificationSelectView:(DSClassficationSelectView *)selectView didSelectRowAtIndexPath:(NSIndexPath *)indexPath withClassificationModel:(DSClassificationModel *)classificationModel{
    self.contentVIew.currentSelectSection = indexPath.row;
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
