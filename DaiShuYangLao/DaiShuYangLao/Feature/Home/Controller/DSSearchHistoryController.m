//
//  JXSearchHistoryController.m
//  JXZX
//
//  Created by apple on 2017/9/13.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "DSSearchHistoryController.h"
#import "JXSearchHistoryCell.h"
#import "JXSearchHistorySectionHeaderView.h"

#import "DSSearchTitleView.h"
#import "YJAlertView.h"
#import "JXSearchHotWordModel.h"
#import "MBProgressHUD+JXAdd.h"
#import "DSClassificationDetailController.h"

@interface DSSearchHistoryController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate>{
    
}

@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout * layout;
@property (nonatomic, copy) NSString * searchKeyword;
@property (nonatomic, strong) NSArray * historyArray;
@property (nonatomic, strong) NSArray * hotWordsArray;

@property (nonatomic, strong) DSSearchTitleView * searchView;

@end


static NSString * const cellIdentifer = @"hisCell";

static NSString * const sectionIdentifer = @"header";

static NSString * const footerIdentifer = @"footer";

static CGFloat historyItemWidth = 0;

static CGFloat hotwordItemWidth = 0;

@implementation DSSearchHistoryController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.collectionView];
    _searchKeyword = nil;
    [self requestHotWords];
    self.hidenBackBarItem = YES;
    self.navigationItem.titleView = self.searchView;
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(ios 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        }else{
            make.top.equalTo(self.view.mas_top);
        }
        make.left.right.and.bottom.equalTo(self.view);
    }];
}


- (NSArray *)historyArray{
    if (!_historyArray) {
        NSMutableArray * mu = @[].mutableCopy;
        for (NSInteger i=0; i<6; i++) {
            [mu addObject:@"百威300ml"];
        }
        _historyArray = mu;
    }
    return _historyArray;
}

- (NSArray *)hotWordsArray{
    if (! _hotWordsArray) {
        NSMutableArray * mu = @[].mutableCopy;
        for (NSInteger i=0; i<8; i++) {
             JXSearchHotWordModel * model = [[JXSearchHotWordModel alloc]init];
            model.fullname = @"热词";
            [mu addObject:model];
        }
        _hotWordsArray = mu;
    }
    return _hotWordsArray;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        self.layout = [[UICollectionViewFlowLayout alloc]init];
        self.layout.sectionInset = UIEdgeInsetsMake(10, 15, 28, 15);
        self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView registerClass:[JXSearchHistoryCell class] forCellWithReuseIdentifier:cellIdentifer];
        [_collectionView registerClass:[JXSearchHistorySectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionIdentifer];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerIdentifer];
    }
    return _collectionView;
}

