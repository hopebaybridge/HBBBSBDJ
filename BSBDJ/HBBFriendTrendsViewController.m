//
//  HBBFriendTrendsViewController.m
//  HBBBDBDJ
//
//  Created by HopeBayBridge on 16/1/16.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import "HBBFriendTrendsViewController.h"
#import "HBBRecommandViewController.h"
#import "HBBLoginRegisterViewController.h"


@interface HBBFriendTrendsViewController ()

@end

@implementation HBBFriendTrendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 设置导航栏内容
    // 设置标题
    self.navigationItem.title = @"我的关注";
    
    // 设置左边按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"friendsRecommentIcon" highImage:@"friendsRecommentIcon-click" target:self action:@selector(friendsClick)];
    
    // 在 pch 文件中统一设置整站的背景颜色
    self.view.backgroundColor = HBBGlobalBG;

    
}
/**
 *  推荐关注
 */
- (void)friendsClick{
    
    
    HBBRecommandViewController  *recommandVC = [[HBBRecommandViewController alloc] init];
    
    [self.navigationController pushViewController:recommandVC animated:YES];
    
}


/**
 *  点击登录注册产生的事件  (关注)  默认加载与控制器同名的 xib
 *
 *  @param sender <#sender description#>
 */
- (IBAction)loginRegister:(UIButton *)sender {
    
    HBBLoginRegisterViewController *loginRegisterVC = [[HBBLoginRegisterViewController alloc] init];
    
    [self presentViewController:loginRegisterVC animated:YES completion:nil];
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
