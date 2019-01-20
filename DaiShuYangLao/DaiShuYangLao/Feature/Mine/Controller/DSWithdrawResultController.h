//
//  DSWithdrawResultController.h
//  DaiShuYangLao
//
//  Created by YueLiang Song on 2018/7/23.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSBaseViewController.h"

@class DSWithdrawCashConfigureModel;
@interface DSWithdrawResultController : DSBaseViewController

@property (nonatomic, strong) NSString * accountName;
@property (nonatomic, strong) NSString * withdrawAmount;
@property (nonatomic, strong) DSWithdrawCashConfigureModel * configreModel;

@end
