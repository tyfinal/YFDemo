//
//  DSHttpData.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/11.
//  Copyright © 2018年 tyfinal. All rights reserved.
//  对响应的数据进行处理并返回

#import "DSHttpResponseCodeHandle.h"
#import "MBProgressHUD+JXAdd.h"
#import <MJExtension.h>
#import "DSParametersSignature.h"
#import "DSHttpRequest.h"
#import "DSClassificationModel.h"
#import "DSGoodsInfoModel.h"
#import "DSUserInfoModel.h"
#import "DSHomeModel.h"
#import "DSUserAddress.h"
#import "DSHttpResponseCodeHandle.h"
#import "DSGoodsDetailInfoModel.h"
#import "DSMembershipInfoModel.h"
#import "DSShopCartModel.h"
#import "DSPensionDetailModel.h"
#import "DSOrderListModel.h"
#import "DSAboutUsModel.h"
#import "PPNetworkCache.h"
#import "DSOrderInfoModel.h"
#import "DSWithdrawCashConfigureModel.h"
#import "DSClockInDetailModel.h"
#import <WXApi.h>
#import "DSUserInfoModel.h"

static NSString * const kToken_Type_Paramter  = @"parameter";

static NSString * const kToken_Type_HttpField = @"httpfield";

@implementation DSHttpResponseData

#pragma mark 首页

+ (void)homeGetData:(completeBlock)block cacheBlock:(completeBlock)cacheBlock{
    NSString * urlStr = [NSString stringWithFormat:@"%@api/homeV2",DS_APP_SERVER];
    DSHomeModel * cacheModel = [PPNetworkCache httpCacheForURL:urlStr parameters:nil];
    if (cacheModel&&cacheBlock) {
        cacheBlock(cacheModel,YES,nil);
    }
    NSString * token = [[JXAccountTool account]access_token];
    if ([token isNotBlank]) {
        token = kToken_Type_Paramter;
    }else{
        token = nil;
    }
    [DSHttpResponseCodeHandle getWirhUrl:urlStr parms:nil token:token success:^(id json) {
        JXLog(@"%@",json);
        if ([json[@"error"] integerValue]==0) {
            DSHomeModel * model = [DSHomeModel mj_objectWithKeyValues:json[@"data"]];
            if (model) {
                [PPNetworkCache setHttpCache:model URL:urlStr parameters:nil];
            }
            if (block) {
                block(model,YES,nil);
            }
        }else{
            if ([json[@"msg"] isNotBlank]) {
                [MBProgressHUD showText:json[@"msg"]  toView:nil];
            }
            if (block) {
                block(nil,NO,nil);
            }
        }
    } failture:^(id error) {
        if (block) {
            block(nil,NO,nil);
        }
    }];
}

/* 更新会员数量 */
+ (void)homeRefreshMemberShipNumber:(completeBlock)block{
    NSString * urlStr = [NSString stringWithFormat:@"%@api/home/vipNum",DS_APP_SERVER];
    
    [DSHttpResponseCodeHandle getWirhUrl:urlStr parms:nil token:nil success:^(id json) {
        JXLog(@"%@",json);
        if ([json[@"error"] integerValue]==0) {
            NSString * vipNumber = [NSString stringWithFormat:@"%@",json[@"data"][@"vipNum"]];
            if (block) {
                block(vipNumber,YES,nil);
            }
        }else{
            if ([json[@"msg"] isNotBlank]) {
                [MBProgressHUD showText:json[@"msg"]  toView:nil];
            }
            if (block) {
                block(nil,NO,nil);
            }
        }
    } failture:^(id error) {
        if (block) {
            block(nil,NO,nil);
        }
    }];
}

// MARK: 商品详情

+ (void)homeGoodsDetalsInfoWithGoodsId:(NSString *)goodsId callback:(completeBlock)block{
    NSString * urlStr = [NSString stringWithFormat:@"%@api/product/info",DS_APP_SERVER];
    NSMutableDictionary * params = @{}.mutableCopy;
    params[@"productId"] = goodsId;
    
    DSUserInfoModel * account = [JXAccountTool account];
    NSString * token = nil;
    if ([account.access_token isNotBlank]) {
        token = kToken_Type_Paramter;
    }
    
    //    urlStr = [self combineUrlStringWithParameters:params urlString:urlStr];
    [DSHttpResponseCodeHandle getWirhUrl:urlStr parms:params token:token success:^(id json) {
        JXLog(@"%@",json);
        if ([json[@"error"] integerValue]==0) {
            DSGoodsDetailInfoModel * goodsDetailInfoModel = [DSGoodsDetailInfoModel mj_objectWithKeyValues:json[@"data"][@"product"]];

            if (block) {
                block(goodsDetailInfoModel,YES,nil);
            }
        }else{
            if ([json[@"msg"] isNotBlank]) {
                [MBProgressHUD showText:json[@"msg"]  toView:nil];
            }
            if (block) {
                block(nil,NO,nil);
            }
        }
    } failture:^(id error) {
        if (block) {
            block(nil,NO,nil);
        }
    }];
}

/** 获取分享内容 */
+ (void)homeGetShareGoodsContentsWithParmas:(NSDictionary *)params callback:(completeBlock)block{
    NSString * urlStr = [NSString stringWithFormat:@"%@open/api/share/product",DS_APP_SERVER];
    [DSHttpResponseCodeHandle getWirhUrl:urlStr parms:params token:nil success:^(id json) {
        JXLog(@"%@",json);
        if ([json[@"error"] integerValue]==0) {
            NSDictionary * data = json[@"data"];
            NSMutableDictionary * params = [NSMutableDictionary dictionary];
            if([data[@"url"] isNotBlank]) params[@"weburl"] = data[@"url"];
            DSUserInfoModel * account = [JXAccountTool account];
            if ([account.user_id isNotBlank]&&[params[@"weburl"] isNotBlank]) {
                params[@"weburl"] = [NSString stringWithFormat:@"%@&dsInviterUserId=%@",params[@"weburl"],account.user_id];
            }
            if([data[@"icon"] isNotBlank]) params[@"imageurl"] = data[@"icon"];
            
            if([data[@"title"] isNotBlank]) params[@"text"] = data[@"title"];
            if([data[@"description"] isNotBlank]) params[@"desc"] = data[@"description"];
            if([data[@"circleTitle"] isNotBlank]) params[@"detaildesc"] = data[@"circleTitle"];
            

            if (block) {
                block(params,YES,nil);
            }
        }else{
            if ([json[@"msg"] isNotBlank]) {
                [MBProgressHUD showText:json[@"msg"]  toView:nil];
            }
            if (block) {
                block(nil,NO,nil);
            }
        }
    } failture:^(id error) {
        if (block) {
            block(nil,NO,nil);
        }
    }];
}

#pragma mark 分类 方法名均以 Classification 开头

