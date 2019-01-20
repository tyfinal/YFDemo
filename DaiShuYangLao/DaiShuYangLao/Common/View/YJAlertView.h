//
//  YJAlertView.h
//  YJRRT
//
//  Created by apple on 2017/8/1.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YJAlertView : NSObject

+ (UIAlertController *)presentAlertWithTitle:(NSString *)title message:(NSString *)message actionTitles:(NSArray <NSString *> *)actionTitles  preferredStyle:(UIAlertControllerStyle)preferredStyle actionHandler:(void(^)(NSUInteger buttonIndex, NSString *buttonTitle))actionHandler;

@end
