//
//  HBBRecommandViewController.m
//  HBBBDBDJ
//
//  Created by HopeBayBridge on 16/1/17.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import "HBBRecommandViewController.h"
#import "HBBRecommandCategoryCell.h"
#import "HBBRecommandUserTableViewCell.h"
#import "HBBRecommandCategory.h"
#import "HBBRecommandUser.h"

#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import <MJExtension.h>
#import <MJRefresh.h>


#define HBBSelectedCategory self.categories[self.categoryTableView.indexPathForSelectedRow.row];


@interface HBBRecommandViewController () <UITableViewDataSource,UITableViewDelegate>
/** 左边类别数据*/
@property (nonatomic,strong)NSArray  *categories;
///** 右边用户数据*/
//@property (nonatomic,strong)NSArray  *users;

/** 左边的类别表格*/
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;
/** 右边表格的详情信息*/
@property (weak, nonatomic) IBOutlet UITableView *recommandUserTableView;

/** 存储请求参数    防止网速慢,多次请求进行判断 */
@property (nonatomic,strong) NSMutableDictionary  *params;

/** AFN 请求管理者*/
@property (nonatomic,strong) AFHTTPSessionManager  *manager;



@end

@implementation HBBRecommandViewController

static NSString *const HBBCategoryID = @"category";

static NSString *const HBBUserID = @"user";

- (AFHTTPSessionManager *)manager{
    if(!_manager){
        _manager = [AFHTTPSessionManager manager];
    }
    
    return _manager;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 初始化数据
    [self setupTableView];
    
    
    // 添加刷新控件
    [self  setupRefresh];
    
    
    // 显示指示器
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    
    
    // 发送请求
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"category";
    params[@"c"] = @"subscribe";
    
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        HBBLog(@"%@",downloadProgress);
    }  success:^(NSURLSessionDataTask *task, id  responseObject) {
        
        // 隐藏指示器
        [SVProgressHUD dismiss];
        
        // 服务器返回的 json 数据
//        self.categories = responseObject[@"list"];
//        HBBLog(@"%@",responseObject[@"list"]);
        // 利用 MJExtension.h  自动转换数据模型   pod  文件里有
        self.categories = [HBBRecommandCategory mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        HBBLog(@"%@",responseObject);

        // 请求后需要刷新表格,否则没有数据
        [self.categoryTableView reloadData];
        
        // 取消滚动条
        self.categoryTableView.showsVerticalScrollIndicator = NO;
        
        // 默认选中第一行
        [self.categoryTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        
        // 让用户表格进入下拉刷新状态  显示第一行数据   自动调用  loadNewUsers 方法
        [self.recommandUserTableView.mj_header beginRefreshing];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // 显示指示器加载失败的信息
        [SVProgressHUD showErrorWithStatus:@"数据加载失败,请刷新!"];
    }];
}


/**
 *  初始化数据
 */
- (void)setupTableView{
    //注册
    [self.categoryTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HBBRecommandCategoryCell class]) bundle:nil] forCellReuseIdentifier:HBBCategoryID];
    
    [self.recommandUserTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HBBRecommandUserTableViewCell class]) bundle:nil] forCellReuseIdentifier:HBBUserID];
    
    // 设置 inset  距离导航栏的距离
    self.automaticallyAdjustsScrollViewInsets = NO;  // 去掉系统的自动调整
    self.categoryTableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.recommandUserTableView.contentInset = self.categoryTableView.contentInset;
    self.recommandUserTableView.rowHeight = 70;
    
    
    
    // 设置标题
    self.title = @"推荐关注";
    // 设置背景颜色
    self.view.backgroundColor = HBBGlobalBG;
    
}

/**
 *  添加刷新控件
 */
- (void)setupRefresh{
    
    // 加载最新数据   下拉
    self.recommandUserTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewUsers)];
    
    //  tableview 上拉滚动时产生新的数据效果  back (回弹)
    self.recommandUserTableView.mj_footer = [MJRefreshBackNormalFooter  footerWithRefreshingTarget:self refreshingAction:@selector(loadmoreUsers)];
    self.recommandUserTableView.mj_footer.hidden = YES;
}


# pragma mark - 加载用户数据


- (void)loadNewUsers{
    
    HBBFunc;
    
    HBBRecommandCategory *category = HBBSelectedCategory;

    
    
    category.currentPage = 1;
    // 发送请求给服务器,获取右侧的详情数据
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"subscribe";
    params[@"category_id"] = @(category.id);
    params[@"page"] = @(category.currentPage);
    self.params = params;
    
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HBBLog(@"%@",responseObject);
        
        // 字典数组  --> 模型数组
        NSArray  *users = [HBBRecommandUser mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        
        // 删除所有旧数据
        [category.users removeAllObjects];
        
        // 添加到当前类别对应的用户数组里
        [category.users addObjectsFromArray:users];
        
        //存放信息的总数
        category.total = [responseObject[@"total"] integerValue];
        
        if (self.params != params) return ;

        
        // 刷新表格
        [self.recommandUserTableView reloadData];
        
        
        
        // 时刻检测 footer的状态
        [self checkFooterState];
        
        HBBLog(@"@%ld",category.users.count);
        HBBLog(@"@%ld",category.total);
        
        [self.recommandUserTableView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (self.params != params) return ;

        HBBLog(@"刷新数据.....");
    }];
    
}


