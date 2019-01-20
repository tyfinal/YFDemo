//
//  DSMineEntranceController.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/5/23.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSMineEntranceController.h"
#import "DSMineEntranceTableBackgroundView.h"
#import "DSMineHeaderView.h"
#import "DSControllableRoundedCell.h"
#import "DSMineTableCell.h"
#import "DSSettingEntranceController.h"
#import "DSMyOrderEntranceController.h"
#import "DSMyCollectionController.h"
#import "DSPensionDetailController.h"
#import "DSLoginEntranceController.h"
#import "DSUserInfoModel.h"
#import "DSMembershipInfoModel.h"
#import "DSControllableRoundedCell.h"
#import "YJPayHelper.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DSCompleteInfoController.h"
#import "DSCommonWebViewController.h"
#import "DSBannerModel.h"
#import "DSGoodsDetailController.h"
#import "DSClassificationDetailController.h"
#import "DSMyOrderEntranceSubController.h"
#import "KLCPopup.h"
#import "DSLaunchConfigureModel.h"
#import "DSWithdrawCashController.h"
#import "DSWithdrawCashConfigureModel.h"
#import "DSGoldDetailController.h"
#import "DSDayClockInView.h"
#import "DSGoldDetailController.h"
#import "DSOptionsDetailController.h"
#import "DSClockInDetailModel.h"
#import <ZXingObjC.h>
#import "QRContentView.h"
#import "YJUMengShareHelper.h"
#import <UShareUI/UShareUI.h>

@interface DSMineEntranceController ()<UITableViewDelegate,UITableViewDataSource>{
    
    NSString * invitationCode;
    UIImageView * QRImageView;
}

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) DSMineEntranceTableBackgroundView * tableBackgroundView;
@property (nonatomic, strong) DSMineHeaderView * headerView;
@property (nonatomic, strong) NSArray * rightItemsArray;
@property (nonatomic, strong) DSUserInfoModel * userInfoModel;
@property (nonatomic, strong) DSMembershipInfoModel * membershipModel;
@property (nonatomic, assign) BOOL didLogined;
@property (nonatomic, strong) KLCPopup * upgradePopView; /**< 升级成功的提示 */
@property (nonatomic, strong) KLCPopup * clockInPopView; /**< 签到 */
@property (nonatomic, strong) QRContentView * QRView;
@property (nonatomic, strong) KLCPopup * QRCodePopView;
@property (nonatomic, strong) UIImage * QRImage;
//@property (nonatomic, assign) BOOL didLogined;

@end

static BOOL requestBarrage = NO; //请求完成 或者 阻塞时间结束 才可以再次请求
static CGFloat contentViewTop = 180;
@implementation DSMineEntranceController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    adjustsScrollViewInsets_NO(self.tableView, self);
    self.title = @"袋鼠乐购";
    [self changeNavigationBarTransparent:YES];
    [self.view addSubview:self.tableView];
    
    _QRImage = nil;
    invitationCode = nil;
    
    self.didLogined = NO;
    
    self.navigationItem.rightBarButtonItems = self.rightItemsArray;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-KTabbarHeight);
    }];
    
    if (self.ds_universal_params) {
        if ([self.ds_universal_params[@"upgradesucceed"] boolValue]==YES) {
            //会员升级成功
            [self.upgradePopView showWithLayout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutCenter)];
        }
    }

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     DSUserInfoModel * account = [JXAccountTool account];
    [DSUserInfoModel mj_objectWithKeyValues:nil];
    [self getMembershipInfo];
    if ([account.access_token isNotBlank]) {
        [self getUserInfo];
    }else{
        //游客
        self.didLogined = NO;
    }
//    [self.upgradePopView showWithLayout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutCenter)];
}

- (void)setDidLogined:(BOOL)didLogined{
    _didLogined = didLogined;
    if (_didLogined) {
        //已经登录
        self.navigationController.navigationBarHidden = NO;
        self.navigationItem.rightBarButtonItems = self.rightItemsArray;
        self.title = @"袋鼠乐购";
    }else{
        //未登录
        self.navigationController.navigationBarHidden = YES;
        self.navigationItem.rightBarButtonItems = nil;
        self.title = nil;
        self.userInfoModel = nil;
    }
     self.headerView.model = self.userInfoModel;
}

