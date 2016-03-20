//
//  HBBAVPlayer.h
//  BSBDJ
//
//  Created by HopeBayBridge on 16/2/12.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface HBBAVPlayer : AVPlayer

+ (HBBAVPlayer *)sharedAVPlayer;

@end
