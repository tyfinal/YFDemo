//
//  DSHttpBase.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/11.
//  Copyright © 2018年 tyfinal. All rights reserved.
//  对afn进行简单封装

#import "DSHttpBase.h"
#import <AFNetworking.h>
#import "DSUploadingImageModel.h"

static CGFloat const kCompressionQuality = 0.5;

static CGFloat const kTimeoutInterval = 10;

@implementation DSHttpBase
static AFHTTPSessionManager * _manager = nil;

+ (AFHTTPSessionManager *)shareSessionManager{
    if (!_manager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            if (IS_Release) {
                //生产
                _manager = [[AFHTTPSessionManager manager]initWithBaseURL:[NSURL URLWithString:DS_APP_SERVER]];
                [_manager setSecurityPolicy:[self SecurityPolicy]];
            }else{
                //测试
                _manager = [AFHTTPSessionManager manager];
            }
            _manager.requestSerializer.timeoutInterval = kTimeoutInterval;
        });
    }
    return _manager;
}

+ (AFSecurityPolicy *)SecurityPolicy{
    // 先导入证书 证书由服务端生成，具体由服务端人员操作
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"daishu" ofType:@"cer"];//证书的路径
    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.validatesDomainName = YES;
    securityPolicy.allowInvalidCertificates = NO;
    securityPolicy.pinnedCertificates = [[NSSet alloc] initWithObjects:cerData,nil];
    
    return securityPolicy;
}

//网络请求的GET方法
+(void)get:(NSString*)url parms: (NSDictionary*)parms token:(NSString*)token success:(void(^)(id json)) success failture:(void(^)(id json)) failture{
//    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    AFHTTPSessionManager *manager = [self shareSessionManager];
    if (token) {
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    }
    [manager GET:url parameters:parms progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(success){
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failture){
            failture(error);
        }
    }];
}


//网络请求的POST方法
+(void)post:(NSString*)url parms: (NSDictionary*)parms token:(NSString*)token success:(void(^)(id json)) success failture:(void(^)(id json)) failture{
    AFHTTPSessionManager *manager=[self shareSessionManager];
    
//     AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
//    //申明返回的结果是json类型
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    //申明请求的数据是json类型
//    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
//    manager.requestSerializer.timeoutInterval = kTimeoutInterval;
    
    if (token) {
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    }
        
    
    [manager POST:url parameters:parms progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(success){
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failture){
            failture(error);
        }
    }];
}

+ (void)patch:(NSString*)url parms: (NSDictionary*)parms token:(NSString*)token success:(void(^)(id json)) success failture:(void(^)(id json)) failture{
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
     manager.requestSerializer.timeoutInterval = kTimeoutInterval;
    
    if (token) {
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    }
    
    [manager PATCH:url parameters:parms success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(success){
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failture){
            failture(error);
        }
    }];
}

//网络请求的PATCH方法
+ (void)put:(NSString*)url parms: (NSDictionary*)parms token:(NSString*)token success:(void(^)(id json)) success failture:(void(^)(id json)) failture{
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    //申明返回的结果是json类型
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = kTimeoutInterval;
    
    if (token) {
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    }
    
    [manager PUT:url parameters:parms success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(success){
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failture){
            failture(error);
        }
    }];
}

+ (void)dele:(NSString *)url parms: (NSDictionary*)parms token:(NSString*)token success:(void(^)(id json)) success failture:(void(^)(id json)) failture{
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    
    
    
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = kTimeoutInterval;
    
    if (token) {
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    }
    
    [manager DELETE:url parameters:parms success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(success){
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failture){
            failture(error);
        }
    }];
}

+ (void)post:(NSString *)url imageArray:(NSArray <DSUploadingImageModel *> *)imageArray parms:(NSDictionary*)parms  token:(NSString*)token success:(void(^)(id json)) success failture:(void(^)(id json)) failture{
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    
    
    
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = kTimeoutInterval;
    
    if (token) {
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    }

    [manager POST:url parameters:parms constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (imageArray.count>0) {
            NSString * mime = @"image/jpeg";
            for (NSInteger i=0; i<imageArray.count; i++) {
                DSUploadingImageModel * imageModel = imageArray[i];
                if ([imageModel.fileName isNotBlank]==NO) {
                    NSString * timeString = [NSString getStampStringFromDate:[NSDate date]];
                    imageModel.fileName = [NSString stringWithFormat:@"%@_i",timeString];
                }
                
                if ([imageModel.mime isNotBlank]) {
                    mime = imageModel.mime;
                }
                
                UIImage * image = imageModel.image;
                NSData * imageData = UIImageJPEGRepresentation(image, kCompressionQuality);
                [formData appendPartWithFileData:imageData name:imageModel.upload_key fileName:imageModel.fileName mimeType:mime];
            }
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(success){
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failture){
            failture(error);
        }
    }];
}

@end
