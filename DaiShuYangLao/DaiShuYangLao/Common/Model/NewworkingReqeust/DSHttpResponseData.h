//
//  DSHttpData.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/11.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DSHttpResponseData : NSObject

#pragma mark 首页

+ (void)homeGetData:(completeBlock)block cacheBlock:(completeBlock)cacheBlock;

/* 更新会员数量 */
+ (void)homeRefreshMemberShipNumber:(completeBlock)block;

// MARK: 商品详情

+ (void)homeGoodsDetalsInfoWithGoodsId:(NSString *)goodsId callback:(completeBlock)block;

/** 获取分享内容 params - >@{productId(Y),skuId(N)} */
+ (void)homeGetShareGoodsContentsWithParmas:(NSDictionary *)params callback:(completeBlock)block;

#pragma mark 分类 方法名均以 Classification 开头

/** 获取所有分类 */
+ (void)classificationsDataLoad:(completeBlock)block cacheBlock:(completeBlock)cacheBlock;

/** 获取某个分类的商品列表 */
+ (void)classificationGetGoodsListWithParams:(NSDictionary *)params callback:(completeBlock)block;

/** 搜索商品列表 */
+ (void)classificationSearchGoodsListWithParams:(NSDictionary *)params callback:(completeBlock)block;

/** 获取领航会员分类id */
+ (void)classificationGetMembershipClassficationId:(completeBlock)block;

#pragma mark 我的 方法名均以 Mine 开头

/* 获取用户信息 */
+ (void)mineGetUserInfo:(completeBlock)block;

/** 获取用户可用积分 与 购物金 */
+ (void)mineGetUserPointAndGoldAmount:(completeBlock)block;

/** 获取会员相关信息 */
+ (void)mineGetMenbershipInfoWithToken:(NSString *)token callback:(completeBlock)block;

/** 编辑个人信息 */
+ (void)mineEditUserInfoWtihParams:(NSDictionary *)params imageModel:(DSUploadingImageModel *)imageModel callback:(completeBlock)block;

/** 获取订单详细 */
+ (void)minePensionDetailListGetByParams:(NSDictionary *)params callback:(completeBlock)block;

/** 获取购物金明细 */
+ (void)mineGoldDetailListGetByParams:(NSDictionary *)params callback:(completeBlock)block;

/** 领航会员 params -> {name, idNo,invitationCode,level} */
+ (void)mineUpgradeMembershipWithParams:(NSDictionary *)params callback:(completeBlock)block;

/**< 提现 params - >{amount 提现金额,type 1支付宝 2微信,accountNo 账户,accountName 用户真实姓名} */
+ (void)mineWithdrawCashWithParams:(NSDictionary *)params callback:(completeBlock)block;

/**< 请求提现配置 如手续费用 等 */
+ (void)mineWithdrawCashConfigure:(completeBlock)block;

/**< 获取用户期权明细 */
+ (void)mineGetOptionsDetailwithParams:(NSDictionary *)params  callback:(completeBlock)block;

/** 用户签到 */
+ (void)mineClockin:(completeBlock)block;

/**< 获取qr code 内容 */
+ (void)mineGetQRCodeContent:(completeBlock)block;

#pragma mark 登录注册  方法名均以 Log 开头

/* 开始注册 */
+ (void)LoginStartRegistWithParams:(NSDictionary *)params callback:(completeBlock)block;

/** 获取验证码 */
+ (void)LoginGetVerificationCodeWithParams:(NSDictionary *)params callback:(completeBlock)block;

/** 开始登陆 */
+ (void)LoginWithParams:(NSDictionary *)params callback:(completeBlock)block;

/**< 使用第三方账号登录 */
+ (void)loginWithThirdPartyAccount:(NSDictionary *)params callback:(completeBlock)block;

/** 重设密码 */
+ (void)LoginResetPasswordWithParams:(NSDictionary *)params callback:(completeBlock)block;

/**< 手机号与第三方平台绑定 params - > uid,phone,code,type (0 微信 1qq 2微博) */
+ (void)loginBindPhoneWithThirdPlatForm:(NSDictionary *)params callback:(completeBlock)block;

