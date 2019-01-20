//
//  NSString+MKDate.m
//  maike
//
//  Created by keiyi on 15/7/28.
//  Copyright (c) 2015年 ky. All rights reserved.
//

#import "NSString+MKDate.h"
//#import <DateTools.h>

//static const NSInteger SECONDS_IN_TWODAY = 172800;  /**< 2天   */
static const NSInteger SECONDS_IN_DAY = 86400;      /**< 1天   */
static const NSInteger SECONDS_IN_HOUR = 3600;      /**< 1小时  */
static const NSInteger SECONDS_IN_MINUTE = 60;      /**< 1分钟  */
//static const NSInteger SECONDS_IN_MONTH = 30*86400; /**< 1个月  */

@implementation NSString (MKDate)
+ (NSString *)stringFromDate:(NSDate *)date andFormaterString:(NSString *)formaterString{
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    if (formaterString) {
        [formatter setDateFormat:formaterString];
    }else{
        [formatter setDateFormat:@"yyyy-MM-dd HH-mm-ss"];
    }
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/beijing"];
    NSLocale * loacle = [NSLocale currentLocale];
    [formatter setLocale:loacle];
    [formatter setTimeZone:timeZone];
    NSString * dateString = [formatter stringFromDate:date];
    return dateString;
}

+ (NSDate *)dateFromString:(NSString *)dateString WithFormaterString:(NSString *)formaterString{
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    if (formaterString) {
        [formatter setDateFormat:formaterString];
    }else{
        [formatter setDateFormat:@"yyyy-MM-dd HH-mm-ss"];
    }
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/beijing"];
    [formatter setTimeZone:timeZone];
    NSLocale * loacle = [NSLocale currentLocale];
    [formatter setLocale:loacle];
    NSDate * date = [formatter dateFromString:dateString];
    return date;
}

+ (NSString *)getSpecifyTime:(NSString *)dateString{
//    NSDate * currentDate = [self dateFromString:da WithFormaterString:<#(NSString *)#>];
    NSDate * publishDate = [self dateFromString:dateString WithFormaterString:nil];
    NSTimeInterval timeInterVal = [publishDate timeIntervalSinceNow];
    NSString * timeString;
    if (timeInterVal/SECONDS_IN_MINUTE<1) {
        timeString = @"刚刚";
         return timeString;
    }
    if (timeInterVal/SECONDS_IN_HOUR<1)
    {
        timeString = [NSString stringWithFormat:@"%ld", (NSInteger)(timeInterVal/60)];
        timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
        return timeString;
    }
    if (timeInterVal/SECONDS_IN_HOUR>1&&timeInterVal/SECONDS_IN_DAY<1)
    {
        timeString = [NSString stringWithFormat:@"%ld", (NSInteger)(timeInterVal/3600)];
        timeString = [NSString stringWithFormat:@"%@小时前", timeString];
        return timeString;
    }else{
        //大于24小时后 判断是否是昨天，需将时间的基准点调至今天的开始 00:00:00
        NSString * nowDate  = [self stringFromDate:[NSDate date] andFormaterString:@"yyyy-MM-dd"];
        NSString * zeroString = [NSString stringWithFormat:@"%@ 00:00:00",nowDate];
        NSDate * zeroTime     = [self dateFromString:zeroString WithFormaterString:nil];
         NSTimeInterval dateInterval = [zeroTime timeIntervalSinceDate:publishDate];
//        NSDate * zeroTime = [NSString ]
        if (dateInterval/SECONDS_IN_DAY<=1) {
            timeString =  @"昨天";
            return timeString;
        }
        if (dateInterval/SECONDS_IN_DAY>1&&dateInterval/(SECONDS_IN_DAY*3)<=1) {
            timeString = [NSString stringWithFormat:@"%ld", (NSInteger)(dateInterval/(SECONDS_IN_DAY))];
            timeString = [NSString stringWithFormat:@"%ld天前", timeString.integerValue+1];
            return timeString;
        }
        if (dateInterval/(3*SECONDS_IN_DAY)>1) {
            timeString = [self stringFromDate:publishDate andFormaterString:@"M月dd日"];
            return timeString;
        }
    }
    return timeString;
}

/** 根据时间戳 将字符串转成特定字符串几小时前、刚刚等。超过一天显示具体时间*/
+ (NSString *)getSpecificTimeWithStampString:(NSString *)stampDateString{
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval createTime = stampDateString.integerValue/1000;
    NSTimeInterval timeInterVal = currentTime - createTime;
    NSString * timeString;
    if (timeInterVal/SECONDS_IN_MINUTE<1) {
        timeString = @"刚刚";
        return timeString;
    }
    if (timeInterVal/SECONDS_IN_HOUR<1)
    {
        timeString = [NSString stringWithFormat:@"%ld", (NSInteger)(timeInterVal/60)];
        timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
        return timeString;
    }
    if (timeInterVal/SECONDS_IN_HOUR>1&&timeInterVal/SECONDS_IN_DAY<1)
    {
        timeString = [NSString stringWithFormat:@"%ld", (NSInteger)(timeInterVal/3600)];
        timeString = [NSString stringWithFormat:@"%@小时前", timeString];
        return timeString;
    }else{
        NSString * nowDate  = [self stringFromDate:[NSDate date] andFormaterString:@"yyyy-MM-dd"];
        NSString * zeroString = [NSString stringWithFormat:@"%@ 00:00:00",nowDate];
        NSDate * zeroTime     = [self dateFromString:zeroString WithFormaterString:nil];
        NSTimeInterval startTime = [stampDateString doubleValue]/1000;
        NSDate *publishTime = [NSDate dateWithTimeIntervalSince1970:startTime];
        NSTimeInterval dateInterval = [zeroTime timeIntervalSinceDate:publishTime];
        if (dateInterval/SECONDS_IN_DAY<=1) {
            timeString =  @"昨天";
            return timeString;
        }
        if (dateInterval/SECONDS_IN_DAY>1&&dateInterval/(SECONDS_IN_DAY*3)<=1) {
            timeString = [NSString stringWithFormat:@"%ld", (NSInteger)(dateInterval/(SECONDS_IN_DAY))];
            timeString = [NSString stringWithFormat:@"%ld天前", timeString.integerValue+1];
            return timeString;
        }
        if (dateInterval/(3*SECONDS_IN_DAY)>1) {
            timeString = [self stringFromDate:publishTime andFormaterString:@"MM月dd日"];
            return timeString;
        }
    }
    return timeString;
}

