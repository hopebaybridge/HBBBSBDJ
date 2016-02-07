//
//  HBBCommentViewController.m
//  BSBDJ
//
//  Created by HopeBayBridge on 16/2/2.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import "HBBCommentViewController.h"
#import "HBBTopicCell.h"
#import "HBBTopic.h"
#import "HBBComment.h"
#import "HBBUser.h"
#import "HBBCommentHeaderView.h"
#import "HBBCommentTableViewCell.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import <AFNetworking.h>
#import <UIImageView+WebCache.h>


static NSString *const HBBCommentID = @"comment";

@interface HBBCommentViewController () <UITableViewDelegate,UITableViewDataSource>
/** 工具条底部的间距 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolBottomSpace;
/** 评论内容  */
@property (weak, nonatomic) IBOutlet UITableView *contentTableView;

/** 写评论的内容*/
@property (weak, nonatomic) IBOutlet UITextField *commentText;

/** 最热评论*/
@property (nonatomic,strong) NSArray  *hotComments;
/** 最新评论(变量不能以 new 开头  否则报错 returning owner object */
@property (nonatomic,strong) NSMutableArray  *latestComments;
/** 保存帖子的 top_cmt*/
@property (nonatomic,strong)HBBComment  *saved_top_cmt;
/** 保存当前的页面 */
@property (nonatomic,assign) NSInteger currentPage;

/** AF 管理者*/
@property (nonatomic,strong) AFHTTPSessionManager  *manager;


@end


//static NSInteger const HbbHeaderLabelTag = 101;

@implementation HBBCommentViewController

- (AFHTTPSessionManager *)manager{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setupBasic];
    
    [self setupHeader];
    
    [self setupRefresh];
}

- (void)setupRefresh{
    
    // 下拉刷新
    self.contentTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewComments)];
    
    [self.contentTableView.mj_header beginRefreshing];
    // 上拉刷新
    //MJRefreshAutoNormalFooter  显示文字
    //MJRefreshAutoFooter  不显示文字
    
    self.contentTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreComments)];
    self.contentTableView.mj_footer.hidden = YES;
    
    
}
/**
 *  上拉刷新  加载更多数据
 */
- (void)loadMoreComments{
    
    // 结束之前的所有需求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];

    // 页面
    NSInteger page = self.currentPage + 1;
    
    // 参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.topic.ID;
    params[@"page"] = @(page);
    
    HBBComment *cmt = [self.latestComments lastObject];
    params[@"lastcid"] = cmt.ID;
    
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // 最新评论
        NSArray *newCmts= [ HBBComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self.latestComments addObjectsFromArray:newCmts];
        
        self.currentPage = page;
        
        [self.contentTableView reloadData];
        
        // 控制 footer的状态
        // 获取所有的数据量
        NSInteger total = [responseObject[@"total"] integerValue];
        // 返回的实际数量可能大于 最大数  全部加载完毕
        if (self.latestComments.count >= total) {
//            self.contentTableView.mj_footer.hidden = YES;
            [self.contentTableView.mj_footer  endRefreshingWithNoMoreData];
        }else{
            [self.contentTableView.mj_footer endRefreshing];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.contentTableView.mj_footer endRefreshing];
    }];
    
    
}
/**
 *  下拉刷新  加载最新的数据
 */
- (void)loadNewComments{
    
    
    // 结束之前的所有需求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.topic.ID;
    params[@"hot"] = @"1";
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // 最热评论
        self.hotComments = [HBBComment mj_objectArrayWithKeyValuesArray:responseObject[@"hot"]];
        // 最新评论
        self.latestComments = [ HBBComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        // 设置页面
        self.currentPage = 1;
        
        [self.contentTableView reloadData];
        [self.contentTableView.mj_header endRefreshing];
        
        // 控制 footer的状态
        // 获取所有的数据量
        NSInteger total = [responseObject[@"total"] integerValue];
        // 返回的实际数量可能大于 最大数  全部加载完毕
        if (self.latestComments.count >= total) {
//            self.contentTableView.mj_footer.hidden = YES;
           [self.contentTableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            self.contentTableView.mj_footer.hidden = NO;

        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.contentTableView.mj_header endRefreshing];
    }];
    
}


/**
 *  获取头文件信息
 */
- (void)setupHeader{
    // 创建头信息包装
    UIView *header = [[UIView alloc] init];
    
    
    if (self.topic.top_cmt) {
        self.saved_top_cmt = self.topic.top_cmt;
        // 利用 kvc 去除评论的最热评论的高度  显示格局不一样  看图说话  帖子的最热评论和  评论 controller的显示是不一样的
        self.topic.top_cmt = nil;
        [self.topic setValue:@0 forKeyPath:@"cellHeight"];
    }
    
    
    
    // 添加 cell
    HBBTopicCell *cell = [HBBTopicCell cell];
    cell.topic = self.topic;
    cell.size = CGSizeMake(HBBScreenWidth, self.topic.cellHeight);
    [header addSubview:cell];
    
    // header 的高度
    header.height = self.topic.cellHeight + HBBTopicCellMargin;
    
    // 设置 header
    self.contentTableView.tableHeaderView = header;
}


