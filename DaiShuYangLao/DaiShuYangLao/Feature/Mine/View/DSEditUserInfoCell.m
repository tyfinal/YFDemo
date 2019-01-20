//
//  DSEditUserInfoCell.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/22.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSEditUserInfoCell.h"

@implementation DSEditUserInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _titleLabel.font = JXFont(15);
        _titleLabel.textColor = JXColorFromRGB(0x242424);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_titleLabel];
        
        _inputTF = [[UITextField alloc]initWithFrame:CGRectZero];
        _inputTF.hidden = YES;
        _inputTF.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_inputTF];
        
        _seperator = [[UIView alloc]initWithFrame:CGRectZero];
        _seperator.backgroundColor = JXColorFromRGB(0xc6c6c6);
        [self addSubview:_seperator];
        
        _avatarIV = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self addSubview:_avatarIV];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(15);
            make.size.mas_equalTo(CGSizeMake(70, 20));
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        
        [_avatarIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 60));
            make.right.equalTo(self.mas_right).with.offset(-45);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        [_inputTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_right).with.offset(15);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.height.mas_equalTo(40);
            make.right.equalTo(self.avatarIV.mas_right);
        }];
        
        [_seperator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.bottom.equalTo(self).with.offset(0);
            make.height.mas_equalTo(0.5);
        }];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
