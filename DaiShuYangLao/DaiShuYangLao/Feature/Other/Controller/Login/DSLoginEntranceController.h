//
//  DSLoginEntranceController.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/5/24.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSBaseViewController.h"

@interface DSLoginEntranceController : DSBaseViewController

@property (nonatomic, copy) void(^DidLoginSucceed)(void);

@end