+ (NSString *)getSpecialFormatDateString:(NSString *)dateString withFormaterString:(NSString *)formaterString{
    NSDate * date = [self dateFromString:dateString WithFormaterString:@"yyyy-MM-dd HH:mm:ss"];
    NSString * dateStr = [self stringFromDate:date andFormaterString:formaterString];
    return dateStr;
}


/** 时间戳转时间 */
+ (NSString *)getDateStringFromStampString:(NSString *)dateStr andFormaterString:(NSString *)formaterString{
    NSTimeInterval startTime = [dateStr doubleValue]/1000;
    NSDate *publishTime = [NSDate dateWithTimeIntervalSince1970:startTime];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (!formaterString) {
        [formatter setDateFormat:@"yyyy-MM-dd HH-mm-ss"];
    }else{
        [formatter setDateFormat:formaterString];
    }
    NSString *publishTimeStr = [formatter stringFromDate:publishTime];
    return publishTimeStr;
}


+ (NSString *)getStringFromTimeStamp:(NSString *)timeStampSting{
    NSTimeInterval time = [timeStampSting longLongValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSString *str = [formatter stringFromDate:date];
    str = [str stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    return str;
}

/** 获取时间戳 */
+ (NSString *)getStampStringFromDateString:(NSString *)dateString formaterString:(NSString *)formaterString{
    NSDate * date = [self dateFromString:dateString WithFormaterString:formaterString];
    NSTimeInterval interVal = [date timeIntervalSince1970];
    return [NSString stringWithFormat:@"%.lf",interVal*1000];
}

+ (NSString *)getStampStringFromDate:(NSDate *)date{
    NSTimeInterval interVal = [date timeIntervalSince1970];
    return [NSString stringWithFormat:@"%.lf",interVal*1000];
}

+ (NSString *)timeHandleWithString:(NSString *)stirng{
    NSDate * currentDate = [self dateFromString:[self stringFromDate:[NSDate date] andFormaterString:nil] WithFormaterString:nil];
    NSDate * publishDate = [self dateFromString:stirng WithFormaterString:nil];
    NSTimeInterval timeInterVal = [currentDate timeIntervalSinceDate:publishDate];
    NSString * timeString;
    if (timeInterVal/60<1) {
        timeString = @"刚刚";
    }else{
        if (timeInterVal/SECONDS_IN_HOUR<1)
        {
            timeString = [NSString stringWithFormat:@"%ld", (NSInteger)(timeInterVal/60)];
            timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
        }
        if (timeInterVal/SECONDS_IN_HOUR>1&&timeInterVal/SECONDS_IN_DAY<1)
        {
            timeString = [NSString stringWithFormat:@"%ld", (NSInteger)(timeInterVal/3600)];
            timeString=[NSString stringWithFormat:@"%@小时前", timeString];
        }
        if (timeInterVal/SECONDS_IN_DAY>1&&timeInterVal/(SECONDS_IN_DAY*3)<=1) {
            timeString = [NSString stringWithFormat:@"%ld", (NSInteger)(timeInterVal/(SECONDS_IN_DAY))];
            timeString=[NSString stringWithFormat:@"%@天前", timeString];
        }
        if (timeInterVal/(3*SECONDS_IN_DAY)>1) {
            timeString = [self stringFromDate:publishDate andFormaterString:@"MM月dd日"];
        }
    }
    return timeString;
}



///** 根据日期返回是星期几 */
//+ (NSString *)weekStringFromDate:(NSDate *)date{
//    
//    NSArray *weeks=@[[NSNull null],@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
//    NSCalendar *calendar=[[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
//    [calendar setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_hans"]];
//    NSTimeZone *timeZone=[[NSTimeZone alloc]initWithName:@"Asia/Beijing"];
//    [calendar setTimeZone:timeZone];
//    NSCalendarUnit calendarUnit=NSWeekdayCalendarUnit;
//    NSDateComponents *components=[calendar components:calendarUnit fromDate:date];
//    return [weeks objectAtIndex:components.weekday];
//}
//
//+ (NSString *)dayStringFromDate:(NSDate *)date{
//    NSCalendar *calendar=[[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
//    [calendar setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_hans"]];
//    NSTimeZone *timeZone=[[NSTimeZone alloc]initWithName:@"Asia/Beijing"];
//    [calendar setTimeZone:timeZone];
//    NSCalendarUnit calendarUnit=NSWeekdayCalendarUnit;
//    NSDateComponents *components=[calendar components:calendarUnit fromDate:date];
//    return [NSString stringWithFormat:@"%ld",components.day];
//}


+(NSString*)timeStringForTimeInterval:(NSTimeInterval)timeInterval
{
    NSInteger ti = (NSInteger)timeInterval;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    
    if (hours > 0)
    {
        return [NSString stringWithFormat:@"%02li:%02li:%02li", (long)hours, (long)minutes, (long)seconds];
    }
    else
    {
        return  [NSString stringWithFormat:@"%02li:%02li", (long)minutes, (long)seconds];
    }
}

@end
