//
//  DSNewLoginSubView.h
//  DaiShuYangLao
//
//  Created by YueLiang Song on 2018/8/31.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DSLoginInputView;
@interface DSNewLoginSubView : UIView

@property (nonatomic, strong) UIView * contentView;

@property (nonatomic, strong) DSLoginInputView * phoneInputView;
@property (nonatomic, strong) DSLoginInputView * passwordInputView;
//@property (nonatomic, strong) UIButton *
@property (nonatomic, strong) UIButton * registButton;
@property (nonatomic, strong) UIButton * changeLoginWayButton;
@property (nonatomic, strong) UIButton * loginButton;
@property (nonatomic, strong) UIButton * resetPasswordButton;
@property (nonatomic, strong) UIButton * sendVerificationCodeButton;

@property (nonatomic, assign) NSInteger loginWay;  /**< 1验证码登录 2账号登录 */

@property (nonatomic, copy) ButtonClickHandle registHandle;  /**< 注册 */
@property (nonatomic, copy) ButtonClickHandle resetPasswordHandle; /**< 忘记密码 */
@property (nonatomic, copy) ButtonClickHandle applyForVerificationCodeHandle; /**< 获取验证码 */
@property (nonatomic, copy) ButtonClickHandle loginHandle;

- (void)startTimer;

- (void)stopTime; 

@end

