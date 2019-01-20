//
//  DSMyOrderCell.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/1.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSMyOrderCell.h"
#import "DSOrderListModel.h"

@implementation DSMyOrderCell

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

- (void)setModel:(DSOrderListModel *)model{
    _model = model;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end




@implementation OrderStatusCell
@synthesize orderStatusTipsArray = _orderStatusTipsArray;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _merchantLabel = [[UILabel alloc]init];
        _merchantLabel.font = JXFont(15);
        _merchantLabel.textColor = JXColorFromRGB(0x282828);
        _merchantLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_merchantLabel];
        
        _statusLabel = [[UILabel alloc]init];
        _statusLabel.font = JXFont(13);
        _statusLabel.textColor = APP_MAIN_COLOR;
        _statusLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_statusLabel];
        
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.hidden = YES;
        [_deleteButton addTarget:self action:@selector(deleteOrderEvent) forControlEvents:UIControlEventTouchUpInside];
        [_deleteButton setImage:ImageString(@"public_delete") forState:UIControlStateNormal];
        [self.contentView addSubview:_deleteButton];
        
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
        
    }
    return self;
}

- (void)updateConstraints{
    if (!self.didSetupLayout) {
        [_merchantLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(25);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(100, kLabelHeightOffset+15));
        }];
        
        [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.centerX.equalTo(self.contentView.mas_right).with.offset(-23);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        
        //待收货
        [_statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(kLabelHeightOffset+13);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.merchantLabel.mas_right).with.offset(10);
            make.right.equalTo(self.contentView.mas_right).with.offset(-15);
        }];
        
        self.didSetupLayout = YES;
    }
    
//    if (self.model.status.integerValue == DSOrderRequestWaitForPayment) {
//        //待付款
//        [_statusLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.contentView.mas_right).with.offset(-50);
//        }];
//    }else{
//        //待发货
//        [_statusLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//             make.right.equalTo(self.contentView.mas_right).with.offset(-15);
//        }];
//    }
    [super updateConstraints];
}

- (void)deleteOrderEvent{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ds_myOrderCell:cancelOrder:)]) {
        [self.delegate ds_myOrderCell:self cancelOrder:self.model];
    }
}

- (void)setModel:(DSOrderListModel *)model{
    [super setModel:model];
    _merchantLabel.text = @"";
    
//    if (model.status.integerValue == DSOrderRequestWaitForPayment) {
//        _deleteButton.hidden = NO;
//    }
    
    if ([model.statusMsg isNotBlank]) {
        _statusLabel.text = model.statusMsg;
    }
    
    if ([model.merchant.name isNotBlank]) {
        _merchantLabel.text = model.merchant.name;
    }
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

@end

@implementation OrderGoodsInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = JXColorFromRGB(0xf4f4f4);
        self.goodsCoverIV = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:self.goodsCoverIV];
        
        _descLabel = [[UILabel alloc]init];
        _descLabel.font = JXFont(12);
        _descLabel.textColor = JXColorFromRGB(0x282828);
        _descLabel.textAlignment = NSTextAlignmentLeft;
        _descLabel.numberOfLines = 2;
        [self.contentView addSubview:_descLabel];
        
        _priceLabel = [[UILabel alloc]init];
        _priceLabel.font = JXFont(13);
        _priceLabel.textColor = JXColorFromRGB(0x333333);
        _priceLabel.textAlignment = NSTextAlignmentRight;
//        _priceLabel.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_priceLabel];
        
        _numberLabel = [[UILabel alloc]init];
        _numberLabel.font = JXFont(10.0);
        _numberLabel.textColor = JXColorFromRGB(0x999999);
        _numberLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_numberLabel];
        
        _remarksLabel = [[UILabel alloc]init];
        _remarksLabel.font = JXFont(12);
        _remarksLabel.textColor = JXColorFromRGB(0x9f9f9f);
        _remarksLabel.textAlignment = NSTextAlignmentLeft;
        _remarksLabel.hidden = YES;
        [self.contentView addSubview:_remarksLabel];
        
        self.seperator = [[UIView alloc]initWithFrame:CGRectZero];
        self.seperator.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.seperator];
        
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
    }
    return self;
}