- (NSArray *)rightItemsArray{
    if (!_rightItemsArray) {
        UIBarButtonItem * settingItem = [[UIBarButtonItem alloc]initWithImage:[ImageString(@"public_navigation_setting") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(settingEvent)];
        UIBarButtonItem * collectionItem = [[UIBarButtonItem alloc]initWithImage:[ImageString(@"public_navigation_collection")  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(collectGoodsEvent)];
        _rightItemsArray = @[collectionItem,settingItem];
    }
    return _rightItemsArray;
}

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, boundsHeight) style:UITableViewStylePlain];
        tableView.showsVerticalScrollIndicator = NO;
        tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = 60;
        [tableView setTableFooterView:[UIView new]];
        tableView.backgroundView = self.tableBackgroundView;
        [tableView setTableHeaderView:self.headerView];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView = tableView;
    }
    return _tableView;
}

- (DSMineHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[DSMineHeaderView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, 150)];
//        _headerView.backgroundColor = [];
        _headerView.backgroundColor = [UIColor clearColor];
        _headerView.clipsToBounds = YES;
        [_headerView.loginButton addTarget:self action:@selector(goToLoginPage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerView;
}

- (DSMineEntranceTableBackgroundView *)tableBackgroundView{
    if (!_tableBackgroundView) {
        _tableBackgroundView = [[DSMineEntranceTableBackgroundView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, boundsHeight-KTabbarHeight)];
        _tableBackgroundView.topView.frame = CGRectMake(0, 0, boundsWidth, contentViewTop);
        _tableBackgroundView.bottomView.frame = CGRectMake(0, _tableBackgroundView.topView.frameBottom, _tableBackgroundView.topView.frameWidth, boundsHeight-_tableBackgroundView.topView.frameHeight);
    }
    return _tableBackgroundView;
}

- (KLCPopup *)upgradePopView{
    if (!_upgradePopView) {
        UIImageView * imageView = [[UIImageView alloc]initWithImage:ImageString(@"mine_upgrademembership")];
        imageView.userInteractionEnabled = YES;
        
        UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [imageView addSubview:cancelButton];
        [cancelButton addTarget:self action:@selector(dismissPopView) forControlEvents:UIControlEventTouchUpInside];
        cancelButton.frame = CGRectMake(imageView.frameWidth-30, 0, 30, 30);
        
        UIButton * startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [imageView addSubview:startButton];
        [startButton addTarget:self action:@selector(enterMembershipAcitivtyPage) forControlEvents:UIControlEventTouchUpInside];
        startButton.frame = CGRectMake((imageView.frameWidth-110)/2.0, imageView.frameHeight-33, 110, 30);
        
        _upgradePopView = [KLCPopup popupWithContentView:imageView showType:KLCPopupShowTypeGrowIn dismissType:KLCPopupDismissTypeGrowOut maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:NO];
    }
    return _upgradePopView;
}

- (KLCPopup *)clockInPopView{
    if (!_clockInPopView) {
        DSDayClockInView * clockInView = [[DSDayClockInView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth*0.89, 500)];
        [clockInView layoutIfNeeded];
        clockInView.frameHeight = clockInView.backgroundView.frameBottom;
        __weak typeof (self)weakSelf = self;
        clockInView.clickAdertHandle = ^(id info, BOOL succeed, id extraInfo) {
            [weakSelf.clockInPopView dismiss:YES];
            [weakSelf clickAdvert:info];
        };
        
        clockInView.closePopViewHandle = ^(UIButton *button, id view) {
            [weakSelf.clockInPopView dismiss:YES];
        };
        
        _clockInPopView = [KLCPopup popupWithContentView:clockInView showType:KLCPopupShowTypeFadeIn dismissType:KLCPopupDismissTypeFadeOut maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:NO];
        [_clockInPopView setDidFinishDismissingCompletion:^{
            [weakSelf.tableView reloadData]; //签到完成后更新购物金金额
        }];
    }
    return _clockInPopView;
}

- (KLCPopup *)QRCodePopView{
    if (!_QRCodePopView) {
        _QRView = [[QRContentView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, boundsWidth)];
        [_QRView layoutIfNeeded];
        _QRView.frameHeight = _QRView.contentView.frameBottom;
        QRImageView.backgroundColor = [UIColor whiteColor];
        __weak typeof (self)weakSelf = self;
        //MARK: 邀请码分享
        _QRView.shareQRCodeHandle = ^(UIButton *button, id view) {
            [weakSelf.QRCodePopView dismiss:YES];
            NSMutableDictionary * params = [NSMutableDictionary dictionary];
            params[@"image"] = weakSelf.QRImage;
            params[@"text"] = @"袋鼠乐购";
            DSLaunchConfigureModel * configure = [DSLaunchConfigureModel configureModel];
            if ([configure.inviteFirstRewardPointMsg isNotBlank]) {
                NSArray * strings = [configure.inviteFirstRewardPointMsg componentsSeparatedByString:@"|"];
                if (strings.count>0) {
                    params[@"text"] = strings[0];
                }
                if (strings.count>1) {
                    params[@"desc"] = strings[1];
                }
            }
            [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
                [[YJUMengShareHelper shareUMengHelper]shareToPlatform:platformType Params:params shareType:0];
            }];
        };
        _QRCodePopView = [KLCPopup popupWithContentView:_QRView showType:KLCPopupShowTypeFadeIn dismissType:KLCPopupDismissTypeFadeOut maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:NO];
    }
    return _QRCodePopView;
}


