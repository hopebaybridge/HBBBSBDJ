//
//  HBBTopicVedioView.m
//  BSBDJ
//
//  Created by HopeBayBridge on 16/1/31.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import "HBBTopicVedioView.h"
#import <UIImageView+WebCache.h>
#import "HBBTopic.h"
#import <AVFoundation/AVFoundation.h>
#import "HBBAVPlayer.h"
#import "HBBAVPlayerItem.h"
#import "HBBAVPlayerLayer.h"
#import "HBBFullViewController.h"
#import "HBBVideoViewController.h"


@interface HBBTopicVedioView()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *playCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;

/* 播放器 */
@property (nonatomic, strong) AVPlayer *player;

// 播放器的Layer
@property (weak, nonatomic) AVPlayerLayer *playerLayer;

@property (weak, nonatomic) IBOutlet UIView *toolView;
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseBtn;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

// 记录当前是否显示了工具栏
@property (assign, nonatomic) BOOL isShowToolView;

/* 定时器 */
@property (nonatomic, strong) NSTimer *progressTimer;




#pragma mark - 监听事件的处理
- (IBAction)playOrPause:(UIButton *)sender;
- (IBAction)switchOrientation:(UIButton *)sender;
- (IBAction)slider;
- (IBAction)startSlider;
- (void)tapAction:(UITapGestureRecognizer *)sender;
- (IBAction)sliderValueChange;


@end


@implementation HBBTopicVedioView


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}






//-(AVPlayer *)player{
//    
//
////    if (_player != nil) {
////        [_player pause];
////
////    }
//    
//    if (_player == nil) {
//        
//        CGSize videoSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 4 * HBBTopicCellMargin, MAXFLOAT);
//        
//        CGFloat videoWidth = videoSize.width;
//        CGFloat videoHeight = videoWidth * self.topic.height / self.topic.width;
//        // 创建 AVPlayerItem
////         _playerItem  = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.topic.videouri]];
//        
//     
//        // 创建 AVPlayer
//        _player = [AVPlayer playerWithPlayerItem:_playerItem];
//        
//        // 添加 AVPlayerLayer
//        AVPlayerLayer *layer =  [AVPlayerLayer playerLayerWithPlayer:_player];
//        
//        layer.frame = CGRectMake(0, 0, videoWidth,videoHeight );
//        [self.imageView.layer addSublayer:layer];
//
//        
//    }
//    
//    return _player;
//}


/**
 *  播放视频
 *
 *  @param sender <#sender description#>
 */
- (IBAction)playVideo{
//    [self.player.currentItem cancelPendingSeeks];
//    [self.player.currentItem.asset cancelLoading];
//    
//    self.playBtn.hidden = YES;
////    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.topic.videouri]];
////    [self.player replaceCurrentItemWithPlayerItem:item];
//
//    [self.player play];
   HBBLog(@"%@",self.topic.videouri);
    
    
    
    [self.player.currentItem cancelPendingSeeks];
    [self.player.currentItem.asset cancelLoading];
    
    self.playBtn.hidden = YES;
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.topic.videouri]];
    
    [self setPlayerItem:item];
    
//    
//    HBBFullViewController *vc;
//    
//    
//    NSString *path  = self.topic.videouri;
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    
    
//    // increase buffering for .wmv, it solves problem with delaying audio frames
//    if ([path.pathExtension isEqualToString:@"wmv"])
//        parameters[KxMovieParameterMinBufferedDuration] = @(5.0);
//    
//    // disable deinterlacing for iPhone, because it's complex operation can cause stuttering
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//        parameters[KxMovieParameterDisableDeinterlacing] = @(YES);
//
//    
//    vc = [KxMovieViewController movieViewControllerWithContentPath:path parameters:parameters];
//    [self.window.rootViewController  presentViewController:vc animated:YES completion:nil];
//    
    
}


+ (instancetype)videoView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

/**
 *  去掉 xib 图片的默认伸缩  防止图片过大对自定义宽度 的影响
 */
//- (void)awakeFromNib{
//    self.autoresizingMask = UIViewAutoresizingNone;
//}

