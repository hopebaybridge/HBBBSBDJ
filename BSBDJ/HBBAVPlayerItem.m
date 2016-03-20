//
//  HBBAVPlayerItem.m
//  BSBDJ
//
//  Created by HopeBayBridge on 16/2/12.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import "HBBAVPlayerItem.h"

@implementation HBBAVPlayerItem



+ (HBBAVPlayerItem *)sharedAVPlayerItem

{
    static HBBAVPlayerItem *avPlayerItemInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        avPlayerItemInstance = [[self alloc] init];
    });
    return avPlayerItemInstance;
}

@end
