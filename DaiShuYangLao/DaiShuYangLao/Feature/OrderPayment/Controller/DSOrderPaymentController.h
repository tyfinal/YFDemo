//
//  DSOrderPaymentController.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/4.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSBaseViewController.h"

@interface DSOrderPaymentController : DSBaseViewController

@property (nonatomic, copy) NSString * orderNumber;     /** 订单编号 */
@property (nonatomic, copy) NSString * pensionAmount;     /**< 使用的积分 */
@property (nonatomic, copy) NSString * totalAmount;     /**< 待支付总价 */
@property (nonatomic, copy) NSString * actualPayAmount; /**< 实际支付金额 */
@property (nonatomic, copy) NSString * goldAmount;      /**< 使用的购物金 */
@property (nonatomic, assign) NSInteger pagementWay;    /**< 支付方式 默认为 1 支付宝, 2 微信  默认为支付宝支付 */

@property (nonatomic, assign) NSInteger popControllerLevel; /** 返回第几层视图 popControllerLevel = 2 上一层  */

@end
