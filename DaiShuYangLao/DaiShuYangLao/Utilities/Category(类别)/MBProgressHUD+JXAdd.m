//
//  MBProgressHUD+JXAdd.m
//  JXZX
//
//  Created by apple on 2017/9/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "MBProgressHUD+JXAdd.h"
@implementation MBProgressHUD (JXAdd)

#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    // Prepare by adding to the top window.
    if(!view){
        NSEnumerator *frontToBackWindows = [[[UIApplication sharedApplication] windows] reverseObjectEnumerator];
        
        for (UIWindow *window in frontToBackWindows) {
            if (window.windowLevel == UIWindowLevelNormal) {
                view = window;
                break;
            }
        }
    }
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    //    [hud setUserInteractionEnabled:NO];
    hud.label.text = text;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    hud.userInteractionEnabled = NO;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hideAnimated:YES afterDelay:0.7];
}

#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"error.png" view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"success.png" view:view];
}

#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    if(!view){
        NSEnumerator *frontToBackWindows = [[[UIApplication sharedApplication] windows] reverseObjectEnumerator];
        
        for (UIWindow *window in frontToBackWindows) {
            if (window.windowLevel == UIWindowLevelNormal) {
                view = window;
                break;
            }
        }
    }
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    //    hud.dimBackground = YES;
    //    [hud hide:YES afterDelay:];
    return hud;
}

+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil];
}

+ (void)showError:(NSString *)error
{
    [self showError:error toView:nil];
}

+ (void)showText:(NSString *)text toView:(UIView *)view{
    
    if(!view){
        NSEnumerator *frontToBackWindows = [[[UIApplication sharedApplication] windows] reverseObjectEnumerator];
        
        for (UIWindow *window in frontToBackWindows) {
            if (window.windowLevel == UIWindowLevelNormal) {
                view = window;
                break;
            }
        }
    }
    [self hideHUD];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.margin = 10.0f;
    //    hud.yOffset = boundsHeight/2 -30;
    hud.mode = MBProgressHUDModeText;
    hud.label.text = text;
    [view addSubview:hud];
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:1.5];
    
}

+ (MBProgressHUD *)showMessage:(NSString *)message
{
    return [self showMessage:message toView:nil];
}

+ (void)hideHUDForView:(UIView *)view
{
    [self hideHUDForView:view animated:YES];
}

+ (void)hideHUD
{
    [self hideHUDForView:nil];
}


@end
