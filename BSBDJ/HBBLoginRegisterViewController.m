//
//  HBBLoginRegisterViewController.m
//  HBBBDBDJ
//
//  Created by HopeBayBridge on 16/1/22.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import "HBBLoginRegisterViewController.h"

@interface HBBLoginRegisterViewController ()

/** 登录界面左边的约束线  */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginLeftConstraintMarign;

/**注册页面*/
@property (weak, nonatomic) IBOutlet UIView *registerView;

@end

@implementation HBBLoginRegisterViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.registerView.hidden = YES;
}

/**
 *  登录注册切换按钮
 *
 *  @param sender <#sender description#>
 */
- (IBAction)loginRegisterChange:(UIButton *)btn {
    
    // 退出键盘
    
    [self.view endEditing:YES];
    
    if (self.loginLeftConstraintMarign.constant == 0) {

        self.registerView.hidden = NO;
        self.loginLeftConstraintMarign.constant =  -self.view.width;
        [btn setTitle:@"已有账号" forState: UIControlStateNormal];
    } else {
        
        self.loginLeftConstraintMarign.constant = 0;
        self.registerView.hidden = YES;
        [btn setTitle:@"注册账号" forState: UIControlStateNormal];

    }
    
    
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
    
}

/**
 *  退出登录注册页面的按钮
 */
- (IBAction)back {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  让当前控制器对应的状态栏是白色
 *
 *  @return <#return value description#>
 */

- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
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
