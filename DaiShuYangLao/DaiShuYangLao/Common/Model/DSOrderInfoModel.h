//
//  DSOrderInfoModel.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/14.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSBaseModel.h"

@class DSGoodsInfoModel;
@class OrderProductInfoModel;
@class OrderProductInfoModel;
@class OrderShippingAddressModel;
@class OrderMerchantModel;

@interface DSOrderInfoModel : DSBaseModel

@property (nonatomic, copy) NSString * order_id;
@property (nonatomic, copy) NSString * orderNo;        //订单编号
@property (nonatomic, copy) NSArray * products;
@property (nonatomic, copy) NSString * amount;           //订单金额
@property (nonatomic, copy) NSString * payChannel;      //支付渠道 0未知 1支付宝 2微信
@property (nonatomic, copy) NSString * payAmount;       //支付金额
@property (nonatomic, copy) NSString * point;           //消费积分
@property (nonatomic, copy) NSString * remark;          //用户备注
@property (nonatomic, copy) NSString * productNum;      //商品数
@property (nonatomic, copy) NSString * orderTime;       //下单时间
@property (nonatomic, copy) NSString * payTime;         //支付时间
@property (nonatomic, copy) NSString * sendTime;        //发货时间
@property (nonatomic, copy) NSString * receiveTime;     //收货时间
@property (nonatomic, copy) NSString * status;          //订单状态 0=未付款,1=已付款,2=已发货,3=已签收,4=退货申请,5=退货中,6=已退货,99=取消交易 100交易完成
@property (nonatomic, copy) NSString * statusMsg;       //详查状态描述
@property (nonatomic, copy) NSArray * logistics;        //物流
@property (nonatomic, copy) NSString * expressNo;       //物流单号
@property (nonatomic, copy) NSString * logisticsFee;    //物流费用
@property (nonatomic, strong) OrderMerchantModel * merchant; //商家
@property (nonatomic, copy) NSString * gold; /**< 购物金 */

@property (nonatomic, strong) OrderShippingAddressModel * shippingAddress;

@end


@interface OrderProductInfoModel : DSBaseModel

@property (nonatomic, copy) NSString * goods_id;
@property (nonatomic, copy) NSString * name;      //名称
@property (nonatomic, copy) NSString * info;
@property (nonatomic, copy) NSString * minPic;    //小图
@property (nonatomic, copy) NSString * num;       //数量
@property (nonatomic, copy) NSString * price;     //单价
@property (nonatomic, copy) NSString * amount;    //金额
@property (nonatomic, copy) NSString * remark;    //备注
@property (nonatomic, strong) GoodsDetailSaleInfo * sku;

@end


@interface OrderLogisticsModel : DSBaseModel

@property (nonatomic, copy) NSString * name;      //物流公司名称
@property (nonatomic, copy) NSString * logo;      //物流公司logo

@end


@interface OrderShippingAddressModel : DSBaseModel

@property (nonatomic, copy) NSString * name;       //收货人姓名
@property (nonatomic, copy) NSString * phone;     //手机
@property (nonatomic, copy) NSString * address;    //收货地址
@property (nonatomic, copy) NSString * postcode;   //邮编

@end


@interface OrderMerchantModel : DSBaseModel

@property (nonatomic, copy) NSString * merchant_id;
@property (nonatomic, copy) NSString * name;
@end


@interface OrderSkuModel : DSBaseModel

@property (nonatomic, copy) NSString * code;
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, copy) NSString * sku_id;
@property (nonatomic, copy) NSString * inventoryNum;
@property (nonatomic, copy) NSString * originalPrice;
@property (nonatomic, copy) NSString * price;
@property (nonatomic, copy) NSString * productId;
@property (nonatomic, copy) NSString * sellNum;
@property (nonatomic, copy) NSString * sku;

@end


