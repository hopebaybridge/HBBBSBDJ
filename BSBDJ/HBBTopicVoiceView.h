//
//  HBBTopicVoiceView.h
//  BSBDJ
//
//  Created by HopeBayBridge on 16/1/31.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HBBTopic;

@interface HBBTopicVoiceView : UIView

+ (instancetype)voiceView;


/** 帖子模型 */
@property (nonatomic,strong)HBBTopic  *topic;


@end
