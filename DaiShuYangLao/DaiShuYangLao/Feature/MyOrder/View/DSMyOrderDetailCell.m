//
//  DSMyOrderDetailCell.m
//  DaiShuYangLao
//
//  Created by YueLiang Song on 2018/7/10.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSMyOrderDetailCell.h"
#import "DSOrderInfoModel.h"
@implementation DSMyOrderDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.seperator = [[UIView alloc]initWithFrame:CGRectZero];
        self.seperator.backgroundColor = JXColorFromRGB(0xf0f0f0);
        self.seperator.hidden = YES;
        [self addSubview:self.seperator];
        
        [self.seperator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.and.bottom.equalTo(self);
            make.height.mas_equalTo(0.5f);
        }];
    }
    return self;
}

- (void)setOrderModel:(DSOrderInfoModel *)orderModel{
    _orderModel = orderModel;
    self.orderInfoDic = orderModel.mj_keyValues;
}

@end

//MARK:订单状态
@implementation MyOrderDetailStatusCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _statusIcon = [[UIImageView alloc]init];
        [self.contentView addSubview:_statusIcon];
        
        _statusLabel = [[UILabel alloc]init];
        _statusLabel.font = JXFont(17);
        _statusLabel.textColor = JXColorFromRGB(0x000000);
        _statusLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_statusLabel];
        
        [_statusIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(14);
            make.size.mas_equalTo(CGSizeMake(25, 25));
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        
        [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_statusIcon.mas_right).with.offset(14);
            make.centerY.equalTo(_statusIcon.mas_centerY);
            make.right.equalTo(self.contentView.mas_right).with.offset(-11);
            make.height.mas_equalTo(20);
        }];
    }
    return self;
}

- (void)setOrderModel:(DSOrderInfoModel *)orderModel{
    [super setOrderModel:orderModel];
//    DSOrderRequestType orderType = orderModel.status.integerValue;
    NSArray * imageNames = @[@"mine_waitingfor_payment",@"mine_watingfor_delivery",@"mine_waitingfor_receving",@"mine_tradefailure",@"mine_tradesuccess"];
    NSInteger status = orderModel.status.integerValue;
    if (orderModel.status.integerValue<3) {
        _statusIcon.image = ImageString(imageNames[status]);
    }else if(orderModel.status.integerValue>=99){
        _statusIcon.image = ImageString(imageNames[status-99]);
    }
    _statusLabel.text = orderModel.statusMsg;
}

@end

//MARK:普通
@implementation MyOrderDetailCommonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = JXFont(15);
        _titleLabel.textColor = JXColorFromRGB(0x2e2d2d);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_titleLabel];
        
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.font = JXFont(14);
        _contentLabel.textColor = JXColorFromRGB(0x2e2d2d);
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_contentLabel];
        
        _operationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_operationButton setTitle:@"复制" forState:UIControlStateNormal];
        [_operationButton setTitleColor:JXColorFromRGB(0x414140)forState:UIControlStateNormal];
        [_operationButton setBackgroundImage:ImageString(@"myorder_copybg") forState:UIControlStateNormal];
        _operationButton.titleLabel.font = JXFont(13.0f);
        _operationButton.hidden = YES;
        [_operationButton addTarget:self action:@selector(copyEvent) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_operationButton];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(14);
            make.height.mas_equalTo(20);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.mas_equalTo(80);
        }];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleLabel.mas_right).with.offset(8);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.equalTo(self.contentView.mas_right).with.offset(-11).priorityLow();
            make.height.mas_equalTo(_titleLabel.mas_height);
        }];
        
        [_operationButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(55, 20));
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.lessThanOrEqualTo(self.contentView.mas_right).with.offset(-11);
        }];
    }
    return self;
}

- (void)updateConstraints{
    if ([self.cellKey isNotBlank]) {
        if ([self.cellKey isEqualToString:@"orderNo"]||[self.cellKey isEqualToString:@"expressNo"]) {
            [_contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_operationButton.mas_left).with.offset(-15);
            }];
        }else{
            [_contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView.mas_right).with.offset(-11);
            }];
        }
    }
    [super updateConstraints];
}

- (void)setOrderModel:(DSOrderInfoModel *)orderModel{
    [super setOrderModel:orderModel];
    if ([self.cellKey isNotBlank]) {
        self.contentLabel.text = @"";
        self.operationButton.hidden = YES;
        
        if ([self.cellKey isEqualToString:@"orderNo"]||[self.cellKey isEqualToString:@"expressNo"]){
            if ([self.orderInfoDic[self.cellKey] isNotBlank]) { //订单编号 与 物流单号为空时隐藏复制 
                self.operationButton.hidden = NO;
                self.contentLabel.text = self.orderInfoDic[self.cellKey];
            }
        }else if ([self.cellKey isEqualToString:@"payChannel"]) {
            NSNumber * number = self.orderInfoDic[self.cellKey];
            self.contentLabel.text = @[@"未知",@"支付宝",@"微信"][number.integerValue];
        }else{
            if([self.orderInfoDic[self.cellKey] isNotBlank]){
              self.contentLabel.text = self.orderInfoDic[self.cellKey];
            }
        }
    }
    [self setNeedsUpdateConstraints];
}