#pragma mark 网络请求及数据处理

- (void)getUserInfo{
    [DSHttpResponseData mineGetUserInfo:^(id info, BOOL succeed, id extraInfo) {
        if (succeed) {
            if (info) {
                self.userInfoModel = info;
                self.didLogined = YES;
                [self.tableView reloadData];
                //access_token 只在登录时候获取
                self.userInfoModel.access_token = [JXAccountTool account].access_token;
                [JXAccountTool saveAccount:self.userInfoModel];
            }
        }
    }];
}

- (void)getMembershipInfo{
    DSUserInfoModel * account = [JXAccountTool account];
    [DSHttpResponseData mineGetMenbershipInfoWithToken:account.access_token callback:^(id info, BOOL succeed, id extraInfo){
        if (succeed) {
            if (info) {
                self.membershipModel = info;
                [self.tableView reloadData];
            }
        }
    }];
}



#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section==0? 0: 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section!=0) {
        UIView * sectionHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, 15)];
        sectionHeaderView.backgroundColor = [UIColor clearColor];
        return sectionHeaderView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 112.5;
    }else if (indexPath.section==1){
        if (self.membershipModel.banners.count>0) {
            return boundsWidth*0.27;
        }
        return 0.0f;
    }else if (indexPath.section==2){
        return 65;
    }else if (indexPath.section==3){
        return 65;
    }else if (indexPath.section==4){
        return 35;
    }else if (indexPath.section==5){
        return 58;
    }
    return 110;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==1) {
        return self.membershipModel.banners.count>0 ? 1:0;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==2||indexPath.section==3) {
        static NSString * identifer = @"pensioncell";
        MinePensionCell * cell=[tableView dequeueReusableCellWithIdentifier:identifer];
        if(cell==nil){
            cell = [[MinePensionCell alloc] initWithStyle:UITableViewCellStyleDefault      reuseIdentifier:identifer];
        }
        cell.section = indexPath.section;
        [cell.pensionDetailButton addTarget:self action:@selector(checkPensionDetail:) forControlEvents:UIControlEventTouchUpInside];
        [cell.withdrawCashItem addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(withdrawCashEvent:)]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.userInfoModel;
        return cell;
    }else if (indexPath.section==4){
        static NSString * identifer = @"opinionscell";
        MineOptionsCell * cell=[tableView dequeueReusableCellWithIdentifier:identifer];
        if(cell==nil){
            cell = [[MineOptionsCell alloc] initWithStyle:UITableViewCellStyleDefault      reuseIdentifier:identifer];
        }
        [cell.regulationButton addTarget:self action:@selector(viewOptionsRegulation) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.userInfoModel;
        return cell;
    }else if (indexPath.section==5){
        static NSString * identifer = @"identifycell";
        MineIdentityCodeCell * cell=[tableView dequeueReusableCellWithIdentifier:identifer];
        if(cell==nil){
            cell = [[MineIdentityCodeCell alloc] initWithStyle:UITableViewCellStyleDefault      reuseIdentifier:identifer];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.userInfoModel;
        return cell;
    }else if(indexPath.section==6){
        static NSString * identifer = @"membershipcell";
        MineMenbershipInfoCell * cell=[tableView dequeueReusableCellWithIdentifier:identifer];
        if(cell==nil){
            cell = [[MineMenbershipInfoCell alloc] initWithStyle:UITableViewCellStyleDefault      reuseIdentifier:identifer];
        }
        [cell.regulationButton addTarget:self action:@selector(viewPromotedRegulation) forControlEvents:UIControlEventTouchUpInside];
        cell.model = self.membershipModel;
        return cell;
    }else if (indexPath.section==0){
        static NSString * identifer = @"order";
        MineOrderInfoCell * cell=[tableView dequeueReusableCellWithIdentifier:identifer];
        if(cell==nil){
            cell = [[MineOrderInfoCell alloc] initWithStyle:UITableViewCellStyleDefault      reuseIdentifier:identifer];
        }
        __weak typeof (self)weakSelf = self;
        cell.viewAllOrderHandle = ^(UIButton *button, id view) {
            if ([self shouldLogin]) {
                DSMyOrderEntranceController * orderEntraceVC = [[DSMyOrderEntranceController alloc]init];
                orderEntraceVC.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:orderEntraceVC animated:YES];
            }
        };
        
        cell.OrderClickHandle = ^(NSInteger index) {
           
                if ([self shouldLogin]) {
                     if (index<3) {
                         DSMyOrderEntranceController * orderEntraceVC = [[DSMyOrderEntranceController alloc]init];
                         orderEntraceVC.hidesBottomBarWhenPushed = YES;
                         orderEntraceVC.selectIndex = @(index+1).intValue;
                         [weakSelf.navigationController pushViewController:orderEntraceVC animated:YES];
                     }else{
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
                     }
                }
        };
        if (self.membershipModel) {
            cell.model = self.membershipModel;
        }
        return cell;
    }else{
        static NSString * identifer = @"advertcell";
        MineAdvertisementCell * cell=[tableView dequeueReusableCellWithIdentifier:identifer];
        if(cell==nil){
            cell = [[MineAdvertisementCell alloc] initWithStyle:UITableViewCellStyleDefault      reuseIdentifier:identifer];
        }
        if (self.membershipModel.banners.count>0) {
            DSBannerModel * bannerModel = self.membershipModel.banners[0];
            [cell.adverImageView sd_setImageWithURL:[NSURL URLWithString:bannerModel.pic]];
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==1) {
        DSBannerModel * model = self.membershipModel.banners[0];
        [self clickAdvert:model];
    }else if (indexPath.section==4){
        if (self.userInfoModel.level.integerValue==2) {
            DSOptionsDetailController * optionsVC = [[DSOptionsDetailController alloc]init];
            optionsVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:optionsVC animated:YES];
        }
    }else if (indexPath.section==5){
        DSUserInfoModel * account = [JXAccountTool account];
        if ([account.access_token isNotBlank]==NO) {
            return; //没有登录
        }
        
        if (account.level.integerValue!=2) {
            return; //非领航会员 没有邀请码
        }
        
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [DSHttpResponseData mineGetQRCodeContent:^(id info, BOOL succeed, id extraInfo) {
            [hud hideAnimated:YES];
            if (succeed) {
                if (info) {
                    if ([info[@"weburl"] isNotBlank]) {
                        if (![invitationCode isEqualToString:info[@"weburl"] ]) {
                            //                //邀请码相同时不再生成图片
                            invitationCode = info[@"weburl"];
                            if (account.user_id) {
                                invitationCode = [NSString stringWithFormat:@"%@&dsInviterUserId=%@",invitationCode,account.user_id];
                            }
                           
                            if (!self.QRImage) {
                                UIImage * image = [self createQRImageWithImageSize:CGSizeMake(400, 400)];
                                _QRImage = image;
                            }
                        }
                        [self.QRCodePopView showWithLayout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutCenter)];
                        if ([_QRImage isKindOfClass:[UIImage class]]) {
                            NSLog(@"%@",_QRImage);
                           _QRView.QRImageView.image = _QRImage;
                        }
                    }
                }
            }
        }];

    }
}

