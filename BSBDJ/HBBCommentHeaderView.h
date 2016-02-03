//
//  HBBCommentHeaderView.h
//  BSBDJ
//
//  Created by HopeBayBridge on 16/2/3.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBBCommentHeaderView : UITableViewHeaderFooterView

/**  文字数据 */
@property (nonatomic,copy)  NSString *title;

+ (instancetype)headerViewWithTableView:(UITableView *)tableView;
@end
