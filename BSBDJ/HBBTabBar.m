//
//  HBBTabBar.m
//  HBBBDBDJ
//
//  Created by HopeBayBridge on 16/1/16.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import "HBBTabBar.h"

@interface HBBTabBar()
/**
 *  定义发布按钮
 */
@property(nonatomic,weak)UIButton *publishBtn;


@end

@implementation HBBTabBar


- (instancetype)initWithFrame:(CGRect)frame{
    
    if( self = [super initWithFrame:frame]){
        UIButton *publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [publishBtn setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [publishBtn setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
        
        [self addSubview:publishBtn];
        self.publishBtn = publishBtn;

    }
    return  self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    // 设置发布按钮的 frame
    CGSize btnSize =self.publishBtn.currentBackgroundImage.size;
    self.publishBtn.bounds = CGRectMake(0, 0, btnSize.width, btnSize.height);
    self.publishBtn.center = CGPointMake(width * 0.5,  height* 0.5);
    
    // 设置其他 UITabBarButton 的 frame
    CGFloat btnY = 0;
    CGFloat btnW = width / 5;
    CGFloat btnH = height;
    
    NSInteger index = 0;
    for (UIView *btn in self.subviews) {
        if (![btn isKindOfClass:[UIControl class]]  || btn == self.publishBtn) continue;
        
        // 计算按钮的 x 值
        CGFloat btnX = btnW * ((index > 1)? (index + 1):index);
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        
        index++;
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

/**
 layoutSubviews在以下情况下会被调用：
 1、init初始化不会触发layoutSubviews
 2、addSubview会触发layoutSubviews
 3、设置view的Frame会触发layoutSubviews，当然前提是frame的值设置前后发生了变化
 4、滚动一个UIScrollView会触发layoutSubviews
 5、旋转Screen会触发父UIView上的layoutSubviews事件
 6、改变一个UIView大小的时候也会触发父UIView上的layoutSubviews事件
 */
/**
 
 
 1. initWithFrame方法是什么？
 
 initWithFrame方法用来初始化并返回一个新的视图对象,根据指定的CGRect（尺寸）。
 当然，其他UI对象，也有initWithFrame方法，但是，我们以UIView为例，来搞清楚initWithFrame方法。
 
 2.什么时候用initWithFrame方法？
 简单的说，我们用编程方式申明，创建UIView对象时，使用initWithFrame方法。
 在此，我们必须搞清楚，两种方式来进行初始化UIView。
 1.使用 Interface Builder 方式。
 这种方式，就是使用nib文件。通常我们说的“拖控件” 的方式。
 
 实际编程中，我们如果用Interface Builder 方式创建了UIView对象。（也就是，用拖控件的方式）
 那么，initWithFrame方法方法是不会被调用的。因为nib文件已经知道如何初始化该View。（因为，我们在拖该view的时候，就定义好了长、宽、背景等属性）。
 这时候，会调用initWithCoder方法，我们可以用initWithCoder方法来重新定义我们在nib中已经设置的各项属性。
 
 2.使用编程方式。
 就是我们声明一个UIView的子类，进行“手工”编写代码的方式。
 
 实际编程中，我们使用编程方式下，来创建一个UIView或者创建UIView的子类。这时候，将调用initWithFrame方法，来实例化UIView。
 特别注意，如果在子类中重载initWithFrame方法，必须先调用父类的initWithFrame方法。在对自定义的UIView子类进行初始化操作。
 比如：
 - (id)initWithFrame:(CGRect)frame{
 self = [super initWithFrame:frame];// 先调用父类的initWithFrame方法
 if (self) {
 
 // 再自定义该类（UIView子类）的初始化操作。
 _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
 [_scrollView setFrame:CGRectMake(0, 0, 320, 480)];
 _scrollView.contentSize = CGSizeMake(320*3, 480);
 
 [self addSubview:_scrollView];
 }
 return self;
 }
 
 在这里，我想，应该对initWithFrame方法略知一二了。
 
 那么，用Interface Builder 方式创建的nib文件是什么？
 
 
 对于应用程序，资源是一种数据文件，伴随可程序执行程序的一种数据文件。（可以理解为可执行程序的，一种不可缺少的组陈部分）。
 资源文件，是一种可移动的，由适合的工具编写的一种特殊的代码。
 如：plish文件，txt文件，图像，视频等文件。都可以被xCode识别和引用。
 
 一个应用程序可以包含多种形式的资源文件。
 
 当然，nib文件也不例外，仅仅是一种资源文件。
 通过Interface Builder 方式，可以创建nib文件，存储应用程序的UI对象。供应用程序来读取。

 */


