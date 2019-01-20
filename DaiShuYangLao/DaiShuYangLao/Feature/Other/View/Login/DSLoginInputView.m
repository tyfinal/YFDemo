//
//  DSLoginInputView.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/5/25.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSLoginInputView.h"
#import "NSString+MKExtension.h"

@interface DSLoginInputView()<UITextFieldDelegate>{
    
}



@end

@implementation DSLoginInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentView = [[UIView alloc]initWithFrame:CGRectZero];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.mas_key = @"inputcontent";
        [self addSubview:self.contentView];
        
        _textField = [[UITextField alloc]initWithFrame:CGRectZero];
        _textField.font = JXFont(15);
        _textField.delegate = self;
        _textField.textColor = JXColorFromRGB(0x333333);
        _textField.mas_key = @"textfield";
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        _leftView = [[TextFiledDefaultLeftView alloc]initWithFrame:CGRectMake(0, 0, 40, 31)];
        _leftImageView = [(TextFiledDefaultLeftView *)_leftView iconImageView];
        _textField.leftViewMode = UITextFieldViewModeAlways;
        _textField.leftView = _leftView;
        
        [self.contentView addSubview:_textField];
        
        _line = [[UILabel alloc]initWithFrame:CGRectZero];
        _line.mas_key = @"line";
        _line.backgroundColor = JXColorFromRGB(0xd9d9d9);
        [self.contentView addSubview:_line];
//        _line.mas_key = [NSString stringWithFormat:@"line_%ld_key",i];
        
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).with.insets(UIEdgeInsetsZero);
        }];
        
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.and.top.equalTo(self.contentView);
            make.height.mas_equalTo(33);
        }];
        
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(0);
            make.right.equalTo(self.contentView.mas_right).with.offset(0);
            make.height.mas_equalTo(2);
            make.top.equalTo(self.textField.mas_bottom).with.offset(3);
        }];
    
    }
    return self;
}

- (void)setRightView:(UIView *)rightView{
    _rightView = rightView;
    if (rightView) {
        self.textField.rightView = _rightView;
        self.textField.rightViewMode = UITextFieldViewModeAlways;
    }else{
        self.textField.rightViewMode = UITextFieldViewModeNever;
    }
}

- (void)setLeftView:(UIView *)leftView{
    _leftView = leftView;
    if (leftView) {
        self.textField.leftView = _leftView;
        self.textField.leftViewMode = UITextFieldViewModeAlways;
    }else{
        _leftImageView = nil;
        self.textField.leftViewMode = UITextFieldViewModeNever;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

@implementation TextFiledDefaultLeftView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentView = [[UIView alloc]initWithFrame:CGRectZero];
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.contentView];
        
        _tipsLabel = [[UILabel alloc]init];
        _tipsLabel.font = JXFont(15);
        _tipsLabel.textColor = JXColorFromRGB(0x231c12);
        _tipsLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_tipsLabel];
        
        _iconImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_iconImageView];
        
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.bottom.equalTo(self).priorityLow();
        }];
        
        [_tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.height.mas_equalTo(20);
            make.left.equalTo(self.contentView.mas_left).with.offset(10);
            make.right.lessThanOrEqualTo(self.contentView.mas_right).with.offset(-10);
        }];
        
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(25, 25));
            make.left.equalTo(self.contentView.mas_left).with.offset(0);
        }];
        
    }
    return self;
}

@end


@implementation TextFieldDefaultRightView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentView = [[UIView alloc]initWithFrame:CGRectZero];
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.contentView];
        
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setTitle:@"发送验证码" forState:UIControlStateNormal];
        _button.titleLabel.font = JXFont(15);
        [_button setTitleColor:JXColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [self.contentView addSubview:_button];
        
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.bottom.equalTo(self).priorityLow();
        }];

        [_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.top.and.bottom.equalTo(self.contentView);
            make.left.equalTo(self.contentView.mas_left).with.offset(0);
            make.right.equalTo(self.contentView.mas_right);
        }];
        
    }
    return self;
}

@end



