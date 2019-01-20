//
//  UIWindow+VisibleController.m
//  DaiShuYangLao
//
//  Created by YueLiang Song on 2018/9/29.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "UIWindow+VisibleController.h"

@implementation UIWindow (VisibleController)

- (UIViewController *)visibleViewController {
    UIViewController *rootViewController = self.rootViewController;
    return [UIWindow getVisibleViewControllerFrom:rootViewController];
}

+ (UIViewController *) getVisibleViewControllerFrom:(UIViewController *) vc {
    if ([vc isKindOfClass:[RTRootNavigationController class]]) {
        return [UIWindow getVisibleViewControllerFrom:[((RTRootNavigationController *) vc) rt_visibleViewController]];
    }else if ([vc isKindOfClass:[UINavigationController class]]) {
        return [UIWindow getVisibleViewControllerFrom:[((UINavigationController *) vc) visibleViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [UIWindow getVisibleViewControllerFrom:[((UITabBarController *) vc) selectedViewController]];
    } else {
        if (vc.presentedViewController) {
            return [UIWindow getVisibleViewControllerFrom:vc.presentedViewController];
        } else {
            return vc;
        }
    }
}

@end