/** 获取所有分类 */
+ (void)classificationsDataLoad:(completeBlock)block cacheBlock:(completeBlock)cacheBlock{
    NSString * urlStr = [NSString stringWithFormat:@"%@api/category/list",DS_APP_SERVER];
    NSArray * cacheArray = [PPNetworkCache httpCacheForURL:urlStr parameters:nil];
    if (cacheArray&&cacheBlock) {
        cacheBlock(cacheArray,YES,nil);
    }
    [DSHttpResponseCodeHandle getWirhUrl:urlStr parms:nil token:nil success:^(id json) {
        JXLog(@"%@",json);
        if ([json[@"error"] integerValue]==0) {
            NSArray * dataArray = [DSClassificationModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"categories"]];
            [PPNetworkCache setHttpCache:dataArray URL:urlStr parameters:nil];
            if (block) {
                block(dataArray,YES,nil);
            }
        }else{
            if ([json[@"msg"] isNotBlank]) {
                [MBProgressHUD showText:json[@"msg"]  toView:nil];
            }
            if (block) {
                block(nil,NO,nil);
            }
        }
    } failture:^(id error) {
        if (block) {
            block(nil,NO,nil);
        }
    }];
}

/** 获取某个分类的商品列表 */
+ (void)classificationGetGoodsListWithParams:(NSDictionary *)params callback:(completeBlock)block{
    NSMutableDictionary * actualParams = [NSMutableDictionary dictionaryWithDictionary:params];
    NSString * subUrlStr = @"api/product/list";
    if ([params[@"specialclass"] isEqualToString:@"1"]) {
        subUrlStr = @"api/section/products";
        [actualParams removeObjectForKey:@"specialclass"];
    }else if ([params[@"specialclass"] isEqualToString:@"2"]){
        subUrlStr = @"api/banner/products";
        [actualParams removeObjectForKey:@"specialclass"];
    }
    
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",DS_APP_SERVER,subUrlStr];

    [DSHttpResponseCodeHandle getWirhUrl:urlStr parms:actualParams token:nil success:^(id json) {
        JXLog(@"%@",json);
        if ([json[@"error"] integerValue]==0) {
            if ([json[@"data"] isKindOfClass:[NSString class]]) {
                if (block) {
                    block(@[],YES,nil);
                }
            }else{
                NSArray * dataArray = [DSGoodsInfoModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"products"]];
                if (block) {
                    block(dataArray,YES,nil);
                }
            }
        }else{
            if ([json[@"msg"] isNotBlank]) {
                [MBProgressHUD showText:json[@"msg"]  toView:nil];
            }
            if (block) {
                block(nil,NO,nil);
            }
        }
    } failture:^(id error) {
        if (block) {
            block(nil,NO,nil);
        }
    }];
}

/** 搜索商品列表 */
+ (void)classificationSearchGoodsListWithParams:(NSDictionary *)params callback:(completeBlock)block{
    NSString * urlStr = [NSString stringWithFormat:@"%@api/product/search",DS_APP_SERVER];
    
    [DSHttpResponseCodeHandle postWirhUrl:urlStr parms:params token:nil success:^(id json) {
        JXLog(@"%@",json);
        if ([json[@"error"] integerValue]==0) {
            if ([json[@"data"] isKindOfClass:[NSString class]]) {
                if (block) {
                    block(@[],YES,nil);
                }
            }else{
                NSArray * dataArray = [DSGoodsInfoModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"products"]];
                if (block) {
                    block(dataArray,YES,nil);
                }
            }
        }else{
            if ([json[@"msg"] isNotBlank]) {
                [MBProgressHUD showText:json[@"msg"]  toView:nil];
            }
            if (block) {
                block(nil,NO,nil);
            }
        }
    } failture:^(id error) {
        if (block) {
            block(nil,NO,nil);
        }
    }];
}

/** 获取领航会员分类id */
+ (void)classificationGetMembershipClassficationId:(completeBlock)block{
    NSString * urlStr = [NSString stringWithFormat:@"%@api/section/getVipId",DS_APP_SERVER];
    
    [DSHttpResponseCodeHandle postWirhUrl:urlStr parms:nil token:nil success:^(id json) {
        JXLog(@"%@",json);
        if ([json[@"error"] integerValue]==0) {
            NSString * membershipExclusiveId = [NSString stringWithFormat:@"%@",json[@"data"][@"id"]];
            if (block) {
                block(membershipExclusiveId,YES,nil);
            }
        }else{
            if ([json[@"msg"] isNotBlank]) {
                [MBProgressHUD showText:json[@"msg"]  toView:nil];
            }
            if (block) {
                block(nil,NO,nil);
            }
        }
    } failture:^(id error) {
        if (block) {
            block(nil,NO,nil);
        }
    }];
}

#pragma mark 我的 方法名均以 Mine 开头

/* 获取用户信息 */
+ (void)mineGetUserInfo:(completeBlock)block{
    NSString * urlStr = [NSString stringWithFormat:@"%@api/user/info",DS_APP_SERVER];
    
    [DSHttpResponseCodeHandle postWirhUrl:urlStr parms:nil token:kToken_Type_Paramter success:^(id json) {
        JXLog(@"%@",json);
        if ([json[@"error"] integerValue]==0) {
            DSUserInfoModel * model = [[DSUserInfoModel alloc]init];
            if (json[@"data"][@"userInfo"]) {
                model = [DSUserInfoModel mj_objectWithKeyValues:json[@"data"][@"userInfo"]];
            }
            if (block) {
                block(model,YES,nil);
            }
        }else{
            if ([json[@"msg"] isNotBlank]) {
                [MBProgressHUD showText:json[@"msg"]  toView:nil];
            }
            if (block) {
                block(nil,NO,nil);
            }
        }
    } failture:^(id error) {
        if (block) {
            block(nil,NO,nil);
        }
    }];
}

/** 获取用户可用积分 与 购物金 */
+ (void)mineGetUserPointAndGoldAmount:(completeBlock)block{
    NSString * urlStr = [NSString stringWithFormat:@"%@/api/user/myPoint",DS_APP_SERVER];
    
    [DSHttpResponseCodeHandle postWirhUrl:urlStr parms:nil token:kToken_Type_Paramter success:^(id json) {
        JXLog(@"%@",json);
        if ([json[@"error"] integerValue]==0) {
            if (block) {
                block(json[@"data"],YES,nil);
            }
        }else{
            if ([json[@"msg"] isNotBlank]) {
                [MBProgressHUD showText:json[@"msg"]  toView:nil];
            }
            if (block) {
                block(nil,NO,nil);
            }
        }
    } failture:^(id error) {
        if (block) {
            block(nil,NO,nil);
        }
    }];
    
}

