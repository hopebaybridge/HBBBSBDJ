//
//  HBBRecommandTag.h
//  HBBBDBDJ
//
//  Created by HopeBayBridge on 16/1/21.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HBBRecommandTag : NSObject

/**  推荐名称 */
@property (nonatomic,copy)  NSString *theme_name;
/**  图片 */
@property (nonatomic,copy)  NSString *image_list;
/** 订阅数 */
@property (nonatomic,assign) NSInteger sub_number;

@end
