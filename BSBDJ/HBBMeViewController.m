//
//  HBBMeViewController.m
//  HBBBDBDJ
//
//  Created by HopeBayBridge on 16/1/16.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import "HBBMeViewController.h"
#import "HBBMeCell.h"
#import "HBBMeFooterView.h"

@interface HBBMeViewController ()

@end

@implementation HBBMeViewController

static NSString *HBBMeID = @"me";

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
    
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[HBBMeCell class] forCellReuseIdentifier:HBBMeID];
    
     // 调整 header 和 footer
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = HBBTopicCellMargin;
    
    // 调整 inset
    self.tableView.contentInset = UIEdgeInsetsMake(HBBTopicCellMargin - 35, 0, 0, 0);
    
    // 设置 footerView
    self.tableView.tableFooterView = [[HBBMeFooterView alloc] init];

}

- (void)settingClick{
//    HBBFunc;
}

- (void)moonClick{
//    HBBFunc;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 数据源代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HBBMeCell *cell = [tableView dequeueReusableCellWithIdentifier:HBBMeID];
    
    if (indexPath.section == 0) {
        cell.imageView.image = [UIImage imageNamed:@"mine-icon-nearby"];
        cell.textLabel.text = @"登录/注册";
    } else  if(indexPath.section == 1){
        cell.textLabel.text = @"离线下载";
    }
    
    return cell;
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
