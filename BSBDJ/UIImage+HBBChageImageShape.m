//
//  UIImage+HBBChageImageShape.m
//  BSBDJ
//
//  Created by HopeBayBridge on 16/2/6.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import "UIImage+HBBChageImageShape.h"

@implementation UIImage (HBBChageImageShape)

- (UIImage *)chageImageShape{
    
    // NO 代表透明
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    
    // 获得上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 添加一个圆
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextAddEllipseInRect(ctx, rect);
    
    // 裁剪
    CGContextClip(ctx);
    
    // 将图片画上去
    [self drawInRect:rect];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    
    return image;
    
}

@end
