//
//  DSItemModel.h
//  DaiShuYangLao
//
//  Created by YueLiang Song on 2018/8/30.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSBaseModel.h"

@interface DSItemModel : DSBaseModel

@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * icon;
@property (nonatomic, assign) BOOL disclosedEnable;
@property (nonatomic, assign) CGFloat itemHeight;

@property (nonatomic) Class className;


@end
