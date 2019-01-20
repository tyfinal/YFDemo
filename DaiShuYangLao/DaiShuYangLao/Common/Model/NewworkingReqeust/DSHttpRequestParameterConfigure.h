//
//  DSHttpRequestParameterConfigure.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/19.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSBaseModel.h"
@class DSUploadingImageModel;
@interface DSHttpRequestParameterConfigure : DSBaseModel

+ (void)getWirhUrl:(NSString*)url parms:(NSDictionary*)parms token:(NSString *)token success:(void(^)(id json))success failture:(void(^)(id error))failture;

+ (void)postWirhUrl:(NSString*)url parms:(NSDictionary*)parms token:(NSString *)token success:(void(^)(id json))success failture:(void(^)(id error))failture;

+ (void)postWirhUrl:(NSString*)url parms:(NSDictionary*)parms images:(NSArray <DSUploadingImageModel *> *)images token:(NSString *)token success:(void(^)(id json))success failture:(void(^)(id error))failture;

@end
