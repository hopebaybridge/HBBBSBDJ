
//
//  HBBLoginTool.m
//  BSBDJ
//
//  Created by HopeBayBridge on 16/2/11.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import "HBBLoginTool.h"
#import "HBBLoginRegisterViewController.h"

@implementation HBBLoginTool

- (void)setUid:(NSString *)uid{
    [[NSUserDefaults standardUserDefaults] setObject:uid forKey:@"uid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 *  获得当前登录用户的 uid  检测是否登录   NSString *: 已经登录    nil  没有登录
 *
 *  @return <#return value description#>
 */
+(NSString *)getUid{
    return [self getUid:NO];
}
+(NSString *)getUid:(BOOL)showLoginController{
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] stringForKey:@"uid"];
    
    if (showLoginController) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            HBBLoginRegisterViewController *loginVC = [[HBBLoginRegisterViewController alloc] init];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:loginVC animated:YES completion:nil];
        });
    }
    
    return uid;
    
}

@end
