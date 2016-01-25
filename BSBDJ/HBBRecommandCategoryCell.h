//
//  HBBRecommandCategoryCell.h
//  HBBBDBDJ
//
//  Created by HopeBayBridge on 16/1/17.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HBBRecommandCategory;  // 导入模型类

@interface HBBRecommandCategoryCell : UITableViewCell
/** 类型模型*/
@property (nonatomic,strong)HBBRecommandCategory  *category;

@end
