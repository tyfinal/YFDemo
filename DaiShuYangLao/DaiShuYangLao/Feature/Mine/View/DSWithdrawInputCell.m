//
//  DSWithdrawInputCell.m
//  DaiShuYangLao
//
//  Created by YueLiang Song on 2018/7/19.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSWithdrawInputCell.h"
#import "DSLoginInputView.h"

@implementation DSWithdrawInputCell
static TextFieldDefaultRightView * _rightView = nil;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.ds_inputView = [[DSLoginInputView alloc]initWithFrame:CGRectZero];
        self.ds_inputView.textField.delegate = self;
        [self.ds_inputView.textField addTarget:self action:@selector(limitTextLength:) forControlEvents:UIControlEventAllEditingEvents];
        [self.contentView addSubview:self.ds_inputView];
        
        self.seperator = [[UIView alloc]initWithFrame:CGRectZero];
        self.seperator.hidden = YES;
        self.seperator.backgroundColor = JXColorFromRGB(0xe4e4e4);
        [self.contentView addSubview:self.seperator];
        
        [self.ds_inputView.textField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.ds_inputView.contentView.mas_centerY);
        }];
        
        [self.ds_inputView.line mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(1.0f);
            make.bottom.equalTo(self.ds_inputView.contentView).with.offset(0);
            make.left.and.right.equalTo(self.ds_inputView.contentView);
        }];
        
        [self.ds_inputView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(30);
            make.right.equalTo(self.contentView.mas_right).with.offset(0);
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.height.mas_equalTo(50);
        }];
        
        [self.seperator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.and.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(1.0);
        }];
    }
    return self;
}

- (void)setTextModel:(DSTextFieldModel *)textModel{
    _textModel = textModel;
    self.ds_inputView.textField.keyboardType = UIKeyboardTypeDefault;
    if ([textModel.key isEqualToString:@"amount"]) {
        self.ds_inputView.textField.keyboardType = UIKeyboardTypeDecimalPad;
    }else if ([textModel.key isEqualToString:@"code"]){
        self.ds_inputView.textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    self.ds_inputView.textField.text = textModel.text;
    self.ds_inputView.textField.placeholder = textModel.placeholder;
    self.ds_inputView.leftView = nil;
    if ([textModel.key isEqualToString:@"code"]) {
        if (!_rightView) {
            TextFieldDefaultRightView * rightView = [[TextFieldDefaultRightView alloc]initWithFrame:CGRectMake(0, 0, ceil(120*(ScreenAdaptFator_W)), 31)];
            [rightView.button setBackgroundImage:ImageString(@"login_getverifycation") forState:UIControlStateNormal];
            rightView.button.titleLabel.font = JXFont(12.0);
            [rightView.button mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(30);
                make.right.equalTo(rightView.contentView.mas_right).with.offset(-ceil(20*ScreenAdaptFator_W));
                make.width.mas_equalTo(rightView.button.mas_height).multipliedBy(6);
            }];
            [rightView.button addTarget:self action:@selector(requestVerification:) forControlEvents:UIControlEventTouchUpInside];
            _rightView = rightView;
        }
        self.ds_inputView.rightView = _rightView;
    }else{
        self.ds_inputView.rightView = nil;
    }
}

- (void)limitTextLength:(UITextField *)textField{
    if ([self.textModel.key isEqualToString:@"code"]) {
        if (textField.text.length > 6) {
            textField.text = [textField.text substringToIndex:6];
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.textModel.text = textField.text;
}

- (void)requestVerification:(UIButton *)verificationButton{
    if (self.requestForVerificationCode) {
        self.requestForVerificationCode(verificationButton, self);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc{
    _rightView = nil;
}

@end
