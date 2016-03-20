//
//  HBBVideoViewController.h
//  BSBDJ
//
//  Created by HopeBayBridge on 16/2/12.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBBTopicVedioView.h"
@class HBBTopic;

@interface HBBVideoViewController : UIViewController 

@property (weak, nonatomic) HBBTopicVedioView *playView;

@property (nonatomic,strong) HBBTopic  *topic;

@end
