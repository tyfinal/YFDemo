//
//  DSOrderPaymentCell.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/4.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PaymentOrderInfoCell;
@interface DSOrderPaymentCell : UITableViewCell

@property (nonatomic, assign) BOOL didSetupLayout;
@property (nonatomic, assign) id model;
@property (nonatomic, strong) UIView * seperator;  /**< 分割线 */

@end


@interface PaymentOrderInfoCell : DSOrderPaymentCell

@property (nonatomic, strong) UIImageView * dotImageView; /**< 小圆点 */
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * amountLabel;      /**< 金额 */

@end



@interface PaymentWayCell : DSOrderPaymentCell

@property (nonatomic, strong) UIImageView * backgroundImageView;
@property (nonatomic, strong) UIImageView * payemntImageView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIButton * button;



@end














