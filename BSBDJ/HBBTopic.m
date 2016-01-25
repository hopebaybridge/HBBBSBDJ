//
//  HBBTopic.m
//  HBBBDBDJ
//
//  Created by HopeBayBridge on 16/1/24.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import "HBBTopic.h"

@implementation HBBTopic

- (NSString *)create_time{
    
    // 日期格式化
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    // 设置日期格式
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    // 帖子的创建时间
    NSDate *createDate = [fmt dateFromString:_create_time];
    
    if (createDate.isThisYear) { // 今年
        if(createDate.isToday){ // 今天
            // pch   hbbdateExtension.h   比较时间差
            NSDateComponents *cmps = [[NSDate date] deltaFrom:createDate];
            if ( cmps.hour >= 1) { // > 1 H
                return [NSString stringWithFormat:@"%zd 小时前",cmps.hour];
            } else if(cmps.minute > 1){ //(1 - 59) mm
                return [NSString stringWithFormat:@"%zd 分钟前",cmps.minute];
            }else{  // < 1 mm
                return @"刚刚";
            }
            
            
        }else if(createDate.isYesterday){ // 昨天
             fmt.dateFormat = @"昨天 HH:mm:ss";
            return [fmt stringFromDate:createDate];
        }else{
            fmt.dateFormat = @"MM-dd HH:mm:ss";
            return [fmt stringFromDate:createDate];
        }
       
    } else {
        return _create_time;
    }
    
    return  0;
}

@end