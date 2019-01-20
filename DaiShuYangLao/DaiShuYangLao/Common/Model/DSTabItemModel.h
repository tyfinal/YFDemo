//
//  JXTabItemModel.h
//  JXZX
//
//  Created by apple on 2017/8/29.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "DSBaseModel.h"

@interface DSTabItemModel : DSBaseModel

@property (nonatomic, weak) Class className;

@property (nonatomic, copy) NSString * title;

@property (nonatomic, copy) NSString * selectedImageNamed;

@property (nonatomic, copy) NSString * imageNamed;

/** 首页底部tabbar */
+ (NSArray *)createHomeTabItems;

@end
