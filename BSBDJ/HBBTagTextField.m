//
//  HBBTagTextField.m
//  BSBDJ
//
//  Created by HopeBayBridge on 16/2/9.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import "HBBTagTextField.h"

@implementation HBBTagTextField


/**
 *  可以监听键盘的输入      比如  “换行”
 *
 *  @param text <#text description#>
 */
//- (void)insertText:(NSString *)text{
//    [super insertText:text];
//    
//    HBBLog(@"%d",[text isEqualToString:@"\n"]);
//}



/**
 *  按键盘右下角的删除键发生的事件
 */
- (void)deleteBackward{
    
    !self.deleteBlock ? :self.deleteBlock();
    
    [super deleteBackward];
    
}

@end
