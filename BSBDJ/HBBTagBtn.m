
//
//  HBBTagBtn.m
//  BSBDJ
//
//  Created by HopeBayBridge on 16/2/9.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import "HBBTagBtn.h"

@implementation HBBTagBtn

/**
 *  设置按钮的图片  文字大小
 *
 *  @param frame <#frame description#>
 *
 *  @return <#return value description#>
 */
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setImage:[UIImage imageNamed:@"chose_tag_close_icon"] forState:UIControlStateNormal];
        self.backgroundColor = HBBPublishWordsTagBG;
        self.titleLabel.font = HBBPublishWordsTagFont;
    }
    return  self;
}

/**
 *  增加按钮的宽度
 *
 *  @param title <#title description#>
 *  @param state <#state description#>
 */
- (void)setTitle:(NSString *)title forState:(UIControlState)state{
    [super setTitle:title  forState:state];
    
    [self sizeToFit];
    
    self.width  += 3 * HBBPublicWordsTagMargin;
}

/**
 *   改变文字  图片的位置
 */
- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.titleLabel.x = HBBPublicWordsTagMargin;
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame) + HBBPublicWordsTagMargin;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
