//
//  AppDelegate+Helper.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/5/23.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "AppDelegate+Helper.h"
#import "DSHomeEntranceController.h"
#import "DSTabBarBaseController.h"
#import "DSTabItemModel.h"
#import "NSString+MKDate.h"
#import "DSHttpBase.h"
#import "DSAreaDataHelper.h"
#import "DSLoginEntranceController.h"
#import "YJGuideController.h"
#import "JXAdvertisementController.h"
#import "DSLaunchConfigureModel.h"
#import "DSBannerModel.h"
#import "UIView+YYAdd.h"
#import "UIImage+YYAdd.h"
#import "DSSnapshotShareView.h"
#import "YJUMengShareHelper.h"
#import <UShareUI/UShareUI.h>

@implementation AppDelegate (Helper)
static DSSnapshotShareView * _shareView = nil;

/** 跳转制定tab页面并传递参数 */
- (void)goToHomePageWithIndex:(NSInteger)index params:(id)params{
    DSTabBarBaseController * tabBarController = [self goToTabControllerWithParams:params];
    self.tabBarController = tabBarController;
    tabBarController.delegate = self;
    tabBarController.selectedIndex = index;
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
}

/** 跳转到指定tab页面 */
- (void)goToHomePageWithIndex:(NSInteger)index{
    [self goToHomePageWithIndex:index params:nil];
}

/** 进入首页 */
- (void)goToHomePage{
    [self goToHomePageWithIndex:0];
}



- (DSTabBarBaseController *)goToTabControllerWithParams:(id)params{
    NSMutableArray *navigationContrllers = [[NSMutableArray alloc] init];
    NSArray * childItemsArray = [DSTabItemModel createHomeTabItems];
    [childItemsArray enumerateObjectsUsingBlock:^(DSTabItemModel * itemModel, NSUInteger idx, BOOL *stop) {
        DSBaseViewController *vc = [[itemModel.className alloc]init];
        vc.ds_universal_params = params;
        vc.title = itemModel.title;
        RTRootNavigationController *nav = [[RTRootNavigationController alloc] initWithRootViewController:vc];
        UITabBarItem *item = nav.tabBarItem;
        item.title = itemModel.title;
        if (idx==2) {
            item.imageInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        }
        item.image = [UIImage imageNamed:itemModel.imageNamed];
        item.selectedImage = [UIImage imageNamed:itemModel.selectedImageNamed];
        //        [item setTitleTextAttributes:@{NSForegroundColorAttributeName : YJLightGreenColor} forState:UIControlStateSelected];
        [item setTitlePositionAdjustment:UIOffsetMake(0, -5)];
        if (idx==0) {
            self.currentNavigation = nav;
        }
        [navigationContrllers addObject:nav];
    }];
    DSTabBarBaseController * homeTabBarController = [[DSTabBarBaseController alloc] init];
    homeTabBarController.selectedIndex = 0;
    homeTabBarController.tabBar.tintColor = APP_MAIN_COLOR;
//    homeTabBarController.tabBar.barTintColor = [UIColor whiteColor];
    [homeTabBarController setViewControllers:navigationContrllers];
    return homeTabBarController;
}

/** 登录 */
- (void)goToLoginPage{
    DSLoginEntranceController * loginEntrance = [[DSLoginEntranceController alloc]init];
    RTRootNavigationController * nav = [[RTRootNavigationController alloc]initWithRootViewController:loginEntrance];
    nav.hidesBottomBarWhenPushed = YES;
    [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
}

/** 引导页 */
- (void)goToGuidancePage{
    YJGuideController * rootViewCtr = [[YJGuideController alloc] init];
    RTRootNavigationController *nav=[[RTRootNavigationController alloc]initWithRootViewController:rootViewCtr];
    nav.navigationBarHidden = YES;
    self.currentNavigation = nav;
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];  //设置主窗口 并可见
}

/** 广告页面 */
- (void)goToAdvertPage{
    JXAdvertisementController * rootViewCtr = [[JXAdvertisementController alloc] init];
    RTRootNavigationController *nav=[[RTRootNavigationController alloc]initWithRootViewController:rootViewCtr];
    nav.navigationBarHidden = YES;
    self.currentNavigation = nav;
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];  //设置主窗口 并可见
}