/** 登出  */
+ (void)Logout:(completeBlock)block;

#pragma mark 地址管理 address

/* 获取地址列表 */
+ (void)addressList:(completeBlock)block;

/* 添加新地址 */
+ (void)addressAddNewOneWithParams:(NSDictionary *)params callback:(completeBlock)block;

/* 删除新地址 */
+ (void)addressDeleteWithParams:(NSDictionary *)params callback:(completeBlock)block;

/* 编辑用户地址 */
+ (void)addressEditInfoWithParams:(NSDictionary *)params callback:(completeBlock)block;

/** 获取运费 */
+ (void)addressGetCarriageByAddressId:(NSString *)addressId callback:(completeBlock)block;

#pragma mark 购物车 Shop Cart

/** 获取购物车所有商品 */
+ (void)shopCartGetAllGoods:(completeBlock)block;

/** 添加购物车 */
+ (void)shopCartAddGoods:(NSString *)goodsId skuId:(NSString *)skuId number:(NSInteger)number callback:(completeBlock)block;

/** 多个商品加入购物车 [{productId,num,skuId}] */
+ (void)shopCartAddManyGoods:(NSString *)goodsInfo callback:(completeBlock)block;

/** 修改购物车数量 */
+ (void)shopCartUpdateGoods:(NSString *)goodsId number:(NSInteger)number callback:(completeBlock)block;

/** 购物车删除商品 goodsids -> @"123,124" */
+ (void)shopCartDeleteGoods:(NSString *)goodsIds callback:(completeBlock)block;

#pragma mark 订单 Order

/** 提交订单 productInfo [{productId,skuId,price,num}] 并转成json字符串   */
+ (void)OrderSubmitOrderwithProductInfo:(NSString *)productInfo addressId:(NSString *)addressId callback:(completeBlock)block;

/** 根据订单号生成订单信息 调用支付宝 orderNumber 订单编号 point 使用的积分 gold  购物金*/
+ (void)orderGetAlipayPayOrderInfoWithParams:(NSDictionary *)params callback:(completeBlock)block;

/** 根据订单号生成订单信息 调用微信 orderNumber 订单编号 point 使用的积分 gold  购物金*/
+ (void)orderGetWechatPayOrderInfoWithParams:(NSDictionary *)params callback:(completeBlock)block;

///** 根据地址获取运费 */
//+ (void)orderGetCarriageByAddressId:(NSString *)addressId callback:(completeBlock)block;

/** -1=全部订单，0=未付款,1=已付款,2=已发货,3=已签收,4=退货申请,5=退货中,6=已退货,99=取消交易，100=交易完成。默认-1 */
+ (void)orderGetOrderListByStatus:(NSInteger)status pageNumber:(NSInteger)pageNumber pageSize:(NSInteger)pageSize callback:(completeBlock)block;

/**< orderid 订单编号 */
+ (void)orderGetOrderDetailInfoByOrderId:(NSString *)orderId callback:(completeBlock)block;

/** type -> 1 取消 2 删除 3 确认收货 4 提醒发货  */
+ (void)orderOperationWithOperationType:(NSInteger)type orderId:(NSString *)orderId callback:(completeBlock)block;

#pragma mark 收藏 collection

/** 获取收藏列表 */
+ (void)collectionGetAllCollectionsWithPagenum:(NSInteger)pageNum pageSize:(NSInteger)pageSize callback:(completeBlock)block;

/** 根据id收藏商品 */
+ (void)collectionGoodsByGoodsid:(NSString *)goodsId callback:(completeBlock)block;

/** 根据id删除收藏商品 多个id用逗号分隔 */
+ (void)collectionDeleteGoodsByGoodsid:(NSString *)goodsId callback:(completeBlock)block;

#pragma mark 启动

/* 启动配置 */
+ (void)LaunchInfoConfigure:(completeBlock)block;

/** 关于我们 */
+ (void)aboutusInfoGet:(completeBlock)block;

#pragma  mark 公用方法

+ (void)PublicCheckValidityOfToken:(completeBlock)block;

@end


