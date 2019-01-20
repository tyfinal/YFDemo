//
//  DSWithdrawCashController.h
//  DaiShuYangLao
//
//  Created by YueLiang Song on 2018/7/19.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSBaseViewController.h"
@class DSWithdrawCashConfigureModel;

@interface DSWithdrawCashController : DSBaseViewController

@property (nonatomic, copy) NSString * availablePoint;  /**< 可提现积分 */
@property (nonatomic, assign) NSInteger withdrawWay;    /**< 提现方式 1支付宝 2微信 */
@property (nonatomic, strong) DSWithdrawCashConfigureModel * configureModel;



@end
