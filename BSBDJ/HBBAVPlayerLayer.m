//
//  HBBAVPlayerLayer.m
//  BSBDJ
//
//  Created by HopeBayBridge on 16/2/12.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import "HBBAVPlayerLayer.h"

@implementation HBBAVPlayerLayer

+ (HBBAVPlayerLayer *)sharedAVPlayerLayer

{
    static HBBAVPlayerLayer *avPlayerLayerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        avPlayerLayerInstance = [[self alloc] init];
    });
    return avPlayerLayerInstance;
}

@end
