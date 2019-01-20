//
//  DSOrderListModel.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/28.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSBaseModel.h"
#import "DSOrderInfoModel.h"

@interface DSOrderListModel : DSBaseModel

@property (nonatomic, copy) NSString * order_id;
@property (nonatomic, copy) NSString * orderNo;      //订单编号
@property (nonatomic, copy) NSString * expressNo;    //物流单号
@property (nonatomic, copy) NSArray * products;       //产品信息列表
@property (nonatomic, copy) NSString * amount;       //订单金额
@property (nonatomic, copy) NSString * payChannel;   //0=未知，1=支付宝，2=微信
@property (nonatomic, copy) NSString * payAmount;    //支付金额
@property (nonatomic, copy) NSString * point;        //消费积分
@property (nonatomic, copy) NSString * orderTime;    //下单时间，时间格式yyyy-MM-dd HH:mm:ss
@property (nonatomic, copy) NSNumber * status;       //订单状态 0=未付款,1=已付款,2=已发货,3=已签收,4=退货申请,5=退货中,6=已退货,99=取消交易，100=交易完成
@property (nonatomic, copy) NSString * statusMsg;    //详查状态描述
@property (nonatomic, copy) NSString * productNum;      //商品数
@property (nonatomic, copy) NSString * logisticsFee;    //物流费用
@property (nonatomic, copy) NSString * gold;  /**< 购物金 */
@property (nonatomic, strong) OrderMerchantModel * merchant; //商家


@end
