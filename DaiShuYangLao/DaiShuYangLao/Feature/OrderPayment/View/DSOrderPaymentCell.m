//
//  DSOrderPaymentCell.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/4.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSOrderPaymentCell.h"

@implementation DSOrderPaymentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end


@implementation PaymentOrderInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //小圆点
        _dotImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:_dotImageView];
        
        //提示文字
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = JXFont(15);
        _titleLabel.textColor = JXColorFromRGB(0x5f5f5f);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_titleLabel];
        
        //金额
        _amountLabel = [[UILabel alloc]init];
        _amountLabel.font = JXFont(14);
        _amountLabel.textColor = JXColorFromRGB(0x333333);
        _amountLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_amountLabel];
        
        self.seperator = [[UIView alloc]initWithFrame:CGRectZero];
        self.seperator.backgroundColor = JXColorFromRGB(0xdcdcdc);
        [self.contentView addSubview:self.seperator];
        
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
    }
    return self;
    
}

- (void)updateConstraints{
    if (!self.didSetupLayout) {
        [_dotImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(10, 10));
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.contentView.mas_left).with.offset(26);
        }];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.height.mas_equalTo(15+kLabelHeightOffset/2.0);
            make.left.equalTo(_dotImageView.mas_right).with.offset(7);
            make.width.mas_equalTo(120);
        }];
        
        [_amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.and.height.equalTo(_titleLabel);
            make.right.equalTo(self.contentView.mas_right).with.offset(-30);
            make.left.greaterThanOrEqualTo(_titleLabel.mas_right).with.offset(10);
        }];
        
        [self.seperator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(0.5);
            make.left.equalTo(self.contentView.mas_left).with.offset(26);
            make.right.equalTo(self.contentView.mas_right).with.offset(-30);
        }];
        
        self.didSetupLayout = YES;
    }
    [super updateConstraints];
}

- (void)setModel:(id)model{
    self.amountLabel.text = @"￥0.00";
}

@end



@implementation  PaymentWayCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = JXColorFromRGB(0xf6f7f8);
        
        _backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:_backgroundImageView];
        
        _payemntImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _payemntImageView.image = ImageString(@"public_payment_alipay");
        [self.contentView addSubview:_payemntImageView];
        
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = JXFont(16);
        _titleLabel.textColor = JXColorFromRGB(0x8c8b8b);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [_backgroundImageView addSubview:_titleLabel];
        
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_button addTarget:self action:@selector(<#selecttorName#>) forControlEvents:UIControlEventTouchUpInside];
        _button.titleLabel.font = JXFont(16);
        [_button setTitleColor:JXColorFromRGB(0x828181) forState:UIControlStateNormal];
        [_button setImage:ImageString(@"address_defaultaddress_n") forState:UIControlStateNormal];
        [_button setImage:ImageString(@"address_defaultaddress_s") forState:UIControlStateSelected];
        _button.selected = YES;
        [_backgroundImageView addSubview:_button];
        
        self.seperator = [[UIView alloc]initWithFrame:CGRectZero];
        self.seperator.backgroundColor = JXColorFromRGB(0xe5e5e5);
        [self.contentView addSubview:self.seperator];
        
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
        
    }
    return self;
}

- (void)updateConstraints{
    
    if (!self.didSetupLayout) {
        
        [_backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(15);
            make.right.equalTo(self.contentView.mas_right).with.offset(-15);
            make.top.equalTo(self.contentView.mas_top).with.offset(0);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(0);
        }];
        
        [_payemntImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(34, 34));
            make.centerY.equalTo(_backgroundImageView.mas_centerY);
            make.left.equalTo(_backgroundImageView.mas_left).with.offset(17);
        }];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_payemntImageView.mas_right).with.offset(20);
            make.height.mas_equalTo(15+kLabelHeightOffset);
            make.width.mas_equalTo(75);;
            make.centerY.equalTo(_backgroundImageView.mas_centerY);
        }];
        
        [_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(35, 35));
            make.centerY.equalTo(_backgroundImageView.mas_centerY);
            make.centerX.equalTo(_backgroundImageView.mas_right).with.offset(-20);
        }];
        
        [self.seperator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(15);
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.height.mas_equalTo(0.5);
            make.right.mas_equalTo(17.5);
        }];
        
        self.didSetupLayout = YES;
    }
    [super updateConstraints];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    _button.selected = selected;
}

- (void)setModel:(id)model{
    
}

@end



