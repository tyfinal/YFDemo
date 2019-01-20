//
//  NSString+MKDate.h
//  maike
//
//  Created by keiyi on 15/7/28.
//  Copyright (c) 2015年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MKDate)
/** 将date类型转成字符串 */
+ (NSString *)stringFromDate:(NSDate *)date andFormaterString:(NSString *)formaterString;

/** 将字符串转换成日期 */
+ (NSDate *)dateFromString:(NSString *)dateString WithFormaterString:(NSString *)formaterString;

/** 将字符串转成特定字符串几小时前、刚刚等。超过一天显示具体时间 */
+ (NSString *)getSpecifyTime:(NSString *)dateString;

/** 根据时间戳 将字符串转成特定字符串几小时前、刚刚等。超过一天显示具体时间*/
+ (NSString *)getSpecificTimeWithStampString:(NSString *)stampDateString;

/** 截取日期字符串到特定格式 */
+ (NSString *)getSpecialFormatDateString:(NSString *)dateString withFormaterString:(NSString *)formaterString;

/** 时间戳转时间 */
+ (NSString *)getDateStringFromStampString:(NSString *)dateStr andFormaterString:(NSString *)formaterString;

/** 将时间戳转成时间字符串 */
+ (NSString *)getStringFromTimeStamp:(NSString *)timeStampSting;

/** 获取时间戳 */
+ (NSString *)getStampStringFromDateString:(NSString *)dateString formaterString:(NSString *)formaterString;

/** 时间转时间戳 */
+ (NSString *)getStampStringFromDate:(NSDate *)date;

/** 时间处理转换成几天前几小时前等 */
+ (NSString *)timeHandleWithString:(NSString *)stirng;

///** 根据日期返回是星期几 */
//+ (NSString *)weekStringFromDate:(NSDate *)date;
//
//+ (NSString *)dayStringFromDate:(NSDate *)date;


+(NSString*)timeStringForTimeInterval:(NSTimeInterval)timeInterval;


@end
