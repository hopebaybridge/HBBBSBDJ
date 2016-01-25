//
//  HBBEssenceViewController.m
//  HBBBDBDJ
//
//  Created by HopeBayBridge on 16/1/16.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import "HBBEssenceViewController.h"
#import "UIBarButtonItem+HBBExtension.h"
#import "HBBRecommandTagsViewController.h"
#import "HBBTopciTableViewController.h"



@interface HBBEssenceViewController () <UIScrollViewDelegate>
/**指示器*/
@property (nonatomic,weak) UIView *indicatorView;

/**存储选中的指示器的按钮*/
@property (nonatomic,weak)  UIButton *selectedBtn;

/**顶部所有的标签*/
@property (nonatomic,weak)  UIView *titlesView;

/**设置 contentView*/
@property (nonatomic,weak) UIScrollView *contentView;


@end

@implementation HBBEssenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 设置导航栏内容
    [self setupNav];
    
    
    // 初始化所有标签栏标识的 tableViewController 的子控制器
    [self setupAllChildrenTableViews];
    
    // 设置顶部标签栏
    [self setupTitleView];
    
    //  设置底部的 scrollView
    [self setupContentView];
    
   
}

/**
 *  初始化所有标签栏标识的 tableViewController 的子控制器
 */
- (void)setupAllChildrenTableViews{
    
    
    // 通过传递 type    enum  创建5个类似的帖子模块
    
    HBBTopciTableViewController *allTabVC = [[HBBTopciTableViewController alloc] init];
    allTabVC.title = @"全部";
    allTabVC.type = HBBTopicTypeAll;
    [self addChildViewController:allTabVC];
    
    HBBTopciTableViewController *wordTabVC = [[HBBTopciTableViewController alloc] init];
    [wordTabVC setTitle:@"段子"];
    [wordTabVC setType:HBBTopicTypeWord];
    [self addChildViewController:wordTabVC];
    
    HBBTopciTableViewController *videoTabVC = [[HBBTopciTableViewController alloc] init];
    [videoTabVC setTitle:@"视频"];
    [videoTabVC setType:HBBTopicTypeVideo];
    [self addChildViewController:videoTabVC];
    
    HBBTopciTableViewController *voiceTabVC = [[HBBTopciTableViewController alloc] init];
    [voiceTabVC setTitle:@"声音"];
    [voiceTabVC setType:HBBTopicTypeVoice];
    [self addChildViewController:voiceTabVC];
    
    HBBTopciTableViewController *picTabVC = [[HBBTopciTableViewController alloc] init];
    [picTabVC setTitle:@"图片"];
    [picTabVC setType:HBBTopicTypePicture];
    [self addChildViewController:picTabVC];


}


/**
 *  设置底部的 scrollview
 */
- (void)setupContentView{
    // 去掉自动调整 insert
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *contentView = [[UIScrollView alloc] init];
    contentView.frame = self.view.bounds;
    
    // 设置代理自动调用方法加载 tableview内容
    contentView.delegate = self;
    // 设置分页
    contentView.pagingEnabled = YES;
    
    // 设置内边距
//    CGFloat bottom =self.tabBarController.tabBar.height;
//    CGFloat top = CGRectGetMaxY(self.titlesView.frame);
//    // ⬆️ ⬅️ ⬇️ →
//    contentView.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
    
    // 将contentView 插入底部
    [self.view insertSubview:contentView atIndex:0];
    
    // 设置滚动的范围
    contentView.contentSize = CGSizeMake(contentView.width * self.childViewControllers.count, 0);
    self.contentView = contentView ;
    
    // 默认添加第一个控制器的 view
    
    [self scrollViewDidEndScrollingAnimation:contentView];
    
   
}

/**
 *  设置顶部标签栏
 */