/** 获取会员相关信息 */
+ (void)mineGetMenbershipInfoWithToken:(NSString *)token callback:(completeBlock)block;{
    NSString * urlStr = [NSString stringWithFormat:@"%@api/user/my",DS_APP_SERVER];
    if ([token isNotBlank]) {
        token = kToken_Type_Paramter;
    }else{
        token = nil;
    }
    
    [DSHttpResponseCodeHandle postWirhUrl:urlStr parms:nil token:token success:^(id json) {
        JXLog(@"%@",json);
        if ([json[@"error"] integerValue]==0) {
            DSMembershipInfoModel * model = [DSMembershipInfoModel mj_objectWithKeyValues:json[@"data"][@"userInfo"]];
            if (block) {
                block(model,YES,nil);
            }
        }else{
            if ([json[@"msg"] isNotBlank]) {
                [MBProgressHUD showText:json[@"msg"]  toView:nil];
            }
            if (block) {
                block(nil,NO,nil);
            }
        }
    } failture:^(id error) {
        if (block) {
            block(nil,NO,nil);
        }
    }];
}

+ (void)mineEditUserInfoWtihParams:(NSDictionary *)params imageModel:(DSUploadingImageModel *)imageModel callback:(completeBlock)block{
    NSString * urlStr = [NSString stringWithFormat:@"%@api/user/modifyInfo",DS_APP_SERVER];
    
    [DSHttpResponseCodeHandle postWirhUrl:urlStr parms:params token:kToken_Type_Paramter success:^(id json) {
        JXLog(@"%@",json);
        if ([json[@"error"] integerValue]==0) {
            if (block) {
                block(nil,YES,nil);
            }
        }else{
            if ([json[@"msg"] isNotBlank]) {
                [MBProgressHUD showText:json[@"msg"]  toView:nil];
            }
            if (block) {
                block(nil,NO,nil);
            }
        }
    } failture:^(id error) {
        if (block) {
            block(nil,NO,nil);
        }
    }];
}

/** 获取订单详细 */
+ (void)minePensionDetailListGetByParams:(NSDictionary *)params callback:(completeBlock)block{
    NSString * urlStr = [NSString stringWithFormat:@"%@api/user/pointDetails",DS_APP_SERVER];
    
    [DSHttpResponseCodeHandle postWirhUrl:urlStr parms:params token:kToken_Type_Paramter success:^(id json) {
        JXLog(@"%@",json);
        if ([json[@"error"] integerValue]==0) {
            NSArray * array = [DSPensionDetailModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"details"]];
            if (block) {
                block(array,YES,nil);
            }
        }else{
            if ([json[@"msg"] isNotBlank]) {
                [MBProgressHUD showText:json[@"msg"]  toView:nil];
            }
            if (block) {
                block(nil,NO,nil);
            }
        }
    } failture:^(id error) {
        if (block) {
            block(nil,NO,nil);
        }
    }];
}

/** 获取购物金明细 */
+ (void)mineGoldDetailListGetByParams:(NSDictionary *)params callback:(completeBlock)block{
    NSString * urlStr = [NSString stringWithFormat:@"%@api/user/gold/details",DS_APP_SERVER];
    
    [DSHttpResponseCodeHandle postWirhUrl:urlStr parms:params token:kToken_Type_Paramter success:^(id json) {
        JXLog(@"%@",json);
        if ([json[@"error"] integerValue]==0) {
            NSArray * array = [DSPensionDetailModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"details"]];
            if (block) {
                block(array,YES,nil);
            }
        }else{
            if ([json[@"msg"] isNotBlank]) {
                [MBProgressHUD showText:json[@"msg"]  toView:nil];
            }
            if (block) {
                block(nil,NO,nil);
            }
        }
    } failture:^(id error) {
        if (block) {
            block(nil,NO,nil);
        }
    }];
}

/** 领航会员 params -> {name, idNo,invitationCode,level} */
+ (void)mineUpgradeMembershipWithParams:(NSDictionary *)params callback:(completeBlock)block{
    NSString * urlStr = [NSString stringWithFormat:@"%@api/user/buyLevel",DS_APP_SERVER];
    [DSHttpResponseCodeHandle postWirhUrl:urlStr parms:params token:kToken_Type_Paramter success:^(id json) {
        JXLog(@"%@",json);
        if ([json[@"error"] integerValue]==0) {
            if ([json[@"data"][@"status"] integerValue]==0||[json[@"data"][@"status"] integerValue]==9) {
                if (block) {
                    block(json[@"data"][@"orderNo"],YES,json[@"data"][@"status"]);
                }
            }else{
                if ([json[@"data"][@"statusMsg"] isNotBlank]) {
                    [MBProgressHUD showText:json[@"data"][@"statusMsg"]  toView:nil];
                }
                if (block) {
                    block(nil,NO,nil);
                }
            }
        }else{
            if ([json[@"msg"] isNotBlank]) {
                [MBProgressHUD showText:json[@"msg"]  toView:nil];
            }
            if (block) {
                block(nil,NO,nil);
            }
        }
    } failture:^(id error) {
        if (block) {
            block(nil,NO,nil);
        }
    }];
}

/**< 提现 params - >{amount 提现金额,type 1支付宝 2微信,accountNo 账户,accountName 用户真实姓名} */
+ (void)mineWithdrawCashWithParams:(NSDictionary *)params callback:(completeBlock)block{
    NSString * urlStr = [NSString stringWithFormat:@"%@api/user/point/withdraw",DS_APP_SERVER];
    [DSHttpResponseCodeHandle postWirhUrl:urlStr parms:params token:kToken_Type_Paramter success:^(id json) {
        JXLog(@"%@",json);
        if ([json[@"error"] integerValue]==0) {
            if (block) {
                block(nil,YES,nil);
            }
        }else{
            if ([json[@"msg"] isNotBlank]) {
                [MBProgressHUD showText:json[@"msg"]  toView:nil];
            }
            if (block) {
                block(nil,NO,nil);
            }
        }
    } failture:^(id error) {
        if (block) {
            block(nil,NO,nil);
        }
    }];
}

/**< 请求提现配置 如手续费用 等 */
+ (void)mineWithdrawCashConfigure:(completeBlock)block{
    NSString * urlStr = [NSString stringWithFormat:@"%@api/user/point/withdrawConfig",DS_APP_SERVER];
    [DSHttpResponseCodeHandle getWirhUrl:urlStr parms:nil token:kToken_Type_Paramter success:^(id json) {
        JXLog(@"%@",json);
        if ([json[@"error"] integerValue]==0) {
            DSWithdrawCashConfigureModel * configureModel = [DSWithdrawCashConfigureModel mj_objectWithKeyValues:json[@"data"]];
            if (block) {
                block(configureModel,YES,nil);
            }
        }else{
            if ([json[@"msg"] isNotBlank]) {
                [MBProgressHUD showText:json[@"msg"]  toView:nil];
            }
            if (block) {
                block(nil,NO,nil);
            }
        }
    } failture:^(id error) {
        if (block) {
            block(nil,NO,nil);
        }
    }];
}

