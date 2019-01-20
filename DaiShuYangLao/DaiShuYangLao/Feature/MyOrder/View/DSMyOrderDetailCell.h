//
//  DSMyOrderDetailCell.h
//  DaiShuYangLao
//
//  Created by YueLiang Song on 2018/7/10.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DSOrderInfoModel;
@class DSMyOrderDetailCell;

@protocol DSMyOrderDetailCellDelegate <NSObject>
@optional;
- (void)ds_myOrderDetailCell:(DSMyOrderDetailCell *)cell buttonClickHandle:(NSString *)buttonHandle;

@end

@interface DSMyOrderDetailCell : UITableViewCell

@property (nonatomic, assign) BOOL didSetupLayout;
@property (nonatomic, strong) UIView * seperator;

@property (nonatomic, copy) NSString * cellKey;  /**< 必须优先赋值 */
@property (nonatomic, strong) DSOrderInfoModel * orderModel;
@property (nonatomic, copy) NSDictionary * orderInfoDic;

@property (nonatomic, weak) id<DSMyOrderDetailCellDelegate>delegate;

@end

//MARK:订单状态
@interface MyOrderDetailStatusCell : DSMyOrderDetailCell

@property (nonatomic, strong) UIImageView * statusIcon;
@property (nonatomic, strong) UILabel * statusLabel;

@end

//MARK:普通
@interface MyOrderDetailCommonCell : DSMyOrderDetailCell

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * contentLabel;
@property (nonatomic, strong) UIButton * operationButton;

@end

//MARK:地址信息
@interface MyOrderDetailAddressCell : DSMyOrderDetailCell
@property (nonatomic, strong) UILabel * userNameLabel;
@property (nonatomic, strong) UILabel * phoneLabel;
@property (nonatomic, strong) UILabel * addressLabel;

@end

//MARK:结算
@interface MyOrderDetailCheckOutCell : DSMyOrderDetailCell

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * amountLabel;

@end

//MARK:操作
@interface MyOrderDetailOperationCell : DSMyOrderDetailCell

@property (nonatomic, strong) UIButton * leftButton;
@property (nonatomic, strong) UIButton * rightButton;

@end
