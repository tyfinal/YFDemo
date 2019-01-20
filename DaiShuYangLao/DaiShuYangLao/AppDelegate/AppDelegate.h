//
//  AppDelegate.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/5/23.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSTabBarBaseController.h"
#import <AFNetworking.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (nonatomic, strong) RTRootNavigationController * currentNavigation;
@property (nonatomic, strong) DSTabBarBaseController * tabBarController;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) AFNetworkReachabilityStatus  netStatus;

@end

