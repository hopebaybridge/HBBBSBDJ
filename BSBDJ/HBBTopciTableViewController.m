
//
//  HBBWordTableViewController.m
//  HBBBDBDJ
//
//  Created by HopeBayBridge on 16/1/23.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

// option + command ⬅️ / →     代码模块的折叠/展开
#import "HBBTopciTableViewController.h"
#import "HBBTopic.h"
#import "HBBTopicCell.h"
#import "HBBCommentViewController.h"
#import <AFNetworking.h>
#import <UIImageView+WebCache.h>
#import <MJExtension.h>
#import <MJRefresh.h>
#import "HBBNewViewController.h"

static NSString *const HBBTopicIdentifier = @"topic";

@interface HBBTopciTableViewController ()

/** 存储帖子*/
@property (nonatomic,strong) NSMutableArray  *topics;

/** 当前页码*/
@property (nonatomic,assign) NSInteger  currentPage;

/** 当加载下一页时需要传入上一次返回的这个参数*/
@property (nonatomic,copy) NSString  *maxtime;

/** 记录请求参数   与返回的作对比*/
@property (nonatomic,strong) NSDictionary  *params;

/**上次选中的索引 (或者控制器) */
@property (nonatomic,assign) NSInteger lastSelectedIndex;

@end

@implementation HBBTopciTableViewController

- (NSMutableArray *)topics{
    if (!_topics) {
        _topics = [NSMutableArray array];
    }
    
    return _topics;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // 初始化表格
    [self setupTableView];
    
    // 添加下拉刷新数据控件
    [self setupRefresh];
    
    
}
/**
 *  初始化表格
 */
- (void)setupTableView{
    // 设置内边距
    CGFloat bottom =self.tabBarController.tabBar.height;
    
    // pch  hbbconst.h
    CGFloat top = HBBTitlesViewY + HBBTitlesViewH;
    // ⬆️ ⬅️ ⬇️ →
    self.tableView.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
    // 设置滚动条的内边距  拒绝穿透的遮挡效果
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    
    // 去掉分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 去掉 cell 背景色
    self.tableView.backgroundColor = [UIColor clearColor];
    
    
    // 注册topicecellnib
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HBBTopicCell class]) bundle:nil] forCellReuseIdentifier:HBBTopicIdentifier];
    
    
    //监听 tabBar点击的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarSelect) name:HBBTabBarDidSelectNotificatioin object:nil];
    
}

- (void)tabBarSelect{
    
    // 如果精华被连续点击两次直接刷新   选中的在视觉主窗口  选中的是导航控制器
    if(self.lastSelectedIndex == self.tabBarController.selectedIndex
       && self.tabBarController.selectedViewController == self.navigationController
       && self.view.isShowingOnKeyWindow){
        
        [self.tableView.mj_header beginRefreshing];
        
         HBBFunc;
        
    }
    
   
    
    // 记录这一次选中的索引
    self.lastSelectedIndex = self.tabBarController.selectedIndex;
    
}



/**
 *  添加下拉刷新数据控件 (配置的图片 和 文字   在 MJRereshConst.m    Resources/MJRefresh.bundle
 */
- (void)setupRefresh{
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    // 自动改变下拉控件的透明度,从而改变下拉回缩带来的穿透视觉影像(不设置会有穿透文字重叠)
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 默认刷新
    [self.tableView.mj_header beginRefreshing];
    
    // 加载更多数据  上拉
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
    
    
}

/**
 *  param  a 参数处理    精华和新帖只有这个参数不同
 *
 *  @return <#return value description#>
 */

- (NSString *)a{
    
    return  [self.parentViewController isKindOfClass:[HBBNewViewController class]] ? @"newlist":@"list";
}


/**
 *  加载更多数据  上拉
 */
- (void)loadMoreTopics{
    
    
    // 进行上拉操作时 结束下拉
    [self.tableView.mj_header endRefreshing];
    
    self.currentPage++;
    // 参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = self.a;
    params[@"c"] = @"data";
    params[@"type"] = @(self.type);
    params[@"page"] = @(self.currentPage);
    params[@"maxtime"] = self.maxtime;
    self.params = params;
    
    
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
//        HBBLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask *  task, id  responseObject) {
        
        // 网络请求迟缓  请求会一直执行  网络请求时的 params  与记录的 params不同
        if(self.params != params) return ;
        
        // 存储 maxtime  用于访问下一页使用
        self.maxtime = responseObject[@"info"][@"maxtime"];
    
        // 转换数据模型  添加新的数据
        NSArray *newTopics = [HBBTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [self.topics addObjectsFromArray:newTopics];
        
        [self.tableView reloadData];
        
        // [responseObject writeToFile:@"/Users/sunqiaojin/Desktop/duanzi.plist" atomically:YES];
        // 结束数据的刷新
        [self.tableView.mj_footer endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 结束数据的刷新
        [self.tableView.mj_footer endRefreshing];
        // 加载失败恢复页码
        self.currentPage--;
    }];
}

/**
 *  加载新的帖子的数据
 */
- (void)loadNewTopics{
    
    // 进行下拉操作的时候,结束上拉操作
    [self.tableView.mj_footer endRefreshing];
    
    // 参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = self.a;
    params[@"c"] = @"data";
    params[@"type"] = @(self.type);
    self.params = params;
    
    
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
//        HBBLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//       HBBLog(@"%@",responseObject);
        
        // 网络请求迟缓  请求会一直执行  网络请求时的 params  与记录的 params不同
        if(self.params != params) return ;
        
        
        // 存储 maxtime  用于访问下一页使用
        self.maxtime = responseObject[@"info"][@"maxtime"];
        
        // 转换数据模型
        self.topics = [HBBTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [self.tableView reloadData];
        
        
        
        // [responseObject writeToFile:@"/Users/sunqiaojin/Desktop/duanzi.plist" atomically:YES];
        // 结束数据的刷新
        [self.tableView.mj_header endRefreshing];
        
        // 防止加载失败
        self.currentPage = 0;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 结束数据的刷新
        [self.tableView.mj_header endRefreshing];
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
    
    self.tableView.mj_footer.hidden = (self.topics.count == 0);
    return self.topics.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    HBBTopicCell *cell = [tableView dequeueReusableCellWithIdentifier: HBBTopicIdentifier];
    
    cell.topic = self.topics[indexPath.row];
    
    //HBBTopic *topic = self.topics[indexPath.row];
    
    //    cell.textLabel.text = topic.name;
    //    cell.detailTextLabel.text = topic.text;
    //    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:topic.profile_image] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    return cell;
}

#pragma mark - 代理方法
/**
 *  改变 cell 高度
 *
 *  @param tableView <#tableView description#>
 *  @param indexPath <#indexPath description#>
 *
 *  @return <#return value description#>
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 取出帖子模型
    HBBTopic *topic = self.topics[indexPath.row];
    

    
    // cell 高度封装到模型( cellheight)
    return topic.cellHeight;
}

/**
 *  选中指定 cell 发生的事件
 *
 *  @param tableView <#tableView description#>
 *  @param indexPath <#indexPath description#>
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HBBCommentViewController *commentVC = [[HBBCommentViewController alloc] init];
    
    commentVC.topic = self.topics[indexPath.row];
    [self.navigationController pushViewController:commentVC animated:YES];
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
