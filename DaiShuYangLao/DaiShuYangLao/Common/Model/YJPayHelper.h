//
//  YJPayHelper.h
//  YJRRT
//
//  Created by apple on 2017/6/1.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^PaymentCompletionBlock)(NSString * message,id response);


typedef NS_ENUM(NSUInteger,PaymentMode){
    Payment_ALiPay,
    Payment_WeChatPay,
    Payment_UnionPay,
    Payment_ApplePay,
};


@interface YJPayHelper : NSObject

@property (nonatomic, copy) completeBlock alipayPayResultCallback; //

@property (nonatomic, copy) completeBlock wechatPayResultCallback;

//单例
+ (instancetype)sharePayHelper;

/* 注册应用 */
- (void)registerAppWithPaymentMode:(PaymentMode)mode;

/* 处理支付软件通过URL回到App时传递的数据 */
- (BOOL)handleOpenUrl:(NSURL *)url;

/* 支付订单并返回支付结果 */
- (void)payOrder:(id)order paymentMode:(PaymentMode)mode;

@end
