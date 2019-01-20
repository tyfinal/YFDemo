//
//  DSOrderConfirmTableCell.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/4.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderConfirmGoodsInfoCell;
@class OrderConfirmAddressCell;
@class OrderConfirmCarriageCell;
@class OrderConfirmReceiptCell;
@class OrderConfirmPointsExchangeCell;


@protocol OrderConfirmCellDelegate<NSObject>

@optional

- (void)ds_orderConfirmCell:(OrderConfirmAddressCell *)addressCell createNewAddress:(UIButton *)button;

@end


@interface DSOrderConfirmTableCell : UITableViewCell

@property (nonatomic, assign) BOOL didSetupLayout;

@property (nonatomic, strong) id model;

@property (nonatomic, assign) id<OrderConfirmCellDelegate>delegate;

@end

//MARK:地址
@interface OrderConfirmAddressCell : DSOrderConfirmTableCell

@property (nonatomic, strong) UIView * addressView;
@property (nonatomic, strong) UILabel * userNameLabel;
@property (nonatomic, strong) UILabel * phoneLabel;
@property (nonatomic, strong) UILabel * addressLabel;

@property (nonatomic, strong) UIButton * addNewAddressButton;

@property (nonatomic, strong) UIImageView * seperator;



@end

//MARK:商品信息
@interface OrderConfirmGoodsInfoCell : DSOrderConfirmTableCell<UITextFieldDelegate>

@property (nonatomic, strong) UIImageView * coverImageView;
@property (nonatomic, strong) UILabel * goodsTitleLabel;
@property (nonatomic, strong) UILabel * priceLabel;
@property (nonatomic, strong) UILabel * descLabel;
@property (nonatomic, strong) UILabel * goodsNumberLabel;
@property (nonatomic, strong) UITextField * messageTF;
@property (nonatomic, strong) UITextField * statementTF; /**< 不支持无条件退货的声明 */

@property (nonatomic, strong) UIView * seperator;


@end

//MARK:运费
@interface OrderConfirmCarriageCell : DSOrderConfirmTableCell

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * carriageLabel;
@property (nonatomic, strong) UIView * seprator;

@end

//MARK:商品信息
@interface OrderConfirmReceiptCell : DSOrderConfirmTableCell

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UITextField * receiptTF;
@property (nonatomic, strong) UIView * seprator;

@end

//MARK:积分
@interface OrderConfirmPointsExchangeCell : DSOrderConfirmTableCell

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * PointsExchangeLabel;
@property (nonatomic, strong) UISwitch * enablePointsPayment;
@property (nonatomic, strong) UITextField * limitTipsLabel;
@property (nonatomic, strong) UIView * seprator;

@end


@interface OrderConfirmImageCell : DSOrderConfirmTableCell

@property (nonatomic, strong) UIImageView * promptIV;

@end

//@interface 
//
//@end
