//
//  HBBTopic.m
//  HBBBDBDJ
//
//  Created by HopeBayBridge on 16/1/24.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import "HBBTopic.h"
#import <MJExtension.h>
#import "HBBUser.h"
#import "HBBComment.h"

@implementation HBBTopic

{
    CGFloat _cellHeight;
//    CGRect _pictureViewFrame;
    
}

+ (NSDictionary *)replacedKeyFromPropertyName{
    
    return @{
             @"small_image" : @"image0",
             @"middle_image" : @"image2",
             @"large_image" : @"image1",
             @"ID":@"id",
             @"top_cmt":@"top_cmt[0]"
             };
    
}

+ (NSDictionary *)objectClassInArray{
    //return @{@"top_cmt":[HBBComment class]};
    return @{@"top_cmt": @"HBBComment"};
}


- (NSString *)passtime{
    
    // 日期格式化
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    // 设置日期格式
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    // 帖子的创建时间
    NSDate *createDate = [fmt dateFromString:_passtime];
    
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
        return _passtime;
    }
    
    return  0;
}


- (CGFloat )cellHeight{
    
    if (!_cellHeight) {
        // 文字的最大尺寸 (高度不限
        CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 4 * HBBTopicCellMargin, MAXFLOAT);
        
        CGFloat textH = [self.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
        
        // cell 高度
        // 文字的高度
         _cellHeight = HBBTopicCellTextY + textH + HBBTopicCellMargin;
        
        // 根据帖子的类型来计算 cell 的高度
        if (self.type == HBBTopicTypePicture) {
            // 图片帖子
            // 图片显示的宽度
            CGFloat picWidth = maxSize.width;
            // 图片显示的高度
            CGFloat picHeight =picWidth * self.height / self.width;
            
            // 如果图片过长  将其改变为自定义的高度  400 
            if (picHeight > HBBTopicCellPictureMaxHeight) {
                picHeight = HBBTopicCellPictureCustomHeight;
                self.bigPicture = YES; // 标识为大图
            }
            
            
            
            
            // 计算控件的 frame
            CGFloat picX = HBBTopicCellMargin;
            CGFloat picY = HBBTopicCellTextY + textH + HBBTopicCellMargin;
            _pictureViewFrame = CGRectMake(picX, picY, picWidth, picHeight);
            
            _cellHeight += picHeight + HBBTopicCellMargin;
            
        }else if(self.type == HBBTopicTypeVoice){
            
            CGFloat voiceX = HBBTopicCellMargin;
            CGFloat voiceY = HBBTopicCellTextY + textH + HBBTopicCellMargin;
            CGFloat voiceWidth = maxSize.width;
            CGFloat voiceHeight = voiceWidth * self.height / self.width;
            
            _voiceViewFrame = CGRectMake(voiceX, voiceY, voiceWidth, voiceHeight);
            
            _cellHeight += voiceHeight + HBBTopicCellMargin;
            
            
        }else if(self.type ==HBBTopicTypeVideo){
            
            CGFloat videoX = HBBTopicCellMargin;
            CGFloat videoY = HBBTopicCellTextY + textH + HBBTopicCellMargin;
            CGFloat videoWidth = maxSize.width;
            CGFloat videoHeight = videoWidth * self.height / self.width;
            
            _videoViewFrame = CGRectMake(videoX, videoY, videoWidth, videoHeight);
            
            _cellHeight += videoHeight + HBBTopicCellMargin;
            
            
        }
        
        // 如果有最热评论
        HBBComment *cmt  = self.top_cmt;
        if (cmt) {
            NSString *content  = [NSString stringWithFormat:@"%@ : %@",cmt.user.username ,cmt.content];
            CGFloat contentH = [content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.height;
            _cellHeight += HBBTopicCellTopicCmtTitleH + contentH + 6 * HBBTopicCellMargin;
        }
        
        // 底部工具条的高度
        _cellHeight  += HBBTopicCellBottomBarH + HBBTopicCellMargin;
    }
    
    return _cellHeight;
}

@end
