//
//  HBBTagTextField.h
//  BSBDJ
//
//  Created by HopeBayBridge on 16/2/9.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBBTagTextField : UITextField

/** 按了删除键后的回调 */
@property (nonatomic,copy) void (^deleteBlock)();


@end
