//
//  DSPensionCell.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/5.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DSPensionDetailModel;
@interface DSPensionCell : UITableViewCell

//@property (nonatomic, strong) UILabel * ;
@property (nonatomic, strong) UILabel * expenseTypeLabel;       /**< 消费类型 */
@property (nonatomic, strong) UILabel * pensionAmountLabel;     /**< 积分余额 */
@property (nonatomic, strong) UILabel * dateLabel;              /**< 时间 */
@property (nonatomic, strong) UILabel * expenseAmountLabel;     /**< 积分变动 */

@property (nonatomic, strong) UIView * seperator;

@property (nonatomic, assign) NSInteger cellType; /**< 1积分 2购物金 3期权 需先于model赋值 默认为1 */
@property (nonatomic, assign) DSPensionDetailModel * model; 

@end
