//
//  DSAddressManagerController.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/5/30.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSBaseViewController.h"
@class DSUserAddress;
@interface DSAddressManagerController : DSBaseViewController

@property (nonatomic, copy) void(^DidSelectedAddressHandle)(DSUserAddress * addressModel);

@end
