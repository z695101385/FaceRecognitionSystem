//
//  NSDate+ZCExtension.h
//
//  Created by zhangchen on 16/7/1.
//  Copyright (c) 2016年 张晨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (ZCExtension)
/**
 * 比较from和self的时间差值
 */
- (NSDateComponents *)zc_deltaFrom:(NSDate *)from;

/**
 * 是否为今年
 */
- (BOOL)zc_isThisYear;

/**
 * 是否为今天
 */
- (BOOL)zc_isToday;

/**
 * 是否为昨天
 */
- (BOOL)zc_isYesterday;
/**
 *  根据输入时间返回规则时间
 *
 *  @param date     NSString * 时间数据
 *  @param dateForm 时间数据的形式 例如 @"yyyy-MM-dd HH:mm:ss”
 *
 *  @return 规则时间
 */
- (NSString *)zc_ruleTimeWithStringDate:(NSString *)date dateForm:(NSString *)dateForm;
/**
 *  根据输入时间返回规则时间
 *
 *  @param date NSDate * 时间数据
 *
 *  @return 规则时间
 */
- (NSString *)zc_ruleTimeWithDate:(NSDate *)date;
@end
