//
//  DSClassificationsEntranceController.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/5/23.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSClassificationsEntranceController.h"
#import "DSClassificationCollectionCell.h"
#import "DSClassificationDetailController.h"
#import "DSSearchHistoryController.h"
#import "DSClassificationModel.h"
#import "UIBarButtonItem+YYAdd.h"
#import "DSCommonWebViewController.h"

@interface DSClassificationsEntranceController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    
}

@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout * layout;
@property (nonatomic, strong) UIView * searchView;
@property (nonatomic, copy) NSArray * dataArray;

@end


static NSString * classificationCellIdentifer = @"classficationcell";
@implementation DSClassificationsEntranceController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"商品分类";
    self.dataArray = @[];

    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self addTableHeaderRefresher];
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        self.layout = [[UICollectionViewFlowLayout alloc]init];
        self.layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        self.layout.minimumLineSpacing = 0;
        self.layout.minimumInteritemSpacing = 0;
        CGFloat itemW = (boundsWidth-(_layout.sectionInset.left+_layout.sectionInset.right+_layout.minimumInteritemSpacing*3))/4.0f;
        
        CGFloat itemH = 115 ;
        itemW = floor(itemW);
        self.layout.itemSize = CGSizeMake(itemW, itemH);
        self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.contentInset = UIEdgeInsetsMake(40, 0, 0, 0);
        [_collectionView addSubview:self.searchView];
        self.searchView.frame = CGRectMake(0, -40, boundsWidth, 40);

//        _collectionView.showsVerticalScrollIndicator = NO;
//        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[DSClassificationCollectionCell class] forCellWithReuseIdentifier:classificationCellIdentifer];
    }
    return _collectionView;
}

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
            make.centerY.equalTo(searchView.mas_centerY);
        }];
        [searchView layoutIfNeeded];
        searchTF.layer.cornerRadius = searchTF.frameHeight/2.0;
        
        searchTF.layer.masksToBounds = YES;
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

#pragma mark 网络请求

- (void)addTableHeaderRefresher{
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self reqeustDataWithRefreshFlag:DSRereshHeader];
    }];
    self.collectionView.mj_header.ignoredScrollViewContentInsetTop = 40;
    [self.collectionView.mj_header beginRefreshing];
}

- (void)reqeustDataWithRefreshFlag:(DSRefreshFlag)refreshFlag {
    [DSHttpResponseData classificationsDataLoad:^(id info, BOOL succeed, id extraInfo) {
        [self.collectionView.mj_header endRefreshing];
        if (succeed) {
            self.dataArray = info;
            [self.collectionView reloadData];
        }
    }cacheBlock:^(id info, BOOL succeed, id extraInfo) {
        if (info) {
            self.dataArray = info;
            [self.collectionView reloadData];
        }
    }];
}

#pragma mark UIColletionViewDelegate && UICollectionViewDataSource && UICollectionIVewFlowLayoutDelegate


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count>0?self.dataArray.count:0;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DSClassificationCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:classificationCellIdentifer forIndexPath:indexPath];
    if (self.dataArray.count>0) {
        DSClassificationModel * model = self.dataArray[indexPath.item];
        cell.model = model;
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DSClassificationDetailController * detailVC = [[DSClassificationDetailController alloc]init];
    DSClassificationModel * model = self.dataArray[indexPath.item];
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