- (void)updateConstraints{
    if (!self.didSetupLayout) {
        [_goodsCoverIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(75, 75));
            make.left.equalTo(self.contentView.mas_left).with.offset(25);
            make.top.equalTo(self.contentView.mas_top).with.offset(7);
        }];
        
        [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.goodsCoverIV.mas_right).with.offset(15);
            make.top.equalTo(self.goodsCoverIV.mas_top).with.offset(12);
            make.right.equalTo(_priceLabel.mas_left).with.offset(-10);
            make.bottom.lessThanOrEqualTo(self.goodsCoverIV.mas_bottom).with.offset(-12);
        }];
        
        [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_descLabel.mas_top).with.offset(-kLabelHeightOffset/2.0);
            make.right.equalTo(self.contentView.mas_right).with.offset(-10);
            make.height.mas_equalTo(13+kLabelHeightOffset/2.0);
            make.width.mas_equalTo(70);
        }];
        
        [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_priceLabel.mas_bottom).with.offset(3);
            make.right.equalTo(_priceLabel.mas_right);
            make.height.mas_equalTo(10+kLabelHeightOffset/2.0);
            make.width.equalTo(_priceLabel.mas_width);
        }];
        
        [_remarksLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_goodsCoverIV.mas_left);
            make.height.mas_equalTo(12+kLabelHeightOffset/2.0);
            make.top.equalTo(_goodsCoverIV.mas_bottom).with.offset(15-kLabelHeightOffset/2.0);
            make.right.equalTo(_priceLabel.mas_right);
        }];
        
        [self.seperator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.goodsCoverIV.mas_left);
            make.right.equalTo(_priceLabel.mas_right);
            make.height.mas_equalTo(1.0f);
            make.bottom.equalTo(self.contentView.mas_bottom);
        }];
        
        self.didSetupLayout = YES;
    }
    [super updateConstraints];
}

- (void)setGoodsModel:(OrderProductInfoModel *)goodsModel{
    _goodsModel = goodsModel;
    [self.goodsCoverIV sd_setImageWithURL:[NSURL URLWithString:goodsModel.minPic] placeholderImage:ImageString(@"public_clearbg_placeholder")];
    _descLabel.text = goodsModel.name;
    _priceLabel.text  = [NSString stringWithFormat:@"￥%.2f",goodsModel.price.floatValue];
    _numberLabel.text = [NSString stringWithFormat:@"x%ld",(long)goodsModel.num.integerValue];
    _remarksLabel.hidden = YES;
    if ([goodsModel.remark isNotBlank]) {
        _remarksLabel.hidden = NO;
        _remarksLabel.text = [NSString stringWithFormat:@"买家备注：%@",goodsModel.remark];
    }
}

@end



@implementation OrderSettlementCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _settlementInfoLabel = [[UILabel alloc]init];
        _settlementInfoLabel.font = JXFont(12);
        _settlementInfoLabel.textColor = JXColorFromRGB(0x3e4345);
        _settlementInfoLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_settlementInfoLabel];
        
        _line = [[UILabel alloc]initWithFrame:CGRectZero];
        _line.backgroundColor = JXColorFromRGB(0xe5e5e5);
        [self.contentView addSubview:_line];
        
        [_settlementInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.contentView.mas_left).with.offset(25);
            make.right.equalTo(self.contentView.mas_right).with.offset(-25);
            make.height.mas_equalTo(kLabelHeightOffset+12);
        }];
        
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.and.right.equalTo(self.contentView);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}

- (void)setModel:(DSOrderListModel *)model{
    [super setModel:model];
    self.settlementInfoLabel.text = [NSString stringWithFormat:@"共%ld件商品 合计：￥%.2f(含运费￥%.2f元)",(long)model.productNum.integerValue,model.payAmount.floatValue,model.logisticsFee.floatValue];
}

@end


@implementation OrderOperationCell

