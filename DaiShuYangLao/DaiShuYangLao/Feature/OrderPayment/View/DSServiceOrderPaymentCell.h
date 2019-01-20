//
//  DSServiceOrderPaymentCell.h
//  DaiShuYangLao
//
//  Created by YueLiang Song on 2018/10/18.
//  Copyright © 2018 tyfinal. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DSServiceOrderPaymentCell : UITableViewCell

@property (nonatomic, assign) BOOL didSetupLayout;

@property (nonatomic, strong) id model;

//@property (nonatomic, assign) id<OrderConfirmCellDelegate>delegate;

@end

NS_ASSUME_NONNULL_END


@interface ServiceOrderCheckOutCell : DSServiceOrderPaymentCell




@end


@interface ServiceOrderPromptCell : DSServiceOrderPaymentCell

@end
