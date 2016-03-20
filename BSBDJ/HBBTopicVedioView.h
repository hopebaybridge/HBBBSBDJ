//
//  HBBTopicVedioView.h
//  BSBDJ
//
//  Created by HopeBayBridge on 16/1/31.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HBBTopic;

#import <AVFoundation/AVFoundation.h>

@protocol VideoPlayViewDelegate <NSObject>

@optional
- (void)videoplayViewSwitchOrientation:(BOOL)isFull;

@end

@interface HBBTopicVedioView : UIView

+ (instancetype)videoView;

@property (weak, nonatomic) id<VideoPlayViewDelegate> delegate;

@property (nonatomic, strong) AVPlayerItem *playerItem;
/** 帖子模型 */
@property (nonatomic,strong)HBBTopic  *topic;

@end
