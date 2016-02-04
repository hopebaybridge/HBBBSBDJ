//
//  HBBTopicCell.m
//  HBBBDBDJ
//
//  Created by HopeBayBridge on 16/1/24.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import "HBBTopicCell.h"
#import "HBBTopic.h"
#import <UIImageView+WebCache.h>
#import "HBBTopicPictureView.h"
#import "HBBTopicVoiceView.h"
#import "HBBTopicVedioView.h"
#import "HBBUser.h"
#import "HBBComment.h"

@interface HBBTopicCell()
/**图像*/
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

/**昵称*/
@property (nonatomic,weak) IBOutlet UILabel *nameLabel;

/**时间*/
@property (nonatomic,weak) IBOutlet UILabel *createTimeLabel;
/** 顶 */
@property (weak, nonatomic) IBOutlet UIButton *dingBtn;
/** 踩 */
@property (weak, nonatomic) IBOutlet UIButton *caiBtn;

/** 转发 */
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
/** 评论 */
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
/** 文字 */
@property (weak, nonatomic) IBOutlet UILabel *text_label;
/**图片帖子的中间内容*/
@property (nonatomic,weak)  HBBTopicPictureView *pictureView;
/**声音帖子的中间内容*/
@property (nonatomic,weak)  HBBTopicVoiceView *voiceView;
/**音频帖子的中间内容*/
@property (nonatomic,weak)  HBBTopicVedioView *videoView;
/** 最新评论的整个 UIView */
@property (weak, nonatomic) IBOutlet UIView *topicCmtView;
/**最新评论的内容*/
@property (weak, nonatomic) IBOutlet UILabel *topicCmtContentLabel;

@end

@implementation HBBTopicCell

/**
 *  加载评论 commentcontroller 数据
 *
 *  @return <#return value description#>
 */
+ (instancetype)cell{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil]  firstObject];
}


/**
 *  懒加载图像信息     没有数据记在数据,有数据不在访问服务器
 *
 *  @return <#return value description#>
 */
- (HBBTopicPictureView *)pictureView{
    if (!_pictureView) {
        // 加载 xib
        HBBTopicPictureView *pictureView = [HBBTopicPictureView pictureView];
        [self.contentView addSubview:pictureView];
        _pictureView = pictureView;
    }
       return _pictureView;
}



- (HBBTopicVoiceView *)voiceView{
    if (!_voiceView) {
        // 加载 xib
        HBBTopicVoiceView *voiceView = [HBBTopicVoiceView voiceView];
        [self.contentView addSubview:voiceView];
        _voiceView = voiceView;
    }
    return _voiceView;
}


- (HBBTopicVedioView *)videoView{
    if (!_videoView) {
        // 加载 xib
        HBBTopicVedioView *videoView = [HBBTopicVedioView videoView];
        [self.contentView addSubview:videoView];
        _videoView = videoView;
    }
    return _videoView;
}



- (void)awakeFromNib {
    // Initialization code
    // 初始化背景图片
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.image = [UIImage imageNamed:@"mainCellBackground"];
    self.backgroundView = bgView;
}



- (void)setTopic:(HBBTopic *)topic{
    
    _topic = topic;
    
    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:topic.profile_image] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    self.nameLabel.text = topic.name;
    
    // 设置时间  setter
    self.createTimeLabel.text = topic.passtime;
    
    
    // 设置按钮文字
    [self setupBtn:self.dingBtn count:topic.ding placeholder:@"顶"];
    [self setupBtn:self.caiBtn count:topic.cai placeholder:@"踩"];
    [self setupBtn:self.shareBtn count:topic.repost placeholder:@"分享"];
    [self setupBtn:self.commentBtn count:topic.comment placeholder:@"评论"];
    
    // 设置帖子的文字内容
    self.text_label.text= topic.text;
    
    //根据帖子的类型添加对应的内容到 cell 中间(图片,声音,视频)
    if(topic.type == HBBTopicTypePicture){
        // 图片帖子
        self.pictureView.topic = topic;
        self.pictureView.frame = topic.pictureViewFrame;
        
        
        self.voiceView.hidden = YES;
        self.videoView.hidden = YES;
        self.pictureView.hidden = NO;
    }else if (topic.type == HBBTopicTypeVideo) {
        
        // 视频帖子
        self.videoView.topic = topic;
        self.videoView.frame = topic.videoViewFrame;
        
        
        self.voiceView.hidden = YES;
        self.videoView.hidden = NO;
        self.pictureView.hidden = YES;
    }else if (topic.type == HBBTopicTypeVoice) {
        // 声音帖子
        self.voiceView.topic = topic;
        self.voiceView.frame = topic.voiceViewFrame;
        
        self.voiceView.hidden = NO;
        self.videoView.hidden = YES;
        self.pictureView.hidden = YES;
        
    }else{ // 段子
        
        self.voiceView.hidden = YES;
        self.videoView.hidden = YES;
        self.pictureView.hidden = YES;
        
    }
    
    // 处理最热评论
    
    HBBComment *cmt = topic.top_cmt;
    
    if (cmt) {
        self.topicCmtView.hidden = NO;
        self.topicCmtContentLabel.text = [NSString stringWithFormat:@"%@ : %@",cmt.user.username ,cmt.content];
    } else {
        self.topicCmtView.hidden = YES;
    }
    
    
}


- (void)setupBtn:(UIButton *)btn count:(NSInteger )count placeholder:(NSString *)placeholder{
    
    if (count > 10000) {
        placeholder = [NSString stringWithFormat:@"%.1f万", count / 10000.0];
    } else if(count > 0){
        placeholder = [NSString stringWithFormat:@"%zd", count];
    }
    
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn setTitle:placeholder forState:UIControlStateNormal];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (void)testIntervalDate:(NSString *)create_time{
//    // 日期格式化类
//    NSDateFormatter *nsfmt = [[NSDateFormatter alloc] init];
//    // 设置日期格式
//    nsfmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//    
//    // 当前的时间
//    NSDate *now = [NSDate date];
//    // 发帖时间
//    NSDate *createDate = [nsfmt dateFromString:create_time];
//    
//    HBBLog(@"%@",[now deltaFrom:createDate]);
//    
//}


/**
 *  重写 frame 方法让 cell产生边距
 *
 *  @param frame <#frame description#>
 */
- (void)setFrame:(CGRect)frame{
    
    frame.origin.x = HBBTopicCellMargin;
    frame.size.width -= 2 * HBBTopicCellMargin;
//    frame.size.height -= HBBTopicCellMargin; 
    frame.size.height = self.topic.cellHeight - HBBTopicCellMargin;
    frame.origin.y += HBBTopicCellMargin;
    
    [super setFrame:frame];
}

@end
