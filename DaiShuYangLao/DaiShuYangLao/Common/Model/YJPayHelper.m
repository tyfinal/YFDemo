//
//  YJPayHelper.m
//  YJRRT
//
//  Created by apple on 2017/6/1.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "YJPayHelper.h"
#import <AlipaySDK/AlipaySDK.h>
#import <WXApi.h>

static NSString * const alipaySchemeName    = @"dslocation";
static NSString * const wechatpaySchemeName = @"dslocation";

//static NSString * const alipay_app_id    = @"201706011701";

@interface YJPayHelper()<WXApiDelegate>{
    
}

@end

static YJPayHelper * _payHelper = nil;
@implementation YJPayHelper

//单例
+ (instancetype)sharePayHelper{
    if (!_payHelper) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _payHelper = [[YJPayHelper alloc]init];
        });
    }
    return _payHelper;
}

/* 注册应用 */
- (void)registerAppWithPaymentMode:(PaymentMode)mode{
    if (mode==Payment_ALiPay) {
        
    }else if (mode==Payment_WeChatPay){
        [WXApi registerApp:kWechat_app_key];
    }
}

/* 处理支付软件通过URL回到App时传递的数据 */
- (BOOL)handleOpenUrl:(NSURL *)url{
    if ([url.host isEqualToString:@"safepay"]) {
        [self handelAlipayOpenUrl:url]; //支付宝返回app
        return YES;
    }else if ([url.host isEqualToString:@"pay"]){
        return [WXApi handleOpenURL:url delegate:self]; //微信返回app
    }else{
        return NO;
    }
}

//支付宝返回app
- (void)handelAlipayOpenUrl:(NSURL *)url{
    // 支付跳转支付宝钱包进行支付，处理支付结果
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        JXLog(@"%@",resultDic);
        [self alipayCallbackHandleWithResult:resultDic];
    }];
    
    // 授权跳转支付宝钱包进行支付，处理支付结果
    [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
        NSLog(@"result = %@",resultDic);
        // 解析 auth code
        NSString *result = resultDic[@"result"];
        NSString *authCode = nil;
        if (result.length>0) {
            NSArray *resultArr = [result componentsSeparatedByString:@"&"];
            for (NSString *subResult in resultArr) {
                if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                    authCode = [subResult substringFromIndex:10];
                    break;
                }
            }
        }
        NSLog(@"授权结果 authCode = %@", authCode?:@"");
    }];
}

#pragma mark 支付订单

/* 支付订单并返回支付结果 */
- (void)payOrder:(id)order paymentMode:(PaymentMode)mode{
    if (mode==Payment_WeChatPay) {
        //微信支付
        [WXApi sendReq:(PayReq  *)order];
    }else if (mode==Payment_ALiPay){
        //支付宝支付
        [[AlipaySDK defaultService] payOrder:(NSString *)order fromScheme:alipaySchemeName callback:^(NSDictionary *resultDic){
            //如果没有安装支付宝并在网页端进行支付 回调在此
            [self alipayCallbackHandleWithResult:resultDic];
        }];
    }
}


/*
 *9000    订单支付成功
 *8000    正在处理中，支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
 *4000    订单支付失败
 *5000    重复请求
 *6001    用户中途取消
 *6002    网络连接出错
 *6004    支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
 * resultDic - > {memo 提示}
 */
- (void)alipayCallbackHandleWithResult:(NSDictionary *)resultDic{
    JXLog(@"%@",resultDic);
    
    NSString *resultStatus = resultDic[@"resultStatus"];
     //NSString * memo = resultDic[@"memo"];
    if (resultStatus.integerValue==4000) {
        if (self.alipayPayResultCallback) {
            self.alipayPayResultCallback(nil, NO, @"-1");
        }
        //memo = @"支付失败";
    }else if (resultStatus.integerValue==9000){
        if (self.alipayPayResultCallback) {
            self.alipayPayResultCallback(nil, YES, @"0");
        }
        //memo = @"支付成功";
    }else if (resultStatus.integerValue==6001){
        //memo = @"支付已取消";
        if (self.alipayPayResultCallback) {
            self.alipayPayResultCallback(nil, NO, @"-1");
        }
    }
}

#pragma mark - WXApiDelegate

/*  0    成功    展示成功页面
 * -1    错误    可能的原因：签名错误、未注册APPID、项目设置APPID不正确、注册的APPID与设置的不匹配、其他异常等。
 * -2    用户取消    无需处理。发生场景：用户不支付了，点击取消，返回APP。
 */
- (void)onResp:(BaseResp *)resp {
    // 判断支付类型
    if([resp isKindOfClass:[PayResp class]]){
//        PayResp * payResponse = (PayResp *)resp;
        if (self.wechatPayResultCallback) {
            if (resp.errCode==0) {
                self.wechatPayResultCallback(nil, YES, @"0");
            }else{
                self.wechatPayResultCallback(nil, NO, @"-1");
            }
        }
    }
}


@end
