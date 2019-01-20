//
//  DSLoginInputView.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/5/25.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TextFiledDefaultLeftView;
@class TextFieldDefaultRightView;

@interface DSLoginInputView : UIView

@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) UITextField * textField;
@property (nonatomic, strong) UILabel * line;

@property (nonatomic, strong) UIView * rightView;
@property (nonatomic, strong) UIView * leftView;

@property (nonatomic, strong) UIImageView * leftImageView; //设置 leftView为空时 leftiamgeview也会被置空

@property (nonatomic, strong) UIButton * rightButton;  //设置 rightView为空时 rightButton也会被置空

@end

@interface TextFiledDefaultLeftView : UIView

@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) UIImageView * iconImageView;
@property (nonatomic, strong) UILabel * tipsLabel;

@end

@interface TextFieldDefaultRightView : UIView

@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) UIButton * button;

@end






