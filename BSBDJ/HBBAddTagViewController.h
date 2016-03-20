//
//  HBBAddTagViewController.h
//  BSBDJ
//
//  Created by HopeBayBridge on 16/2/9.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBBAddTagViewController : UIViewController


/**  创建添加标签的回调属性   传递所有的标签文字数组 */
@property (nonatomic,copy)  void (^tagsBlock)(NSArray *tags);


/** 接受标签*/
@property (nonatomic,strong) NSArray  *tags;


@end
