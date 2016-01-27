//
//  HBBTopicPictureView.m
//  BSBDJ
//
//  Created by HopeBayBridge on 16/1/26.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import "HBBTopicPictureView.h"
#import "HBBTopic.h"
#import <UIImageView+WebCache.h>
#import "HBBProgressView.h"
#import "HBBShowPictureViewController.h"

@interface HBBTopicPictureView()
/** 图片*/
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
/**gif标识*/
@property (weak, nonatomic) IBOutlet UIImageView *gifView;

/**点击大图按钮*/
@property (weak, nonatomic) IBOutlet UIButton *seeBigButton;
/** 进度条的控件*/
@property (weak, nonatomic) IBOutlet HBBProgressView *progressView;

@end

@implementation HBBTopicPictureView

+ (instancetype)pictureView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

/**
 *  去掉 xib 图片的默认伸缩  防止图片过大对自定义宽度 的影响
 */
- (void)awakeFromNib{
    self.autoresizingMask = UIViewAutoresizingNone;
    
    
    // 给图片添加监听器 (显示大图)
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicture)]];
}

/**
 *  点击图片 和 按钮显示 独立图片内容  (保存,转发)
 */
-(IBAction)showPicture{
    HBBShowPictureViewController *showPictureVC = [[HBBShowPictureViewController alloc] init];
    showPictureVC.topic = self.topic;
    // modal 模式显示窗口
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:showPictureVC animated:YES completion:nil];
}

- (void)setTopic:(HBBTopic *)topic{
    
    _topic = topic;
    
    // 立马显示最新的进度值
    [self.progressView setProgress:topic.pictureProgress animated:NO];
    
    // 设置图片
    //[self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.large_image]];
    // 网络慢的时候显示进度条
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.large_image] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        self.progressView.hidden = NO;
        topic.pictureProgress  = 1.0 * receivedSize / expectedSize;
        [self.progressView setProgress:(topic.pictureProgress) animated:YES];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.progressView.hidden = YES;
        
        // 不是大图不需要进行绘图处理
        if(topic.isBigPicture != YES) return ;
        
        // 开启图形上下文
        UIGraphicsBeginImageContextWithOptions(topic.pictureViewFrame.size, YES, 0.0);
        // 将下载完毕的 image 对象绘制到图形上下文
        CGFloat width = topic.pictureViewFrame.size.width;
        CGFloat height = width *image.size.height / image.size.width;
        [image drawInRect:CGRectMake(0, 0, width, height)];
        
        // 获得图片
        self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        
        // 结束图形上下文
        UIGraphicsEndImageContext();
        
    }];
    
    
    // 判断是否为 gif
    NSString *extension = topic.large_image.pathExtension;
    self.gifView.hidden = ![extension.lowercaseString isEqualToString:@"gif"];
    
   // [self.gifView bringSubviewToFront:self.imageView];
    [self.imageView addSubview:self.gifView];
    [self.imageView addSubview:self.seeBigButton];
    
    // 判断是否显示点击大图
    if (topic.isBigPicture) {
        self.seeBigButton.hidden = NO;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    } else {
        self.seeBigButton.hidden = YES;
        self.imageView.contentMode = UIViewContentModeScaleToFill;

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
