//
//  DSSettingEntranceTableCell.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/5/30.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSSettingEntranceTableCell.h"

@implementation DSSettingEntranceTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end


@interface SettingEntranceUserInfoCell(){
    
}

@property (nonatomic, assign) BOOL didSetupLayout;
//@property (nonatomic, strong) <#Class#> * <#object#>;

@end

@implementation  SettingEntranceUserInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.avatarIV = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:self.avatarIV];
        
        _userNameLabel = [[UILabel alloc]init];
        _userNameLabel.font = JXFont(12);
        _userNameLabel.textColor = JXColorFromRGB(0x383838);
        _userNameLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_userNameLabel];
        
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
        
        [self layoutIfNeeded];
        self.avatarIV.layer.cornerRadius = 35.0f;
        self.avatarIV.layer.masksToBounds = YES;
    }
    return self;
}

- (void)updateConstraints{
    if (!_didSetupLayout) {
        [self.avatarIV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(70, 70));
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.contentView.mas_left).with.offset(15);
        }];
        
        [self.userNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatarIV.mas_right).with.offset(10);
            make.height.mas_equalTo(20);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.equalTo(self.contentView.mas_right).with.offset(-50);
        }];
        _didSetupLayout = YES;
    }
    [super updateConstraints];
}

@end



