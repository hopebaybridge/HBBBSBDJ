//
//  HBBRecommandCategory.h
//  HBBBDBDJ
//
//  Created by HopeBayBridge on 16/1/17.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//  推荐关注 左边的数据模型

#import <Foundation/Foundation.h>

@interface HBBRecommandCategory : NSObject
/** id */
@property (nonatomic,assign) NSInteger id;
/** 总数 */
@property (nonatomic,assign) NSInteger count;
/**  名字 */
@property (nonatomic,copy) NSString *name;
/** 总条数 */
@property (nonatomic,assign) NSInteger total;
/** 当前页数 */
@property (nonatomic,assign) NSInteger currentPage;



/** 指定类别对应的用户数据*/
@property (nonatomic,strong) NSMutableArray  *users;

@end
