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

@interface HBBTopicVedioView()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *playCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;



@end


@implementation HBBTopicVedioView

/**
 *  播放视频
 *
 *  @param sender <#sender description#>
 */
- (IBAction)playVideo:(UIButton *)sender {
    
    
}


+ (instancetype)videoView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

/**
 *  去掉 xib 图片的默认伸缩  防止图片过大对自定义宽度 的影响
 */
- (void)awakeFromNib{
    self.autoresizingMask = UIViewAutoresizingNone;
}

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

@end
