//
//  DSOrderPayResultHandleController.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/7/4.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSBaseViewController.h"

@interface DSOrderPayResultHandleController : DSBaseViewController

@property (nonatomic, assign) NSInteger payStatus; /**< -1失败 0 成功 1取消 */
@property (nonatomic, copy) NSString * orderNumber;
@property (nonatomic, copy) NSString * pensionAmount;
@property (nonatomic, copy) NSString * goldAmount;
@property (nonatomic, assign) NSInteger pagementWay;    /**< 支付方式 默认为 1 支付宝, 2 微信  默认为支付宝支付 */

//返回第几级视图  popControllerLevel = 3 上上层
@property (nonatomic, assign) NSInteger popControllerLevel;  /** 返回第几层视图 popControllerLevel = 2 上一层  */

@property (nonatomic, assign) BOOL isMembershipUpgrade;  /**< 是否是会员升级 */


@end
