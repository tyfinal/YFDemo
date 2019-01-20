//
//  DSClassificationDetailController.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/2.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSBaseViewController.h"

@interface DSClassificationDetailController : DSBaseViewController

@property (nonatomic, copy) NSString * classificationId;
@property (nonatomic, copy) NSString * searchWord;
@property (nonatomic, copy) NSString * specialClassfication; /**< 1 栏目列表 2banner列表 */

@end
