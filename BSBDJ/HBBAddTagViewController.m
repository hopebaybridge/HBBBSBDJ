//
//  HBBAddTagViewController.m
//  BSBDJ
//
//  Created by HopeBayBridge on 16/2/9.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import "HBBAddTagViewController.h"
#import "HBBTagBtn.h"
#import "HBBTagTextField.h"
#import <SVProgressHUD.h>

@interface HBBAddTagViewController ()<UITextFieldDelegate>

/** 装载所有内容 */
@property (nonatomic,weak) UIView *contentView;

/**文本输入框*/
@property (nonatomic,weak)  UITextField *textField;

/**添加按钮*/
@property (nonatomic,weak)  UIButton *addBtn;


/** 所有的标签按钮  (排序所用)*/
@property (nonatomic,strong) NSMutableArray  *tagBtns;



@end

@implementation HBBAddTagViewController


- (NSMutableArray *)tagBtns{
    if (!_tagBtns) {
        _tagBtns = [NSMutableArray array];
    }
    
    return _tagBtns;
}


- (UIButton *)addBtn{
    if (!_addBtn) {
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addBtn.width = self.contentView.width;
        addBtn.height = HBBPublicWordsTagHeight;
        [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        // 监听按钮点击
        [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
        addBtn.titleLabel.font = HBBPublishWordsTagFont;
        addBtn.contentEdgeInsets = UIEdgeInsetsMake(0, HBBPublicWordsTagMargin, 0, HBBPublicWordsTagMargin);
        // 让按钮的内部的文字和图片都左对齐
        addBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        addBtn.backgroundColor = HBBPublishWordsTagBG;
        [self.contentView addSubview:addBtn];
        _addBtn = addBtn;
        
    }
    return _addBtn;
}

/**
 *  初始化数据
 */
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //设置导航栏
    [self setupNav];
    // 设置 contentView  装载所有控件 省却边距安排
    [self setupContentView];
    
    // 设置文本框内容输入后按钮的文字联动事件
    [self setupTextField];
    
    
    // 初始化标签
    [self setupTags];
    
}
/**
 *  初始化标签
 */
-(void)setupTags{
    for (NSString *tag in self.tags) {
        self.textField.text = tag;
        [self addBtnClick];
    }
}



/**
 *  监听按钮点击   "添加标签"
 */
-(void)addBtnClick{
    
    if (self.tagBtns.count >=5) {
        [SVProgressHUD showErrorWithStatus:@"最多添加5个标签" maskType:(SVProgressHUDMaskTypeBlack)];
        return;
    }

    // 添加一个"标签按钮"
    HBBTagBtn *tagBtn = [HBBTagBtn buttonWithType:UIButtonTypeCustom];
    // 添加点击标签按钮的事件
    [tagBtn addTarget:self action:@selector(tagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [tagBtn setTitle:self.textField.text forState:UIControlStateNormal];
    tagBtn.height = self.textField.height;
    [self.contentView addSubview:tagBtn];
    [self.tagBtns addObject:tagBtn];
    
    // 更新标签按钮的 frame;
    [self updateTagBtnFrame];
    
    // 清空 textField 文字
    self.textField.text = nil;
    self.addBtn.hidden = YES;
}

/**
 *  添加点击标签按钮的事件
 */
- (void)tagBtnClick:(HBBTagBtn *) tagBtn{
    [tagBtn removeFromSuperview];
    [self.tagBtns removeObject:tagBtn];
    
    // 重新更新所有标签按钮的 frame
    [UIView animateWithDuration:0.25 animations:^{
        [self updateTagBtnFrame];
    }];
}

/**
 *  更新标签按钮的 frame
 */
- (void)updateTagBtnFrame{
    
    for (int i = 0 ; i < self.tagBtns.count; i++) {
        HBBTagBtn *tagBtn = self.tagBtns[i];
        
        // 最前面的标签按钮
        if (i == 0) {
            tagBtn.x = 0;
            tagBtn.y = 0;
            
        } else {
            // 其他标签按钮  依托第一个排开
            HBBTagBtn *lastTagBtn = self.tagBtns[i - 1];
            // 计算当前行左边的宽度 (每个按钮的间距为5)
            CGFloat leftWidth = CGRectGetMaxX(lastTagBtn.frame) + HBBPublicWordsTagMargin;
            // 计算当前行右边的宽度
            CGFloat rightWidth = self.contentView.width - leftWidth;
            
            
            if (rightWidth >= tagBtn.width) {
                // 剩余的宽度大于 按钮的宽度  显示在本行
                tagBtn.y = lastTagBtn.y;
                tagBtn.x = leftWidth;
                
            } else {
                tagBtn.x = 0;
                tagBtn.y = CGRectGetMaxY(lastTagBtn.frame) + HBBPublicWordsTagMargin;
                
            }
        }
    }// end for
    
    
    // 最后一个标签按钮
    HBBTagBtn *lastTagBtn = [self.tagBtns lastObject];
    CGFloat leftWith = CGRectGetMaxX(lastTagBtn.frame) + HBBPublicWordsTagMargin;
    
    // 更新 textField 的 frame
    //textFieldTextWith()  调用计算textFieldTextWidth方法
    if (self.contentView.width - leftWith >= [self textFieldTextWidth]) {
        
        self.textField.y = lastTagBtn.y;
        self.textField.x = leftWith;
        
    } else {
        
        self.textField.x = 0;
        self.textField.y = CGRectGetMaxY(lastTagBtn.frame) + HBBPublicWordsTagMargin;
    }
    
}

/**
 *  计算textFieldTextWith  宽度方法
 *
 *  @return <#return value description#>
 */
-(CGFloat)textFieldTextWidth{
    
    CGFloat textWidth = [self.textField.text sizeWithAttributes:@{NSFontAttributeName: self.textField.font} ].width;
    
    return MAX(100, textWidth);
}




/**
 *  设置文本框内容输入后按钮的文字联动事件
 */
- (void)setupTextField{
    
    // 避免循环使用
    __weak typeof(self) weakSelf = self;
    
    HBBTagTextField *textField = [[HBBTagTextField alloc] init];
    textField.width = HBBScreenWidth;
    textField.height = 25;
    textField.deleteBlock = ^{
        
        // 输入文本框有文字 删除文字   没有文字 删除最后一个 标签按钮
        
        if(weakSelf.textField.hasText) return ;
        
        [weakSelf tagBtnClick:[weakSelf.tagBtns lastObject]];
        
    };
    textField.delegate = self;
    textField.placeholder = @"多个标签用逗号或者换行隔开";
    // 监听文字改变发生的事件
    [textField addTarget:self action:@selector(textDidChange) forControlEvents:UIControlEventEditingChanged];
    [textField becomeFirstResponder];
    [self.contentView addSubview:textField];
    self.textField = textField;
}
/**
 *  监听文字改变发生的事件
 */
- (void)textDidChange{
    
    
    NSString *text = self.textField.text;
    
    if ([text isEqualToString:@","]  ||  [text isEqualToString:@"，"]) {
        self.textField.text = nil;
        [SVProgressHUD showErrorWithStatus:@"逗号只能作为分隔符" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    
    [self updateTagBtnFrame];
    
    if (self.textField.hasText) {
        // 显示" 添加标签" 按钮
        self.addBtn.hidden = NO;
        self.addBtn.y = CGRectGetMaxY(self.textField.frame) + HBBPublicWordsTagMargin;
        [self.addBtn setTitle:[NSString stringWithFormat:@"添加标签 : %@",self.textField.text] forState:UIControlStateNormal];
        
        
        // 获取最后一个字符  (多个标签用逗号或者换行隔开)
        NSUInteger len = text.length;
        NSString *lastLetter = [text substringFromIndex:len - 1];
        
        if ([lastLetter isEqualToString:@","]  ||  [lastLetter isEqualToString:@"，"]) {
            // 去掉逗号
            self.textField.text = [text substringToIndex:len - 1];
            
            [self addBtnClick];
        }
    } else {
        // 隐藏" 添加标签" 按钮
        self.addBtn.hidden = YES;
    }
}



/**
 *  设置 contentView  装载所有控件 省却边距安排
 */
- (void)setupContentView{
    
    UIView *contentView = [[UIView alloc] init];
    contentView.x = HBBPublicWordsTagMargin;
    contentView.width = self.view.width - 2 * contentView.x;
    contentView.y = 64 + HBBTopicCellMargin;
    contentView.height = HBBScreenHeight;
    [self.view addSubview:contentView];
    self.contentView = contentView;
    
}

/**
 *  设置导航栏
 */
- (void)setupNav{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"添加标签";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target: self action:@selector(completeDone)];
}

/**
 *  点击导航栏右侧的“完成”按钮
 */
- (void)completeDone{
    
    
    // 取出 标签按钮的文字
    NSArray *tags = [self.tagBtns valueForKeyPath:@"currentTitle"];
    
    // 传递文字标签 给点击添加按钮  作为回调属性的值
    !self.tagsBlock ? : self.tagsBlock(tags);
        
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -<UITextFeildDelegate>
/**
 *  代理  监听键盘最右下角按钮的点击 (return key   比如  换行    完成  and so on );
 *
 *  @param textField <#textField description#>
 *
 *  @return <#return value description#>
 */
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField.hasText) {
        //多个标签用逗号或者换行隔开
        [self addBtnClick];
    }
    
    return YES;
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
