//
//  HBBShowPictureViewController.m
//  BSBDJ
//
//  Created by HopeBayBridge on 16/1/27.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import "HBBShowPictureViewController.h"
#import "HBBProgressView.h"
#import "HBBTopic.h"
#import <SVProgressHUD.h>
#import <UIImageView+WebCache.h>

@interface HBBShowPictureViewController ()
/**进度条*/
@property (weak, nonatomic) IBOutlet HBBProgressView *progressView;
/** 图片滚动范围 */
@property (weak, nonatomic) IBOutlet UIScrollView *scollView;

/** 图片显示位置*/
@property (nonatomic,weak)  UIImageView *imageView;


@end

@implementation HBBShowPictureViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // 屏幕的尺寸
    CGFloat screenHeigh = [UIScreen mainScreen].bounds.size.height;
    CGFloat screeWidth = [UIScreen mainScreen].bounds.size.width;
    
    // 添加图片
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.userInteractionEnabled = YES;
    // 注册图片的点击事件 点击图片返回
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)]];
    [self.scollView addSubview:imageView];
    self.imageView = imageView;
    
    // 图片的尺寸
    CGFloat picWidth = screeWidth;
    CGFloat picHeight = picWidth * self.topic.height / self.topic.width;
    // 如果图片的高度大于一个屏幕的高度 需要滚动查看
    if (picHeight > screenHeigh) {
        imageView.frame = CGRectMake(0, 0, picWidth, picHeight);
        self.scollView.contentSize = CGSizeMake(0, picHeight);
    } else {
        imageView.size = CGSizeMake(picWidth, picHeight);
        imageView.centerY = screenHeigh * 0.5;
    }
    
    // 显示图片的下载进度
    [self.progressView setProgress:self.topic.pictureProgress animated:YES];
    
    // 下载图片   (第三方插件会根据nsurl 最为 key 判断图片的下砸 不会重复下载)
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.topic.large_image] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        [self.progressView setProgress:1.0 * receivedSize /expectedSize animated:YES];
        self.progressView.hidden = NO;

    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.progressView.hidden = YES;
    }];
}

/**
 * 点击返回发生的事件
 *
 *  @param sender <#sender description#>
 */
- (IBAction)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  保存图片到相册
 *
 *  @param sender <#sender description#>
 */
- (IBAction)save{
    
    if (self.imageView.image == nil) {
        [SVProgressHUD showErrorWithStatus:@"图片没有下载完毕!"];
        return;
    }
    
    // 将图片写入相册 (图片写入必须接受错误提示值 ,否则崩溃)
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}


-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"保存失败"];
    }else{
        [SVProgressHUD showErrorWithStatus:@"保存成功"];
    }
}

/**
 *  转发图片  (需要登录 暂时不做)
 *
 *  @param sender <#sender description#>
 */
- (IBAction)repost {
    
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
