//
//  HBBPublishViewController.m
//  BSBDJ
//
//  Created by HopeBayBridge on 16/1/27.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import "HBBPublishViewController.h"
#import "HBBVerticalButton.h"
#import <POP.h>

// 动画延迟间隔时间
static CGFloat const HBBAnimationDeLay = 0.1;
// 动画运动辅助趋势
static CGFloat const HBBSpringFactor = 10;


@interface HBBPublishViewController ()

///**动态文字*/
//@property(nonatomic,strong) UIImageView *sloganView;

@end

@implementation HBBPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 让控制器的 view 不能被点击
    self.view.userInteractionEnabled = NO;
 
//    self.sloganView = sloganView;
    
    // 数据
    NSArray *images = @[@"publish-video", @"publish-picture", @"publish-text", @"publish-audio", @"publish-review", @"publish-offline"];
    NSArray *titles = @[@"发视频", @"发图片", @"发段子", @"发声音", @"审帖", @"离线下载"];
    
    
    // 中间的6个按钮
    int maxCols = 3;
    CGFloat btnWidth = 72;
    CGFloat btnHeight = btnWidth + 30;
    CGFloat btnStartY = (HBBScreenHeight - 2 *btnHeight) * 0.5;
    CGFloat btnStartX = 20;
    // 按钮之间的间距
    CGFloat xMarginSpace = (HBBScreenWidth -2 *btnStartX - maxCols * btnWidth) / (maxCols - 1);
    for (int i = 0 ; i < images.count; i++) {
        HBBVerticalButton *btn = [[HBBVerticalButton alloc] init];
        // 设置按钮标识
        btn.tag = i;
        // 添加按钮点击事件
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        // 设置内容
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        
        
        // 设置 frame
        btn.width = btnWidth;
        btn.height = btnHeight;
        int row = i / maxCols;
        int col = i % maxCols;
        
        CGFloat   btnX = btnStartX + col * (xMarginSpace + btnWidth);
        CGFloat btnEndY = btnStartY + row * btnHeight;
        CGFloat btnBeginY =  btnEndY - HBBScreenHeight;
        
        [self.view addSubview:btn];
        
        // 按钮的动画
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        anim.fromValue = [NSValue valueWithCGRect:CGRectMake(btnX, btnBeginY, btnWidth, btnHeight)];
        anim.toValue = [NSValue valueWithCGRect:CGRectMake(btnX, btnEndY, btnWidth, btnHeight)];
        anim.springSpeed = HBBSpringFactor;
        anim.springBounciness = HBBSpringFactor;
        anim.beginTime = CACurrentMediaTime() + HBBAnimationDeLay * i;
        [btn pop_addAnimation:anim forKey:nil];
    }
    
    
    // 添加标语
    UIImageView *sloganView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_slogan"]];
    [self.view addSubview:sloganView];
    
    
    // 标语动画
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    CGFloat centerX = HBBScreenWidth * 0.5;
    CGFloat centerEndY= HBBScreenHeight * 0.2;
    CGFloat centerBeginY = centerEndY - HBBScreenHeight;
    anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(centerX, centerBeginY)];
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(centerX, centerEndY)];
    anim.springSpeed = HBBSpringFactor;
    anim.springBounciness = HBBSpringFactor;
    anim.beginTime = CACurrentMediaTime() + images.count * HBBAnimationDeLay;
    
    [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
       //标语动画结束   恢复点击事件
        self.view.userInteractionEnabled = YES;
    }];

    [sloganView pop_addAnimation:anim forKey:nil];
    
}
/**
 *  点击按钮发生的事件(先关闭这个控制器窗口,在执行相应的操作
 *
 *  @param btn <#btn description#>
 */
- (void) btnClick:(UIButton *)btn{
    [ self cancelWithCompletionBlock:^{
        if (btn.tag == 0) {
            HBBLog(@"发视频");
        }else if (btn.tag == 1){
            HBBLog(@"发图片");
        }
    }];
}


/**
 *  点击取消按钮 不需要执行方法
 */
- (IBAction)cancel{
    
//    [self dismissViewControllerAnimated:NO completion:nil];
    
    [self cancelWithCompletionBlock:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self cancelWithCompletionBlock:nil];
    
    
//    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
//    anim.beginTime = CACurrentMediaTime() + 1.0;
//    anim.springSpeed = 10;
//    anim.springBounciness = 30;
//    anim.fromValue = @(0.0);   //@(self.sloganView.layer.position.y);
//    anim.toValue = @(HBBScreenHeight * 0.2);
//    anim.completionBlock = ^(POPAnimation *anim,BOOL finished){
//        HBBLog(@"动画结束");
//    };
//    
//    [self.sloganView.layer pop_addAnimation:anim forKey:nil];
//    
}

/**
 *  先执行退出动画,动画完毕后执行 completionBlock
 *
 *  @param completionBlock <#completionBlock description#>
 */
- (void)cancelWithCompletionBlock:(void (^)())completionBlock{
    // 让控制器的 view 不能被点击
    self.view.userInteractionEnabled = NO;
    // 背景图片 imageview 的 i  0   cancelbtn 1  按钮和标题是后边动态加载的 i 是  2
    int beginIndex = 2;
    for (int i = 2; i < self.view.subviews.count; i++) {
        UIView *subView = self.view.subviews[i];
        
        // 基本动画
        POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
        CGFloat centerY = subView.centerY + HBBScreenHeight;
        // 动画执行的节奏 (一开始很慢,后面很快)
      //  anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        
        // anim.fromValue  默认的是图像的原来的位置
        anim.toValue = [NSValue valueWithCGPoint:CGPointMake(subView.centerX, centerY)];
        anim.beginTime = CACurrentMediaTime() + (i - beginIndex ) * HBBAnimationDeLay * 0.1;
        
        [subView pop_addAnimation:anim forKey:nil];
        
        // 监听最后一个动画
        if(i == self.view.subviews.count -1){
            [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
                [self dismissViewControllerAnimated:NO completion:nil];
                
                // 执行进来的 completionBlock 参数   加入有模块方法  则在控制器关闭后 执行
//                if (completionBlock) {
//                    completionBlock();
//                }
                
                !completionBlock ? : completionBlock();
                
            }];
        }
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
