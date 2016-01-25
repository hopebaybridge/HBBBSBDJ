//
//  HBBVerticalButton.m
//  HBBBDBDJ
//
//  Created by HopeBayBridge on 16/1/22.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import "HBBVerticalButton.h"

@implementation HBBVerticalButton

/**
 *  让文字居中显示
 */
- (void)setup{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}



/**
 *  重写此方法可以让 代码生成的 button 也可以自定义图片和文字的位置
 *
 *  @param frame <#frame description#>
 *
 *  @return <#return value description#>
 */
- (instancetype) initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return  self;
}

/**
 *  重写此方法可以让 xib 布局的 button 自定义文字和图片的位置
 */
- (void)awakeFromNib{
    [self setup];
}



/**
 *  自定义 button 图片文字的位置
 *
 *   */
-(void)layoutSubviews{
    [super layoutSubviews];
    
    // 调整图片 (正方形)
    self.imageView.x = 0;
    
    self.imageView.y = 0;
    
    self.imageView.width = self.width;
    
    self.imageView.height = self.imageView.width;
    
    
    // 调整文字
    
    self.titleLabel.x = 0;
    
    self.titleLabel.y = self.imageView.height + 5;
    
    self.titleLabel.width = self.width;
    
//    HBBLog(@"%f----",self.titleLabel.width);
    
    self.titleLabel.height = self.height - self.titleLabel.y;
    
    //self.titleLabel.backgroundColor = [UIColor redColor];
    
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
