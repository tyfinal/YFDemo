//
//  DSCompleteInfoCell.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/14.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSLoginInputView.h"
@class DSTextFieldModel;

@interface DSCompleteInfoCell : UITableViewCell

@property (nonatomic, strong) DSLoginInputView * inputTextView;

@property (nonatomic, strong) DSTextFieldModel * model;

@end