- (void)setupBasic{
    self.title = @"评论";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"comment_nav_item_share_icon" highImage:@"comment_nav_item_share_icon_click" target:nil action:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    
    
    // 设置 inset  距离导航栏的距离
    self.automaticallyAdjustsScrollViewInsets = NO;  // 去掉系统的自动调整
    self.contentTableView.contentInset = UIEdgeInsetsMake(64, 0, HBBTopicCellMargin, 0);
    
    
    // cell 的高度设置   ios8  以后的特性
    // 估计的(高度)  (不设置高度 ,底部可以设置 内容 contentLabel  距离底部为10
    self.contentTableView.estimatedRowHeight = 44;
    self.contentTableView.rowHeight = UITableViewAutomaticDimension;
    
    self.contentTableView.backgroundColor = HBBGlobalBG;
    
    //注册 cell
    [self.contentTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HBBCommentTableViewCell class]) bundle:nil] forCellReuseIdentifier:HBBCommentID];
    
    // 去掉系统分割线
    self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    //self.contentTableView.contentInset = self.contentTableView.contentInset;
    //self.contentTableView.rowHeight = 70;
}

- (void)keyboardWillChangeFrame:(NSNotification *)note{
    // 键盘显示/隐藏完毕的 frame
    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 修改底部的约束
    self.toolBottomSpace.constant = HBBScreenHeight - frame.origin.y;
    // 动画时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 动画即使刷新
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // 恢复帖子中的 top_cmt

    if(self.saved_top_cmt){
        self.topic.top_cmt = self.saved_top_cmt;
        [self.topic setValue:@0 forKeyPath:@"cellHeight"];
    }
    
    // 取消所有任务
//    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    [self.manager invalidateSessionCancelingTasks:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -<UITableViewDataSource>
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    NSInteger hotCmtCount = self.hotComments.count;
    NSInteger latestCmtCount = self.latestComments.count;
    
    if(hotCmtCount) return 2;  // 有最热评论  + 最新评论
    if(latestCmtCount) return 1;  // 有最新评论 1 组
    return  0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger hotCmtCount = self.hotComments.count;
    NSInteger latestCmtCount = self.latestComments.count;
    
    
    // 隐藏尾部控件
    tableView.mj_footer.hidden = (latestCmtCount == 0);
    
    if (section == 0) {
        // 最热评论有数据则第0组 返回 hotCmtCount  否则返回latestCmtCount
        return hotCmtCount ? hotCmtCount :latestCmtCount;
    }
    
    // 非第0 组
    return  latestCmtCount;
}
/**
 *  设置头部文字 1⃣️
 *
 *  @param tableView <#tableView description#>
 *  @param section   <#section description#>
 *
 *  @return <#return value description#>
 */
//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    
//    
//    NSInteger hotCmtCount = self.hotComments.count;
//    
//    if (section == 0) {
//        return hotCmtCount ? @"最热评论":@"最新评论";
//    }
//    
//    return @"最新评论";
//}

/**
 *  给头部标题添加自定义的富文本  2⃣️
 *
 *  @param tableView <#tableView description#>
 *  @param section   <#section description#>
 *
 *  @return <#return value description#>
 */
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *header = [[UIView alloc] init];
//    header.backgroundColor = HBBGlobalBG;
//    
//    // 创建 label
//    UILabel *label = [[UILabel alloc] init];
//    label.textColor = HBBRGBColor(67, 67, 67);
//    label.width = 200;
//    label.x = HBBTopicCellMargin;
//    label.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//    [header addSubview:label];
//    
//     //设置文字
//
//    NSInteger hotCmtCount = self.hotComments.count;
//
//    if (section == 0) {
//        label.text = hotCmtCount ? @"最热评论":@"最新评论";
//    }else{
//        label.text = @"最新评论";
//    }
//
//    return header;
//}

/**
 *  通过设置缓存池 设置标题标题文字   3⃣️
 *
 *  @param tableView <#tableView description#>
 *  @param section   <#section description#>
 *
 *  @return <#return value description#>
 */
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    
//    static NSString *ID = @"header";
//    
//    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
//
//    UILabel *label = nil;
//    // 缓存池中没有自己创建
//    if (header == nil) {
//        header = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:ID];
//        header.backgroundColor = HBBGlobalBG;
//        
//        label = [[UILabel alloc] init];
//        label.textColor = HBBRGBColor(67, 67, 67);
//        label.width = 200;
//        label.x = HBBTopicCellMargin;
//        label.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//        label.tag = HbbHeaderLabelTag;
//        [header addSubview:label];
//    }else{
//        
//        label = (UILabel *)[header viewWithTag:HbbHeaderLabelTag];
//    }
//    
//   
//    
//    //设置文字
//    
//    NSInteger hotCmtCount = self.hotComments.count;
//    
//    if (section == 0) {
//        label.text = hotCmtCount ? @"最热评论":@"最新评论";
//    }else{
//        label.text = @"最新评论";
//    }
//    
//    return header;
//}