/**< 获取用户期权明细 params ->(page,max 每页条数,type = 0全部 1收入 2支出) */
+ (void)mineGetOptionsDetailwithParams:(NSDictionary *)params  callback:(completeBlock)block;{
    NSString * urlStr = [NSString stringWithFormat:@"%@/api/user/companyOption/details",DS_APP_SERVER];
    
    [DSHttpResponseCodeHandle postWirhUrl:urlStr parms:params token:kToken_Type_Paramter success:^(id json) {
        JXLog(@"%@",json);
        if ([json[@"error"] integerValue]==0) {
            NSArray * array = [DSPensionDetailModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"details"]];
            if (block) {
                block(array,YES,nil);
            }
        }else{
            if ([json[@"msg"] isNotBlank]) {
                [MBProgressHUD showText:json[@"msg"]  toView:nil];
            }
            if (block) {
                block(nil,NO,nil);
            }
        }
    } failture:^(id error) {
        if (block) {
            block(nil,NO,nil);
        }
    }];
}

/** 用户签到 */
+ (void)mineClockin:(completeBlock)block{
    NSString * urlStr = [NSString stringWithFormat:@"%@api/user/signIn",DS_APP_SERVER];
    [DSHttpResponseCodeHandle postWirhUrl:urlStr parms:nil token:kToken_Type_Paramter success:^(id json) {
        JXLog(@"%@",json);
        if ([json[@"error"] integerValue]==0) {
            DSClockInDetailModel * model = [DSClockInDetailModel mj_objectWithKeyValues:json[@"data"]];
//            if (model.status.boolValue==1) {
//                //已经签到过
//                 [MBProgressHUD showText:@"已经签过到了，明天再来吧" toView:nil];
//                if (block) {
//                    block(model,NO,nil);
//                }
//            }else{
                if (block) {
                    block(model,YES,nil);
                }
//            }
        }else{
            if ([json[@"msg"] isNotBlank]) {
                [MBProgressHUD showText:json[@"msg"]  toView:nil];
            }
            if (block) {
                block(nil,NO,nil);
            }
        }
    } failture:^(id error) {
        if (block) {
            block(nil,NO,nil);
        }
    }];
}

/**< 获取qr code 内容 */
+ (void)mineGetQRCodeContent:(completeBlock)block{
    NSString * urlStr = [NSString stringWithFormat:@"%@open/api/share/vipReg",DS_APP_SERVER];
    [DSHttpResponseCodeHandle postWirhUrl:urlStr parms:nil token:kToken_Type_Paramter success:^(id json) {
        JXLog(@"%@",json);
        if ([json[@"error"] integerValue]==0) {
            NSDictionary * data = json[@"data"];
            NSMutableDictionary * params = [NSMutableDictionary dictionary];
            if([data[@"icon"] isNotBlank]) params[@"imageurl"] = data[@"icon"];
            if([data[@"url"] isNotBlank]) params[@"weburl"] = data[@"url"];
            if([data[@"title"] isNotBlank]) params[@"text"] = data[@"title"];
            if([data[@"description"] isNotBlank]) params[@"desc"] = data[@"description"];
            if([data[@"circleTitle"] isNotBlank]) params[@"detaildesc"] = data[@"circleTitle"];
            if (block) {
                block(params,YES,nil);
            }
        }else{
            if ([json[@"msg"] isNotBlank]) {
                [MBProgressHUD showText:json[@"msg"]  toView:nil];
            }
            if (block) {
                block(nil,NO,nil);
            }
        }
    } failture:^(id error) {
        if (block) {
            block(nil,NO,nil);
        }
    }];
}

#pragma mark 登录注册  方法名均以 Login 开头

/* 开始注册 */
+ (void)LoginStartRegistWithParams:(NSDictionary *)params callback:(completeBlock)block{
    NSString * urlStr = [NSString stringWithFormat:@"%@api/user/register",DS_APP_SERVER];

    [DSHttpResponseCodeHandle postWirhUrl:urlStr parms:params token:nil success:^(id json) {
        JXLog(@"%@",json);
        if ([json[@"error"] integerValue]==0) {
            if ([json[@"data"][@"status"] integerValue]==0) {
                if (block) {
                    block(nil,YES,nil);
                }
            }else{
                if ([json[@"data"][@"statusMsg"] isNotBlank]) {
                    [MBProgressHUD showText:json[@"data"][@"statusMsg"] toView:nil];
                }
                if (block) {
                    block(nil,NO,nil);
                }
            }
        }else{
            if ([json[@"msg"] isNotBlank]) {
                [MBProgressHUD showText:json[@"msg"]  toView:nil];
            }
            if (block) {
                block(nil,NO,nil);
            }
        }
    } failture:^(id error) {
        if (block) {
            block(nil,NO,nil);
        }
    }];
}

/** 获取验证码 */
+ (void)LoginGetVerificationCodeWithParams:(NSDictionary *)params callback:(completeBlock)block{
    NSString * urlStr = [NSString stringWithFormat:@"%@api/sendVerifyCode",DS_APP_SERVER];

    [DSHttpResponseCodeHandle postWirhUrl:urlStr parms:params token:nil success:^(id json) {
        JXLog(@"%@",json);
        if ([json[@"error"] integerValue]==0) {
            if (block) {
                block(nil,YES,nil);
            }
        }else{
            if ([json[@"msg"] isNotBlank]) {
                [MBProgressHUD showText:json[@"msg"]  toView:nil];
            }
            if (block) {
                block(nil,NO,nil);
            }
        }
    } failture:^(id error) {
        if (block) {
            block(nil,NO,nil);
        }
    }];
}

/** 开始登陆 */
+ (void)LoginWithParams:(NSDictionary *)params callback:(completeBlock)block{
    NSString * urlStr = [NSString stringWithFormat:@"%@api/user/login",DS_APP_SERVER];

    [DSHttpResponseCodeHandle postWirhUrl:urlStr parms:params token:nil success:^(id json) {
        JXLog(@"%@",json);
        if ([json[@"error"] integerValue]==0) {
            if ([json[@"data"][@"status"] integerValue]==0) {
                //存储token
                DSUserInfoModel * account = [[DSUserInfoModel alloc]init];
                account.access_token = json[@"data"][@"token"];
                account.phone = params[@"phone"];
                [JXAccountTool saveAccount:account];
                
                if (block) {
                    block(nil,YES,nil);
                }
            }else{
                if ([json[@"data"][@"statusMsg"] isNotBlank]) {
                    [MBProgressHUD showText:json[@"data"][@"statusMsg"] toView:nil];
                }
                if (block) {
                    block(nil,NO,nil);
                }
            }

        }else{
            if ([json[@"msg"] isNotBlank]) {
                [MBProgressHUD showText:json[@"msg"]  toView:nil];
            }
            if (block) {
                block(nil,NO,nil);
            }
        }
    } failture:^(id error) {
        if (block) {
            block(nil,NO,nil);
        }
    }];
}

