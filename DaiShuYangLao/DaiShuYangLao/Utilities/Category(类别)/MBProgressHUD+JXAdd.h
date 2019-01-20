//
//  MBProgressHUD+JXAdd.h
//  JXZX
//
//  Created by apple on 2017/9/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (JXAdd)

+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;


+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;
+ (void)showText:(NSString *)text toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message;

+ (void)hideHUDForView:(UIView *)view;
+ (void)hideHUD;

@end
