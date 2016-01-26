//
//  HBBTopic.m
//  HBBBDBDJ
//
//  Created by HopeBayBridge on 16/1/24.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import "HBBTopic.h"
#import <MJExtension.h>

@implementation HBBTopic

{
    CGFloat _cellHeight;
    
}

+ (NSDictionary *)replaceKeyFromPropertyName{
    
    return @{
             @"small_image" : @"image0",
             @"middle_image" : @"image2",
             @"large_image" : @"image1",
             };
    
}


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


- (CGFloat )cellHeight{
    
    if (!_cellHeight) {
        // 文字的最大尺寸 (高度不限
        CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 4 * HBBTopicCellMargin, MAXFLOAT);
        
        CGFloat textH = [self.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
        
        // cell 高度
         _cellHeight = HBBTopicCellTextY + textH +HBBTopicCellBottomBarH + 2 * HBBTopicCellMargin;
        
        // 根据帖子的类型来计算 cell 的高度
        if (self.type == HBBTopicTypePicture) {
            // 图片帖子
            // 图片显示的宽度
            CGFloat picWidth = maxSize.width;
            // 图片显示的高度
            CGFloat picH =picWidth * self.height / self.width;
            
            // 计算控件的 frame
            CGFloat picX = HBBTopicCellMargin;
            CGFloat picY = HBBTopicCellTextY + textH + HBBTopicCellMargin;
            
            
            _cellHeight += picH;
            
        }
        
        
    }
    
    return _cellHeight;
}

@end