/**< 使用第三方账号登录 */
+ (void)loginWithThirdPartyAccount:(NSDictionary *)params callback:(completeBlock)block{
    NSString * urlStr = [NSString stringWithFormat:@"%@api/user/thirdLogin",DS_APP_SERVER];
    
    [DSHttpResponseCodeHandle postWirhUrl:urlStr parms:params token:nil success:^(id json) {
        JXLog(@"%@",json);
        if ([json[@"error"] integerValue]==0) {
            if ([json[@"data"][@"status"] integerValue]==0) {
                if ([json[@"data"][@"isBindingPhone"] boolValue]==YES) {
                    //存储token
                    DSUserInfoModel * account = [[DSUserInfoModel alloc]init];
                    account.access_token = json[@"data"][@"token"];
                    [JXAccountTool saveAccount:account];
                    
                    if (block) {
                        block(nil,YES,@{@"isBindingPhone":@"1"});
                    }
                }else{
                    if (block) {
                        block(nil,YES,@{@"isBindingPhone":@"0"});
                    }
                }

            }else{
                if ([json[@"data"][@"statusMsg"] isNotBlank]) {
                    [MBProgressHUD showText:json[@"data"][@"statusMsg"] toView:nil];
                }
                if (block) {
                    block(nil,NO,nil);
                }
            }
            
        }else{
            if ([json[@"msg"] isNotBlank]) {
                [MBProgressHUD showText:json[@"msg"]  toView:nil];
            }
            if (block) {
                block(nil,NO,nil);
            }
        }
    } failture:^(id error) {
        if (block) {
            block(nil,NO,nil);
        }
    }];
}

/** 重设密码 */
+ (void)LoginResetPasswordWithParams:(NSDictionary *)params callback:(completeBlock)block{
    NSString * urlStr = [NSString stringWithFormat:@"%@api/user/modifyPwd",DS_APP_SERVER];
    
    [DSHttpResponseCodeHandle postWirhUrl:urlStr parms:params token:nil success:^(id json) {
        JXLog(@"%@",json);
        if ([json[@"error"] integerValue]==0) {
            if (block) {
                block(nil,YES,nil);
            }
        }else{
            if ([json[@"msg"] isNotBlank]) {
                [MBProgressHUD showText:json[@"msg"]  toView:nil];
            }
            if (block) {
                block(nil,NO,nil);
            }
        }
    } failture:^(id error) {
        if (block) {
            block(nil,NO,nil);
        }
    }];
}

/**< 手机号与第三方平台绑定 params - > uid,phone,code,type (0 微信 1qq 2微博) */
+ (void)loginBindPhoneWithThirdPlatForm:(NSDictionary *)params callback:(completeBlock)block{
    NSString * urlStr = [NSString stringWithFormat:@"%@api/user/bindingPhone",DS_APP_SERVER];
    
    [DSHttpResponseCodeHandle postWirhUrl:urlStr parms:params token:nil success:^(id json) {
        JXLog(@"%@",json);
        if ([json[@"error"] integerValue]==0) {
            if ([json[@"data"][@"status"] integerValue]==0) {
                //存储token
                DSUserInfoModel * account = [[DSUserInfoModel alloc]init];
                account.access_token = json[@"data"][@"token"];
                account.phone = params[@"phone"];
                [JXAccountTool saveAccount:account];
                if (block) {
                    block(nil,YES,@{@"isBindingPhone":@"1"});
                }
            }else{
                if ([json[@"data"][@"statusMsg"] isNotBlank]) {
                    [MBProgressHUD showText:json[@"data"][@"statusMsg"] toView:nil];
                }
                if (block) {
                    block(nil,NO,nil);
                }
            }
        }else{
            if ([json[@"msg"] isNotBlank]) {
                [MBProgressHUD showText:json[@"msg"]  toView:nil];
            }
            if (block) {
                block(nil,NO,nil);
            }
        }
    } failture:^(id error) {
        if (block) {
            block(nil,NO,nil);
        }
    }];
}

/** 登出  */
+ (void)Logout:(completeBlock)block{
    NSString * urlStr = [NSString stringWithFormat:@"%@api/user/logout",DS_APP_SERVER];

    [DSHttpResponseCodeHandle postWirhUrl:urlStr parms:nil token:kToken_Type_Paramter success:^(id json) {
        JXLog(@"%@",json);
        if ([json[@"error"] integerValue]==0) {
            if (block) {
                block(nil,YES,nil);
            }
        }else{
            if ([json[@"msg"] isNotBlank]) {
                [MBProgressHUD showText:json[@"msg"]  toView:nil];
            }
            if (block) {
                block(nil,NO,nil);
            }
        }
    } failture:^(id error) {
        if (block) {
            block(nil,NO,nil);
        }
    }];
}

#pragma mark 地址管理 address

/* 获取地址列表 */
+ (void)addressList:(completeBlock)block{
    NSString * urlStr = [NSString stringWithFormat:@"%@api/user/shippingAddress/list",DS_APP_SERVER];

    [DSHttpResponseCodeHandle getWirhUrl:urlStr parms:nil token:kToken_Type_Paramter success:^(id json) {
        JXLog(@"%@",json);
        if ([json[@"error"] integerValue]==0) {
            NSArray * addresses = [DSUserAddress mj_objectArrayWithKeyValuesArray:json[@"data"][@"addresses"]];
            if (block) {
                block(addresses,YES,nil);
            }
        }else{
            if ([json[@"msg"] isNotBlank]) {
                [MBProgressHUD showText:json[@"msg"]  toView:nil];
            }
            if (block) {
                block(nil,NO,nil);
            }
        }
    } failture:^(id error) {
        if (block) {
            block(nil,NO,nil);
        }
    }];
}

/* 添加新地址 */
+ (void)addressAddNewOneWithParams:(NSDictionary *)params callback:(completeBlock)block{
    NSString * urlStr = [NSString stringWithFormat:@"%@api/user/shippingAddress/add",DS_APP_SERVER];
    
    [DSHttpResponseCodeHandle postWirhUrl:urlStr parms:params token:kToken_Type_Paramter success:^(id json) {
        JXLog(@"%@",json);
        if ([json[@"error"] integerValue]==0) {
            DSUserAddress * address = [DSUserAddress mj_objectWithKeyValues:json[@"data"][@"address"]];
            if (block) {
                block(address,YES,nil);
            }
        }else{
            if ([json[@"msg"] isNotBlank]) {
                [MBProgressHUD showText:json[@"msg"]  toView:nil];
            }
            if (block) {
                block(nil,NO,nil);
            }
        }
    } failture:^(id error) {
        if (block) {
            block(nil,NO,nil);
        }
    }];
}

/* 删除新地址 */
+ (void)addressDeleteWithParams:(NSDictionary *)params callback:(completeBlock)block{
    NSString * urlStr = [NSString stringWithFormat:@"%@api/user/shippingAddress/delete",DS_APP_SERVER];
    
    [DSHttpResponseCodeHandle postWirhUrl:urlStr parms:params token:kToken_Type_Paramter success:^(id json) {
        JXLog(@"%@",json);
        if ([json[@"error"] integerValue]==0) {
            if (block) {
                block(nil,YES,nil);
            }
        }else{
            if ([json[@"msg"] isNotBlank]) {
                [MBProgressHUD showText:json[@"msg"]  toView:nil];
            }
            if (block) {
                block(nil,NO,nil);
            }
        }
    } failture:^(id error) {
        if (block) {
            block(nil,NO,nil);
        }
    }];
}

