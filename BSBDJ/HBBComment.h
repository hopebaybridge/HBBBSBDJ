//
//  HBBComment.h
//  BSBDJ
//
//  Created by HopeBayBridge on 16/2/2.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//  评论模型

#import <Foundation/Foundation.h>
@class HBBUser;

@interface HBBComment : NSObject
/** 音效文件的时长 */
@property (nonatomic,assign) NSInteger voicetime;
/**  评论的文字内容 */
@property (nonatomic,copy)  NSString *content;
/** 被点赞的数量 */
@property (nonatomic,assign) NSInteger like_count;
/** 用户*/
@property (nonatomic,strong) HBBUser  *user;
@end