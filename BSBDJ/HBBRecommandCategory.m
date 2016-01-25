//
//  HBBRecommandCategory.m
//  HBBBDBDJ
//
//  Created by HopeBayBridge on 16/1/17.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import "HBBRecommandCategory.h"

@implementation HBBRecommandCategory

- (NSMutableArray *)users{
    if(!_users){
        _users = [NSMutableArray array];
    }
    
    return _users;
}

@end