- (UIImage *)createQRImageWithImageSize:(CGSize)imageSize{
    NSError *error = nil;
    
    ZXMultiFormatWriter *writer = [ZXMultiFormatWriter writer];
    NSLog(@"%@",invitationCode);
    ZXBitMatrix* result = [writer encode:invitationCode format:kBarcodeFormatQRCode width:imageSize.width height:imageSize.height error:&error];//这里写想要跳转的网址
    
    if (result) {
                
        // This CGImageRef image can be placed in a UIImage, NSImage, or written to a file.
        UIImage * imageResult = [[UIImage alloc] initWithCGImage:[[ZXImage imageWithMatrix:result] cgimage]];
//        CGImageRelease(image);
        return imageResult;
        
    } else {
        
        NSString *errorMessage = [error localizedDescription];
        
        NSLog(@"出错：%@",errorMessage);
        return nil;
    }
}

- (void)clickAdvert:(DSBannerModel *)model{
    [self bannerClickEventHandle:model];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    UIView * topView = self.tableBackgroundView.topView;
    UIView * bottomView = self.tableBackgroundView.bottomView;
    if (scrollView.contentOffset.y<=0) {
        topView.frameHeight = contentViewTop-scrollView.contentOffset.y;
        bottomView.frameY = topView.frameBottom;
        bottomView.frameHeight = boundsHeight-bottomView.frameY;
    }else if (scrollView.contentOffset.y>0){
        if (contentViewTop-scrollView.contentOffset.y>=0) {
             topView.frameHeight = contentViewTop-scrollView.contentOffset.y;
        }else{
            topView.frameHeight = 0;
        }
        bottomView.frameY = topView.frameBottom;
        bottomView.frameHeight = boundsHeight-bottomView.frameY;
    }

//    self.tableBackgroundView.topView.frameY = contentViewTop - scrollView.contentOffset.y;
//    self.tableBackgroundView.topView.frameHeight = boundsHeight-self.tableBackgroundView.topView.frameY;
}

