//
//  YJAlertView.m
//  YJRRT
//
//  Created by apple on 2017/8/1.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "YJAlertView.h"

@implementation YJAlertView

+ (UIAlertController *)presentAlertWithTitle:(NSString *)title message:(NSString *)message actionTitles:(NSArray <NSString *> *)actionTitles  preferredStyle:(UIAlertControllerStyle)preferredStyle actionHandler:(void(^)(NSUInteger buttonIndex, NSString *buttonTitle))actionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    if (actionTitles.count==0) {
        actionTitles = @[@"取消",@"确定"];
    }
    for (NSInteger i=0; i<actionTitles.count; i++) {
        UIAlertAction * action = [UIAlertAction actionWithTitle:actionTitles[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            actionHandler(i,actionTitles[i]);
        }];
        if(preferredStyle==UIAlertControllerStyleActionSheet&&actionTitles.count>=2&&i==actionTitles.count-1) {
            action = [UIAlertAction actionWithTitle:actionTitles[i] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                actionHandler(i,actionTitles[i]);
            }];
        }
        [alertController addAction:action];
    }
    return alertController;
}
@end
