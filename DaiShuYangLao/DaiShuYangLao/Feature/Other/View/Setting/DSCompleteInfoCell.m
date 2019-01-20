//
//  DSCompleteInfoCell.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/14.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSCompleteInfoCell.h"
#import "DSTextFieldModel.h"

@interface DSCompleteInfoCell()<UITextFieldDelegate>{
    
}

@end

@implementation DSCompleteInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.inputTextView = [[DSLoginInputView alloc]initWithFrame:CGRectZero];
        self.inputTextView.textField.delegate = self;
        [self.contentView addSubview:self.inputTextView];
        [self.inputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(55*ScreenAdaptFator_W);
            make.right.equalTo(self.contentView.mas_right).with.offset(-55*ScreenAdaptFator_W);
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.height.mas_equalTo(47);
        }];
    }
    return self;
}

- (void)setModel:(DSTextFieldModel *)model{
    _model = model;
    TextFiledDefaultLeftView * leftView = (TextFiledDefaultLeftView *) self.inputTextView.leftView;
    leftView.iconImageView.image = ImageString(model.iconName);
    self.inputTextView.textField.enabled = model.editEnable;
    self.inputTextView.textField.placeholder = model.placeholder;
    self.inputTextView.textField.text = model.text;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    textField.text = [textField.text stringByTrim]; //裁剪掉两边的空白
    _model.text = textField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
