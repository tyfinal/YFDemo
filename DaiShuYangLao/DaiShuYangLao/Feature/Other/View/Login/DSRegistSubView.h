//
//  DSRegistSubView.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/5/25.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSBaseViewController.h"

@class DSLoginInputView;

@interface DSRegistSubView : UIView

@property (nonatomic, strong) UIView * contentView;

@property (nonatomic, strong) UITextField * phoneTextField;
@property (nonatomic, strong) UITextField * verificationCodeTextField;
@property (nonatomic, strong) UITextField * passwordTextField;
@property (nonatomic, strong) UIButton * registButton;

@property (nonatomic, strong) YYLabel * agreementLabel;
@property (nonatomic, strong) DSLoginInputView * phoneInputView;
@property (nonatomic, strong) DSLoginInputView * verificationCodeInputView;
@property (nonatomic, strong) DSLoginInputView * passwordInputView;

@property (nonatomic, copy) ButtonClickHandle nextStepHandle;
@property (nonatomic, copy) ButtonClickHandle applyForVerificationCodeHandle;

@property (nonatomic, strong) DSBaseViewController * superController;

- (void)clearAllText;

- (void)startTimer;

- (void)stopTime;

@end



