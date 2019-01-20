//
//  DSTableCellIItemModel.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/20.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSBaseModel.h"

@interface DSTableCellIItemModel : DSBaseModel

@property (nonatomic, copy) NSString * icon;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, assign) NSInteger accessoryType;
@property (nonatomic, copy) NSString * detailText;
@property (nonatomic, assign) CGFloat titleFontSize;
@property (nonatomic, assign) CGFloat detailTextFontSize;
@property (nonatomic, strong) UIColor * titleColor;
@property (nonatomic, strong) UIColor * detailTextColor;
@property (nonatomic, weak) Class className;

@end
