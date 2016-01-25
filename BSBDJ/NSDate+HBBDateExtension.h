//
//  NSDate+HBBDateExtension.h
//  HBBBDBDJ
//
//  Created by HopeBayBridge on 16/1/24.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (HBBDateExtension)

- (NSDateComponents *)deltaFrom:(NSDate *)fromDate;

- (BOOL)isThisYear;

- (BOOL)isToday;

- (BOOL)isYesterday;
@end
