//
//  DSValidInfoCheck.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/11.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSValidInfoCheck.h"

@implementation DSValidInfoCheck

+ (BOOL)iSValidPassword:(NSString *)passwordString{
    NSString * passWordRegex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,}$";
    NSPredicate * passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passwordString];
}

+ (BOOL)isValidPhoneNumber:(NSString *)phoneNumber{
    NSString *pattern = @"^[0-9]{11}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:phoneNumber];
    return isMatch;
}


+ (BOOL)isValidPostCode:(NSString *)postCode{
    NSString *pattern = @"^[0-9]{6}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:postCode];
    return isMatch;
}

+ (BOOL)isValidVerificationCode:(NSString *)verificationCode{
    NSString *pattern = @"^[0-9]{6}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:verificationCode];
    return isMatch;
}

@end
