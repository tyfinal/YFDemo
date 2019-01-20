//
//  DSHomeEntranceController.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/5/23.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSHomeEntranceController.h"
#import <SDCycleScrollView.h>
#import "DSMyOrderEntranceController.h"
//#import "UIImage+JXHandle.h"
#import "DSShopCartEntraceController.h"
#import "UIImage+YYAdd.h"
#import "DSHomeEntranceCell.h"
#import "DSBannerModel.h"
#import "DSHomeEntranceReusableView.h"
#import "DSSearchHistoryController.h"
#import "DSHomeSearchView.h"
#import "DSHomeModel.h"
#import "NSTimer+YYAdd.h"
#import "DSHomeClassificationModel.h"
#import "DSClassificationDetailController.h"
#import "DSGoodsInfoModel.h"
#import "DSCommonWebViewController.h"
#import "DSGoodsDetailController.h"
#import "KLCPopup.h"
#import "DSHomeEntranceActivityPopView.h"
#import <YYImage.h>
#import <FLAnimatedImageView+WebCache.h>

@interface DSHomeEntranceController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SDCycleScrollViewDelegate>{
}

@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout * layout;
//@property (nonatomic, strong) UIView * bannerView;
@property (nonatomic, strong) SDCycleScrollView * bannerScrollView;
@property (nonatomic, copy) NSArray * bannerArray;
@property (nonatomic, assign) BOOL needAdjustStatusBarStyle;
@property (nonatomic, strong) DSHomeSearchView * searchView;
@property (nonatomic, strong) DSHomeModel * homeModel;
@property (nonatomic, assign) NSInteger pageNumber;
@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic, copy) NSString * memberShipNumber;
@property (nonatomic, strong) KLCPopup * acivityPopView;


@end

static const CGFloat kBannerRatio = 0.65;

#define kBannerH  (floor(boundsWidth*kBannerRatio))
static NSString * membershipNumberCell = @"menbershipnumber";

static NSString * membershipRightIntroCell = @"menbershiprightintro";

static NSString * activityIdentifer = @"activitycell";

static NSString * classificationIdentifer = @"classificationIdentifer";

static NSString * hotSaleCellIdentifer = @"hotSaleidentifer";

static NSString * goodsCellIdentifer = @"goodsCell";

static NSString * sectionHeaderIdentifer  = @"sectionheader";

static NSString * sectionFooterIdentifer = @"sectionfooter";

@implementation DSHomeEntranceController

static BOOL didLaunchActivityPopView = NO;

//static const kPageSize = 10;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"袋鼠乐购";
    self.pageNumber = 1;
    self.memberShipNumber = @"0";
    self.extendedLayoutIncludesOpaqueBars = YES;
    [self reqeustDataWithRefreshFlag:DSRefreshFirstTimeLoad];

    adjustsScrollViewInsets_NO(self.collectionView, self);
    [self changeNavigationBarTransparent:YES]; //设置全透明
    
    _needAdjustStatusBarStyle = NO;
    [self.view addSubview:self.collectionView];
   
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.and.right.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            // Fallback on earlier versions
            make.bottom.equalTo(self.view).with.offset(-KTabbarHeight);
        }
    }];
    
    _searchView = [[DSHomeSearchView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, 44)];
    [_searchView.shoppingCartButton addTarget:self action:@selector(goToShoppingCart) forControlEvents:UIControlEventTouchUpInside];
    __weak typeof (self)weakSelf = self;
    _searchView.BeginSearchHandle = ^{
        DSClassificationDetailController * classificationDetailController = [[DSClassificationDetailController alloc]init];
        classificationDetailController.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:classificationDetailController animated:YES];
    };
    self.navigationItem.titleView = _searchView;
    
    [self addCollectionViewHeaderAndFooterRefresher];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self startTime];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self stopTimer];
}


