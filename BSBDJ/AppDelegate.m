//
//  AppDelegate.m
//  HBBBDBDJ
//
//  Created by HopeBayBridge on 16/1/16.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import "AppDelegate.h"
#import "HBBTabBarController.h"
#import "HBBPushGuideView.h"
#import "HBBScolledTopWindow.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // 创建窗口
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    
    // 设置窗口根控制器
    
    HBBTabBarController *tabBarController = [[HBBTabBarController alloc] init];
    
    
    self.window.rootViewController = tabBarController;
    
        // 显示窗口
    [self.window makeKeyAndVisible];
    
    
    // 显示推送引导
    [HBBPushGuideView show];
    
//        [HBBScolledTopWindow show];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}
/**
 *  在AppDelegate创建一个新的窗口必须给这个窗口设置一个根控制器,否则会报错,这里可以通过dispatch_after来给添加窗口一个延时就可以不设置根控制器
 *窗口是有级别的windowLevel,级别越高就越显示在顶部,如果级别一样,那么后添加的创建显示在顶部.级别分为三种,UIWindowLevelAlert > UIWindowLevelStatusBar
 *> UIWindowLevelNormal,接下来创建一个创建并且添加一个监控
 *
 *  @param application <#application description#>
 */
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        [HBBScolledTopWindow show];
    });

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
