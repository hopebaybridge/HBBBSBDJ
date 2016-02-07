//
//  HBBMeCell.m
//  BSBDJ
//
//  Created by HopeBayBridge on 16/2/7.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import "HBBMeCell.h"

@implementation HBBMeCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self =[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UIImageView *bgView = [[UIImageView alloc] init];
        bgView.image = [UIImage imageNamed:@"mainCellBackground"];
        
        self.backgroundView = bgView;
        
        self.textLabel.textColor = [UIColor darkGrayColor];
        self.textLabel.font = [UIFont systemFontOfSize:16];
        
//        
//        UITableViewCellSelectionStyleNone,
//        UITableViewCellSelectionStyleBlue,
//        UITableViewCellSelectionStyleGray,
//        UITableViewCellSelectionStyleDefault
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}


/**
 *  布局 cell的图片和文字格局
 */
- (void)layoutSubviews{
    [super layoutSubviews];
    
    if(self.imageView.image == nil) return ;
    
    self.imageView.width = 30;
    self.imageView.height = self.imageView.width;
    self.imageView.centerY = self.contentView.height * 0.5;
    
    self.textLabel.x = CGRectGetMaxX(self.imageView.frame) + HBBTopicCellMargin;
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
