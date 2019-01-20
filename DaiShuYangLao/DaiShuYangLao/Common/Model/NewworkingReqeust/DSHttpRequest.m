//
//  DSHttpRequest.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/11.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSHttpRequest.h"
#import "DSHttpResponseCodeHandle.h"
#import "MBProgressHUD+JXAdd.h"

@implementation DSHttpRequest


/* 获取数据 不需要解析
 * requestUrl 请求的url
 * requestParams 入参
 * object 会随请求结果一起返回 不需要可以传 nil
 * token  不需要可以传 nil
 * showHUDInView 展示loading框
 * hidenErrorMsg 隐藏错误提示 例如 "请求超时","网络异常"
 */
+ (void)getDataWithrequestUrl:(NSString *)requestUrl requestParams:(NSDictionary *)requestParams object:(id)object token:(NSString *)token showHUDInView:(UIView *)view hidenErrorMsg:(BOOL)hidenErrorMsg callback:(completeBlock)block;{
    MBProgressHUD * HUD = nil;
    if (view) {
        HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    [DSHttpResponseCodeHandle getWirhUrl:requestUrl parms:requestParams token:token success:^(id json) {
        if(HUD) [HUD hideAnimated:YES];
        NSLog(@"%@",json);
        JXLog(@"%@",json);
        if ([json[@"result"] integerValue]==2000||[json[@"result"] integerValue]==4004) {
            if (block) {
                block(json[@"data"],YES,object);
            }
        }else{
            if (block) {
                block(nil,NO,object);
            }
            if(!hidenErrorMsg) [MBProgressHUD showText:json[@"description"] toView:nil];
        }
    } failture:^(id error) {
        if(HUD) [HUD hideAnimated:YES];
        if (block) {
            block(nil,NO,object);
        }
        JXLog(@"%@",error);
    }];
}

/* 获取的数据类型是模型时
 * modelClass 数组的数据模型
 * requestUrl 请求的url
 * requestParams 入参
 * object 会随请求结果一起返回 不需要可以传 nil
 * token  不需要可以传 nil
 * showHUDInView 展示loading框
 * hidenErrorMsg 隐藏错误提示 例如 "请求超时","网络异常"
 * parserKeys 解析层的键例如 @[@"data",@"result_list"]; 表示 json[@"data"][@"result_list"]
 */
+ (void)getDataModelWithModelClass:(Class)modelClass requestUrl:(NSString *)requestUrl requestParams:(NSDictionary *)requestParams object:(id)object token:(NSString *)token showHUDInView:(UIView *)view hidenErrorMsg:(BOOL)hidenErrorMsg parserKeys:(NSArray *)parserKeys callback:(completeBlock)block{
    MBProgressHUD * HUD = nil;
    if (view) {
        HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    if (!parserKeys||parserKeys.count==0) {
        parserKeys = @[@"data",@"result_list"];
    }
    [DSHttpResponseCodeHandle getWirhUrl:requestUrl parms:requestParams token:token success:^(id json) {
        if(HUD) [HUD hideAnimated:YES];
        JXLog(@"%@",json);
        if ([json[@"result"] integerValue]==2000||[json[@"result"] integerValue]==4004) {
            NSDictionary * finalJson = json;
            for (NSInteger i=0; i<parserKeys.count; i++) {
                finalJson = finalJson[parserKeys[i]];
            }
            id model = [[modelClass class] mj_objectWithKeyValues:finalJson];
            if (block) {
                block(model,YES,object);
            }
        }else{
            if (block) {
                block(nil,NO,object);
            }
            if(!hidenErrorMsg) [MBProgressHUD showText:json[@"description"] toView:nil];
        }
    } failture:^(id error) {
        if(HUD) [HUD hideAnimated:YES];
        if (block) {
            block(nil,NO,object);
        }
        JXLog(@"%@",error);
    }];
}

/* 获取的数据类型是数组时
 * modelClass 数组的数据模型
 * requestUrl 请求的url
 * requestParams 入参
 * object 会随请求结果一起返回 不需要可以传 nil
 * token  不需要可以传 nil
 * showHUDInView 展示loading框
 * hidenErrorMsg 隐藏错误提示 例如 "请求超时","网络异常"
 * parserKeys 解析层的键例如 @[@"data",@"result_list"]; 表示 json[@"data"][@"result_list"]
 */
+ (void)getDataArrayWithModelClass:(Class)modelClass requestUrl:(NSString *)requestUrl requestParams:(NSDictionary *)requestParams object:(id)object token:(NSString *)token showHUDInView:(UIView *)view hidenErrorMsg:(BOOL)hidenErrorMsg parserKeys:(NSArray *)parserKeys callback:(completeBlock)block{
    MBProgressHUD * HUD = nil;
    if (view) {
        HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    if (!parserKeys||parserKeys.count==0) {
        parserKeys = @[@"data",@"result_list"];
    }
    [DSHttpResponseCodeHandle getWirhUrl:requestUrl parms:requestParams token:token success:^(id json) {
        if(HUD) [HUD hideAnimated:YES];
        JXLog(@"%@",json);
        if ([json[@"result"] integerValue]==2000||[json[@"result"] integerValue]==4004) {
            NSDictionary * finalJson = json;
            for (NSInteger i=0; i<parserKeys.count; i++) {
                finalJson = finalJson[parserKeys[i]];
            }
            NSArray * array = [[modelClass class] mj_objectArrayWithKeyValuesArray:finalJson];
            if (block) {
                block(array,YES,object);
            }
        }else{
            if (block) {
                block(nil,NO,object);
            }
            if(!hidenErrorMsg) [MBProgressHUD showText:json[@"description"] toView:nil];
        }
    } failture:^(id error) {
        if(HUD) [HUD hideAnimated:YES];
        if (block) {
            block(nil,NO,object);
        }
        JXLog(@"%@",error);
    }];
}


@end
