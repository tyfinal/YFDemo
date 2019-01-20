//
//  DSHttpBase.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/11.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DSUploadingImageModel;
@interface DSHttpBase : NSObject

//网络请求的GET方法
+(void)get:(NSString*)url parms: (NSDictionary*)parms token:(NSString*)token success:(void(^)(id json)) success failture:(void(^)(id json)) failture;

//网络请求的POST方法
+(void)post:(NSString*)url parms: (NSDictionary*)parms token:(NSString*)token success:(void(^)(id json)) success failture:(void(^)(id json)) failture;

//网络请求的PATCH方法
+ (void)patch:(NSString*)url parms: (NSDictionary*)parms token:(NSString*)token success:(void(^)(id json)) success failture:(void(^)(id json)) failture;

//网络请求的put方法
+ (void)put:(NSString*)url parms: (NSDictionary*)parms token:(NSString*)token success:(void(^)(id json)) success failture:(void(^)(id json)) failture;

//网络请求的DELETE方法
+ (void)dele:(NSString *)url parms: (NSDictionary*)parms token:(NSString*)token success:(void(^)(id json)) success failture:(void(^)(id json)) failture;

+ (void)post:(NSString *)url imageArray:(NSArray <DSUploadingImageModel *> *)imageArray parms:(NSDictionary*)parms  token:(NSString*)token success:(void(^)(id json)) success failture:(void(^)(id json)) failture;


@end
