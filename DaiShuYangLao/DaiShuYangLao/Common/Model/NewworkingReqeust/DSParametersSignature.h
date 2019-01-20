//
//  DSParametersSignature.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/11.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSParametersSignature : NSObject

+ (NSDictionary *)universalParameters; /**< 通用请求参数 */

/** 为参数进行签名 */
+ (NSString *)signForParameters:(NSDictionary *)parameters signatureKey:(NSString *)signatureKey;



@end
