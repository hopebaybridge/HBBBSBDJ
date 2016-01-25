//
//  UIBarButtonItem+HBBExtension.m
//  HBBBDBDJ
//
//  Created by HopeBayBridge on 16/1/16.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import "UIBarButtonItem+HBBExtension.h"

@implementation UIBarButtonItem (HBBExtension)
/**
 *  扩展  UIBarButtonItem  自定义导航栏的左右栏
 *
 *  @param image     <#image description#>  默认图片
 *  @param highImage <#highImage description#> 高亮图片
 *  @param target    <#target description#>  作用的可控制器
 *  @param action    <#action description#>   方法
 *
 *  @return <#return value description#>
 */
+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    // 默认图像
    [btn setBackgroundImage:[UIImage imageNamed:image ] forState:UIControlStateNormal];
    // 点击高亮图片
    [btn setBackgroundImage:[UIImage imageNamed:highImage ] forState:UIControlStateHighlighted];
    
    // 必须设置 size 否则不显示
    btn.size = btn.currentBackgroundImage.size;

    // 点击 target(控制器)
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return  [[self alloc] initWithCustomView:btn];

}


@end
