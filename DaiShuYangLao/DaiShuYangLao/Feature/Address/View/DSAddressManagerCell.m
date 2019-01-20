//
//  DSAddressManagerCell.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/5/30.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSAddressManagerCell.h"
#import "DSUserAddress.h"
#import "DSAreaModel.h"

@interface DSAddressManagerCell(){
    
}

@property (nonatomic, assign) BOOL didSetupLayout;

@end

@implementation DSAddressManagerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        NSArray * fontSizes = @[JXFont(15),JXFont(14),JXFont(13)];
        NSArray * textColors = @[JXColorFromRGB(0x484747),JXColorFromRGB(0x484747),JXColorFromRGB(0x484747)];
        for (NSInteger i=0; i<3; i++) {
            UILabel * label = [[UILabel alloc]init];
            label.font = fontSizes[i];
            label.textColor = textColors[i];
            label.textAlignment = NSTextAlignmentLeft;
            [self.contentView addSubview:label];
            if(i==0) self.userNameLabel = label;
            if(i==1) self.phoneLabel = label;
            if(i==2) {
                self.addressLabel = label;
                //label.numberOfLines = 0;
            }
        }
        
        _defaultAddressButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_defaultAddressButton setTitle:@"设为默认" forState:UIControlStateNormal];
        [_defaultAddressButton setTitle:@"默认地址" forState:UIControlStateNormal];
        [_defaultAddressButton addTarget:self action:@selector(setDefaultAddress) forControlEvents:UIControlEventTouchUpInside];
        _defaultAddressButton.adjustsImageWhenHighlighted = NO;
        _defaultAddressButton.adjustsImageWhenDisabled = NO;
//        _defaultAddressButton.enabled = NO;
        _defaultAddressButton.titleLabel.font = JXFont(12);
        [_defaultAddressButton setTitleColor:JXColorFromRGB(0x999999) forState:UIControlStateNormal];
        [_defaultAddressButton setTitleColor:APP_MAIN_COLOR forState:UIControlStateSelected];
        [_defaultAddressButton setImage:ImageString(@"address_defaultaddress_n") forState:UIControlStateNormal];
        [_defaultAddressButton setImage:ImageString(@"address_defaultaddress_s") forState:UIControlStateSelected];
        [_defaultAddressButton setImagePosition:LXMImagePositionLeft spacing:15];
        [self.contentView addSubview:_defaultAddressButton];

        NSArray * imageNames = @[@"public_edit",@"public_delete"];
        for (NSInteger i=0; i<2; i++) {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self action:@selector(addressManage:) forControlEvents:UIControlEventTouchUpInside];
            [button setImage:ImageString(imageNames[i]) forState:UIControlStateNormal];
            button.tag = 10+i;
            if(i==0) self.editButton = button;
            if(i==1) self.deleteButton = button;
            [self.contentView addSubview:button];
        }
        
        _line = [[UILabel alloc]initWithFrame:CGRectZero];
        _line.backgroundColor = JXColorFromRGB(0xbebebf);
        [self.contentView addSubview:_line];
        
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
        
    }
    return self;
}

- (void)setAddressModel:(DSUserAddress *)addressModel{
    _addressModel = addressModel;
    self.userNameLabel.text = _addressModel.name;
    self.phoneLabel.text = [self encodePhoneNumber:addressModel.phone];
    NSMutableString * areaMuString = [NSMutableString string];
    if ([addressModel.province.code isNotBlank]) {
        [areaMuString appendFormat:@"%@",addressModel.province.name];
    }
    if ([addressModel.city.code isNotBlank]) {
        [areaMuString appendFormat:@"%@",addressModel.city.name];
    }
    if ([addressModel.district.code isNotBlank]) {
        [areaMuString appendFormat:@"%@",addressModel.district.name];
    }
    
    if ([addressModel.address isNotBlank]) {
        [areaMuString appendFormat:@"%@",addressModel.address];
    }
    
    self.addressLabel.text = areaMuString;
    self.defaultAddressButton.selected = addressModel.def.boolValue;
}

- (NSString *)encodePhoneNumber:(NSString *)phone{
    if ([phone isNotBlank]) {
        phone = [phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }
    return phone;
}

- (void)addressManage:(UIButton *)button{
    if (self.addressButtonClickHandle) {
        self.addressButtonClickHandle(button, self);
    }
}

- (void)setDefaultAddress{
    if (self.UpdateAddressDefaultStatusHandle) {
        self.UpdateAddressDefaultStatusHandle(_indexPath, _addressModel);
    }
}

- (void)updateConstraints{
    if (!_didSetupLayout) {
        
//        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.top.equalTo(self);
//            make.bottom.equalTo(self).priorityLow();
//        }];
        
        [_userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(26);
            make.top.equalTo(self.contentView.mas_top).with.offset(21-kLabelHeightOffset/2.0);
            make.height.mas_equalTo(kLabelHeightOffset+15);
        }];
        
        [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(15+kLabelHeightOffset);
            make.centerY.equalTo(self.userNameLabel.mas_centerY);
            make.left.equalTo(self.userNameLabel.mas_right).with.offset(15);
            make.right.lessThanOrEqualTo(self.contentView.mas_right).with.offset(-34);
        }];
        
        [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(kLabelHeightOffset+15);
            make.left.equalTo(self.userNameLabel.mas_left);
            make.right.equalTo(self.contentView.mas_right).with.offset(-34);
            make.top.equalTo(self.userNameLabel.mas_bottom).with.offset(11-kLabelHeightOffset);
        }];
        
        [_defaultAddressButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(10);
            make.height.mas_equalTo(35);
            make.width.mas_equalTo(100);
            make.centerY.equalTo(self.contentView.mas_bottom).with.offset(-27);
        }];
        
        [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.centerY.equalTo(self.defaultAddressButton.mas_centerY);
            make.centerX.equalTo(self.contentView.mas_right).with.offset(-35);
        }];
        
        [_editButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.centerY.equalTo(self.defaultAddressButton.mas_centerY);
            make.centerX.equalTo(self.deleteButton.mas_centerX).with.offset(-44);
        }];
        
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.5);
            make.left.bottom.and.right.equalTo(self.contentView);
        }];
        
        _didSetupLayout = YES;
        
    }
    [super updateConstraints];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
