//
//  DSBaseViewController.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/5/23.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSBaseViewController.h"
#import "DSCompleteInfoController.h"
#import "DSGoodsDetailController.h"
#import "DSBannerModel.h"
#import "DSCommonWebViewController.h"
#import "DSClassificationDetailController.h"

@interface DSBaseViewController ()

@end

@implementation DSBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.view.backgroundColor = [UIColor whiteColor];
    //设置导航条样式
    [[UINavigationBar appearance]setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance]setTintColor:JXColorFromRGB(0x666666)];
    _needChangeStatusBarStyle = NO;
}

//设置导航条返回按钮
- (UIBarButtonItem *)rt_customBackItemWithTarget:(id)target action:(SEL)action{
    if (self.hidenBackBarItem) {
        return nil;
    }
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithImage:ImageString(@"public_back") style:UIBarButtonItemStylePlain target:self action:@selector(backToPreviosPage)];
    self.backItem = item;
    return item;
}

//- (BOOL)prefersStatusBarHidden{
//
//}

- (void)changeNavigationBarTransparent:(BOOL)tranparent{
    if (tranparent) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = [UIImage new];
        [self setNeedChangeStatusBarStyle:YES];
    }else{
        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = nil;
        [self setNeedChangeStatusBarStyle:NO];
    }
    
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    if (_needChangeStatusBarStyle==NO) {
        return UIStatusBarStyleDefault;
    }else{
        return UIStatusBarStyleLightContent;
    }
}

- (void)setNeedChangeStatusBarStyle:(BOOL)needChangeStatusBarStyle{
    if (_needChangeStatusBarStyle!=needChangeStatusBarStyle) {
        _needChangeStatusBarStyle = needChangeStatusBarStyle;\
        if (self.navigationController) {
            if (needChangeStatusBarStyle) {
                self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
            }else{
                self.navigationController.navigationBar.titleTextAttributes = nil;
            }
        }
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

/**< 返回上层界面 默认为pop 调用block后会截取事件 */
- (void)backToPreviosPage{
    if (self.backButtonHandle) {
        self.backButtonHandle();
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/** 是否需要引导用户去升级会员 */
- (BOOL)shouldGuidaUserToUpgradeMembershipWithGoodsModel:(id)model{
    BOOL isMembershipGoods = NO;
    if ([model isKindOfClass:[DSGoodsDetailInfoModel class]]) {
        DSGoodsDetailInfoModel * goodsDetailInfoModel = (DSGoodsDetailInfoModel *)model;
        if(goodsDetailInfoModel.special.boolValue==1) isMembershipGoods = YES;
    }
    DSUserInfoModel * account = [JXAccountTool account];
    if (account.level.integerValue==1&&isMembershipGoods==YES) {
        UIAlertController * alertController = [YJAlertView presentAlertWithTitle:@"您只有成为领航会员才能购买此商品" message:nil actionTitles:@[@"取消",@"去升级"] preferredStyle:UIAlertControllerStyleAlert actionHandler:^(NSUInteger buttonIndex, NSString *buttonTitle) {
            if (buttonIndex==1) {
                DSCompleteInfoController * completeInfoVC = [[DSCompleteInfoController alloc]init];
                [self.navigationController pushViewController:completeInfoVC animated:YES];
            }
        }];
        [self presentViewController:alertController animated:YES completion:nil];
        return YES;
    }
    return NO;
}

/**< banner跳转事件 */
- (void)bannerClickEventHandle:(DSBannerModel *)bannerModel{
    if (bannerModel.type.integerValue==1) {
        //跳转商详
        DSGoodsDetailController * detailVC = [[DSGoodsDetailController alloc]init];
        detailVC.hidesBottomBarWhenPushed = YES;
        detailVC.goodsId = bannerModel.action;
        [self.navigationController pushViewController:detailVC animated:YES];
    }else if (bannerModel.type.integerValue==2){
        //web
        DSCommonWebViewController * webVC = [[DSCommonWebViewController alloc]init];
        webVC.hidesBottomBarWhenPushed = YES;
        webVC.title = bannerModel.name;
        webVC.urlString = bannerModel.action;
        [self.navigationController pushViewController:webVC animated:YES];
    }else if(bannerModel.type.integerValue==3){
        //分类列表
        DSClassificationDetailController * classificationVC = [[DSClassificationDetailController alloc]init];
        classificationVC.classificationId = bannerModel.action;
        classificationVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:classificationVC animated:YES];
    }else if (bannerModel.type.integerValue==4){
        DSClassificationDetailController * classificationVC = [[DSClassificationDetailController alloc]init];
        classificationVC.classificationId = bannerModel.action;
        classificationVC.specialClassfication = @"2";
        classificationVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:classificationVC animated:YES];
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
