//
//  HBBProgressView.m
//  BSBDJ
//
//  Created by HopeBayBridge on 16/1/27.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import "HBBProgressView.h"

@implementation HBBProgressView



- (void)awakeFromNib{
    // 设置圆角效果
    self.roundedCorners = 2;
    self.progressLabel.textColor = [UIColor whiteColor];
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated{
    [super setProgress:progress animated:animated];
    
    // 修复 bug   -0.000
    NSString *text = [NSString stringWithFormat:@"%.0f%%",progress * 100];
    self.progressLabel.text = [text stringByReplacingOccurrencesOfString:@"-" withString:@""];
}


@end