- (void)loadmoreUsers{
    
    HBBRecommandCategory *category = HBBSelectedCategory;
    
    // 发送请求给服务器,获取右侧的详情数据
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"subscribe";
    params[@"category_id"] = @(category.id);
    params[@"page"] =  @(++category.currentPage);
    self.params = params;
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HBBLog(@"%@",responseObject);
        // 字典数组  --> 模型数组
        NSArray  *users = [HBBRecommandUser mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        // 添加到当前类别对应的用户数组里
        [category.users addObjectsFromArray:users];
        
        
        // 不是最后一次请求
        if (self.params != params) return ;
        // 刷新表格
        [self.recommandUserTableView reloadData];
        
        // 时刻检测 footer的状态
        [self checkFooterState];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 不是最后一次请求
        if (self.params != params) return ;
        
        [SVProgressHUD showErrorWithStatus: @"加载数据失败"];
        
        
        
        [self.recommandUserTableView.mj_footer endRefreshing];
        
        HBBLog(@"刷新数据.....");
    }];
}
/**
 *  时刻检测 footer的状态
 */
-(void)checkFooterState{
    
    HBBRecommandCategory *category = HBBSelectedCategory;
    
    // 每次刷新右边数据时,都控制 footer的显示或者隐藏
    self.recommandUserTableView.mj_footer.hidden = (category.users.count == 0);

    if (category.users.count == category.total) {
        // 没有数据了
        [self.recommandUserTableView.mj_footer  endRefreshingWithNoMoreData];
    }else{
        //等待下次刷新
        [self.recommandUserTableView.mj_footer endRefreshing];
    }
}

#pragma mark  - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.categoryTableView) {  // 左边栏
        return  self.categories.count;

    }else{ // 右边栏的数据是选择的指定左边栏类别数据的包含类
        HBBRecommandCategory *category = HBBSelectedCategory;
        
        // 时刻检测 footer的状态
        [self checkFooterState];
        
        
        return category.users.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.categoryTableView) {  // 左边的类别表格
        HBBRecommandCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:HBBCategoryID];
        
        cell.category = self.categories[indexPath.row];
        
        return  cell;
    }else{// 右边的用户表格  右边栏的数据是选择的指定左边栏类别数据的包含类
        HBBRecommandUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HBBUserID];
        HBBRecommandCategory *category = HBBSelectedCategory;

        cell.user = category.users[indexPath.row];
        
        return cell;
    }
}


#pragma mark - <UITableViewDelegate>
/**
 *  选中指定行发生的事件
 *
 *  @param tableView <#tableView description#>
 *  @param indexPath <#indexPath description#>
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //  请求新的数据的时候 停止以前的刷新
    [self.recommandUserTableView.mj_header endRefreshing];
    [self.recommandUserTableView.mj_footer endRefreshing];
    
    HBBRecommandCategory *category =  self.categories[indexPath.row];
    
    // 历史数据  不请求 http
    if (category.users.count) {
        // 显示曾经的数据
        [self.recommandUserTableView reloadData];
    }else{
        // 赶紧刷新表格,目的是:马上显示指定选择的 category 的用户数据,不让用户看到上一个 category 的残留数据
        [self.recommandUserTableView reloadData];
        // HBBLog(@"%@",category.name);
        
        // bgginRefreshing 会自动调用 loadNewUsers 方法
        [self.recommandUserTableView.mj_header beginRefreshing];
        
        
        category.currentPage = 1;
        // 发送请求给服务器,获取右侧的详情数据
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"a"] = @"list";
        params[@"c"] = @"subscribe";
        params[@"category_id"] = @(category.id);
        params[@"page"] = @(category.currentPage);
        self.params = params;
        
        [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            HBBLog(@"%@",responseObject);
            // 字典数组  --> 模型数组
            NSArray  *users = [HBBRecommandUser mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
            
            
            // 添加到当前类别对应的用户数组里
            [category.users addObjectsFromArray:users];
            
            //存放信息的总数
            category.total = [responseObject[@"total"] integerValue];
            
            // 最后一次请求的数据与之前的参数不同
            if (self.params != params) return ;
            // 刷新表格
            [self.recommandUserTableView reloadData];
            
            
            
            // 时刻检测 footer的状态
            [self checkFooterState];
            
            HBBLog(@"@%ld",category.users.count);
            HBBLog(@"@%ld",category.total);
            
            
            // 结束刷新
            
            [self.recommandUserTableView.mj_header endRefreshing];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
             if (self.params != params) return ;
            HBBLog(@"刷新数据.....");
            [self.recommandUserTableView.mj_header endRefreshing];

        }];

        
    }
}


#pragma mark 控制器的销毁
/**
 *  当请求数据没有完成后点击返回  后台没有结束  会空指针异常   controller应该销毁
 */
- (void)dealloc{
    // 停止所有的操作
    [self.manager.operationQueue cancelAllOperations];
}

@end


/**
 *  注意点
 *  1.重复发送请求
 *  2.目前只能显示1也数据
 *  3.网络慢带来的细节问题
 */
