//
//  HBBMeViewController.m
//  HBBBDBDJ
//
//  Created by HopeBayBridge on 16/1/16.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import "HBBMeViewController.h"

@interface HBBMeViewController ()

@end

@implementation HBBMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 设置导航栏内容
    // 设置标题
    self.navigationItem.title = @"我的";
    
    
    // 设置右边按钮
    UIBarButtonItem *settingItem = [UIBarButtonItem itemWithImage:@"mine-setting-icon" highImage:@"mine-setting-icon-click" target:self action:@selector(settingClick)];
    UIBarButtonItem *moonItem = [UIBarButtonItem itemWithImage:@"mine-moon-icon" highImage:@"mine-moon-icon-click" target:self action:@selector(moonClick)];
    // 设置右边按钮以右为开始点
    self.navigationItem.rightBarButtonItems = @[settingItem,moonItem];
    
    // 在 pch 文件中统一设置整站的背景颜色
    self.view.backgroundColor = HBBGlobalBG;

}

- (void)settingClick{
    HBBFunc;
}

- (void)moonClick{
    HBBFunc;
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
