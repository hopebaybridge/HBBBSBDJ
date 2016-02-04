//
//  HBBCommentTableViewCell.h
//  BSBDJ
//
//  Created by HopeBayBridge on 16/2/3.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HBBComment;

@interface HBBCommentTableViewCell : UITableViewCell

/** 评论模型*/
@property (nonatomic,strong) HBBComment  *comment;


@end
