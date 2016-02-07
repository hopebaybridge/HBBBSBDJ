//
//  HBBWebViewController.m
//  BSBDJ
//
//  Created by HopeBayBridge on 16/2/7.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import "HBBWebViewController.h"
#import <NJKWebViewProgress.h>

@interface HBBWebViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *mineWebView;
@property (weak, nonatomic) IBOutlet UIProgressView *mineProgressView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *goBackItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goForwardItem;

/** 进度代理对象*/
@property (nonatomic,strong) NJKWebViewProgress  *progress;


@end

@implementation HBBWebViewController





- (IBAction)goback:(UIBarButtonItem *)sender {
    
    [self.mineWebView goBack];
}


- (IBAction)goforward:(UIBarButtonItem *)sender {
    
    [self.mineWebView goForward];
}

- (IBAction)refresh:(UIBarButtonItem *)sender {
    
    [self.mineWebView reload];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.progress = [[NJKWebViewProgress alloc] init];
    self.mineWebView.delegate = self.progress;
    __weak typeof(self) weakSelf = self;
    
    self.progress.progressBlock = ^(float progress){
      
        weakSelf.mineProgressView.progress = progress;
        weakSelf.mineProgressView.hidden = (progress == 1.0);
    };
    
    self.progress.webViewProxyDelegate = self;
    
    [self.mineWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}


#pragma mark  - <UIWebViewDelegate>
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    self.goBackItem.enabled = webView.canGoBack;
    self.goForwardItem.enabled = webView.canGoForward;
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
