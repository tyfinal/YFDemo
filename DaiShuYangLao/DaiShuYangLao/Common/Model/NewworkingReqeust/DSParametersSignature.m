//
//  DSParametersSignature.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/11.
//  Copyright © 2018年 tyfinal. All rights reserved.
//  将参数进行签名

#import "DSParametersSignature.h"
#import "UIDevice+FCUUID.h"
#import "UIDevice+YYAdd.h"
#import "NSString+MKDate.h"


static NSDictionary * UniveralParameters = nil;
@implementation DSParametersSignature

/**< 通用请求参数 */
+ (NSDictionary *)universalParameters{
    if (UniveralParameters==nil) {
        NSMutableDictionary * mutableParameters = [NSMutableDictionary dictionary];
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        mutableParameters[@"appVer"] = [infoDictionary objectForKey:@"CFBundleShortVersionString"]; //版本号
        mutableParameters[@"deviceType"] = @"ios";
        mutableParameters[@"deviceId"] = [[UIDevice currentDevice]uuid];
        mutableParameters[@"osVer"] = [[UIDevice currentDevice]systemVersion];
        UniveralParameters = mutableParameters;
    }
    return UniveralParameters;
}



+ (void)method{
    [self signForParameters:@{@"phone":@"189999000",@"name":@"tyfinal"} signatureKey:nil];
}

/** 为参数进行签名 */
+ (NSString *)signForParameters:(NSDictionary *)parameters signatureKey:(NSString *)signatureKey{
    if (parameters!=nil) {
        NSMutableDictionary * muParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
        if ([signatureKey isNotBlank]==NO) {
            muParameters[@"sign_key"] =  @"daishu20180501";
        }else{
            muParameters[@"sign_key"] = signatureKey;
        }
        
        NSArray * keysArray = muParameters.allKeys;
        
        NSArray *sortedArray = [keysArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
           return [obj1 compare:obj2 options:NSNumericSearch]; //key值按照升序排列
        }];
        
        NSMutableString * signatureMu = [NSMutableString string];
        
        NSString * key = @"";
        NSString * value = @"";
        for (NSInteger i=0; i<sortedArray.count; i++) {
            key = sortedArray[i];
            value = muParameters[key];
            [signatureMu appendFormat:@"%@%@",key,value];
        }
        
        NSString * signature = [signatureMu md5String];
        
        return signature;
    }
    return nil;
}



@end
