//
//  AppDelegate+Helper.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/5/23.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "AppDelegate.h"

@class DSBaseViewController;
@interface AppDelegate (Helper)<UITabBarControllerDelegate>

/** 跳转制定tab页面并传递参数 */
- (void)goToHomePageWithIndex:(NSInteger)index params:(id)params;

/** 跳转到指定tab页面 */
- (void)goToHomePageWithIndex:(NSInteger)index;

/** 进入首页 */
- (void)goToHomePage;

/** 登录 */
- (void)goToLoginPage;

/** 引导页 */
- (void)goToGuidancePage;

/** 广告页面 */
- (void)goToAdvertPage;

/** 请求启动配置 */
- (void)requestLaunchConfigure;

///**< 是否需要登录 */
//- (void)accessTokenValidityCheck;

//添加用户截屏通知
- (void)addTakeScreenShotObserver;

/** 判断用户是否需要登录 并弹出提示框 */
- (BOOL)shouldShowLoginAlertViewInController:(DSBaseViewController *)controller;


@end
