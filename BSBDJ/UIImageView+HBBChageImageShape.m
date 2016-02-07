//
//  UIImageView+HBBChageImageShape.m
//  BSBDJ
//
//  Created by HopeBayBridge on 16/2/6.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import "UIImageView+HBBChageImageShape.h"
#import <UIImageView+WebCache.h>

@implementation UIImageView (HBBChageImageShape)

-(void)setHeadImageShape:(NSString *)url{
    UIImage *placeholder = [[UIImage imageNamed:@"defaultUserIcon"] chageImageShape];
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        // 没有图片显示占位图片
        self.image = image?[image chageImageShape]:placeholder;
    }];
    
}

@end
