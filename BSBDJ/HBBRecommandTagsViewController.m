//
//  HBBRecommandTagsViewController.m
//  HBBBDBDJ
//
//  Created by HopeBayBridge on 16/1/21.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import "HBBRecommandTagsViewController.h"
#import "HBBRecommandTag.h"
#import "HBBRecommandTagCell.h"
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import <AFNetworking.h>

@interface HBBRecommandTagsViewController ()

/** 标签数据*/
@property (nonatomic,strong) NSArray *tags;

@end

static NSString * const HBBTagID = @"tag";

@implementation HBBRecommandTagsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    self.title = @"推荐标签";
    
    // 注册 cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HBBRecommandTagCell class]) bundle:nil] forCellReuseIdentifier:HBBTagID];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    
    // 发送请求
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"tag_recommend";
    params[@"action"] = @"sub";
    params[@"c"] = @"topic";

    
    
   [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.tags = [HBBRecommandTag mj_objectArrayWithKeyValuesArray:responseObject];
        
        [self.tableView reloadData];
        
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"加载标签数据失败"];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.tags.count;
   
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    HBBRecommandTagCell *cell = [tableView dequeueReusableCellWithIdentifier:HBBTagID];
    
    cell.recommandTag = self.tags[indexPath.row];
    
    return cell;
}



@end
