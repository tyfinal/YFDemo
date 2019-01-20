//
//  DSEnumHeader.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/12.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#ifndef DSEnumHeader_h
#define DSEnumHeader_h


#endif /* DSEnumHeader_h */

/** 订单类型 */
typedef NS_ENUM(NSInteger,DSOrderRequestType) {
    DSOrderRequestAll                   = -1,   /**< 所有订单 */
    DSOrderRequestWaitForPayment        = 0,    /**< 待付款 */
    DSOrderRequestWaitForDelivery       = 1,    /**< 待发货 */
    DSOrderRequestWaitForReceiving      = 2,    /**< 待收货 */
    DSOrderRequestReceived              = 3,    /**< 已签收 */
    DSOrderRequestCanApplyRefund        = 4,    /**< 退款申请 */
    DSOrderRequestRefunding             = 5,    /**< 退款中 */
    DSOrderRequestRefunded              = 6,    /**< 已退款 */
    DSOrderRequestTradeCaceled          = 99,   /**< 交易取消 */
    DSOrderRequestTradeSuccess          = 100,  /**< 交易完成 */
    DSOrderRequestOrderDidDelete        = -100, /**< 订单已删除  自定义 */ 
};


/* 数据刷新状态 */
typedef NS_ENUM(NSInteger, DSRefreshFlag) {
    DSRefreshFirstTimeLoad   = 1,        /**< 初次加载 */
    DSRereshHeader           = 2,        /**< 下拉刷新 */
    DSRereshFooter           = 3,        /**< 上拉加载 */
};


/** 数据加载状态 */
typedef NS_ENUM(NSInteger,DSLoadDataStatus){
    DSBeginLoadingData = 0,    /**< 正在加载数据 */
    DSLoadDataFailed = -1,     /**< 数据加载失败 */
    DSLoadDataSuccessed = 1,   /**< 数据加载成功 */
};








