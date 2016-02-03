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
#import <MJExtension.h>
#import <MJRefresh.h>
#import <AFNetworking.h>
#import <UIImageView+WebCache.h>

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


@end


static NSInteger const HbbHeaderLabelTag = 101;

@implementation HBBCommentViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setupBasic];
    
    [self setupHeader];
    
    [self setupRefresh];
}

- (void)setupRefresh{
    
    self.contentTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewComments)];
    
    [self.contentTableView.mj_header beginRefreshing];
}

- (void)loadNewComments{
    // 参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.topic.ID;
    params[@"hot"] = @"1";
    
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // 最热评论
        self.hotComments = [HBBComment mj_objectArrayWithKeyValuesArray:responseObject[@"hot"]];
        // 最新评论
        self.latestComments = [ HBBComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        [self.contentTableView reloadData];
        [self.contentTableView.mj_header endRefreshing];
        
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
    
    self.contentTableView.backgroundColor = HBBGlobalBG;
    
    
    
    // 设置 inset  距离导航栏的距离
    self.automaticallyAdjustsScrollViewInsets = NO;  // 去掉系统的自动调整
    self.contentTableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -<UITableViewDelegate>
/**
 *  拖拽发生的事件 (键盘隐藏)  需要 tableView 的代理连线  file's owner  当前的控制器
 *
 *  @param scrollView <#scrollView description#>
 */
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
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
 *  封装缓存池
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"comment"];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"comment"];
    }
    
    
    HBBComment *cmt = [self commentInIndexPath:indexPath];
    cell.detailTextLabel.text = cmt.content;
    cell.textLabel.text = cmt.user.username;
   // cell.imageView.image = [NSURL URLWithString:cmt.user.profile_image];
    [cell.imageView  sd_setImageWithURL:[NSURL URLWithString:cmt.user
                                         .profile_image]];
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
