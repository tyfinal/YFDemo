//
//  DSValidInfoCheck.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/11.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSValidInfoCheck : NSObject

+ (BOOL)iSValidPassword:(NSString *)passwordString;

+ (BOOL)isValidPhoneNumber:(NSString *)phoneNumber;

+ (BOOL)isValidPostCode:(NSString *)postCode;

+ (BOOL)isValidVerificationCode:(NSString *)verificationCode;

@end
