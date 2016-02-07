//
//  HBBMeFooterView.m
//  BSBDJ
//
//  Created by HopeBayBridge on 16/2/7.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import "HBBMeFooterView.h"
#import "HBBSquare.h"
#import "HBBSquareButton.h"
#import "HBBWebViewController.h"
#import <AFNetworking.h>
#import <MJExtension.h>

@implementation HBBMeFooterView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        // 参数
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"a"] = @"square";
        params[@"c"] = @"topic";
      
        
        
        [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask *  task, id  responseObject) {
            
            NSArray *squares = [HBBSquare mj_objectArrayWithKeyValuesArray:responseObject[@"square_list"]];
       
            // 创建方块
            [self createSquares: squares];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];

        
    }
    
    return self;
}
/**
 *  创建方块
 *
 *  @param squares <#squares description#>
 */
- (void)createSquares:(NSArray *)squares{
    
    // 一行最多4列
    int maxCols = 4;
    // 宽度和高度
    CGFloat btnW = HBBScreenWidth / maxCols;
    CGFloat btnH = btnW;
    
    for (int i = 0 ; i < squares.count; i++) {
        // 创建按钮
        HBBSquareButton *btn = [HBBSquareButton buttonWithType:UIButtonTypeCustom];
        
        // 监听点击
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        // 传递模型
        btn.square = squares[i];
        [self addSubview:btn];
        
        // 计算 frame
        int col = i % maxCols;
        int row = i / maxCols;
        btn.x = col * btnW;
        btn.y = row * btnH;
        btn.width = btnW;
        btn.height = btnH;
    }
    
    // 总行数 = ( 总个数 + 每行最大个数 - 1 ) / 每行最大个数
    NSUInteger rows = (squares.count + maxCols -1) /maxCols;
    
    // 计算 footer的高度
    self.height = rows * btnH;
    
    // 重绘
    [self setNeedsDisplay];
}

- (void)btnClick:(HBBSquareButton *)btn{
    
    // 不得姐有内部 映射的请求
    if(  ![btn.square.url hasPrefix:@"http"] ) return ;
    
    HBBWebViewController *web = [[HBBWebViewController alloc] init];
    web.url = btn.square.url;
    web.title = btn.square.name;
    
    // 取出当前的导航控制器
    UITabBarController *tabBarVC =  (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = (UINavigationController *)tabBarVC.selectedViewController;
    [nav pushViewController:web animated:YES];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
