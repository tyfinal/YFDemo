//
//  DSNewAddressTabelCell.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/5/30.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSNewAddressTabelCell.h"
#import "DSTextFieldModel.h"

@interface DSNewAddressTabelCell()<UITextFieldDelegate>{
    
}

@property (nonatomic, assign) BOOL didSetupLayout;

@end

@implementation DSNewAddressTabelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _titleLabel.font = JXFont(15.0F);
        _titleLabel.textColor = JXColorFromRGB(0x231c12);
        [self.contentView addSubview:_titleLabel];
        
        _contentTF = [[UITextField alloc]initWithFrame:CGRectZero];
//        _contentTF.textColor = JXColorFromRGB(0xb2b0af);
        _contentTF.font = JXFont(15.0);
        [_contentTF addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        _contentTF.borderStyle = UITextBorderStyleNone;
        _contentTF.delegate = self;
        [self.contentView addSubview:_contentTF];
        
        _lineLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _lineLabel.backgroundColor = JXColorFromRGB(0xbebebf);
        [self addSubview:_lineLabel];
        
        _addressSwitch = [[UISwitch alloc]initWithFrame:CGRectZero];
        _addressSwitch.hidden = YES;
        _addressSwitch.on = NO;
        _addressSwitch.onTintColor = APP_MAIN_COLOR;
        [_addressSwitch addTarget:self action:@selector(changeSwitchStatus:) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:_addressSwitch];
        
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
        
    }
    return self;
}

- (void)updateConstraints{
    if (!_didSetupLayout) {
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(15);
            make.height.mas_equalTo(15+kLabelHeightOffset);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.mas_equalTo(71);
        }];
        
        [_contentTF mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_right).with.offset(12);
            make.height.mas_equalTo(31);
            make.centerY.equalTo(self.titleLabel.mas_centerY);
            make.right.equalTo(self.contentView.mas_right).with.offset(-50);
        }];
        
        [_addressSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView.mas_right).with.offset(-70);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        
        [_lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.and.bottom.equalTo(self);
            make.height.mas_equalTo(.5);
        }];
        
        _didSetupLayout = YES;
    }
    
    [super updateConstraints];
}

- (void)setModel:(DSTextFieldModel *)model{
    _model = model;
    self.contentTF.enabled = model.editEnable;
    if([model.key isEqualToString:@"phone"]||[_model.key isEqualToString:@"postcode"]) self.contentTF.keyboardType = UIKeyboardTypePhonePad;
    self.titleLabel.text = model.tipsTitle;
    self.contentTF.placeholder = model.placeholder;
    self.contentTF.text = model.text;
    if ([model.key isEqualToString:@"def"]) {
        self.addressSwitch.on = model.text.boolValue;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    _model.text = textField.text;
}

- (void)textFieldChanged:(UITextField *)textField{
    if ([_model.key isEqualToString:@"phone"]) {
        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
        }
    }else if ([_model.key isEqualToString:@"postcode"]){
        if (textField.text.length > 6) {
            textField.text = [textField.text substringToIndex:6];
        }
    }
}

- (void)changeSwitchStatus:(UISwitch *)aSwitch{
    _model.text = [NSString stringWithFormat:@"%d",aSwitch.on];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