/* 编辑用户地址 */
+ (void)addressEditInfoWithParams:(NSDictionary *)params callback:(completeBlock)block{
    NSString * urlStr = [NSString stringWithFormat:@"%@api/user/shippingAddress/update",DS_APP_SERVER];
    
    [DSHttpResponseCodeHandle postWirhUrl:urlStr parms:params token:kToken_Type_Paramter success:^(id json) {
        JXLog(@"%@",json);
        if ([json[@"error"] integerValue]==0) {
            DSUserAddress * address = [DSUserAddress mj_objectWithKeyValues:json[@"data"][@"address"]];
            if (block) {
                block(address,YES,nil);
            }
        }else{
            if ([json[@"msg"] isNotBlank]) {
                [MBProgressHUD showText:json[@"msg"]  toView:nil];
            }
            if (block) {
                block(nil,NO,nil);
            }
        }
    } failture:^(id error) {
        if (block) {
            block(nil,NO,nil);
        }
    }];
}

/** 获取运费 */
+ (void)addressGetCarriageByAddressId:(NSString *)addressId callback:(completeBlock)block{
    NSString * urlStr = [NSString stringWithFormat:@"%@api/product/carriage",DS_APP_SERVER];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"shippingAddressId"] = addressId;
    [DSHttpResponseCodeHandle getWirhUrl:urlStr parms:params token:kToken_Type_Paramter success:^(id json) {
        JXLog(@"%@",json);
        if ([json[@"error"] integerValue]==0) {
            NSNumber * carriageFee = json[@"data"][@"carriage"];
            if (block) {
                block(carriageFee,YES,nil);
            }
        }else{
            if ([json[@"msg"] isNotBlank]) {
                [MBProgressHUD showText:json[@"msg"]  toView:nil];
            }
            if (block) {
                block(nil,NO,nil);
            }
        }
    } failture:^(id error) {
        if (block) {
            block(nil,NO,nil);
        }
    }];
}

#pragma mark 购物车 Shop Cart

/** 获取购物车所有商品 */
+ (void)shopCartGetAllGoods:(completeBlock)block{
    NSString * urlStr = [NSString stringWithFormat:@"%@api/shoppingCart/list",DS_APP_SERVER];
    [DSHttpResponseCodeHandle getWirhUrl:urlStr parms:nil token:kToken_Type_Paramter success:^(id json) {
        JXLog(@"%@",json);
        if ([json[@"error"] integerValue]==0) {
            NSArray * goodsArray = [DSShopCartModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"carts"]];
            if (block) {
                block(goodsArray,YES,nil);
            }
        }else{
            if ([json[@"msg"] isNotBlank]) {
                [MBProgressHUD showText:json[@"msg"]  toView:nil];
            }
            if (block) {
                block(nil,NO,nil);
            }
        }
    } failture:^(id error) {
        if (block) {
            block(nil,NO,nil);
        }
    }];
}

/** 添加购物车 */
+ (void)shopCartAddGoods:(NSString *)goodsId skuId:(NSString *)skuId number:(NSInteger)number callback:(completeBlock)block{
    NSString * urlStr = [NSString stringWithFormat:@"%@api/shoppingCart/add",DS_APP_SERVER];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"productId"] = goodsId;
    params[@"num"] = @(number);
    params[@"skuId"] = skuId;
    
    [DSHttpResponseCodeHandle postWirhUrl:urlStr parms:params token:kToken_Type_Paramter success:^(id json) {
        JXLog(@"%@",json);
        if ([json[@"error"] integerValue]==0) {
            if (block) {
                block(nil,YES,nil);
            }
        }else{
            if ([json[@"msg"] isNotBlank]) {
                [MBProgressHUD showText:json[@"msg"]  toView:nil];
            }
            if (block) {
                block(nil,NO,nil);
            }
        }
    } failture:^(id error) {
        if (block) {
            block(nil,NO,nil);
        }
    }];
}

/** 多个商品加入购物车 [{productId,num,skuId}] */
+ (void)shopCartAddManyGoods:(NSString *)goodsInfo callback:(completeBlock)block{
    NSString * urlStr = [NSString stringWithFormat:@"%@api/shoppingCart/add",DS_APP_SERVER];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"info"] = goodsInfo;
    [DSHttpResponseCodeHandle postWirhUrl:urlStr parms:params token:kToken_Type_Paramter success:^(id json) {
        JXLog(@"%@",json);
        if ([json[@"error"] integerValue]==0) {
            if (block) {
                block(nil,YES,nil);
            }
        }else{
            if ([json[@"msg"] isNotBlank]) {
                [MBProgressHUD showText:json[@"msg"]  toView:nil];
            }
            if (block) {
                block(nil,NO,nil);
            }
        }
    } failture:^(id error) {
        if (block) {
            block(nil,NO,nil);
        }
    }];
}

/** 修改购物车数量 */
+ (void)shopCartUpdateGoods:(NSString *)goodsId number:(NSInteger)number callback:(completeBlock)block{
    NSString * urlStr = [NSString stringWithFormat:@"%@api/shoppingCart/update",DS_APP_SERVER];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"id"] = goodsId;
    params[@"num"] = @(number);
    [DSHttpResponseCodeHandle postWirhUrl:urlStr parms:params token:kToken_Type_Paramter success:^(id json) {
        JXLog(@"%@",json);
        if ([json[@"error"] integerValue]==0) {
            if (block) {
                block(nil,YES,nil);
            }
        }else{
            if ([json[@"msg"] isNotBlank]) {
                [MBProgressHUD showText:json[@"msg"]  toView:nil];
            }
            if (block) {
                block(nil,NO,nil);
            }
        }
    } failture:^(id error) {
        if (block) {
            block(nil,NO,nil);
        }
    }];
}

/** 购物车删除商品 goodsids -> @"123,124" */
+ (void)shopCartDeleteGoods:(NSString *)goodsIds callback:(completeBlock)block{
    NSString * urlStr = [NSString stringWithFormat:@"%@api/shoppingCart/delete",DS_APP_SERVER];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"ids"] = goodsIds;
    [DSHttpResponseCodeHandle postWirhUrl:urlStr parms:params token:kToken_Type_Paramter success:^(id json) {
        JXLog(@"%@",json);
        if ([json[@"error"] integerValue]==0) {
            if (block) {
                block(nil,YES,nil);
            }
        }else{
            if ([json[@"msg"] isNotBlank]) {
                [MBProgressHUD showText:json[@"msg"]  toView:nil];
            }
            if (block) {
                block(nil,NO,nil);
            }
        }
    } failture:^(id error) {
        if (block) {
            block(nil,NO,nil);
        }
    }];
}

#pragma mark 订单 Order

