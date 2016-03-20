//
//  HBBAVPlayer.m
//  BSBDJ
//
//  Created by HopeBayBridge on 16/2/12.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import "HBBAVPlayer.h"

@implementation HBBAVPlayer

+ (HBBAVPlayer *)sharedAVPlayer
{
    static HBBAVPlayer *avPlayerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        avPlayerInstance = [[self alloc] init];
    });
    return avPlayerInstance;
}

@end
