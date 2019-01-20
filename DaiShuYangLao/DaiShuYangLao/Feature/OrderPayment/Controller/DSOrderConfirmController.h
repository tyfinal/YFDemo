//
//  DSOrderConfirmController.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/4.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSBaseViewController.h"

@interface DSOrderConfirmController : DSBaseViewController

@property (nonatomic, strong) NSArray * checkingOutArray;
@property (nonatomic, copy) NSString * totalAmount; /**< 待支付总价 */


@end
