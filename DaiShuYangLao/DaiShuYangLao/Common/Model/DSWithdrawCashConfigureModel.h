//
//  DSWithdrawCashConfigureModel.h
//  DaiShuYangLao
//
//  Created by YueLiang Song on 2018/7/27.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSBaseModel.h"

@interface DSWithdrawCashConfigureModel : DSBaseModel

@property (nonatomic, copy) NSString * withdrawServiceFee; /**< 提现手续费 */
@property (nonatomic, copy) NSString * withdrawMinimumLimit; /**< 提现需保留的积分额度 例如 100，即用户只能提超过100的部分 */
@property (nonatomic, copy) NSString * withdrawMinimum; /**< 提现最低限额 例如 100， 即现金额必须大于100 */

@property (nonatomic, copy) NSString * info;       /**< 连续签到获得提现额度的面熟 */

@property (nonatomic, copy) NSString * isWithdraw; /**< 1用户提现过 0没有 */
@property (nonatomic, copy) NSString * withdrawAmount; /**< 单词提现金额 */
@property (nonatomic, copy) NSString * withdrawNum; /**< 当月提现次数 */
@property (nonatomic, copy) NSString * withdrawFirst; /**< 用户首次提现金额 */
@property (nonatomic, copy) NSString * withdrawAvailable; /**< 用户可提现额度 */

@end
