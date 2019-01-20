//
//  DSMyOrderCell.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/1.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSOrderInfoModel.h"

@class DSOrderListModel;
@class OrderStatusCell;
@class OrderGoodsInfoCell;
@class OrderSettlementCell;
@class OrderOperationCell;

@class DSGoodsInfoModel;
@class DSMyOrderCell;

@protocol MyOrderCellDelegate <NSObject>

@optional;

/** 取消订单 */
- (void)ds_myOrderCell:(DSMyOrderCell *)cell cancelOrder:(DSOrderListModel *)orderInfo;

/** 根据orderinfo中的status判断 按钮操作  */
- (void)ds_myOrderCell:(DSMyOrderCell *)cell model:(DSOrderListModel *)model buuttonClickHandle:(NSString *)info;

@end


@interface DSMyOrderCell : UITableViewCell

@property (nonatomic, assign) BOOL didSetupLayout;  
@property (nonatomic, strong) DSOrderListModel * model;
@property (nonatomic, weak) id <MyOrderCellDelegate> delegate;
@property (nonatomic, strong) UIView * seperator;

@end


@interface OrderStatusCell : DSMyOrderCell

@property (nonatomic, assign) DSOrderRequestType orderRequestStatus;

@property (nonatomic, strong) UILabel * merchantLabel;
@property (nonatomic, strong) UILabel * statusLabel;
@property (nonatomic, strong) UIButton * deleteButton;
@property (nonatomic, readonly) NSArray * orderStatusTipsArray;

@end


@interface OrderGoodsInfoCell : DSMyOrderCell

@property (nonatomic, strong) UIImageView * goodsCoverIV;
@property (nonatomic, strong) UILabel * descLabel;
@property (nonatomic, strong) OrderProductInfoModel * goodsModel;
@property (nonatomic, strong) UILabel * priceLabel;
@property (nonatomic, strong) UILabel * numberLabel;
@property (nonatomic, strong) UILabel * remarksLabel; /** 备注 */

@end


@interface OrderSettlementCell : DSMyOrderCell

@property (nonatomic, strong) UILabel * settlementInfoLabel;
@property (nonatomic, strong) UILabel * line;
@end


@interface OrderOperationCell : DSMyOrderCell

@property (nonatomic, strong) UIButton * leftButton;
@property (nonatomic, strong) UIButton * rightButton;

@end


