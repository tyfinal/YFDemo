//
//  DSHttpRequestParameterConfigure.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/19.
//  Copyright © 2018年 tyfinal. All rights reserved.
//  主要处理参数拼接

#import "DSHttpRequestParameterConfigure.h"
#import "DSHttpBase.h"
#import "DSParametersSignature.h"
#import "DSUploadingImageModel.h"

@implementation DSHttpRequestParameterConfigure

+ (void)getWirhUrl:(NSString*)url parms:(NSDictionary*)parms token:(NSString *)token success:(void(^)(id json))success failture:(void(^)(id error))failture;{
    
    NSMutableDictionary * combiningParams = [NSMutableDictionary dictionaryWithDictionary:parms];
    NSDictionary * universalParams = [DSParametersSignature universalParameters]; //通用参数
    [combiningParams addEntriesFromDictionary:universalParams]; //拼接通用参数
    NSString * httpFieldToken = nil;
    if (token) {
        if ([token isEqualToString:@"parameter"]) {
            DSUserInfoModel * account = [JXAccountTool account];
            combiningParams[@"token"] = account.access_token;
        }else{
            httpFieldToken = token; //作为httpField;
        }
    }

    NSDictionary * params = [self combineParametersWithPartParameters:combiningParams];
    
    [DSHttpBase get:url parms:params token:httpFieldToken success:^(id json) {
        if(success){
            success(json);
        }
    } failture:^(id json) {
        if(failture){
            failture(json);
        }
    }];
}

+ (void)postWirhUrl:(NSString*)url parms:(NSDictionary*)parms token:(NSString *)token success:(void(^)(id json))success failture:(void(^)(id error))failture{
    
    NSMutableDictionary * combiningParams = [NSMutableDictionary dictionaryWithDictionary:parms];
    
    NSDictionary * universalParams = [DSParametersSignature universalParameters]; //通用参数
    [combiningParams addEntriesFromDictionary:universalParams]; //拼接通用参数
    NSString * httpFieldToken = nil;
    if (token) {
        if ([token isEqualToString:@"parameter"]) {
            DSUserInfoModel * account = [JXAccountTool account];
            combiningParams[@"token"] = account.access_token;
        }else{
            httpFieldToken = token; //作为httpField;
        }
    }
    
    NSDictionary * params = [self combineParametersWithPartParameters:combiningParams];
    
    [DSHttpBase post:url parms:params token:httpFieldToken success:^(id json) {
        if(success){
            success(json);
        }
    } failture:^(id json) {
        if(failture){
            failture(json);
        }
    }];
}


+ (void)postWirhUrl:(NSString*)url parms:(NSDictionary*)parms images:(NSArray <DSUploadingImageModel *> *)images token:(NSString *)token success:(void(^)(id json))success failture:(void(^)(id error))failture{
    NSMutableDictionary * combiningParams = [NSMutableDictionary dictionaryWithDictionary:parms];
    
    NSDictionary * universalParams = [DSParametersSignature universalParameters]; //通用参数
    [combiningParams addEntriesFromDictionary:universalParams]; //拼接通用参数
    NSString * httpFieldToken = nil;
    if (token) {
        if ([token isEqualToString:@"parameter"]) {
            DSUserInfoModel * account = [JXAccountTool account];
            combiningParams[@"token"] = account.access_token;
        }else{
            httpFieldToken = token; //作为httpField;
        }
    }
    
    NSDictionary * params = [self combineParametersWithPartParameters:combiningParams];
    [DSHttpBase post:url imageArray:images parms:params token:httpFieldToken success:^(id json) {
        if(success){
            success(json);
        }
    } failture:^(id json) {
        if(failture){
            failture(json);
        }
    }];
}


//组装参数
+ (NSDictionary *)combineParametersWithPartParameters:(NSDictionary *)partparameters{
    NSMutableDictionary * universalParameters = [NSMutableDictionary dictionaryWithDictionary:[DSParametersSignature universalParameters]];
    NSString * timeStamp = [NSString stringWithFormat:@"%.f", [[NSDate date] timeIntervalSince1970]*1000];
    universalParameters[@"timestamp"] = timeStamp;
    if (partparameters!=nil) {
        [universalParameters addEntriesFromDictionary:partparameters];
    }
    NSString * signature = [DSParametersSignature signForParameters:universalParameters signatureKey:nil];
    universalParameters[@"signature"] = signature;
    
    return universalParameters;
}

@end
