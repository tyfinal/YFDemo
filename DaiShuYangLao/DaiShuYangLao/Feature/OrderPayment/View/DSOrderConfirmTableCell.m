//
//  DSOrderConfirmTableCell.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/4.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSOrderConfirmTableCell.h"
#import "UIImage+YYAdd.h"
#import "DSShopCartModel.h"
#import "DSGoodsInfoModel.h"
#import "DSUserAddress.h"
#import "DSAreaModel.h"
#import "DSGoodsDetailInfoModel.h"

@implementation DSOrderConfirmTableCell

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


@implementation OrderConfirmAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //底部彩色分割线条
        self.seperator = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.seperator.image = ImageString(@"orderpayment_address_sperator");
        [self.contentView addSubview:self.seperator];
        
        //添加新地址
        self.addNewAddressButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addNewAddressButton setTitle:@"新建收货地址 +" forState:UIControlStateNormal];
        _addNewAddressButton.hidden = YES;
        [_addNewAddressButton addTarget:self action:@selector(addNewAddressEvent) forControlEvents:UIControlEventTouchUpInside];
        _addNewAddressButton.titleLabel.font = JXFont(19);
        [_addNewAddressButton setTitleColor:JXColorFromRGB(0xffffff) forState:UIControlStateNormal];
        
        CGFloat radius = 8;
        UIImage * backgroundImage = [UIImage imageWithColor:APP_MAIN_COLOR size:CGSizeMake(40, 40)];
        backgroundImage = [backgroundImage imageByRoundCornerRadius:radius];
        backgroundImage = [backgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(radius+2, radius+2, radius+2, radius+2) resizingMode:UIImageResizingModeStretch];
        [_addNewAddressButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        [self.contentView addSubview:_addNewAddressButton];
        
        //地址视图
        _addressView = [[UIView alloc]initWithFrame:CGRectZero];
        _addressView.backgroundColor = [UIColor whiteColor];
//        _addressView.hidden = YES;
        [self.contentView addSubview:_addressView];
        
        _userNameLabel = [[UILabel alloc]init];
        _userNameLabel.font = JXFont(16);
        _userNameLabel.textColor = JXColorFromRGB(0x2d2d2d);
        _userNameLabel.textAlignment = NSTextAlignmentLeft;
        [self.addressView addSubview:_userNameLabel];
        
        _phoneLabel = [[UILabel alloc]init];
        _phoneLabel.font = JXFont(13);
        _phoneLabel.textColor = JXColorFromRGB(0x2a2a2a);
        _phoneLabel.textAlignment = NSTextAlignmentLeft;
        [self.addressView addSubview:_phoneLabel];
        
        _addressLabel = [[UILabel alloc]init];
        _addressLabel.font = JXFont(14);
        _addressLabel.textColor = JXColorFromRGB(0x999999);
        _addressLabel.textAlignment = NSTextAlignmentLeft;
        _addressLabel.numberOfLines = 2;
        [self.addressView addSubview:_addressLabel];
        
//        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.and.top.equalTo(self);
//            make.bottom.equalTo(self.seperator.mas_top).priorityLow();
//        }];
        
        [_seperator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self);
            make.height.mas_equalTo(10);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        [_addNewAddressButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(17);
            make.right.equalTo(self.contentView.mas_right).with.offset(-17);
            make.height.mas_equalTo(38);
            make.top.equalTo(self.contentView.mas_top).with.offset(25);
        }];
        
        [_addressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.contentView);
            make.bottom.equalTo(self.seperator.mas_top);
        }];
        
        [_userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.addressView.mas_left).with.offset(16.5);
            make.height.mas_equalTo(kLabelHeightOffset+13);
            make.top.equalTo(self.addressView.mas_top).with.offset(17-kLabelHeightOffset/2.0);
        }];
        
        [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_userNameLabel.mas_right).with.offset(12);
            make.centerY.equalTo(_userNameLabel.mas_centerY);
            make.height.mas_equalTo(13+kLabelHeightOffset);
            make.right.lessThanOrEqualTo(self.addressView.mas_right).with.offset(-40);
        }];
        
        [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_userNameLabel.mas_left);
            make.top.equalTo(_userNameLabel.mas_bottom).with.offset(13-kLabelHeightOffset/2.0);
            make.right.equalTo(self.addressView.mas_right).with.offset(-40);
            make.height.mas_greaterThanOrEqualTo(15+kLabelHeightOffset/2.0);
        }];
        