-(void)setTopic:(HBBTopic *)topic{
    _topic = topic;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.large_image]];
    
    self.playCountLabel.text = [NSString stringWithFormat:@"%zd 播放",topic.playcount];
    
    self.videoTimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd",(topic.videotime / 60),(topic.videotime % 60) ];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib
{
    self.autoresizingMask = UIViewAutoresizingNone;
    
    
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    
    //注意加的顺序和方式
    [self.imageView addGestureRecognizer:tap];
    
    
    

    self.player = [[AVPlayer alloc] init];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    [self.imageView.layer addSublayer:self.playerLayer];
    
    self.toolView.alpha = 0;
    self.isShowToolView = NO;
    
    [self.progressSlider setThumbImage:[UIImage imageNamed:@"thumbImage"] forState:UIControlStateNormal];
    [self.progressSlider setMaximumTrackImage:[UIImage imageNamed:@"MaximumTrackImage"] forState:UIControlStateNormal];
    [self.progressSlider setMinimumTrackImage:[UIImage imageNamed:@"MinimumTrackImage"] forState:UIControlStateNormal];
    
    [self removeProgressTimer];
    [self addProgressTimer];
    
    self.playOrPauseBtn.selected = YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.playerLayer.frame = self.bounds;
}

#pragma mark - 设置播放的视频
- (void)setPlayerItem:(AVPlayerItem *)playerItem
{
    _playerItem = playerItem;
    [self.player replaceCurrentItemWithPlayerItem:playerItem];
    [self.player play];
}

// 是否显示工具的View
- (void)tapAction:(UITapGestureRecognizer *)sender {
    [UIView animateWithDuration:0.5 animations:^{
        if (self.isShowToolView) {
            self.toolView.alpha = 0;
            self.isShowToolView = NO;
        } else {
            self.toolView.alpha = 0.6;
            self.isShowToolView = YES;
        }
    }];
}
// 暂停按钮的监听
- (IBAction)playOrPause:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.player play];
        
        [self addProgressTimer];
    } else {
        [self.player pause];
        
        [self removeProgressTimer];
    }
}

#pragma mark - 定时器操作
- (void)addProgressTimer
{
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateProgressInfo) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.progressTimer forMode:NSRunLoopCommonModes];
}

- (void)removeProgressTimer
{
    [self.progressTimer invalidate];
    self.progressTimer = nil;
}

- (void)updateProgressInfo
{
    // 1.更新时间
    self.timeLabel.text = [self timeString];
    
    // 2.设置进度条的value
    self.progressSlider.value = CMTimeGetSeconds(self.player.currentTime) / CMTimeGetSeconds(self.player.currentItem.duration);
    
    if (CMTimeGetSeconds(self.player.currentTime) == CMTimeGetSeconds(self.player.currentItem.duration)) {
        self.playBtn.hidden = NO;
    }
    
    
}

- (NSString *)timeString
{
    NSTimeInterval duration = CMTimeGetSeconds(self.player.currentItem.duration);
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentTime);
    
    return [self stringWithCurrentTime:currentTime duration:duration];
}

// 切换屏幕的方向
- (IBAction)switchOrientation:(UIButton *)sender {
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(videoplayViewSwitchOrientation:)]) {
        
        [self.delegate videoplayViewSwitchOrientation:sender.selected];
       
    }
}

- (IBAction)slider {
    [self addProgressTimer];
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentItem.duration) * self.progressSlider.value;
    
    // 设置当前播放时间
    [self.player seekToTime:CMTimeMakeWithSeconds(currentTime, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    

    if (currentTime != CMTimeGetSeconds(self.player.currentItem.duration)  ) {
        self.playBtn.hidden = YES;
    }
    
    [self.player play];
}

- (IBAction)startSlider {
    [self removeProgressTimer];
}

- (IBAction)sliderValueChange {
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentItem.duration) * self.progressSlider.value;
    NSTimeInterval duration = CMTimeGetSeconds(self.player.currentItem.duration);
    self.timeLabel.text = [self stringWithCurrentTime:currentTime duration:duration];
}

- (NSString *)stringWithCurrentTime:(NSTimeInterval)currentTime duration:(NSTimeInterval)duration
{
    NSInteger dMin = duration / 60;
    NSInteger dSec = (NSInteger)duration % 60;
    
    NSInteger cMin = currentTime / 60;
    NSInteger cSec = (NSInteger)currentTime % 60;
    
    NSString *durationString = [NSString stringWithFormat:@"%02ld:%02ld", dMin, dSec];
    NSString *currentString = [NSString stringWithFormat:@"%02ld:%02ld", cMin, cSec];
    
    return [NSString stringWithFormat:@"%@/%@", currentString, durationString];
}

@end