- (void)setupTitleView{
    
    // 标签栏整体
    UIView *titlesView = [[UIView alloc] init];
    //    titlesView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
    //    titlesView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    titlesView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    



    
   titlesView.width = self.view.width;
    titlesView.height = 35;
    titlesView.y = 64;
    [self.view addSubview:titlesView];
    self.titlesView = titlesView;
    
    
    // 内部子标签
    CGFloat width = titlesView.width / self.childViewControllers.count;
    CGFloat height = titlesView.height;
    for (NSInteger i = 0 ; i < self.childViewControllers.count; i++) {
        UIButton *btn = [[UIButton alloc] init];
        btn.height = height;
        btn.width = width;
        btn.x = i * width;
        // 设置 btn 的 tag用作 scrollview 的滚动 offset
        btn.tag = i;
       [btn setTitle:self.childViewControllers[i].title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        // 选中后不能再点击  颜色为红色
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [titlesView addSubview:btn];

        // 默认第一个按钮为红色
        if(i == 0){
            btn.enabled = NO;
            self.selectedBtn = btn;
            
            // 让按钮内部的 label 根据文字内容计算尺寸
            [btn.titleLabel sizeToFit];
            self.indicatorView.width = btn.titleLabel.width;
            //   2⃣️self.indicatorView.width = [titles[i] sizeWithAttributes:@{NSFontAttributeName:btn.titleLabel.font}].width;
            self.indicatorView.centerX = btn.centerX ;
        }
        
    }
    

    
  //  [self.view bringSubviewToFront:titlesView];
    
    // 设置底部的红色指示器
    UIView *indicatorView = [[UIView alloc] init];
    indicatorView.backgroundColor = [UIColor redColor];
    indicatorView.height = 1;
    indicatorView.y = titlesView.height - indicatorView.height;
    [titlesView addSubview:indicatorView];
    self.indicatorView = indicatorView;

    
    
}

- (void)titleClick:(UIButton *)btn{
    
    
    // 修改按钮状态
    self.selectedBtn.enabled = YES;
    // 当前点击的按钮不能再点
    btn.enabled = NO;
    // 此按钮为选中的按钮
    self.selectedBtn = btn;
    
    
    
    [UIView animateWithDuration:0.25 animations:^{
        
        
        self.indicatorView.width  = btn.titleLabel.width;
        self.indicatorView.centerX = btn.centerX;
    }];
    
    
    // 点击按钮滚动 scrollview 显示 tableview 内容
    CGPoint offset = self.contentView.contentOffset;
    offset.x = btn.tag * self.contentView.width;
    [self.contentView setContentOffset:offset animated:YES];
    
    
}

/**
 *  设置导航栏内容
 */
- (void)setupNav{
    // 设置标题
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
    // 设置左边按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"MainTagSubIcon" highImage:@"MainTagSubIconClick" target:self action:@selector(tagClick)];
    // 在 pch 文件中统一设置整站的背景颜色
    self.view.backgroundColor = HBBGlobalBG;
    
}



/**
 *  进入推荐标签
 */
- (void)tagClick{
    HBBRecommandTagsViewController *tags = [[HBBRecommandTagsViewController alloc] init];
   
    
    [self.navigationController pushViewController:tags animated:YES];
}



#pragma mark ---调用 UIScrollViewDelegate 方法
/**
 *  scrollView 滚动结束后调用此方法
 *
 *  @param scrollView <#scrollView description#>
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
     // 当前的索引
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    
    // 取出子控制器
    UIViewController *vc = self.childViewControllers[index];
    vc.view.x = scrollView.contentOffset.x;
    // 撤销系统默认给出的 纵坐标20
    vc.view.y = 0;
    // 修改系统给出高度(默认少20)
    vc.view.height = scrollView.height;

    
    [scrollView addSubview:vc.view];
    
}
/**
 *  分页调用此方法  (减速decelerating)
 *
 *  @param scrollView <#scrollView description#>
 */
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    // 点击按钮一起联动  (指示器在 btn 后加的,所以 index 可以先取到 btn
    NSInteger index = scrollView.contentOffset.x /scrollView.width;
    [self titleClick:self.titlesView.subviews[index]];
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
