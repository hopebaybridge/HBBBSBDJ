//
//  HBBTopicVoiceView.m
//  BSBDJ
//
//  Created by HopeBayBridge on 16/1/31.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import "HBBTopicVoiceView.h"
#import <UIImageView+WebCache.h>
#import "HBBTopic.h"


@interface HBBTopicVoiceView()
/**声音帖子的背景图片*/
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
/**播放次数*/
@property (weak, nonatomic) IBOutlet UILabel *playCountLabel;
/**播放的时长*/
@property (weak, nonatomic) IBOutlet UILabel *voiceTimeLabel;

@end



@implementation HBBTopicVoiceView


+ (instancetype)voiceView{
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
    
    self.voiceTimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd",(topic.voicetime / 60),(topic.voicetime % 60) ];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
