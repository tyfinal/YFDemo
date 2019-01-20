//
//  DSHttpTool.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/11.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DSUploadingImageModel;
@interface DSHttpResponseCodeHandle : NSObject

/** 如果token传递 parameter 则作为参数传递 如过使用httpfield则作为httpfield */
+ (void)getWirhUrl:(NSString*)url parms:(NSDictionary*)parms token:(NSString*)token success:(void(^)(id json))success failture:(void(^)(id error))failture;

/** 如果token传递 parameter 则作为参数传递 如过使用httpfield则作为httpfield */
+ (void)postWirhUrl:(NSString*)url parms:(NSDictionary*)parms token:(NSString*)token success:(void(^)(id json))success failture:(void(^)(id error))failture;

/** 图片上传 */
+ (void)postWirhUrl:(NSString*)url parms:(NSDictionary*)parms imageArray:(NSArray <DSUploadingImageModel *> *)imageArray token:(NSString*)token success:(void(^)(id json))success failture:(void(^)(id error))failture;

+ (void)patchWirhUrl:(NSString*)url parms:(NSDictionary*)parms token:(NSString*)token success:(void(^)(id json))success failture:(void(^)(id error))failture;

+ (void)putWirhUrl:(NSString*)url parms:(NSDictionary*)parms token:(NSString*)token success:(void(^)(id json))success failture:(void(^)(id error))failture;

+ (void)deleteWithUrl:(NSString *)url parms:(NSDictionary*)parms token:(NSString*)token success:(void(^)(id json))success failture:(void(^)(id error))failture;

@end
