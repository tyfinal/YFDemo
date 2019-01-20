//
//  DSMembershipInfoModel.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/21.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSBaseModel.h"

@interface DSMembershipInfoModel : DSBaseModel

@property (nonatomic, copy) NSString *star;  //星级，未登录为0
@property (nonatomic, copy) NSString *inviteFirstNum;  //一级数量，未登录为0
@property (nonatomic, copy) NSString *inviteSecondNum; //二级数量，未登录为0
@property (nonatomic, copy) NSArray *banners;  //banner
@property (nonatomic, copy) NSArray *orderNum; //各状态下的订单数量。格式：[待付款数量，已付款数量，已发货数量] ，登录为0


@end
