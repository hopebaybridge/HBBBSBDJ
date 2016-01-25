//
//  HBBPushGuideView.m
//  HBBBDBDJ
//
//  Created by HopeBayBridge on 16/1/22.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import "HBBPushGuideView.h"

@implementation HBBPushGuideView




+ (void)show{
    
    NSString *key = @"CFBundleShortVersionString";
    
    // 获取当前的软件版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    // 获得沙盒中存储的版本号
    NSString *sandBoxVersion = [[NSUserDefaults standardUserDefaults] stringForKey:key];
    
    if ( ![currentVersion isEqualToString:sandBoxVersion]) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
        HBBPushGuideView *guideView = [HBBPushGuideView guideView];
        
        guideView.frame = window.bounds;
        
        [window addSubview:guideView];
        
        //存储版本号
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
        // 即时同步
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}

+ (instancetype)guideView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    
}



/**
 *  点击我知道了 去掉蒙版推送
 */
- (IBAction)close {
    
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