/** 提交订单 productInfo [{productId,skuId,price,num}] 并转成json字符串  */
+ (void)OrderSubmitOrderwithProductInfo:(NSString *)productInfo addressId:(NSString *)addressId callback:(completeBlock)block{
    NSString * urlStr = [NSString stringWithFormat:@"%@api/product/buy",DS_APP_SERVER];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"productInfo"] = productInfo;
    params[@"shippingAddressId"] = addressId;
    [DSHttpResponseCodeHandle postWirhUrl:urlStr parms:params token:kToken_Type_Paramter success:^(id json) {
        JXLog(@"%@",json);
        if ([json[@"error"] integerValue]==0) {
            if ([json[@"data"][@"status"] integerValue]==0) {
                if (block) {
                    block(json[@"data"][@"orderNo"],YES,nil);
                }
            }else{
                if ([json[@"data"][@"statusMsg"] isNotBlank]) {
                    [MBProgressHUD showText:json[@"data"][@"statusMsg"]  toView:nil];
                }
                if (block) {
                    block(nil,NO,nil);
                }
            }
        }else{
            if ([json[@"msg"] isNotBlank]) {
                [MBProgressHUD showText:json[@"msg"]  toView:nil];
            }
            if (block) {
                block(nil,NO,nil);
            }
        }
    } failture:^(id error) {
        if (block) {
            block(nil,NO,nil);
        }
    }];
}

/** 根据订单号生成订单信息 调用支付宝 orderNumber 订单编号 point 使用的积分 gold  购物金*/
+ (void)orderGetAlipayPayOrderInfoWithParams:(NSDictionary *)params callback:(completeBlock)block{
    NSString * urlStr = [NSString stringWithFormat:@"%@api/alipay/pay",DS_APP_SERVER];
    [DSHttpResponseCodeHandle postWirhUrl:urlStr parms:params token:kToken_Type_Paramter success:^(id json) {
        JXLog(@"%@",json);
        if ([json[@"error"] integerValue]==0) {
            if ([json[@"data"][@"status"] integerValue]==0) {
                if (block) {
                    block(json[@"data"][@"orderInfo"],YES,nil);
                }
            }else{
                if ([json[@"data"][@"statusMsg"] isNotBlank]) {
                    [MBProgressHUD showText:json[@"data"][@"statusMsg"]  toView:nil];
                }
                if (block) {
                    block(nil,NO,nil);
                }
            }
        }else{
            if ([json[@"msg"] isNotBlank]) {
                [MBProgressHUD showText:json[@"msg"]  toView:nil];
            }
            if (block) {
                block(nil,NO,nil);
            }
        }
    } failture:^(id error) {
        if (block) {
            block(nil,NO,nil);
        }
    }];
}
                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
/** 根据订单号生成订单信息 调用微信 orderNumber 订单编号 point 使用的积分 gold  购物金*/
+ (void)orderGetWechatPayOrderInfoWithParams:(NSDictionary *)params callback:(completeBlock)block{
    NSString * urlStr = [NSString stringWithFormat:@"%@api/weixin/pay",DS_APP_SERVER];
    [DSHttpResponseCodeHandle postWirhUrl:urlStr parms:params token:kToken_Type_Paramter success:^(id json) {
        JXLog(@"%@",json);
        if ([json[@"error"] integerValue]==0) {
            if (json[@"data"]) {
                if ([json[@"data"][@"status"] integerValue]==0) {
                    NSMutableDictionary * data = json[@"data"];
                    PayReq * wechatReqModel = [[PayReq alloc]init];
                    wechatReqModel.package = data[@"package"];
                    wechatReqModel.prepayId = data[@"prepayid"];
                    wechatReqModel.partnerId = data[@"partnerid"];
                    wechatReqModel.sign = data[@"sign"];
                    wechatReqModel.timeStamp = (UInt32)[data[@"timestamp"] unsignedLongValue];
                    wechatReqModel.nonceStr = data[@"noncestr"];
            
                    if (block) {
                        block(wechatReqModel,YES,nil);
                    }
                }else{
                    if ([json[@"data"][@"status"] integerValue]==1) {
                        [MBProgressHUD showText:@"订单已支付"  toView:nil];
                    }
                    if (block) {
                        block(nil,NO,nil);
                    }
                }
            }else{
                if (block) {
                    block(nil,NO,nil);
                }
            }
        }else{
            if ([json[@"msg"] isNotBlank]) {
                [MBProgressHUD showText:json[@"msg"]  toView:nil];
            }
            if (block) {
                block(nil,NO,nil);
            }
        }
    } failture:^(id error) {
        if (block) {
            block(nil,NO,nil);
        }
    }];
}

/** -1=全部订单，0=未付款,1=已付款,2=已发货,3=已签收,4=退货申请,5=退货中,6=已退货,99=取消交易，100=交易完成。默认-1 */
+ (void)orderGetOrderListByStatus:(NSInteger)status pageNumber:(NSInteger)pageNumber pageSize:(NSInteger)pageSize callback:(completeBlock)block{
    NSString * urlStr = [NSString stringWithFormat:@"%@api/order/list",DS_APP_SERVER];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"status"] = @(status);
    params[@"page"] = @(pageNumber);
    params[@"max"] = @(pageSize);
    [DSHttpResponseCodeHandle getWirhUrl:urlStr parms:params token:kToken_Type_Paramter success:^(id json) {
        JXLog(@"%@",json);
        if ([json[@"error"] integerValue]==0) {
            NSArray * array = [DSOrderListModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"orders"]];
            if (block) {
                block(array,YES,nil);
            }
        }else{
            if ([json[@"msg"] isNotBlank]) {
                [MBProgressHUD showText:json[@"msg"]  toView:nil];
            }
            if (block) {
                block(nil,NO,nil);
            }
        }
    } failture:^(id error) {
        if (block) {
            block(nil,NO,nil);
        }
    }];
}

/**< orderid 订单编号 */
+ (void)orderGetOrderDetailInfoByOrderId:(NSString *)orderId callback:(completeBlock)block{
    NSString * urlStr = [NSString stringWithFormat:@"%@api/order/info",DS_APP_SERVER];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"orderId"] = orderId;
    [DSHttpResponseCodeHandle getWirhUrl:urlStr parms:params token:kToken_Type_Paramter success:^(id json) {
        JXLog(@"%@",json);
        if ([json[@"error"] integerValue]==0) {
            DSOrderInfoModel * orderInfo = [DSOrderInfoModel mj_objectWithKeyValues:json[@"data"][@"order"]];
            if (block) {
                block(orderInfo,YES,nil);
            }
        }else{
            if ([json[@"msg"] isNotBlank]) {
                [MBProgressHUD showText:json[@"msg"]  toView:nil];
            }
            if (block) {
                block(nil,NO,nil);
            }
        }
    } failture:^(id error) {
        if (block) {
            block(nil,NO,nil);
        }
    }];
}

