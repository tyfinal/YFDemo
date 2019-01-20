//
//  NSString+MKExtension.m
//  maike
//
//  Created by kongxiaopeng on 15/7/16.
//  Copyright (c) 2015年 ky. All rights reserved.
//

#import "NSString+MKExtension.h"

@implementation NSString (MKExtension)
- (NSDateComponents*)dateStr{
    NSDateFormatter* fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = @"yyyy.MM.dd";
    NSDate* date = [fmt dateFromString:self];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents* cmps = [[NSCalendar currentCalendar]components:unit fromDate:date];
    return cmps;
}

- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attrs context:nil].size;
}

- (CGSize)sizeWithFont:(UIFont *)font
{
    return [self sizeWithFont:font maxW:MAXFLOAT];
}


- (CGSize)sizeWithFont:(UIFont *)font maxHeight:(CGFloat)maxHeight{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(MAXFLOAT, maxHeight);
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attrs context:nil].size;
}


- (CGSize)sizeWithAttributes:(NSDictionary *)attributes maxW:(CGFloat)maxWidth{
    CGSize maxSize = CGSizeMake(maxWidth, MAXFLOAT);
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
}

- (CGSize)sizeWithAttributes:(NSDictionary *)attributes maxH:(CGFloat)maxHeight{
    CGSize maxSize = CGSizeMake(MAXFLOAT, maxHeight);
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
}

- (NSInteger)fileSize{
    NSFileManager* mgr = [NSFileManager defaultManager];
    //判断是否为文件
    BOOL dir = NO;
    BOOL exists = [mgr fileExistsAtPath:self isDirectory:&dir];
    //文件/文件夹不存在
    if (exists == NO) return 0;
    
    if (dir) {//self是一个文件夹
        // 遍历caches里面的所有内容 --- 直接和间接内容
        NSArray* subpaths = [mgr subpathsAtPath:self];
        NSInteger totalBytesSize = 0;
        for (NSString* subpath in subpaths) {
            //获得全路径
            NSString* fullSubpath = [self stringByAppendingPathComponent:subpath];
            //判断是否为文件
            BOOL dir = NO;
            [mgr fileExistsAtPath:fullSubpath isDirectory:&dir];
            if (dir == NO) {//文件
                totalBytesSize += [[mgr attributesOfItemAtPath:fullSubpath error:nil][NSFileSize] integerValue];
            }
        }
        return totalBytesSize;
    }else{//self是一个文件
        return [[mgr attributesOfItemAtPath:self error:nil][NSFileSize] integerValue];
    }
    return 0;
}

- (NSString*)otherStr:(NSString*)phoneStr{
    if (phoneStr.length > 3) {
        NSString* subStr = [phoneStr substringFromIndex:3];
        NSString* toStr = [phoneStr substringToIndex:3];
        NSString* starStr;
        if (subStr.length > 4) {
            NSString* otherStr = [subStr substringFromIndex:4];
            starStr = [NSString stringWithFormat:@"%@****%@",toStr,otherStr];
        }else{
            NSMutableString* star = [NSMutableString string];
            for (int i = 0; i < subStr.length; i++) {
                [star appendString:@"*"];
            }
            starStr = [NSString stringWithFormat:@"%@%@",toStr,star];
        }
        return starStr;
    }else{
        return phoneStr;
    }
}

+ (NSString *)handleBigNumber:(NSString *)number{
    if (number.integerValue>9999) {
        NSString * num = [NSString stringWithFormat:@"%.1f万",number.floatValue/10000.0];
        return num;
    }
    return number;
}

+ (NSAttributedString *)applyAttributes:(NSDictionary *)attributes forString:(NSString *)string{
    if ([string isNotBlank]) {
        NSMutableAttributedString * muAttri = [[NSMutableAttributedString alloc]initWithString:string];
        if (attributes) {
            [muAttri addAttributes:attributes range:NSMakeRange(0, string.length)];
        }
        return muAttri;
    }
    return nil;
}

/** 用****隐藏手机号中间四位 */
- (NSString *)encodePhoneNumber{
//    if ([self isNotBlank]&&self.length==11) {
//        NSString * ecodeString = [self stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
//        return ecodeString;
//    }
    return self;
}

@end