- (UICollectionView *)collectionView{
    if (!_collectionView) {
        self.layout = [[UICollectionViewFlowLayout alloc]init];
        self.layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.layout.minimumLineSpacing = 10;
        self.layout.minimumInteritemSpacing = 18;
        self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.layout];
        [_collectionView addSubview:self.bannerScrollView];
        _collectionView.contentInset = UIEdgeInsetsMake(self.bannerScrollView.frameHeight, 0, 0, 0);
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = JXColorFromRGB(0xf2f2f2);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[HomeMenbershipNumberCell class] forCellWithReuseIdentifier:membershipNumberCell];
        [_collectionView registerClass:[HomeClassificationCell class] forCellWithReuseIdentifier:classificationIdentifer];
        [_collectionView registerClass:[HomeMembershipRightIntroduceCell class] forCellWithReuseIdentifier:membershipRightIntroCell];
        [_collectionView registerClass:[HomeMembershipRightIntroduceCell class] forCellWithReuseIdentifier:activityIdentifer];
        [_collectionView registerClass:[HomeHotSaleCell class] forCellWithReuseIdentifier:hotSaleCellIdentifer];
        [_collectionView registerClass:[HomeGoodsCell class] forCellWithReuseIdentifier:goodsCellIdentifer];

        [_collectionView registerClass:[HomeEntranceSectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionHeaderIdentifer];
        [_collectionView registerClass:[HomeEntranceSectionFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:sectionFooterIdentifer];

    }
    return _collectionView;
}

- (SDCycleScrollView *)bannerScrollView{
    if (!_bannerScrollView) {
        _bannerScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, -kBannerH, boundsWidth, kBannerH) delegate:self placeholderImage:ImageString(@"public_banner_placeholder")];
        _bannerScrollView.autoScrollTimeInterval = 3;
        _bannerScrollView.delegate = self;
//        _bannerScrollView.imageURLStringsGroup = bannerImageUrls; //图片url地址
        _bannerScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        _bannerScrollView.pageDotColor = JXColorFromRGB(0xf5f5f5);
        _bannerScrollView.currentPageDotColor = APP_MAIN_COLOR;
        _bannerScrollView.pageControlDotSize = CGSizeMake(6, 6);
        _bannerScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    }
    return _bannerScrollView;
}

- (KLCPopup *)acivityPopView{
    if (!_acivityPopView) {
        DSHomeEntranceActivityPopView * activityView = [[DSHomeEntranceActivityPopView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, 0)];
        [activityView layoutIfNeeded];
        activityView.imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer * ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickActivityContentView)];
        [activityView.imageView addGestureRecognizer:ges];
        [activityView.closeButton addTarget:self action:@selector(closeActivityPopView) forControlEvents:UIControlEventTouchUpInside];
        activityView.frameHeight = activityView.contentView.frameBottom;
        _acivityPopView = [KLCPopup popupWithContentView:activityView showType:KLCPopupShowTypeFadeIn dismissType:KLCPopupDismissTypeFadeOut maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:NO];
    }
    return _acivityPopView;
}

//定时请求领航会员数量
- (NSTimer *)timer{
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:10 target:self selector:@selector(reqeustMemberShipNumber) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    if (_needAdjustStatusBarStyle==YES) {
        return UIStatusBarStyleDefault;
    }else{
        return UIStatusBarStyleLightContent;
    }
}

- (void)setBannerArray:(NSArray *)bannerArray{
    _bannerArray = bannerArray;
    if (_bannerArray.count>0) {
        NSMutableArray * mu = [NSMutableArray array];
        [_bannerArray enumerateObjectsUsingBlock:^(DSBannerModel * model, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([model.pic isNotBlank]) {
                [mu addObject:model.pic];
            }
        }];
        self.bannerScrollView.imageURLStringsGroup = mu.copy;
    }
}

#pragma mark 网络请求及数据处理

- (void)addCollectionViewHeaderAndFooterRefresher{
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self reqeustDataWithRefreshFlag:DSRereshHeader];
    }];
    self.collectionView.mj_header.ignoredScrollViewContentInsetTop = kBannerH;
//    [self.collectionView.mj_header beginRefreshing];
}

- (void)reqeustDataWithRefreshFlag:(DSRefreshFlag)refreshFlag{
    MBProgressHUD * HUD = nil;
    if(refreshFlag==DSRefreshFirstTimeLoad) HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [DSHttpResponseData homeGetData:^(id info, BOOL succeed, id extraInfo) {
        if(refreshFlag==DSRefreshFirstTimeLoad) {
            [HUD hideAnimated:YES];
        }
        [self.collectionView.mj_header endRefreshing];
        if (succeed) {
            if (info) {
                
                DSHomeModel * model = (DSHomeModel *)info;
                self.homeModel = model;
               
                DSUserInfoModel * account = [JXAccountTool account];
                
                if (self.homeModel.popupAds.count>0&&didLaunchActivityPopView==NO&&(!account||account.level.integerValue!=2)) {
                    didLaunchActivityPopView = YES;
                    //展示活动页
                    [self.acivityPopView showWithLayout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutCenter)];
                    DSHomeEntranceActivityPopView * activityView = (DSHomeEntranceActivityPopView *)self.acivityPopView.contentView;
                    DSBannerModel * bannerModel = self.homeModel.popupAds[0];
                    activityView.bannerModel = bannerModel;
                }
                
                //刷新界面
                [self.collectionView reloadData];
                 self.bannerArray = model.banners;
//                self.collectionView.hidden = NO;
            }
        }
    }cacheBlock:^(id info, BOOL succeed, id extraInfo) {
        if (info) {
            DSHomeModel * model = (DSHomeModel *)info;
            self.homeModel = model;
            
            //刷新界面
            [self.collectionView reloadData];
            self.bannerArray = model.banners;
        }
    }];
}

