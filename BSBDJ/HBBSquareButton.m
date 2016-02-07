//
//  HBBSquareButton.m
//  BSBDJ
//
//  Created by HopeBayBridge on 16/2/7.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import "HBBSquareButton.h"
#import "HBBSquare.h"
#import <UIButton+WebCache.h>
@implementation HBBSquareButton


- (void)setup{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    [self setBackgroundImage:[UIImage imageNamed:@"mainCellBackground"] forState:UIControlStateNormal];
    
}


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    
    return self;
}


- (void)awakeFromNib{
    [self setup];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    // 调整图片
    self.imageView.y = self.height * 0.15;
    self.imageView.width = self.width * 0.5;
    self.imageView.height = self.imageView.width;
    self.imageView.centerX = self.width * 0.5;
    
    
    // 调整文字
    self.titleLabel.x = 0;
    self.titleLabel.y = CGRectGetMaxY(self.imageView.frame);
    self.titleLabel.width = self.width;
    self.titleLabel.height = self.height - self.titleLabel.y;
    
    
}



- (void)setSquare:(HBBSquare *)square{
    _square = square;
    
    [self setTitle:square.name forState:UIControlStateNormal];
    
    // 利用 SDWebImage 给按钮设置 image
    [self  sd_setImageWithURL:[NSURL URLWithString:square.icon]  forState:UIControlStateNormal];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
