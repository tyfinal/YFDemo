//
//  DSPensionDetailModel.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/28.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSPensionDetailModel : NSObject

@property (nonatomic, copy) NSString * point;
@property (nonatomic, copy) NSString * date;
@property (nonatomic, copy) NSString * info;
@property (nonatomic, copy) NSString * balance;
@property (nonatomic, strong) NSNumber * type;
@property (nonatomic, copy) NSString * amount;
@property (nonatomic, copy) NSString * subInfo;

@end
