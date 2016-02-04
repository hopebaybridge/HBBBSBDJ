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

@end


@implementation HBBCommentTableViewCell



-(void)setComment:(HBBComment *)comment{
    _comment = comment;
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:comment.user.profile_image] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    self.sexImageView.image = [comment.user.sex isEqualToString:HBBUserSexMale] ? [UIImage imageNamed:@"Profile_manIcon"] :[UIImage imageNamed:@"Profile_womanIcon"];
    self.cmtContentLabel.text = comment.content;
    self.usernameLabel.text = comment.user.username;
    self.likeCountLabel.text = [NSString stringWithFormat:@"%zd",comment.like_count];
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