static UIImage * buttonBackgroundImage_red = nil;
static UIImage * buttonBackgroundImage_black = nil;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        if (buttonBackgroundImage_red==nil) {
            buttonBackgroundImage_red = [self createButtonBackgroundImageWithBorderColor:APP_MAIN_COLOR];
        }
        if (buttonBackgroundImage_black==nil) {
            buttonBackgroundImage_black = [self createButtonBackgroundImageWithBorderColor:JXColorFromRGB(0x646464)];
        }
        for (NSInteger i=0; i<2; i++) {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@[@"取消订单",@"立即付款"][i] forState:UIControlStateNormal];
            [button setTitleColor:@[JXColorFromRGB(0x646464),APP_MAIN_COLOR][i] forState:UIControlStateNormal];
            [button setBackgroundImage:@[buttonBackgroundImage_black,buttonBackgroundImage_red][i] forState:UIControlStateNormal];
            button.titleLabel.font = JXFont(15.0f);
            button.tag = 10+i;

            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:button];
            if(i==0) _leftButton = button;
            if(i==1) _rightButton = button;
        }
        
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
    }
    return self;
}


- (void)updateConstraints{
    if (!self.didSetupLayout) {
        
        [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(76, 24));
            make.right.equalTo(self.contentView.mas_right).with.offset(-15);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        
        [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.and.centerY.equalTo(_rightButton);
            make.right.equalTo(_rightButton.mas_left).with.offset(-12);
        }];
        
        self.didSetupLayout = YES;
    }
    [super updateConstraints];
}

- (UIImage *)createButtonBackgroundImageWithBorderColor:(UIColor *)borderColor{
    UIImage * image = [UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(76, 24)];
    image = [image imageByRoundCornerRadius:5 borderWidth:1 borderColor:borderColor];
    return image;
}

- (void)setModel:(DSOrderListModel *)model{
    [super setModel:model];
    
    _leftButton.hidden = YES;
    [_rightButton setBackgroundImage:buttonBackgroundImage_red forState:UIControlStateNormal];
    [_rightButton setTitleColor:APP_MAIN_COLOR forState:UIControlStateNormal];
    if (model.status.integerValue==DSOrderRequestWaitForPayment) {
        _leftButton.hidden = NO;
        [_leftButton setTitle:@"取消订单" forState:UIControlStateNormal];
        [_rightButton setTitle:@"立即付款" forState:UIControlStateNormal];
    }else if (model.status.integerValue==DSOrderRequestWaitForReceiving) {
        [_rightButton setTitle:@"确认收货" forState:UIControlStateNormal];
    }else if (model.status.integerValue==DSOrderRequestWaitForDelivery) {
        [_rightButton setTitle:@"提醒发货" forState:UIControlStateNormal];
    }else if (model.status.integerValue==DSOrderRequestTradeSuccess){
        _leftButton.hidden = NO;
        [_rightButton setTitle:@"再次购买" forState:UIControlStateNormal];
        [_leftButton setTitle:@"删除订单" forState:UIControlStateNormal];
    }else if (model.status.integerValue==DSOrderRequestTradeCaceled){
        [_rightButton setBackgroundImage:buttonBackgroundImage_black forState:UIControlStateNormal];
        [_rightButton setTitleColor:JXColorFromRGB(0x646464) forState:UIControlStateNormal];
        [_rightButton setTitle:@"删除订单" forState:UIControlStateNormal];
    }
}

- (void)buttonClick:(UIButton *)button{
    NSString * buttonHandle = @"";
    NSInteger buttonIndex = button.tag-10;
    if (self.model.status.integerValue==DSOrderRequestWaitForPayment) {
        if (buttonIndex==0) {
            buttonHandle = @"cancelorder";
        }else{
            buttonHandle = @"paynow";
        }
    }else if (self.model.status.integerValue==DSOrderRequestWaitForDelivery){
        if (buttonIndex==1) {
            buttonHandle = @"remind";
        }
    }else if (self.model.status.integerValue==DSOrderRequestWaitForReceiving){
        if (buttonIndex==1) {
            buttonHandle = @"confirm";
        }
    }else if (self.model.status.integerValue==DSOrderRequestTradeSuccess){
        if (buttonIndex==0) {
            buttonHandle = @"deleteorder";
        }else{
            buttonHandle = @"buyagain";
        }
    }else if (self.model.status.integerValue==DSOrderRequestTradeCaceled){
        if (buttonIndex==1) {
            buttonHandle = @"deleteorder";
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(ds_myOrderCell:model:buuttonClickHandle:)]) {
        [self.delegate ds_myOrderCell:self model:self.model buuttonClickHandle:buttonHandle];
    }
}


@end











