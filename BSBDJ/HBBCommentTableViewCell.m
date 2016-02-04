//
//  HBBCommentTableViewCell.m
//  BSBDJ
//
//  Created by HopeBayBridge on 16/2/3.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import "HBBCommentTableViewCell.h"
#import "HBBComment.h"
#import "HBBUser.h"
#import <UIImageView+WebCache.h>

@interface HBBCommentTableViewCell()
/** 头像  */
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
/** 性别 */
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
/** 用户名*/
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
/** 评论内容 */
@property (weak, nonatomic) IBOutlet UILabel *cmtContentLabel;
/** 评论数*/
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
/** 音频按钮*/
@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;

@end


@implementation HBBCommentTableViewCell



-(void)setComment:(HBBComment *)comment{
    _comment = comment;
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:comment.user.profile_image] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    self.sexImageView.image = [comment.user.sex isEqualToString:HBBUserSexMale] ? [UIImage imageNamed:@"Profile_manIcon"] :[UIImage imageNamed:@"Profile_womanIcon"];
    self.cmtContentLabel.text = comment.content;
    self.usernameLabel.text = comment.user.username;
    self.likeCountLabel.text = [NSString stringWithFormat:@"%zd",comment.like_count];
    
    if (comment.voiceuri.length) {
        self.voiceBtn.hidden = NO;
        [self.voiceBtn setTitle:[NSString stringWithFormat:@"%zd''",comment.voicetime] forState:UIControlStateNormal];
    } else {
        self.voiceBtn.hidden = YES;
    }
    
}

/**
 *  自定义 cell分割线
 */
- (void)awakeFromNib {
    // Initialization code
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.image = [UIImage imageNamed:@"mainCellBackground"];
    self.backgroundView = bgView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 *  重写此方法调整 cell 的左右边距
 *
 *  @param frame <#frame description#>
 */
-(void)setFrame:(CGRect)frame{
    frame.origin.x = HBBTopicCellMargin;
    frame.size.width -= 2 *HBBTopicCellMargin;
    
    [super setFrame:frame];
}

@end
