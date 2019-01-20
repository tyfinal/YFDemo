//
//  DSAreaPickerView.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/12.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DSAreaModel;

@interface DSAreaPickerView : UIView

@property (nonatomic, strong) UIPickerView * pickerView;
@property (nonatomic, strong) NSArray * dataArray;
@property (nonatomic, copy) void(^AddressPickerClickButtonAtIndex)(NSInteger buttonIndex,NSMutableDictionary * addressDic);

- (void)reloadData;

@end