- (DSSearchTitleView *)searchView{
    if (!_searchView) {
        _searchView = [[DSSearchTitleView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth-30, 44)];
        _searchView.searchTF.delegate = self;
        _searchView.searchTF.placeholder = @"输入您要查询的商品";

        //        [_searchView.searchTF addTarget:self action:@selector(searchTextChange:) forControlEvents:UIControlEventEditingChanged];
        [_searchView.backButton addTarget:self action:@selector(backToPreviousPage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchView;
}



- (void)setSearchKeyword:(NSString *)searchKeyword{
    _searchKeyword = searchKeyword;
    _searchView.searchTF.text = searchKeyword;
}

#pragma mark 网络请求及数据处理

- (void)requestHotWords{
//    MBProgressHUD * HUD = [MBProgressHUD showMessage:@"" toView:self.view];
//    [JXHttpData CandidateAndCompetitorHotWordsWithType:self.pageType callback:^(id info, BOOL succeed) {
//        [HUD hideAnimated:YES];
//        if (succeed) {
//            _hotWordsArray = info;
//            [self.collectionView reloadData];
//        }
//    }];
}

#pragma mark UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section==0) {
        return self.historyArray.count>0?_historyArray.count:0;
    }else{
        return self.hotWordsArray.count?_hotWordsArray.count:0;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return CGSizeMake(boundsWidth, 42);
    }else if (_hotWordsArray.count>0&&section==1){
        return CGSizeMake(boundsWidth, 42);
    }else{
        return CGSizeZero;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (section==0&&_historyArray.count>0&&_hotWordsArray.count>0) {
        //两个区同时存在内容时才需要中间的间隔
        return CGSizeMake(boundsWidth, 8);
    }else{
        return CGSizeZero;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if (section) {
        return 14;
    }else{
        return 12;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (section) {
        return 11;
    }else{
        return 10;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if (historyItemWidth==0) {
            UICollectionViewFlowLayout * flowLayout = (UICollectionViewFlowLayout *)collectionViewLayout;
            CGFloat totalItemsWidth = boundsWidth-(11*2+flowLayout.sectionInset.left+flowLayout.sectionInset.right);
            CGFloat itemWidth = floor(totalItemsWidth/3.0f);
            historyItemWidth = itemWidth;
        }
        return CGSizeMake(historyItemWidth, 33);
    }else{
        if (hotwordItemWidth==0) {
            UICollectionViewFlowLayout * flowLayout = (UICollectionViewFlowLayout *)collectionViewLayout;
            CGFloat totalItemsWidth = boundsWidth-(10*3+flowLayout.sectionInset.left+flowLayout.sectionInset.right);
            CGFloat itemWidth = floor(totalItemsWidth/4.0f);
            hotwordItemWidth = itemWidth;
        }
        return CGSizeMake(hotwordItemWidth, 33);
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        JXSearchHistorySectionHeaderView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:sectionIdentifer forIndexPath:indexPath];
        headerView.textLabel.text = @[@"搜索历史",@"热门搜索"][indexPath.section];
        headerView.clearButton.hidden = (indexPath.section==0) ? NO:YES;
        [headerView.clearButton addTarget:self action:@selector(clearHistory) forControlEvents:UIControlEventTouchUpInside];
        return headerView;
    }else{
        UICollectionReusableView * footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:footerIdentifer forIndexPath:indexPath];
        footerView.backgroundColor = JXColorFromRGB(0xf2f3f5);
        return footerView;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JXSearchHistoryCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifer forIndexPath:indexPath];
    if (indexPath.section==0) {
        cell.textLabel.text = _historyArray[indexPath.item];
    }else if (indexPath.section==1&&_hotWordsArray.count>0){
        cell.hotWordModel = _hotWordsArray[indexPath.item];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DSClassificationDetailController * detailVC = [[DSClassificationDetailController alloc]init];
    if (indexPath.section==0) {
        detailVC.searchWord = _historyArray[indexPath.item];
    }else if (indexPath.section==1){
        JXSearchHotWordModel * model = _hotWordsArray[indexPath.item];
//        [(DSHomeSearchController *)self.parentViewController setSearchKeyword:model.uid];
        detailVC.searchWord = model.fullname;
    }
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark 按钮点击事件
- (void)clearHistory{
//清除历史记录
    UIAlertController * alert = [YJAlertView presentAlertWithTitle:@"确定清空？" message:@"" actionTitles:@[@"取消",@"确定"] preferredStyle:UIAlertControllerStyleAlert actionHandler:^(NSUInteger buttonIndex, NSString *buttonTitle) {
        if (buttonIndex==1) {
            NSMutableArray * mu = [NSMutableArray array];
            _historyArray = mu;
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        }
    }];
    [self presentViewController:alert animated:YES completion:nil];

}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    NSString * searchText = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([searchText isNotBlank]) {
        self.searchKeyword = searchText;
        //        [DataBaseTool savaHistoryWithHistory:searchText sourceType:self.pageType];
    }
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    self.searchKeyword = @"";
    [textField resignFirstResponder];
    return YES;
}

- (void)backToPreviousPage{
    [self.navigationController popViewControllerAnimated:YES];
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
