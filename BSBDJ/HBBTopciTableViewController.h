//
//  HBBTopciTableViewController.h
//  HBBBDBDJ
//
//  Created by HopeBayBridge on 16/1/24.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  定义帖子的类型
 */
typedef enum{
    
    HBBTopicTypeAll = 1,
    HBBTopicTypeVideo = 41,
    HBBTopicTypeVoice = 31,
    HBBTopicTypePicture = 10,
    HBBTopicTypeWord = 29
    
} HBBTopicType ;


@interface HBBTopciTableViewController : UITableViewController

/** 帖子类型 */
@property (nonatomic,assign) HBBTopicType type;


@end
