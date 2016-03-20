//
//  UIView+HBBExtension.m
//  HBBBDBDJ
//
//  Created by HopeBayBridge on 16/1/16.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import "UIView+HBBExtension.h"

@implementation UIView (HBBExtension)

- (void)setSize:(CGSize)size{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

-(CGSize)size{
    return self.frame.size;

}
- (void)setWidth:(CGFloat)width{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height{
    CGRect frame = self.frame;
    frame.size.height= height;
    self.frame = frame;
}

- (void)setX:(CGFloat)x{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}


- (void)setCenterX:(CGFloat)centerX{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (void)setCenterY:(CGFloat)centerY{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}


- (CGFloat)centerX{
    return  self.center.x;
}

- (CGFloat)centerY{
    return  self.center.y;
}

- (CGFloat)width{
    return self.frame.size.width;
}

- (CGFloat)height{
    return self.frame.size.height;
}

-(CGFloat)x{
    return self.frame.origin.x;
}

- (CGFloat)y{
    return self.frame.origin.y;
}


/**
 *  判断指定的控件是否在主窗口(能见)
 *
 *  @return <#return value description#>
 */
- (BOOL)isShowingOnKeyWindow{
    // 主窗口
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    // 以主窗口左上角为坐标原点,计算 self的矩形框
    CGRect newFrame = [keyWindow convertRect:self.frame fromView:self.superview];
    CGRect winBounds = keyWindow.bounds;
    
    // 主窗口的 bounds 和 self 的矩形框是否有重叠
    BOOL intersects = CGRectIntersectsRect(newFrame, winBounds);
    
    // 没有隐藏    透明度大于0.01 可见   是主窗口   有交叉
    return  !self.isHidden && self.alpha > 0.01 && self.window == keyWindow && intersects ;
}

/**
 *  加载类名和模型图形一样的 xib
 *
 *  @return <#return value description#>
 */
+ (instancetype)viewFromXib{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

@end
