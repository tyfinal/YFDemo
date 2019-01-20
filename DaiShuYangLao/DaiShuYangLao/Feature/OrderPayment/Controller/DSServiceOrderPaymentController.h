//
//  DSServiceOrderPaymentController.h
//  DaiShuYangLao
//
//  Created by YueLiang Song on 2018/10/18.
//  Copyright © 2018 tyfinal. All rights reserved.
//

#import "DSBaseViewController.h"

@interface DSServiceOrderPaymentController : DSBaseViewController
@property (nonatomic, strong) NSArray * checkingOutArray;
@property (nonatomic, copy) NSString * totalAmount; /**< 待支付总价 */
@end