- (void)copyEvent{
    if ([self.cellKey isNotBlank]) {
        if ([self.orderInfoDic[self.cellKey] isNotBlank]) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            [pasteboard setString:self.orderInfoDic[self.cellKey]];
            [MBProgressHUD showText:@"复制成功" toView:nil];
        }
    }

}

@end

//MARK:地址信息
@implementation MyOrderDetailAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _userNameLabel = [[UILabel alloc]init];
        _userNameLabel.font = JXFont(15);
        _userNameLabel.textColor = JXColorFromRGB(0x2e2d2d);
        _userNameLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_userNameLabel];
        
        _phoneLabel = [[UILabel alloc]init];
        _phoneLabel.font = JXFont(12);
        _phoneLabel.textColor = JXColorFromRGB(0x2e2d2d);
        _phoneLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_phoneLabel];
        
        _addressLabel = [[UILabel alloc]init];
        _addressLabel.font = JXFont(12);
        _addressLabel.textColor = JXColorFromRGB(0x444343);
        _addressLabel.textAlignment = NSTextAlignmentLeft;
        _addressLabel.numberOfLines = 2;
        [self.contentView addSubview:_addressLabel];
        
        [_userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(14);
            make.height.mas_equalTo(kLabelHeightOffset+15);
            make.top.equalTo(self.contentView.mas_top).with.offset(15-kLabelHeightOffset/2.0);
        }];
        
        [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_userNameLabel.mas_right).with.offset(24);
            make.centerY.equalTo(_userNameLabel.mas_centerY);
            make.height.mas_equalTo(13+kLabelHeightOffset);
            make.right.lessThanOrEqualTo(self.contentView.mas_right).with.offset(-40);
        }];
        
        [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_userNameLabel.mas_left);
            make.top.equalTo(_userNameLabel.mas_bottom).with.offset(13-kLabelHeightOffset/2.0);
            make.right.equalTo(self.contentView.mas_right).with.offset(-11);
            make.height.mas_greaterThanOrEqualTo(12+kLabelHeightOffset/2.0);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-15).priorityLow();
        }];
    }
    return self;
}

- (void)setOrderModel:(DSOrderInfoModel *)orderModel{
    [super setOrderModel:orderModel];
    OrderShippingAddressModel * addressModel = orderModel.shippingAddress;
    self.userNameLabel.text = addressModel.name;
    self.phoneLabel.text = addressModel.phone;
    self.addressLabel.text = addressModel.address;
}

@end

//MARK:结算
@implementation MyOrderDetailCheckOutCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = JXFont(14);
        _titleLabel.textColor = JXColorFromRGB(0x2e2d2d);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_titleLabel];
        
        _amountLabel = [[UILabel alloc]init];
        _amountLabel.font = JXFont(13);
        _amountLabel.textColor = JXColorFromRGB(0x000000);
        _amountLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_amountLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(14);
            make.height.mas_equalTo(20);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.mas_equalTo(75);
        }];
        
        [_amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleLabel.mas_right).with.offset(8);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.equalTo(self.contentView.mas_right).with.offset(-11);
            make.height.mas_equalTo(_titleLabel.mas_height);
        }];
    }
    return self;
}

