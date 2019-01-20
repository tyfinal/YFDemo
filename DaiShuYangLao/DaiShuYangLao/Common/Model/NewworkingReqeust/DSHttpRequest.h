//
//  DSHttpRequest.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/11.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSHttpRequest : NSObject

#pragma mark GET

/* 获取数据 不需要解析
 * requestUrl 请求的url
 * requestParams 入参
 * object 会随请求结果一起返回 不需要可以传 nil
 * token  不需要可以传 nil
 * showHUDInView 展示loading框
 * hidenErrorMsg 隐藏错误提示 例如 "请求超时","网络异常"
 */
+ (void)getDataWithrequestUrl:(NSString *)requestUrl requestParams:(NSDictionary *)requestParams object:(id)object token:(NSString *)token showHUDInView:(UIView *)view hidenErrorMsg:(BOOL)hidenErrorMsg callback:(completeBlock)block;


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
+ (void)getDataModelWithModelClass:(Class)modelClass requestUrl:(NSString *)requestUrl requestParams:(NSDictionary *)requestParams object:(id)object token:(NSString *)token showHUDInView:(UIView *)view hidenErrorMsg:(BOOL)hidenErrorMsg parserKeys:(NSArray *)parserKeys callback:(completeBlock)block;


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
+ (void)getDataArrayWithModelClass:(Class)modelClass requestUrl:(NSString *)requestUrl requestParams:(NSDictionary *)requestParams object:(id)object token:(NSString *)token showHUDInView:(UIView *)view hidenErrorMsg:(BOOL)hidenErrorMsg parserKeys:(NSArray *)parserKeys callback:(completeBlock)block;


#pragma mark Post



@end
