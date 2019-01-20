//
//  DSWithdrawInputCell.h
//  DaiShuYangLao
//
//  Created by YueLiang Song on 2018/7/19.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DSLoginInputView;
@interface DSWithdrawInputCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic, strong) DSLoginInputView * ds_inputView;
@property (nonatomic, strong) UIView * seperator;
@property (nonatomic, strong) DSTextFieldModel * textModel;
@property (nonatomic, copy) ButtonClickHandle requestForVerificationCode;

@end
