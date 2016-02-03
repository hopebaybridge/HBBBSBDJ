//
//  HBBUser.h
//  BSBDJ
//
//  Created by HopeBayBridge on 16/2/2.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HBBUser : NSObject
/**  用户名 */
@property (nonatomic,copy)  NSString *username;
/**  性别 */
@property (nonatomic,copy)  NSString *sex;
/**  头像 */
@property (nonatomic,copy)  NSString *profile_image;

@end
