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


@end

@implementation HBBTopicCell



- (HBBTopicPictureView *)pictureView{
    if (!_pictureView) {
        // 加载 xib
        HBBTopicPictureView *pictureView = [HBBTopicPictureView pictureView];
        [self.contentView addSubview:pictureView];
        _pictureView = pictureView;
    }
       return _pictureView;
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
    self.createTimeLabel.text = topic.create_time;
    
    
    // 设置按钮文字
    [self setupBtn:self.dingBtn count:topic.ding placeholder:@"顶"];
    [self setupBtn:self.caiBtn count:topic.cai placeholder:@"踩"];
    [self setupBtn:self.shareBtn count:topic.repost placeholder:@"分享"];
    [self setupBtn:self.commentBtn count:topic.comment placeholder:@"评论"];
    
    // 设置帖子的文字内容
    self.text_label.text= topic.text;
    
    
    
    
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
    frame.size.height -= HBBTopicCellMargin;
    frame.origin.y += HBBTopicCellMargin;
    
    [super setFrame:frame];
}

@end
