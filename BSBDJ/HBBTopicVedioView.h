//
//  HBBTopicVedioView.h
//  BSBDJ
//
//  Created by HopeBayBridge on 16/1/31.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HBBTopic;

@interface HBBTopicVedioView : UIView

+ (instancetype)videoView;


/** 帖子模型 */
@property (nonatomic,strong)HBBTopic  *topic;

@end