- (void)setOrderModel:(DSOrderInfoModel *)orderModel{
    [super setOrderModel:orderModel];
    if ([self.cellKey isNotBlank]) {
        self.amountLabel.text = @"";
        NSNumber * number = self.orderInfoDic[self.cellKey];
        if (number!=nil) {
            if ([self.cellKey isEqualToString:@"point"]||[self.cellKey isEqualToString:@"gold"]) {
                self.amountLabel.text = [NSString stringWithFormat:@"%.2f",number.floatValue];
            }else if ([self.cellKey isEqualToString:@"productNum"]){
                self.amountLabel.text = [NSString stringWithFormat:@"共%ld件商品",(long)number.integerValue];
            }else if ([self.cellKey isEqualToString:@"payAmount"]){
                NSString * sufFix = @"实付款：";
                NSAttributedString * suffixAttri = [NSString applyAttributes:@{NSForegroundColorAttributeName:JXColorFromRGB(0x2e2d2d),NSFontAttributeName:JXFont(12)} forString:sufFix];
                NSMutableAttributedString * textAttri = [[NSMutableAttributedString alloc]initWithAttributedString:suffixAttri];
                NSString * payAmount = [NSString stringWithFormat:@"￥%.2f",number.floatValue];
                NSAttributedString * amountAttri = [NSString applyAttributes:@{NSForegroundColorAttributeName:APP_MAIN_COLOR,NSFontAttributeName:[UIFont boldSystemFontOfSize:16]} forString:payAmount];
                [textAttri appendAttributedString:amountAttri];
                self.amountLabel.attributedText = textAttri;
            }else{
               self.amountLabel.text = [NSString stringWithFormat:@"￥%.2f",number.floatValue];
                if ([self.cellKey isEqualToString:@"logisticsFee"]) {
                    if ([number isEqual:@(0)]) {
                        self.amountLabel.text = @"包邮";
                    }
                }
            }
        }
    }
}


@end

//MARK:操作
@implementation MyOrderDetailOperationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        for (NSInteger i=0; i<2; i++) {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitleColor:JXColorFromRGB(0xffffff)forState:UIControlStateNormal];
            [button setBackgroundImage:ImageString(@"myorder_detail_buttonbg") forState:UIControlStateNormal];
            button.titleLabel.font = JXFont(12.0f);
            button.tag = 10+i;
            button.hidden = YES;
            [button addTarget:self action:@selector(buttonClickEvent:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:button];
            if(i==0) self.leftButton = button;
            if(i==1) self.rightButton = button;
        }
        
        [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(75, 25));
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.equalTo(self.contentView.mas_right).with.offset(-11);
        }];
        
        [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.and.centerY.equalTo(self.rightButton);
            make.right.equalTo(self.rightButton.mas_left).with.offset(-10);
        }];
        
    }
    return self;
}

- (void)setOrderModel:(DSOrderInfoModel *)orderModel{
    [super setOrderModel:orderModel];
    self.leftButton.hidden = YES;
    self.rightButton.hidden = YES;
    if (orderModel.status.integerValue==DSOrderRequestWaitForPayment) {
        self.leftButton.hidden = NO;
        self.rightButton.hidden = NO;
        [self.leftButton setTitle:@"取消订单" forState:UIControlStateNormal];
        [self.rightButton setTitle:@"立即付款" forState:UIControlStateNormal];
    }else if (orderModel.status.integerValue==DSOrderRequestWaitForDelivery){
        self.rightButton.hidden = NO;
        [self.rightButton setTitle:@"提醒发货" forState:UIControlStateNormal];
    }else if (orderModel.status.integerValue==DSOrderRequestWaitForReceiving){
        self.rightButton.hidden = NO;
        [self.rightButton setTitle:@"确认收货" forState:UIControlStateNormal];
    }else if (orderModel.status.integerValue==DSOrderRequestTradeSuccess){
        self.leftButton.hidden = NO;
        self.rightButton.hidden = NO;
        [self.leftButton setTitle:@"删除订单" forState:UIControlStateNormal];
        [self.rightButton setTitle:@"再次购买" forState:UIControlStateNormal];
    }else if (orderModel.status.integerValue==DSOrderRequestTradeCaceled){
        self.rightButton.hidden = NO;
        [self.rightButton setTitle:@"删除订单" forState:UIControlStateNormal];
    }
}

- (void)buttonClickEvent:(UIButton *)button{
    NSString * buttonHandle = @"";
    NSInteger buttonIndex = button.tag-10;
    if (self.orderModel.status.integerValue==DSOrderRequestWaitForPayment) {
        if (buttonIndex==0) {
            buttonHandle = @"cancelorder";
        }else{
            buttonHandle = @"paynow";
        }
    }else if (self.orderModel.status.integerValue==DSOrderRequestWaitForDelivery){
        if (buttonIndex==1) {
            buttonHandle = @"remind";
        }
    }else if (self.orderModel.status.integerValue==DSOrderRequestWaitForReceiving){
        if (buttonIndex==1) {
            buttonHandle = @"confirm";
        }
    }else if (self.orderModel.status.integerValue==DSOrderRequestTradeSuccess){
        if (buttonIndex==0) {
            buttonHandle = @"deleteorder";
        }else{
            buttonHandle = @"buyagain";
        }
    }else if (self.orderModel.status.integerValue==DSOrderRequestTradeCaceled){
        if (buttonIndex==1) {
            buttonHandle = @"deleteorder";
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(ds_myOrderDetailCell:buttonClickHandle:)]) {
        [self.delegate ds_myOrderDetailCell:self buttonClickHandle:buttonHandle];
    }
}

@end
