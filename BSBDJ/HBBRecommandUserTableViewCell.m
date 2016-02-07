//
//  HBBRecommandUserTableViewCell.m
//  HBBBDBDJ
//
//  Created by HopeBayBridge on 16/1/18.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import "HBBRecommandUserTableViewCell.h"
#import "HBBRecommandUser.h"
#import <UIImageView+WebCache.h>

@interface HBBRecommandUserTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansCountLabel;
@end

@implementation HBBRecommandUserTableViewCell

- (void)awakeFromNib {
    // Initialization code
}



- (void)setUser:(HBBRecommandUser *)user{
    
    _user = user;
    
    self.screenNameLabel.text = user.screen_name;
    self.fansCountLabel.text = [NSString stringWithFormat:@"%zd人关注",user.fans_count];
//    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:user.header] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    
    // pch   UIImageView + HBBChageImageShape
    [self.headerImageView setHeadImageShape:user.header];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
