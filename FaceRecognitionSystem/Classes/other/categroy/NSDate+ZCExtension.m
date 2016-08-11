//
//  NSDate+ZCExtension.m
//
//  Created by zhangchen on 16/7/1.
//  Copyright (c) 2016年 张晨. All rights reserved.
//

#import "NSDate+ZCExtension.h"

@implementation NSDate (ZCExtension)

- (NSDateComponents *)zc_deltaFrom:(NSDate *)from
{
    // 日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 比较时间
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    return [calendar components:unit fromDate:from toDate:self options:0];
}

- (BOOL)zc_isThisYear
{
    // 日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSInteger nowYear = [calendar component:NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger selfYear = [calendar component:NSCalendarUnitYear fromDate:self];
    
    return nowYear == selfYear;
}

//- (BOOL)isToday
//{
//    // 日历
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    
//    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
//    
//    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
//    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
//    
//    return nowCmps.year == selfCmps.year
//    && nowCmps.month == selfCmps.month
//    && nowCmps.day == selfCmps.day;
//}

- (BOOL)zc_isToday
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSString *nowString = [fmt stringFromDate:[NSDate date]];
    NSString *selfString = [fmt stringFromDate:self];
    
    return [nowString isEqualToString:selfString];
}

- (BOOL)zc_isYesterday
{
    // 2014-12-31 23:59:59 -> 2014-12-31
    // 2015-01-01 00:00:01 -> 2015-01-01
    
    // 日期格式化类
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSDate *nowDate = [fmt dateFromString:[fmt stringFromDate:[NSDate date]]];
    NSDate *selfDate = [fmt dateFromString:[fmt stringFromDate:self]];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:selfDate toDate:nowDate options:0];
    
    return cmps.year == 0
    && cmps.month == 0
    && cmps.day == 1;
}

- (NSString *)zc_ruleTimeWithStringDate:(NSString *)date dateForm:(NSString *)dateForm
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    
    fmt.dateFormat = dateForm;
    
    NSDate *createDate = [fmt dateFromString:date];
    
    if (createDate.zc_isThisYear) {//是今年
        if (createDate.zc_isToday) {//是今天
            NSDateComponents *cmps = [self zc_deltaFrom:createDate];
            if (cmps.hour >= 1) {//大于1小时
                return [NSString stringWithFormat:@"%zd小时以前",cmps.hour];
            } else if (cmps.minute >= 1) {//大于等于1分钟，小于一小时
                return [NSString stringWithFormat:@"%zd分钟以前",cmps.minute];
            }else {//1分钟内
                return @"刚刚";
            }
            
        } else if (createDate.zc_isYesterday) {//是昨天
            fmt.dateFormat = @"昨天 HH:mm:ss";
            return [fmt stringFromDate:createDate];
        } else {//其他
            fmt.dateFormat = @"MM-dd HH:mm:ss";
            return [fmt stringFromDate:createDate];
        }
    }  else {//不是今年
        return date;
    }
}

- (NSString *)zc_ruleTimeWithDate:(NSDate *)date
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    
    if (date.zc_isThisYear) {//是今年
        if (date.zc_isToday) {//是今天
            NSDateComponents *cmps = [self zc_deltaFrom:date];
            if (cmps.hour >= 1) {//大于1小时
                return [NSString stringWithFormat:@"%zd小时以前",cmps.hour];
            } else if (cmps.minute >= 1) {//大于等于1分钟，小于一小时
                return [NSString stringWithFormat:@"%zd分钟以前",cmps.minute];
            }else {//1分钟内
                return @"刚刚";
            }
            
        } else if (date.zc_isYesterday) {//是昨天
            fmt.dateFormat = @"昨天 HH:mm:ss";
            return [fmt stringFromDate:date];
        } else {//其他
            fmt.dateFormat = @"MM-dd HH:mm:ss";
            return [fmt stringFromDate:date];
        }
    }  else {//不是今年
        fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        return [fmt stringFromDate:date];
    }
}

@end