- (BOOL)shouldLogin{
    DSUserInfoModel * account = [JXAccountTool account];
    if ([account.access_token isNotBlank]==NO) {
        [MBProgressHUD showText:@"您还未登录，请先登录" toView:self.view];
        return NO;
    }
    return YES;
}

- (void)collectGoodsEvent{
    DSMyCollectionController * collectionView = [[DSMyCollectionController alloc]init];
    collectionView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:collectionView animated:YES];
}

- (void)settingEvent{
    DSSettingEntranceController * settingVC = [[DSSettingEntranceController alloc]init];
    settingVC.hidesBottomBarWhenPushed = YES;
    settingVC.userinfoModel = self.userInfoModel;
    [self.navigationController pushViewController:settingVC animated:YES];
}

- (void)checkPensionDetail:(UIButton *)button{
    if ([self shouldLogin]) {
        MinePensionCell * cell = (MinePensionCell *)button.superview.superview;
        if (cell.section==2) {
            DSPensionDetailController * pensionDetailVC = [[DSPensionDetailController alloc]init];
            pensionDetailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:pensionDetailVC animated:YES];
        }else{
            if (self.userInfoModel.level.integerValue==2) {
                DSGoldDetailController * goldDetailVC = [[DSGoldDetailController alloc]init];
                goldDetailVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:goldDetailVC animated:YES];
            }
        }
    }
}