//请求会员数量
- (void)reqeustMemberShipNumber{
    [DSHttpResponseData homeRefreshMemberShipNumber:^(id info, BOOL succeed, id extraInfo) {
        if (succeed) {
            self.memberShipNumber = info;
            [UIView performWithoutAnimation:^{
                [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
            }];
        }
    }];
}

#pragma mark UIColletionViewDelegate && UICollectionViewDataSource && UICollectionIVewFlowLayoutDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 6;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section==5) {
        //最后一区
        if (self.homeModel.youLike.products.count>0) {
            NSInteger rowCount = floor(self.homeModel.youLike.products.count/2.0);
            return rowCount*2;
        }
        return 0;
    }else if (section==3){
        //活动
        if (self.homeModel.events.banners.count>0) {
            NSInteger rowCount = floor(self.homeModel.events.banners.count/2.0);
            return rowCount*2;
        }
        return 0.0f;
    }else if (section==4){
        //
        if (self.homeModel.ads.banners.count>0) {
            return self.homeModel.ads.banners.count;
        }
        return 0;
    }else if (self.homeModel.recommendAds.banners.count>0&&section==2){
        return 1;
    }else if (section==0||section==1){
        return 1;
    }
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if (section==5) {
        return 5; //猜你喜欢５
    }
    return CGFLOAT_MIN;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (section==5) {
        return 5;
    }
    return CGFLOAT_MIN;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        CGFloat itemH = (110.0/375.0)*boundsWidth;
        return CGSizeMake(boundsWidth,itemH);
    }else if (indexPath.section==1){
        CGFloat itemH = [HomeClassificationCell getCellHeight];
        return CGSizeMake(boundsWidth,itemH);
    }else if (indexPath.section==2){
        CGFloat itemH = 0.427*boundsWidth;
        return CGSizeMake(boundsWidth,itemH);
    }else if (indexPath.section==3){
        CGFloat itemW = boundsWidth/2.0f;
        CGFloat itemH = itemW*0.71;
        return CGSizeMake(itemW,itemH);
    }else if(indexPath.section==4){
        if (self.homeModel.ads.banners.count>0) {
            DSBannerModel * bannerModel = self.homeModel.ads.banners[indexPath.row];
            return CGSizeMake(boundsWidth,[HomeHotSaleCell getCellHeightWithModel:bannerModel]);
        }
        return CGSizeZero;
    }else{
        CGFloat itemW = floor((boundsWidth-5)/2.0);
        CGFloat itemH = [HomeGoodsCell getItemHeightWithItemWidth:itemW];
        return CGSizeMake(itemW,itemH);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section==4&&[self.homeModel.ads.titleImg isNotBlank]) {
        return CGSizeMake(boundsWidth,47);
    }else if (section==3&&[self.homeModel.events.titleImg isNotBlank]){
        return CGSizeMake(boundsWidth,47);
    }else if (section==5&&[self.homeModel.youLike.titleImg isNotBlank]){
        return CGSizeMake(boundsWidth,47);
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeZero;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        HomeMenbershipNumberCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:membershipNumberCell forIndexPath:indexPath];
        cell.membershipNumber = self.memberShipNumber;
        return cell;
    }else if(indexPath.section==1){
        HomeClassificationCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:classificationIdentifer forIndexPath:indexPath];
        __weak typeof (self)weakSelf = self;
        cell.ClickItemHandle = ^(NSIndexPath * aindexPath, DSHomeClassificationModel *model) {
            [weakSelf clickClassificationItemWithIndexPath:aindexPath model:model];
        };
        cell.dataArray = self.homeModel.sections;
        return cell;
    }else if (indexPath.section==2){
        HomeMembershipRightIntroduceCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:membershipRightIntroCell forIndexPath:indexPath];
        if (self.homeModel.recommendAds.banners.count>0) {
            DSBannerModel * model = self.homeModel.recommendAds.banners[0];
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:ImageString(@"public_banner_placeholder")];
        }
        return cell;
    }else if (indexPath.section==3){
        HomeMembershipRightIntroduceCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:activityIdentifer forIndexPath:indexPath];
        if (self.homeModel.events.banners.count>0) {
            NSInteger itemCount = floor(self.homeModel.events.banners.count/2.0);
            cell.topLine.hidden = NO;
            cell.rightLine.hidden = indexPath.item+1%2==0? YES:NO;
            
            cell.bottomLine.hidden = YES;
            if (indexPath.item>=itemCount-2) {
                cell.bottomLine.hidden = NO;
            }
            DSBannerModel * model = self.homeModel.events.banners[indexPath.item];
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:ImageString(@"public_banner_placeholder")];
        }
        
        return cell; 
    }else if (indexPath.section==4){
        HomeHotSaleCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:hotSaleCellIdentifer forIndexPath:indexPath];
        if (self.homeModel.ads.banners.count>0) {
            DSBannerModel * model = self.homeModel.ads.banners[indexPath.row];
            cell.model = model;
        }
        
        __weak typeof (self)weakSelf = self;
        cell.clickAtBannerHandle = ^(DSBannerModel *model) {
            [weakSelf bannerClickEventHandle:model];
        };
        
        cell.clickItemAtIndexPathHandle = ^(DSBannerModel *bannerModel, NSIndexPath *indexPath, DSGoodsInfoModel *productModel) {
            DSGoodsDetailController * goodsDetailVC = [[DSGoodsDetailController alloc]init];
            goodsDetailVC.goodsId = productModel.goods_id;
            goodsDetailVC.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:goodsDetailVC animated:YES];
        };
        
        return cell;
    }else{
        HomeGoodsCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:goodsCellIdentifer forIndexPath:indexPath];
        if (self.homeModel.youLike.products.count>indexPath.row) {
            cell.model = self.homeModel.youLike.products[indexPath.item];
        }
        
        return cell;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    DSHomeEntranceReusableView * reusableView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        //section header
        if (indexPath.section>=3) {
            reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:sectionHeaderIdentifer forIndexPath:indexPath];
            HomeEntranceSectionHeaderView * headerView = (HomeEntranceSectionHeaderView *)reusableView;
            if (indexPath.section==3&&[self.homeModel.events.titleImg isNotBlank]) {
                [headerView.titleImageView sd_setImageWithURL:[NSURL URLWithString:self.homeModel.events.titleImg]];
            }else if (indexPath.section==4&&[self.homeModel.ads.titleImg isNotBlank]){
                [headerView.titleImageView sd_setImageWithURL:[NSURL URLWithString:self.homeModel.ads.titleImg]];
            }else if (indexPath.section==5&&[self.homeModel.youLike.titleImg isNotBlank]){
                [headerView.titleImageView sd_setImageWithURL:[NSURL URLWithString:self.homeModel.youLike.titleImg]];
            }
        }
    }else{
         //section footer
        if (indexPath.section==3||indexPath.section==0||indexPath.section==4) {
            reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:sectionFooterIdentifer forIndexPath:indexPath];
        }
    }
    return reusableView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==5) {
        DSGoodsDetailController * goodsDetailVC = [[DSGoodsDetailController alloc]init];
        DSGoodsInfoModel * model = self.homeModel.youLike.products[indexPath.item];
        goodsDetailVC.goodsId = model.goods_id;
        goodsDetailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:goodsDetailVC animated:YES];
    }else if (indexPath.section==2||indexPath.section==3){
        DSBannerModel * model = nil;
        if(indexPath.section==2&&_homeModel.recommendAds.banners.count>0) {
            model = _homeModel.recommendAds.banners[0];
        }else if (indexPath.section==3&&_homeModel.events.banners.count>1){
            model = _homeModel.events.banners[indexPath.item];
        }
            
        if (model.type.integerValue==1) {
            //跳转商详
            DSGoodsDetailController * detailVC = [[DSGoodsDetailController alloc]init];
            detailVC.hidesBottomBarWhenPushed = YES;
            detailVC.goodsId = model.action;
            [self.navigationController pushViewController:detailVC animated:YES];
        }else if (model.type.integerValue==2){
            //web
            DSCommonWebViewController * webVC = [[DSCommonWebViewController alloc]init];
            webVC.hidesBottomBarWhenPushed = YES;
            webVC.title = model.name;
            webVC.urlString = model.action;
            [self.navigationController pushViewController:webVC animated:YES];
        }else if(model.type.integerValue==3){
            DSClassificationDetailController * classificationVC = [[DSClassificationDetailController alloc]init];
            classificationVC.classificationId = model.action;
            classificationVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:classificationVC animated:YES];
        }
    }
}

