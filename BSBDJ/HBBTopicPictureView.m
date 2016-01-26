//
//  HBBTopicPictureView.m
//  BSBDJ
//
//  Created by HopeBayBridge on 16/1/26.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import "HBBTopicPictureView.h"

@implementation HBBTopicPictureView

+ (instancetype)pictureView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
