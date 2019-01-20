//
//  DSNewAddressController.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/5/30.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSBaseViewController.h"

@class DSUserAddress;
@interface DSNewAddressController : DSBaseViewController

@property (nonatomic, assign) BOOL edited;  /**< 是否是编辑地址页面 YES 编辑地址 NO 新建地址 */

@property (nonatomic, strong) DSUserAddress * addressModel;  /**< 待编辑的用户地址 */

@property (nonatomic, copy) completeBlock needRefreshBlock;

@end