- (void)dismissPopView{
    [self.upgradePopView dismiss:YES];
}

- (void)enterMembershipAcitivtyPage{
    [self.upgradePopView dismiss:YES];
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [DSHttpResponseData classificationGetMembershipClassficationId:^(id info, BOOL succeed, id extraInfo) {
        [HUD hideAnimated:YES];
        if ([info isNotBlank]) {
            DSClassificationDetailController * classificationVC = [[DSClassificationDetailController alloc]init];
            classificationVC.classificationId = info;
            classificationVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:classificationVC animated:YES];
        }
    }];
}

- (void)goToLoginPage{
    [DSAppDelegate goToLoginPage];
}


- (void)withdrawCashEvent:(UITapGestureRecognizer *)ges{
    if ([self shouldLogin]) {
        MinePensionCell * cell = (MinePensionCell *)ges.view.superview.superview;
        if (cell.section==2) {
            //MARK: 提现
            if (requestBarrage==NO) {
                requestBarrage = YES;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    requestBarrage = NO;
                });
                [DSHttpResponseData mineWithdrawCashConfigure:^(id info, BOOL succeed, id extraInfo) {
                    requestBarrage = NO; //请求完成 或者 阻塞时间结束 才可以再次请求
                    if (succeed) {
                        if (info) {
                            DSWithdrawCashConfigureModel * configureModel = info;
                            if ([configureModel.withdrawMinimumLimit isNotBlank]) {
                                if ([[NSDecimalNumber decimalNumberWithString:configureModel.withdrawMinimumLimit] compare:[NSDecimalNumber decimalNumberWithString:@"0.0"]]==NSOrderedSame) {
                                    [MBProgressHUD showText:@"提现暂不可用" toView:self.view];
                                    return ;
                                }
                            }
                            DSWithdrawCashController * withdrawCashVC = [[DSWithdrawCashController alloc]init];
                            withdrawCashVC.hidesBottomBarWhenPushed = YES;
                            withdrawCashVC.configureModel = info;
                            withdrawCashVC.availablePoint = self.userInfoModel.availablePoint;
                            [self.navigationController pushViewController:withdrawCashVC animated:YES];
                        }
                    }
                }];
            }
        }else{
            //MARK: 签到
            if (self.userInfoModel.level.integerValue==2) {
                //必须是 领航会员才可以签到
                [DSHttpResponseData mineClockin:^(id info, BOOL succeed, id extraInfo) {
                    if (succeed) {
                        //购物金
                        DSClockInDetailModel * model = (DSClockInDetailModel *)info;
                        DSDayClockInView * contentView = (DSDayClockInView *)self.clockInPopView.contentView;
                        contentView.model = info;
                        if (model.status.integerValue==0) {
                           self.userInfoModel.availableGold = NSStringFormat(@"%.2f",self.userInfoModel.availableGold.floatValue+model.gold.floatValue);
                        }
                        
                        [self.clockInPopView showWithLayout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutCenter)];
                    }
                }];
            }else{
                [MBProgressHUD showText:@"成为领航会员即可签到" toView:nil];
            }

        }
    }
}


- (void)viewOptionsRegulation{
    //web
    DSCommonWebViewController * webVC = [[DSCommonWebViewController alloc]init];
    webVC.hidesBottomBarWhenPushed = YES;
    webVC.title = @"袋鼠期权说明";
    webVC.urlString = @"http://wap.dscs123.com/event/qiquan/";
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)viewPromotedRegulation{
    DSCommonWebViewController * webView = [[DSCommonWebViewController alloc]init];
    webView.title = @"成长任务";
    webView.hidesBottomBarWhenPushed = YES;
    webView.urlString = @"http://wap.dscs123.com/event/hysj/gzsm.html";
    [self.navigationController pushViewController:webView animated:YES];
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
