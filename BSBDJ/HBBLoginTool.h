//
//  HBBLoginTool.h
//  BSBDJ
//
//  Created by HopeBayBridge on 16/2/11.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HBBLoginTool : NSObject

- (void)setUid:(NSString *)uid;

/**
 *  获得当前登录用户的 uid  检测是否登录   NSString *: 已经登录    nil  没有登录
 *
 *  @return <#return value description#>
 */
+(NSString *)getUid;
+(NSString *)getUid:(BOOL)showLoginController;

@end
