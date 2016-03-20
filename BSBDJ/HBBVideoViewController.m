//
//  HBBVideoViewController.m
//  BSBDJ
//
//  Created by HopeBayBridge on 16/2/12.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import "HBBVideoViewController.h"
#import "HBBTopicVedioView.h"
#import "HBBFullViewController.h"

#import "HBBTopic.h"


@interface HBBVideoViewController ()<VideoPlayViewDelegate>

@property (nonatomic, strong) HBBFullViewController *fullVc;

@end

@implementation HBBVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupVideoView];
    
    NSString *url = self.topic.videouri;
    
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString: url ]];
    self.playView.playerItem = item;
}

- (void)setupVideoView
{
    HBBTopicVedioView *playView = [HBBTopicVedioView videoView];
    playView.frame = CGRectMake(0, 0, self.topic.width, self.topic.height);
    [self.view addSubview:playView];
    self.playView = playView;
    self.playView.delegate = self;
}

- (void)videoplayViewSwitchOrientation:(BOOL)isFull
{
    if (isFull) {
        [self presentViewController:self.fullVc animated:YES completion:^{
            self.playView.frame = self.fullVc.view.bounds;
            [self.fullVc.view addSubview:self.playView];
        }];
    } else {
        [self.fullVc dismissViewControllerAnimated:YES completion:^{
            self.playView.frame = CGRectMake(0, 0, self.topic.width, self.topic.height);
            [self.view addSubview:self.playView];
        }];
    }
}

#pragma mark - 懒加载代码
- (HBBFullViewController *)fullVc
{
    if (_fullVc == nil) {
        self.fullVc = [[HBBFullViewController alloc] init];
    }
    
    return _fullVc;
}

@end
