//
//  HBBRecommandTagCell.m
//  HBBBDBDJ
//
//  Created by HopeBayBridge on 16/1/21.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import "HBBRecommandTagCell.h"
#import "HBBRecommandTag.h"
#import <UIImageView+WebCache.h>

@interface HBBRecommandTagCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageListImageView;
@property (weak, nonatomic) IBOutlet UILabel *themeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *suBNumberLabel;

@end


@implementation HBBRecommandTagCell

- (void)awakeFromNib {
    // Initialization code
}


- (void)setRecommandTag:(HBBRecommandTag *)recommandTag{
    
    _recommandTag = recommandTag;
    
    
    [self.imageListImageView sd_setImageWithURL:[NSURL URLWithString:recommandTag.image_list] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    
    self.themeNameLabel.text = recommandTag.theme_name;
    
    // 处理订阅数量
    NSString *subNumber = nil;
    
    if (recommandTag.sub_number < 10000) {
        subNumber = [NSString stringWithFormat:@"%zd 人订阅",recommandTag.sub_number];
    } else {
        subNumber = [NSString stringWithFormat:@"%.1f 万人订阅", recommandTag.sub_number / 10000.0];
    }
    
    
    self.suBNumberLabel.text = subNumber;
}
/**
 *  重写 frame 方法  增加 cell 左右间距  separator
 *
 *  @param frame <#frame description#>
 */
- (void) setFrame:(CGRect)frame{
    frame.origin.x = 5;
    frame.size.width  -= 2 * frame.origin.x;
    frame.size.height  -= 1;
    
    
    [super setFrame:frame];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
