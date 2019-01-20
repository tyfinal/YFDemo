//
//  UIWindow+VisibleController.h
//  DaiShuYangLao
//
//  Created by YueLiang Song on 2018/9/29.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIWindow (VisibleController)

- (UIViewController *)visibleViewController;

+ (UIViewController *)getVisibleViewControllerFrom:(UIViewController *) vc;

@end

NS_ASSUME_NONNULL_END
