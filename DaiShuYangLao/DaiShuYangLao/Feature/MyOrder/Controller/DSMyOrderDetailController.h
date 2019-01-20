//
//  DSMyOrderDetailController.h
//  DaiShuYangLao
//
//  Created by YueLiang Song on 2018/7/10.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSBaseViewController.h"

@interface DSMyOrderDetailController : DSBaseViewController

@property (nonatomic, copy) NSString * orderId; /**< 订单id */

@property (nonatomic, copy) void(^DidUpdateOrderStatus)(DSOrderRequestType status);

@end