//        [self layoutIfNeeded];
//        _addNewAddressButton.layer.cornerRadius = 8.0f;
//        _addNewAddressButton.layer.masksToBounds = YES;
    }
    return self;
}

- (void)setModel:(id)model{
    if (model==nil) {
        self.addressView.hidden = YES;
        self.addNewAddressButton.hidden = NO;
        self.accessoryType = UITableViewCellAccessoryNone;
        return;
    }
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.addressView.hidden = NO;
    self.addNewAddressButton.hidden = YES;;
    if ([model isKindOfClass:[DSUserAddress class]]) {
        DSUserAddress * aModel = (DSUserAddress *)model;
        self.userNameLabel.text = aModel.name;
        self.phoneLabel.text = aModel.phone;
        NSMutableString * muAreaString = [NSMutableString string];
        if ([aModel.province.name isNotBlank]) {
            [muAreaString appendFormat:@"%@ ",aModel.province.name];
        }
        if ([aModel.city.name isNotBlank]) {
            [muAreaString appendFormat:@"%@ ",aModel.city.name];
        }
        
        if ([aModel.district.name isNotBlank]) {
            [muAreaString appendFormat:@"%@ ",aModel.district.name];
        }
        
        if ([aModel.address isNotBlank]) {
            [muAreaString appendString:aModel.address];
        }
        if ([muAreaString isNotBlank]) {
           self.addressLabel.text = muAreaString;
        }
    }
}

- (void)addNewAddressEvent{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ds_orderConfirmCell:createNewAddress:)]) {
        [self.delegate ds_orderConfirmCell:self createNewAddress:self.addNewAddressButton];
    }
}

@end


@implementation OrderConfirmGoodsInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.coverImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:self.coverImageView];
        
        _goodsTitleLabel = [[UILabel alloc]init];
        _goodsTitleLabel.font = JXFont(13);
        _goodsTitleLabel.textColor = JXColorFromRGB(0x212121);
        _goodsTitleLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_goodsTitleLabel];
        
        _priceLabel = [[UILabel alloc]init];
        _priceLabel.font = JXFont(15);
        _priceLabel.textColor = JXColorFromRGB(0x212121);
        _priceLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_priceLabel];
        
        _descLabel = [[UILabel alloc]init];
        _descLabel.font = JXFont(14);
        _descLabel.textColor = JXColorFromRGB(0x343434);
        _descLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_descLabel];
        
        _goodsNumberLabel = [[UILabel alloc]init];
        _goodsNumberLabel.font = JXFont(13);
        _goodsNumberLabel.textColor = JXColorFromRGB(0xbdbdbd);
        _goodsNumberLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_goodsNumberLabel];
        
        _statementTF = [[UITextField alloc]initWithFrame:CGRectZero];
        _statementTF.text = @" 不支持无理由退货";
        _statementTF.font = JXFont(14);
        _statementTF.textColor = JXColorFromRGB(0x6c6c6c);
        _statementTF.enabled = NO;
        UIImageView * iconIV = [[UIImageView alloc]initWithImage:ImageString(@"public_warning")];
        iconIV.frameSize = CGSizeMake(15, 15);
        _statementTF.leftViewMode = UITextFieldViewModeAlways;
        _statementTF.leftView = iconIV;
        [self.contentView addSubview:_statementTF];
        
        CGFloat radius = 12.5;
        UIImage * backgroundImage = [UIImage imageWithColor:JXColorFromRGB(0xf0f2f5) size:CGSizeMake(50, 25)];
        backgroundImage = [backgroundImage imageByRoundCornerRadius:radius];
        backgroundImage = [backgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(radius, radius, 0, radius) resizingMode:UIImageResizingModeStretch];
        _messageTF = [[UITextField alloc]initWithFrame:CGRectZero];
        _messageTF.background = backgroundImage;
        _messageTF.delegate = self;
        UILabel * leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 90, 20)];
        leftLabel.textColor = JXColorFromRGB(0x818181);
        leftLabel.font = JXFont(13);
        leftLabel.text = @"买家留言： ";
        leftLabel.textAlignment = NSTextAlignmentRight;
        _messageTF.leftViewMode = UITextFieldViewModeAlways;
        _messageTF.leftView = leftLabel;
        _messageTF.font = JXFont(13.0f);
        [self.contentView addSubview:_messageTF];
        
        self.seperator = [[UIView alloc]initWithFrame:CGRectZero];
        self.seperator.backgroundColor = JXColorFromRGB(0xf5f5f5);
        [self.contentView addSubview:self.seperator];
        
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
    }
    return self;
}

