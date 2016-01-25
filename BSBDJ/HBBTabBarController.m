//
//  HBBTabBarController.m
//  HBBBDBDJ
//
//  Created by HopeBayBridge on 16/1/16.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import "HBBTabBarController.h"
#import "HBBEssenceViewController.h"
#import "HBBNewViewController.h"
#import "HBBFriendTrendsViewController.h"
#import "HBBMeViewController.h"
#import "HBBTabBar.h"
#import "HBBNavigationController.h"


@interface HBBTabBarController ()

@end

@implementation HBBTabBarController

+ (void)initialize{
    // 添加子控制器
    
    // 设置字体不被渲染的样式
    // - (void)setTitleTextAttributes:(nullable NSDictionary<NSString *,id> *)attributes forState:(UIControlState)state NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;   方法中包含UI_APPEARANCE_SELECTOR 都可以
    // 统一设置 UItabBarItem的文字属性
    
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    attrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    
    UITabBarItem *item = [UITabBarItem appearance];
    // 默认显示
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    // 选中显示
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    
 
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加精华帖
    [self setupChildViewController:[[HBBEssenceViewController alloc] init] title:@"精华" image:@"tabBar_essence_icon" selectedImage:@"tabBar_essence_click_icon"];

    // 添加新帖
    [self setupChildViewController:[[HBBNewViewController alloc] init] title:@"新帖" image:@"tabBar_new_icon" selectedImage:@"tabBar_new_click_icon"];

    // 添加 关注
    [self setupChildViewController:[[HBBFriendTrendsViewController alloc] init] title:@"关注" image:@"tabBar_friendTrends_icon" selectedImage:@"tabBar_friendTrends_click_icon"];

    // 添加 我
    [self setupChildViewController:[[HBBMeViewController alloc] init] title:@"我" image:@"tabBar_me_icon" selectedImage:@"tabBar_me_click_icon"];
    
   //  tabbar 只读 无法直接赋值  可以通过 kvc 赋值
   // self.tabBar = [[HBBTabBar alloc] init];  Assignment to readonly property;
   
    [self setValue:[[HBBTabBar alloc] init] forKeyPath :@"tabBar"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 *  初始化子控制器
 *
 *  @param title         title description 标题
 *  @param image         <#image description#> 默认图片
 *  @param selectedImage <#selectedImage description#> 选中图片
 */
- (void)setupChildViewController:(UIViewController *)vc  title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage{
    
    
    //vc.navigationItem.title = title;
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:image];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    
    //设置随机背景颜色  不宜在此处用
    //vc.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(100)/100.0 green:arc4random_uniform(100)/100.0 blue:arc4random_uniform(100)/100.0 alpha:1.0];
    
    // 包装一个导航可控制器,添加导航控制器为 tabbarcontroller的子控制器
    HBBNavigationController *nav = [[HBBNavigationController alloc] initWithRootViewController:vc];
    
    // 添加子控制器
    [self addChildViewController:nav];
    

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