/**
 *  封装缓存池 4⃣️
 *
 *  @param tableView <#tableView description#>
 *  @param section   <#section description#>
 *
 *  @return <#return value description#>
 */
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
  // 从缓存池中找 header
    HBBCommentHeaderView *header = [HBBCommentHeaderView headerViewWithTableView:tableView];
    
    
    //设置文字
    
    NSInteger hotCmtCount = self.hotComments.count;
    
    if (section == 0) {
        header.title = hotCmtCount ? @"最热评论":@"最新评论";
    }else{
        header.title = @"最新评论";
    }
    
    return header;
}


/**
 *  返回第 section 组的所有评论数据
 *
 *  @param section <#section description#>
 *
 *  @return <#return value description#>
 */
-(NSArray *)commentsInSection:(NSInteger)section{
    if (section == 0) {
        return self.hotComments.count? self.hotComments:self.latestComments;
    }
    
    return self.latestComments;
}


-(HBBComment *)commentInIndexPath:(NSIndexPath *)indexPath{
    return [self commentsInSection:indexPath.section][indexPath.row];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HBBCommentID];
    
    HBBCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HBBCommentID];
    
//    if(cell == nil){
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"comment"];
//    }
//
    
    cell.comment = [self commentInIndexPath:indexPath];
    
//    HBBComment *cmt = [self commentInIndexPath:indexPath];
//    cell.detailTextLabel.text = cmt.content;
//    cell.textLabel.text = cmt.user.username;
//   // cell.imageView.image = [NSURL URLWithString:cmt.user.profile_image];
//    [cell.imageView  sd_setImageWithURL:[NSURL URLWithString:cmt.user
//                                         .profile_image]];
    return cell;
}


#pragma mark -<UITableViewDelegate>
/**
 *  拖拽发生的事件 (键盘隐藏)  需要 tableView 的代理连线  file's owner  当前的控制器
 *  
 *  UIMenuController 消失
 *
 *  @param scrollView <#scrollView description#>
 */
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
    
    [[UIMenuController sharedMenuController ] setMenuVisible:NO animated:YES];
}

/**
 *  选中指定 cell 发生的事件
 *
 *  @param tableView <#tableView description#>
 *  @param indexPath <#indexPath description#>
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIMenuController  *menuVC = [UIMenuController sharedMenuController];
    
    // 重复点击 会消失
    if (menuVC.isMenuVisible) {
        [menuVC setMenuVisible:NO animated:YES];
    } else {
        // 被点击的 cell
        HBBCommentTableViewCell *cmtCell =  (HBBCommentTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        // 让 cell 成为第一响应者
        [cmtCell becomeFirstResponder];
        
        // 显示 MenuController
        UIMenuItem  *ding = [[UIMenuItem alloc] initWithTitle:@"顶" action:@selector(ding:)];
        UIMenuItem  *reply = [[UIMenuItem alloc] initWithTitle:@"回复" action:@selector(reply:)];
        UIMenuItem  *report = [[UIMenuItem alloc] initWithTitle:@" 举报" action:@selector(report:)];
        
        menuVC.menuItems = @[ding,reply,report];
        CGRect rect = CGRectMake(0, cmtCell.height * 0.5, cmtCell.width, cmtCell.height * 0.5);
        
        [menuVC setTargetRect:rect inView:cmtCell];
        [menuVC setMenuVisible:YES animated:YES];
        
    }
}


#pragma mark -MenuItem 处理
- (void)ding:(UIMenuController *)menuVC{
    
    NSIndexPath *indexPath = [self.contentTableView indexPathForSelectedRow];
    
    HBBLog(@"%s ---> %@",__func__ ,[self commentInIndexPath:indexPath].content);
    
}

- (void)reply:(UIMenuController *)menuVC{
    
    NSIndexPath *indexPath = [self.contentTableView indexPathForSelectedRow];
    
    HBBLog(@"%s ---> %@",__func__ ,[self commentInIndexPath:indexPath].content);
}

- (void)report:(UIMenuController *)menuVC{
    
    NSIndexPath *indexPath = [self.contentTableView indexPathForSelectedRow];
    
    HBBLog(@"%s ---> %@",__func__ ,[self commentInIndexPath:indexPath].content);
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