- (void)updateConstraints{
    if (!self.didSetupLayout) {
        [_coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(75, 75));
            make.left.equalTo(self.contentView.mas_left).with.offset(12);
            make.top.equalTo(self.contentView.mas_top).with.offset(11);
        }];
        
        [_goodsTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_coverImageView.mas_right).with.offset(10);
            make.top.equalTo(_coverImageView.mas_top).with.offset(5-kLabelHeightOffset/2.0);
            make.height.mas_equalTo(13+kLabelHeightOffset);
            make.right.lessThanOrEqualTo(_priceLabel.mas_left).with.offset(-10);
        }];
        
        [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).with.offset(-15);
            make.height.mas_equalTo(15+kLabelHeightOffset);
            make.centerY.equalTo(_goodsTitleLabel.mas_centerY);
            make.width.mas_equalTo(120);
        }];
    
        [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_goodsTitleLabel.mas_left);
            make.height.mas_equalTo(14+kLabelHeightOffset);
            make.top.equalTo(_goodsTitleLabel.mas_bottom).with.offset(4-kLabelHeightOffset);
            make.right.equalTo(_priceLabel.mas_right);
        }];
        
        [_statementTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_goodsTitleLabel);
            make.height.mas_equalTo(14+kLabelHeightOffset);
            make.centerY.equalTo(_coverImageView.mas_bottom).with.offset(-12);
            make.width.mas_equalTo(135);
        }];
        
        [_goodsNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.and.right.equalTo(_priceLabel);
            make.height.mas_equalTo(13+kLabelHeightOffset);
            make.centerY.equalTo(_statementTF.mas_centerY);
        }];
        
        [_messageTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(55);
            make.right.equalTo(self.contentView.mas_right).with.offset(-55);
            make.height.mas_equalTo(25);
            make.top.equalTo(_coverImageView.mas_bottom).with.offset(16.5);
        }];
        
        [_seperator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.and.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(10);
        }];
        
        self.didSetupLayout = YES;
    }
    [super updateConstraints];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([self.model isKindOfClass:[DSShopCartModel class]]) {
        DSShopCartModel * aModel = (DSShopCartModel *)self.model;
        aModel.remarks = textField.text;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)setModel:(id)model{
    [super setModel:model];
    if ([model isKindOfClass:[DSShopCartModel class]]) {
        DSShopCartModel * aModel = (DSShopCartModel *)model;
        [_coverImageView sd_setImageWithURL:[NSURL URLWithString:aModel.product.minPic] placeholderImage:ImageString(@"public_clearbg_placeholder")];
        _goodsTitleLabel.text = aModel.product.name;
        _priceLabel.text = [NSString stringWithFormat:@"￥%.2f",aModel.sku.price.floatValue];
        _descLabel.text = aModel.product.specification;
        _messageTF.text = aModel.remarks;
        _goodsNumberLabel.text = [NSString stringWithFormat:@"x%ld",(long)aModel.num.integerValue];
    }
}

@end


@implementation OrderConfirmCarriageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray * fontSizes = @[JXFont(15),JXFont(14)];
        for (NSInteger i=0; i<2; i++) {
            UILabel * label = [[UILabel alloc]init];
            label.font = fontSizes[i];
            label.textColor = JXColorFromRGB(0x212121);
            label.textAlignment = (i==0)? NSTextAlignmentLeft:NSTextAlignmentRight;
            [self.contentView addSubview:label];
            if(i==0) _titleLabel = label;
            if(i==1) _carriageLabel = label;
        }
        
        _seprator = [[UIImageView alloc]initWithFrame:CGRectZero];
        _seprator.backgroundColor = JXColorFromRGB(0xf5f5f5);
        [self.contentView addSubview:_seprator];
        
        _titleLabel.text = @"配送费用";
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.contentView.mas_left).with.offset(21);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(70);
        }];
        
        [_carriageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).with.offset(-15);
            make.height.mas_equalTo(20);
            make.centerY.equalTo(_titleLabel);
            make.width.mas_equalTo(70);
        }];
        
        [_seprator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.5);
            make.left.equalTo(self.contentView.mas_left).with.offset(18);
            make.bottom.and.right.equalTo(self.contentView);
        }];
        
    }
    return self;
}

