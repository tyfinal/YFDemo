//
//  DSBindingPhoneController.h
//  DaiShuYangLao
//
//  Created by YueLiang Song on 2018/9/1.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSBaseViewController.h"

@interface DSBindingPhoneController : DSBaseViewController

@property (nonatomic, copy) NSString * uid;
@property (nonatomic, assign) NSInteger loginway; /**< 登录方式 1 微信 2 qq 3 微博 */

@end
