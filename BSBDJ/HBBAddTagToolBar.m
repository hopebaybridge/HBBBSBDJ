//
//  HBBAddTagToolBar.m
//  BSBDJ
//
//  Created by HopeBayBridge on 16/2/9.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import "HBBAddTagToolBar.h"
#import "HBBAddTagViewController.h"

@interface HBBAddTagToolBar()

/** 标签 label superview */
@property (weak, nonatomic) IBOutlet UIView *labelView;


/**添加按钮*/
@property (nonatomic,weak)  UIButton *addBtn;


/** 存放所有标签 label*/
@property (nonatomic,strong)NSMutableArray  *tagLabelsArray;


@end

@implementation HBBAddTagToolBar
/**
 *  初始化 tagLabelsArray
 *
 *  @return <#return value description#>
 */
-(NSArray *)tagLabelsArray{
    
    if (!_tagLabelsArray) {
        _tagLabelsArray = [NSMutableArray array];
    }
    return _tagLabelsArray;
}


- (void)awakeFromNib{
    // 添加一个加号按钮
    UIButton *addBtn = [[UIButton alloc]init];
    [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setImage:[UIImage imageNamed:@"tag_add_icon"] forState:UIControlStateNormal];
//    addBtn.size = [UIImage imageNamed:@"tag_add_icon"].size;
//    addBtn.size = [addBtn imageForState:UIControlStateNormal].size;
    addBtn.size = addBtn.currentImage.size;
//    [addBtn.layer setMasksToBounds:YES];
//    [addBtn.layer setCornerRadius:10.0];
    
    addBtn.layer.cornerRadius = 10; //值越大，角越圆（值为控件宽高一半的时候是正圆）

    addBtn.layer.masksToBounds = YES;
    [self.labelView addSubview:addBtn];
    
    _addBtn = addBtn;
    
    // 默认添加2个标签
    [self createTagLabels:@[@"吐槽",@"糗事"]];
}

-(void)addBtnClick{
    HBBAddTagViewController *addTagVC = [[HBBAddTagViewController alloc] init];
    
    
    __weak typeof(self) weakSelf = self;
    // 接受回调属性传递的标签数组文字
    [addTagVC setTagsBlock:^(NSArray *tags) {
        // 添加标签位置安排
        [weakSelf createTagLabels:tags];
    }];
    
    addTagVC.tags = [self.tagLabelsArray valueForKeyPath:@"text"];
    
    UIViewController *root =[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = (UINavigationController *)root.presentedViewController;
    [nav pushViewController:addTagVC animated:YES];
}


/**
 *  添加标签位置安排
 *
 *  @param tags <#tags description#>
 */
-(void)createTagLabels:(NSArray *)tags{

    [self.tagLabelsArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.tagLabelsArray removeAllObjects];
    
    
    for (int i = 0 ; i < tags.count; i++) {
        
        UILabel *tagLabel = [[UILabel alloc] init];
        [self.tagLabelsArray addObject:tagLabel];
        tagLabel.backgroundColor = HBBPublishWordsTagBG;
        tagLabel.textAlignment = NSTextAlignmentCenter;
        tagLabel.text = tags[i];
        tagLabel.font = HBBPublishWordsTagFont;
        // 应该先设置文字和字体后，再进行计算
        [tagLabel sizeToFit];
        tagLabel.width += 2 * HBBPublicWordsTagMargin;
        tagLabel.height = HBBPublicWordsTagHeight;
        tagLabel.textColor = [UIColor whiteColor];
        [self.labelView addSubview:tagLabel];
        
        // 最前面的标签按钮
        if (i == 0) {
            tagLabel.x = 0;
            tagLabel.y = 0;
            
        } else {
            // 其他标签按钮  依托第一个排开
            UILabel *lastTagLabel = self.tagLabelsArray[i - 1];
            // 计算当前行左边的宽度 (每个按钮的间距为5)
            CGFloat leftWidth = CGRectGetMaxX(lastTagLabel.frame) + HBBPublicWordsTagMargin;
            // 计算当前行右边的宽度
            CGFloat rightWidth = self.labelView.width - leftWidth;
            
            
            if (rightWidth >= tagLabel.width) {
                // 剩余的宽度大于 按钮的宽度  显示在本行
                tagLabel.y = lastTagLabel.y;
                tagLabel.x = leftWidth;
                
            } else {
                tagLabel.x = 0;
                tagLabel.y = CGRectGetMaxY(lastTagLabel.frame) + HBBPublicWordsTagMargin;
                
            }
        }
    }// end for
    
    
    // 最后一个标签按钮
    UILabel *lastTagLabel = [self.tagLabelsArray lastObject];
    CGFloat leftWith = CGRectGetMaxX(lastTagLabel.frame) + HBBPublicWordsTagMargin;
    
    // 更新 textField 的 frame
    //textFieldTextWith()  调用计算textFieldTextWidth方法
    if ( self.labelView.width - leftWith >= self.addBtn.width) {
        
        self.addBtn.y = lastTagLabel.y;
        self.addBtn.x = leftWith;
        
    } else {
        
        self.addBtn.x = 0;
        self.addBtn.y = CGRectGetMaxY(lastTagLabel.frame) + HBBPublicWordsTagMargin;
    }
    self.addBtn.height = HBBPublicWordsTagHeight;
    
    CGFloat oldH = self.height;
    self.height =CGRectGetMaxY(self.addBtn.frame) + 45;
    self.y -= self.height -oldH;
}


/**
 * a modal  出 b
 * a.presentedViewController  --->b
 * b.presentingViewController   --->a
 */

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