- (void)setModel:(id)model{
    _carriageLabel.text = @"￥85.00";
}

@end

@implementation OrderConfirmReceiptCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _titleLabel.font = JXFont(15);
        _titleLabel.textColor = JXColorFromRGB(0x212121);
        _titleLabel.text = @"开具发票";
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_titleLabel];

        CGFloat radius = 12.5;
        UIImage * backgroundImage = [UIImage imageWithColor:JXColorFromRGB(0xf0f2f5) size:CGSizeMake(50, 25)];
        backgroundImage = [backgroundImage imageByRoundCornerRadius:radius];
        backgroundImage = [backgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(radius, radius, 0, radius) resizingMode:UIImageResizingModeStretch];
        _receiptTF = [[UITextField alloc]initWithFrame:CGRectZero];
        _receiptTF.placeholder = @"填写开具发票信息";
        _receiptTF.background = backgroundImage;
        UILabel * leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 14, 25)];
        _receiptTF.leftViewMode = UITextFieldViewModeAlways;
        _receiptTF.leftView = leftLabel;
        [self.contentView addSubview:_receiptTF];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.contentView.mas_left).with.offset(21);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(70);
        }];
        
        [_receiptTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(_titleLabel.mas_right).with.offset(11);
            make.height.mas_equalTo(25);
            make.right.equalTo(self.contentView.mas_right).with.offset(-11);
        }];
        
        [_seprator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.5);
            make.left.equalTo(self.contentView.mas_left).with.offset(18);
            make.bottom.and.right.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)setModel:(id)model{
    
}

@end


@implementation OrderConfirmPointsExchangeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _titleLabel.font = JXFont(15);
        _titleLabel.textColor = JXColorFromRGB(0x212121);
        _titleLabel.text = @"养老备用金：";
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_titleLabel];
        
        _PointsExchangeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _PointsExchangeLabel.font = JXFont(14);
        _PointsExchangeLabel.textColor = JXColorFromRGB(0x212121);
        _PointsExchangeLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_PointsExchangeLabel];
        
        _enablePointsPayment = [[UISwitch alloc]initWithFrame:CGRectZero];
        _enablePointsPayment.onTintColor = APP_MAIN_COLOR;
        [self.contentView addSubview:_enablePointsPayment];
        
        _limitTipsLabel = [[UITextField alloc]initWithFrame:CGRectZero];
        _limitTipsLabel.font = JXFont(14);
        _limitTipsLabel.textColor = JXColorFromRGB(0x6c6c6c);
        _limitTipsLabel.enabled = NO;
        UIImageView * iconIV = [[UIImageView alloc]initWithImage:ImageString(@"public_warning")];
        iconIV.frameSize = CGSizeMake(15, 15);
        _limitTipsLabel.leftViewMode = UITextFieldViewModeAlways;
        _limitTipsLabel.leftView = iconIV;
        [self.contentView addSubview:_limitTipsLabel];
        
        _seprator = [[UIView alloc]initWithFrame:CGRectZero];
        _seprator.backgroundColor = JXColorFromRGB(0xf5f5f5);
        _seprator.hidden = YES;
        [self.contentView addSubview:_seprator];
        
        [_enablePointsPayment mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).with.offset(-11);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_top).with.offset(23);
            make.left.equalTo(self.contentView.mas_left).with.offset(21);
            make.size.mas_equalTo(CGSizeMake(90, 20));
        }];
        
        [_PointsExchangeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleLabel.mas_right).with.offset(3);
            make.height.mas_equalTo(20);
            make.centerY.equalTo(_titleLabel.mas_centerY);
            make.right.lessThanOrEqualTo(_enablePointsPayment.mas_left).with.offset(-10);
        }];
        
        [_limitTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleLabel.mas_left);
            make.height.mas_equalTo(20);
            make.right.lessThanOrEqualTo(_enablePointsPayment.mas_right);
            make.top.equalTo(_titleLabel.mas_centerY).with.offset(30);
        }];
        
        [_seprator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.5);
            make.left.equalTo(self.contentView.mas_left).with.offset(18);
            make.bottom.and.right.equalTo(self.contentView);
        }];
    }
    return self;
}
@end


@implementation OrderConfirmImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _promptIV = [[UIImageView alloc]initWithFrame:CGRectZero];
        _promptIV.contentMode = UIViewContentModeScaleAspectFill;
        _promptIV.clipsToBounds = YES;
        [self.contentView addSubview:_promptIV];
        
        [_promptIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}


@end