//调整导航条透明度
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offset = scrollView.contentOffset.y+self.bannerScrollView.frameHeight;
    CGFloat alpha = 0.0f;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    if (offset<=0) {
        alpha = 0.0f;
        _needAdjustStatusBarStyle = NO;
    }else{
        alpha = offset/60;
        if (alpha>=1.0) {
            alpha = 1.0f;
            self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:APP_MAIN_COLOR};
//            self.navigationController.
        }
    }
    if (alpha==1.0) {
        _needAdjustStatusBarStyle = YES;
    }
    [self preferredStatusBarStyle];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:JXColorAlpha(255, 255, 255, alpha) size:CGSizeMake(boundsWidth, kNavigationBarHeight)] forBarMetrics:UIBarMetricsDefault];
    [self.searchView changeStatusWithAlpha:alpha];
//    self.navigationController.navigationBar.barTintColor = JXColorAlpha(1, 1, 1, 1.0);

}


#pragma mark SDCycleScrollViewDelegate

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    if (self.bannerArray.count>index) {
         DSBannerModel * model = self.bannerArray[index];
        [self bannerClickEventHandle:model];
    }
}

#pragma mark 按钮点击事件

- (void)clickClassificationItemWithIndexPath:(NSIndexPath *)indexPath model:(DSHomeClassificationModel *)model{
    switch (model.type.integerValue) {
        case 0:{
            //分类id 某个分类下的所有商品
            DSClassificationDetailController * detailClassificationVC = [[DSClassificationDetailController alloc]init];
            detailClassificationVC.classificationId = model.classification_id;
            detailClassificationVC.hidesBottomBarWhenPushed = YES;
            detailClassificationVC.specialClassfication = @"1";
            [self.navigationController pushViewController:detailClassificationVC animated:YES];
        }
            break;
        case 1:{
            //跳转商详
            DSGoodsDetailController * detailVC = [[DSGoodsDetailController alloc]init];
            detailVC.hidesBottomBarWhenPushed = YES;
            detailVC.goodsId = model.action;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
            break;
        case 2:{
            //web
            DSCommonWebViewController * webVC = [[DSCommonWebViewController alloc]init];
            webVC.hidesBottomBarWhenPushed = YES;
            webVC.urlString = model.action;
            webVC.title = model.name;
            [self.navigationController pushViewController:webVC animated:YES];
        }
            break;
        case 3:{
            //分类id 某个分类下的所有商品
            if ([model.action isNotBlank]) {
                DSClassificationDetailController * detailClassificationVC = [[DSClassificationDetailController alloc]init];
                detailClassificationVC.classificationId = model.action;
                detailClassificationVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:detailClassificationVC animated:YES];
            }
        }
            break;
            
        default:
            break;
    }
}

//购物车
- (void)goToShoppingCart{
    if ( [DSAppDelegate shouldShowLoginAlertViewInController:self]==YES) {
        return;
    }
    //验证token是否有效
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [DSHttpResponseData PublicCheckValidityOfToken:^(id info, BOOL succeed, id extraInfo) {
        [HUD hideAnimated:YES];
        if (succeed) {
            DSShopCartEntraceController * shopcartVC = [[DSShopCartEntraceController alloc]init];
            shopcartVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:shopcartVC animated:YES];
        }
    }];
}

- (void)closeActivityPopView{
    if (_acivityPopView) {
        [_acivityPopView dismiss:YES];
    }
}

- (void)clickActivityContentView{
    [_acivityPopView dismiss:YES];
    DSHomeEntranceActivityPopView * contentView = (DSHomeEntranceActivityPopView *)self.acivityPopView.contentView;
    if (contentView.bannerModel) {
        [self bannerClickEventHandle:contentView.bannerModel];
    }
   
}

//开启定时器
- (void)startTime{
    [self.timer fire];
}

//关闭定时器
- (void)stopTimer{
    [self.timer invalidate];
    self.timer = nil;
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
