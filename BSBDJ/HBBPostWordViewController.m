//
//  HBBPostWordViewController.m
//  BSBDJ
//
//  Created by HopeBayBridge on 16/2/8.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//  发段子(文字)

#import "HBBPostWordViewController.h"
#import "HBBPlaceholderTextView.h"

@interface HBBPostWordViewController ()
/** 文本输入控件*/
@property (nonatomic,strong) HBBPlaceholderTextView *textView;

@end

@implementation HBBPostWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置导航栏文字
    [self setupNav];
    
    // 设置占位文字
    [self setupTextView];
}

/**
 *  设置占位文字
 */
- (void)setupTextView{
    HBBPlaceholderTextView *textView = [[HBBPlaceholderTextView alloc] init];
    textView.frame = self.view.bounds;
//    textView.placeholderColor = [UIColor redColor];
    textView.placeholder = @"把好玩的图片,好笑的段子活糗事发到这里,接受千万网友膜拜吧!发布违反国家法律内容的,我们将依法提交有关部门处理.";
    
    [self.view addSubview:textView];
    self.textView = textView;
    
    
    
    
    // 监听文字改变
    [[NSNotificationCenter defaultCenter] addObserver:self.textView selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:nil];
   
}


- (void)textDidChange{
    if (self.textView.hasText) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}
/**
 *  设置导航栏文字
 */
- (void)setupNav{
    self.title = @"发表文字";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style: UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发表" style: UIBarButtonItemStyleDone target:self action:@selector(post)];
    // 默认不让点击
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
   // 强制刷新 (按钮设置不能点  enabled = NO 以后 在自定义导航栏HBBNavigationController  的initialize方法里即使设置了 不能点的状态颜色 如果不刷新  颜色也不会变
    // 如果用 viewDidAppear  系统方法  则会出现在短时间内变幻两种颜色的效果(不是想要的)
    [self.navigationController.navigationBar layoutIfNeeded];
}



/**
 *  点击导航栏左侧的取消按钮
 */
- (void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}
/**
 *  点击导航栏右侧的发表按钮
 */
- (void)post{
    
 
    
    HBBFunc;
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
