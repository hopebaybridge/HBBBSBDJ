//
//  NSDate+HBBDateExtension.m
//  HBBBDBDJ
//
//  Created by HopeBayBridge on 16/1/24.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import "NSDate+HBBDateExtension.h"

@implementation NSDate (HBBDateExtension)

-  (NSDateComponents *)deltaFrom:(NSDate *)fromDate{
    
    // 当前的日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSCalendarUnit unit =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute |NSCalendarUnitSecond;
    
    
    return [calendar components:unit fromDate:fromDate toDate:self options:0];
}

- (BOOL)isThisYear{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSInteger nowYear = [calendar component:NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger selfYear = [calendar component:NSCalendarUnitYear fromDate:self];
    
    
    return nowYear == selfYear;
}

- (BOOL)isToday{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSString *nowStr = [fmt stringFromDate:[NSDate date]];
    NSString *selfStr = [fmt stringFromDate:self];
    
    
    return [nowStr isEqualToString:selfStr];

}

- (BOOL)isYesterday{
    // 2014-12-31 23:59:59
    // 2015-01-01 00:00:01
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSDate *nowDate = [fmt dateFromString:[fmt stringFromDate:[NSDate date]]];
    NSDate *selfDate = [fmt dateFromString:[fmt stringFromDate:self]];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    

    return  cmps.year ==0 && cmps.month == 0 && cmps.day == 1;
}

@end
