//
//  HBBScolledTopWindow.m
//  BSBDJ
//
//  Created by HopeBayBridge on 16/2/4.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import "HBBScolledTopWindow.h"


static UIWindow *window_;

@implementation HBBScolledTopWindow

+ (void)initialize{
    window_ = [[UIWindow alloc] init];
    window_.frame = CGRectMake(0, 0, HBBScreenWidth, 20);
    // 设置显示的优先级 为最高
    window_.windowLevel = UIWindowLevelAlert;
    // 此处不设置 clearColor   则  状态栏会为黑色
    window_.backgroundColor = [UIColor clearColor];
    [window_ addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(windowClick)] ];
}


/**
 *  监听窗口点击
 */
+ (void)windowClick{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self searchScrollViewInView:window];
}

+ (void)searchScrollViewInView:(UIView *)superview{
    for (UIScrollView *subView in superview.subviews) {
        // 如果是 scrollView 滚动到最顶部  (并且其父控件也在主窗口)
        if ([subView isKindOfClass:[UIScrollView class]] && subView.isShowingOnKeyWindow) {
            CGPoint offset = subView.contentOffset;
            offset.y = -subView.contentInset.top;
            [subView setContentOffset:offset animated:YES];
        }
        
        // 递归继续查找子控件
        [self searchScrollViewInView:subView];
    }
}

+  (void)show{
    
    window_.hidden = NO;
}
+ (void)hide{
  window_.hidden = YES;
}

@end
