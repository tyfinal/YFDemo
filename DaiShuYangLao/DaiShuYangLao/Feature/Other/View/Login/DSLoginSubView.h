//
//  DSLoginSubView.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/5/25.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DSLoginInputView;
@class DSLoginSubView;

//typedef void(^LoginSubViewButtonClickHandle)(UIButton * button,DSLoginSubView * loginView);

@interface DSLoginSubView : UIView

@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) UITextField * phoneTextField;
@property (nonatomic, strong) UITextField * passwordTextField;
@property (nonatomic, strong) UIButton * loginButton;
@property (nonatomic, strong) UIButton * resetPasswordButton;
@property (nonatomic, strong) DSLoginInputView * phoneInputView;
@property (nonatomic, strong) DSLoginInputView * passwordInputView;
@property (nonatomic, copy) ButtonClickHandle forgetPasswordButtonHandle;
@property (nonatomic, copy) ButtonClickHandle loginButtonHandle;

- (void)clearAllText;

@end