- (void)requestLaunchConfigure{
    [DSHttpResponseData LaunchInfoConfigure:^(id info, BOOL succeed, id extraInfo) {
        if (succeed) {
            if (info[@"data"]) {
                
                DSLaunchConfigureModel * model = [DSLaunchConfigureModel mj_objectWithKeyValues:info[@"data"]];
                [DSLaunchConfigureModel saveConfigureModel:model];
 
                NSString * updateTime = model.area.updateTime;
                NSString * url = model.area.url;
                double buyLimitPoint = model.orderUsePointMinAmountLimit.doubleValue;
                
                NSInteger localUpdateTime = [[NSUserDefaults standardUserDefaults]integerForKey:kAreaUpdateTimeKey];
                if (buyLimitPoint) {
                    [[NSUserDefaults standardUserDefaults] setDouble:buyLimitPoint forKey:kMinimumPurchasingPriceKey];
                    [[NSUserDefaults standardUserDefaults]synchronize];  //起购价
                }
                if (localUpdateTime==0||localUpdateTime!=updateTime.integerValue) {
                    //没有存储更新时间 或者 更新时间与本地存储的更新时间不一致 则更新地址
                    if ([url isNotBlank]) {
                        [DSHttpBase get:url parms:nil token:nil success:^(id json) {
                            if (json) {
                                //更新成功则存储新的更新时间值
                                [[NSUserDefaults standardUserDefaults]setInteger:updateTime.integerValue forKey:kAreaUpdateTimeKey];
                                NSData * data = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
                                [[DSAreaDataHelper shareInstance]saveAreaList:data]; //更新地址数据
                            }
                        } failture:^(id json) {
                            
                        }];
                    }
                }
                
            }
        }
    }];
}


/** 判断用户是否需要登录 并弹出提示框 */
- (BOOL)shouldShowLoginAlertViewInController:(DSBaseViewController *)controller{
    DSUserInfoModel * account = [JXAccountTool account];
    if ([account.access_token isNotBlank]==NO) {
        [DSAppDelegate goToLoginPage];
//        UIAlertController * alertController = [YJAlertView presentAlertWithTitle:@"您还未登录，请先登录" message:nil actionTitles:@[@"取消",@"登录"] preferredStyle:UIAlertControllerStyleAlert actionHandler:^(NSUInteger buttonIndex, NSString *buttonTitle) {
//            if (buttonIndex==1) {
//                [DSAppDelegate goToLoginPage];
//            }
//        }];
//        [controller presentViewController:alertController animated:YES completion:nil];
        return YES;
    }
    return NO;
}

//MARK: 添加用户截屏通知
- (void)addTakeScreenShotObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDidTakeScreenshot:)
                                                 name:UIApplicationUserDidTakeScreenshotNotification
                                               object:nil];
    
}

- (void)userDidTakeScreenshot:(NSNotification *)notification{
    if (_shareView !=nil) {
        [_shareView removeFromSuperview];
        _shareView = nil;
    }
    
    UIImage * snapshotImage = [self.window snapshotImage];
    UIImage * appendixImage = ImageString(@"public_snapshot_appendix");
    UIImage * shareImage = [self componseShareImageWithSnapShotImage:snapshotImage appendixImage:appendixImage];
    
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        params[@"image"] = shareImage;
        [[YJUMengShareHelper shareUMengHelper]shareToPlatform:platformType Params:params shareType:0];
    }];
    
}


/**< 将带有公司二维码的图片拼接至截图底部 */
- (UIImage *)componseShareImageWithSnapShotImage:(UIImage *)snapShotImage appendixImage:(UIImage *)appendixImage{
    CGFloat contextW = snapShotImage.size.width;
    CGFloat contentH = snapShotImage.size.height+appendixImage.size.height;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(contextW, contentH), NO, [UIScreen mainScreen].scale);
    [snapShotImage drawInRect:CGRectMake(0, 0, snapShotImage.size.width, snapShotImage.size.height)];//先把1.png 画到上下文中
    [appendixImage drawInRect:CGRectMake(0, snapShotImage.size.height, contextW, appendixImage.size.height)];//再把小图放在上下文中
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();//从当前上下文中获得最终图片
    UIGraphicsEndImageContext();//关闭上下文
    return resultImg;
}



@end