/** type -> 1 取消 2 删除 3 确认收货 4 提醒发货  */
+ (void)orderOperationWithOperationType:(NSInteger)type orderId:(NSString *)orderId callback:(completeBlock)block{
    NSString * hostSufix = @[@"cancel",@"delete",@"confirm",@"remind"][type-1];
    NSString * host = [NSString stringWithFormat:@"api/order/%@",hostSufix];
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",DS_APP_SERVER,host];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"orderId"] = orderId;
    [DSHttpResponseCodeHandle postWirhUrl:urlStr parms:params token:kToken_Type_Paramter success:^(id json) {
        JXLog(@"%@",json);
        if ([json[@"error"] integerValue]==0) {
            if ([json[@"data"][@"status"] integerValue]==0) {
                if (block) {
                    block(nil,YES,nil);
                }
            }else{
                if (block) {
                    block(nil,NO,nil);
                }
                if ([json[@"data"][@"statusMsg"] isNotBlank]) {
                    [MBProgressHUD showText:json[@"data"][@"statusMsg"] toView:nil];
                }
            }
        }else{
            if ([json[@"msg"] isNotBlank]) {
                [MBProgressHUD showText:json[@"msg"]  toView:nil];
            }
            if (block) {
                block(nil,NO,nil);
            }
        }
    } failture:^(id error) {
        if (block) {
            block(nil,NO,nil);
        }
    }];
}

#pragma mark 收藏 collection

/** 获取收藏列表 */
+ (void)collectionGetAllCollectionsWithPagenum:(NSInteger)pageNum pageSize:(NSInteger)pageSize callback:(completeBlock)block{
    NSString * urlStr = [NSString stringWithFormat:@"%@api/user/like/list",DS_APP_SERVER];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"page"] = @(pageNum);
    params[@"max"]  = @(pageSize);
    [DSHttpResponseCodeHandle getWirhUrl:urlStr parms:params token:kToken_Type_Paramter success:^(id json) {
        JXLog(@"%@",json);
        if ([json[@"error"] integerValue]==0) {
            NSArray * collections = [DSGoodsDetailInfoModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"likes"]];
            if (block) {
                block(collections,YES,nil);
            }
        }else{
            if ([json[@"msg"] isNotBlank]) {
                [MBProgressHUD showText:json[@"msg"]  toView:nil];
            }
            if (block) {
                block(nil,NO,nil);
            }
        }
    } failture:^(id error) {
        if (block) {
            block(nil,NO,nil);
        }
    }];
}

/** 根据id收藏商品 */
+ (void)collectionGoodsByGoodsid:(NSString *)goodsId callback:(completeBlock)block{
    NSString * urlStr = [NSString stringWithFormat:@"%@api/user/like/add",DS_APP_SERVER];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"moduleIds"] = goodsId;
    [DSHttpResponseCodeHandle postWirhUrl:urlStr parms:params token:kToken_Type_Paramter success:^(id json) {
        JXLog(@"%@",json);
        if ([json[@"error"] integerValue]==0) {
            if (block) {
                block(nil,YES,nil);
            }
        }else{
            if ([json[@"msg"] isNotBlank]) {
                [MBProgressHUD showText:json[@"msg"]  toView:nil];
            }
            if (block) {
                block(nil,NO,nil);
            }
        }
    } failture:^(id error) {
        if (block) {
            block(nil,NO,nil);
        }
    }];
}

/** 根据id删除收藏商品 */
+ (void)collectionDeleteGoodsByGoodsid:(NSString *)goodsId callback:(completeBlock)block{
    NSString * urlStr = [NSString stringWithFormat:@"%@api/user/like/delete",DS_APP_SERVER];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"moduleIds"] = goodsId;
    [DSHttpResponseCodeHandle postWirhUrl:urlStr parms:params token:kToken_Type_Paramter success:^(id json) {
        JXLog(@"%@",json);
        if ([json[@"error"] integerValue]==0) {
            if (block) {
                block(nil,YES,nil);
            }
        }else{
            if ([json[@"msg"] isNotBlank]) {
                [MBProgressHUD showText:json[@"msg"]  toView:nil];
            }
            if (block) {
                block(nil,NO,nil);
            }
        }
    } failture:^(id error) {
        if (block) {
            block(nil,NO,nil);
        }
    }];
}

#pragma mark 启动

/* 启动配置 */
+ (void)LaunchInfoConfigure:(completeBlock)block{
    NSString * urlStr = [NSString stringWithFormat:@"%@api/config",DS_APP_SERVER];
    
    [DSHttpResponseCodeHandle getWirhUrl:urlStr parms:nil token:nil success:^(id json) {
        JXLog(@"%@",json);
        if ([json[@"error"] integerValue]==0) {
            if (block) {
                block(json,YES,nil);
            }
        }else{
//            if ([json[@"msg"] isNotBlank]) {
//                [MBProgressHUD showText:json[@"msg"]  toView:nil];
//            }
            if (block) {
                block(nil,NO,nil);
            }
        }
    } failture:^(id error) {
        if (block) {
            block(nil,NO,nil);
        }
    }];
}

/** 关于我们 */
+ (void)aboutusInfoGet:(completeBlock)block{
    NSString * urlStr = [NSString stringWithFormat:@"%@api/about",DS_APP_SERVER];
    
    [DSHttpResponseCodeHandle getWirhUrl:urlStr parms:nil token:nil success:^(id json) {
        JXLog(@"%@",json);
        if ([json[@"error"] integerValue]==0) {
            NSArray * array = @[];
            if (json[@"data"]) {
                if (json[@"data"][@"about"]) {
                    array = [DSAboutUsModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"about"]];
                }
            }
            if (block) {
                block(array,YES,nil);
            }
        }else{
            //            if ([json[@"msg"] isNotBlank]) {
            //                [MBProgressHUD showText:json[@"msg"]  toView:nil];
            //            }
            if (block) {
                block(nil,NO,nil);
            }
        }
    } failture:^(id error) {
        if (block) {
            block(nil,NO,nil);
        }
    }];
}

#pragma  mark 公用方法

+ (void)PublicCheckValidityOfToken:(completeBlock)block{
    NSString * urlStr = [NSString stringWithFormat:@"%@api/user/validToken",DS_APP_SERVER];
    DSUserInfoModel * account = [JXAccountTool account];
    NSString * access_token = account.access_token;
    if ([access_token isNotBlank]==NO) {
        if (block) {
            block(nil,NO,nil);
        }
    }else{
        [DSHttpResponseCodeHandle getWirhUrl:urlStr parms:nil token:kToken_Type_Paramter success:^(id json) {
            JXLog(@"%@",json);
            if ([json[@"error"] integerValue]==0) {
                if ([json[@"data"][@"status"] integerValue]==0) {;
                    if (block) {
                        block(json,YES,nil);
                    }
                }else{
                    if (block) {
                        block(json,YES,nil);
                    }
                }
            }else{
                
                if ([json[@"msg"] isNotBlank]) {
                    [MBProgressHUD showText:json[@"msg"]  toView:nil];
                }
                if (block) {
                    block(nil,NO,nil);
                }
            }
        } failture:^(id error) {
            if (block) {
                block(nil,NO,nil);
            }
        }];
    }
}

@end
