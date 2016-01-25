//
//  HBBRecommandUser.h
//  HBBBDBDJ
//
//  Created by HopeBayBridge on 16/1/18.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HBBRecommandUser : NSObject

/**  头像 */
@property (nonatomic,copy)  NSString *header;
/** 粉丝数(有多少人关注这个用户) */
@property (nonatomic,assign) NSInteger fans_count;
/**  昵称 */
@property (nonatomic,copy)  NSString *screen_name;






@end


