//
//  HBBPlaceholderTextView.h
//  BSBDJ
//
//  Created by HopeBayBridge on 16/2/8.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBBPlaceholderTextView : UITextView

/**  占位文字 */
@property (nonatomic,copy)  NSString *placeholder;


/** 占位文字的颜色*/
@property (nonatomic,strong) UIColor  *placeholderColor;



@end
