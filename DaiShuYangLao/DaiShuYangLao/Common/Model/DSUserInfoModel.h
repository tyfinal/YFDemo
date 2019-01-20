//
//  DSUserInfoModel.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/12.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSBaseModel.h"

@interface DSUserInfoModel : DSBaseModel<NSCoding>

@property (nonatomic, copy) NSString * user_id;
@property (nonatomic, copy) NSString * name;      //用户姓名
@property (nonatomic, copy) NSString * avatar;    //用户头像
@property (nonatomic, copy) NSString * point;     //用户积分
@property (nonatomic, copy) NSString * nickname;  //用户昵称
@property (nonatomic, copy) NSString * gender;    //用户性别
@property (nonatomic, copy) NSString * invitationCode;    //用户邀请码
@property (nonatomic, copy) NSString * phone;     //用户手机号
@property (nonatomic, copy) NSString * availablePoint;    //用户可用积分
@property (nonatomic, copy) NSString * consumptionAmount; //消费金额
@property (nonatomic, copy) NSString * canWithdrawPoint; //可提现金额
@property (nonatomic, copy) NSString * level;     //级别 1普通会员 2 领航会员
@property (nonatomic, copy) NSString * idNo;      //身份证号
@property (nonatomic, copy) NSString * email;     //email号
@property (nonatomic, copy) NSString * address;   //地址号
@property (nonatomic, copy) NSString * birthday;  //生日
@property (nonatomic, copy) NSString * workYears; //工龄
@property (nonatomic, copy) NSString * jobTitle;  //领航会员 额外身份信息
@property (nonatomic, copy) NSString * expireTime; //领航会员到期时间
@property (nonatomic, copy) NSString * availableGold;    //用户可用购物金
@property (nonatomic, copy) NSString * consumptionGold;  //用户消费的购物金；
@property (nonatomic, copy) NSString * companyOption; //公司期权
@property (nonatomic, copy) NSString * isCertification; /**< 用户是否实名 */
@property (nonatomic, copy) NSString * access_token;
@end
