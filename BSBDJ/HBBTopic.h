//
//  HBBTopic.h
//  HBBBDBDJ
//
//  Created by HopeBayBridge on 16/1/24.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//  段子  模型数据类

#import <Foundation/Foundation.h>

@interface HBBTopic : NSObject
/**  id */
@property (nonatomic,copy) NSString *ID;
/**  名称 */
@property (nonatomic,copy)  NSString *name;
/**  头像 */
@property (nonatomic,copy)  NSString *profile_image;
/**  发帖时间*/
@property (nonatomic,copy)  NSString *create_time;
/**  通过时间 */
@property (nonatomic,copy) NSString *passtime;

/**  文字内容 */
@property (nonatomic,copy)  NSString *text;
/** 顶的数量 */
@property (nonatomic,assign) NSInteger ding;
/** 踩的数量 */
@property (nonatomic,assign) NSInteger  cai;
/** 转发的数量 */
@property (nonatomic,assign) NSInteger repost;
/** 评论的数量 */
@property (nonatomic,assign) NSInteger  comment;
/** 图片的宽度 */
@property (nonatomic,assign) NSInteger width;
/** 图片的高度 */
@property (nonatomic,assign)NSInteger height;
/**  小图片的 URL */
@property (nonatomic,copy) NSString *small_image;
/**  中图片的 URL  */
@property (nonatomic,copy) NSString *middle_image;
/**  大图片的 URL  */
@property (nonatomic,copy) NSString *large_image;
/** 帖子的类型 */
@property (nonatomic,assign)HBBTopicType type;
/** 播放次数 */
@property (nonatomic,assign) NSInteger playcount;
/** 音频播放的时长 */
@property (nonatomic,assign) NSInteger voicetime;
/**  音频的播放地址 */
@property (nonatomic,copy)  NSString *voiceuri;
/** 视频播放的时长 */
@property (nonatomic,assign) NSInteger videotime;
/**  视频的播放地址 */
@property (nonatomic,copy) NSString *videouri;
/** 最热评论(期望这个数组中存放的是 HBBComment模型*/
@property (nonatomic,strong) NSArray  *top_cmt;






/*****************额外的辅助属性************************/
/** cell 的高度 */
@property (nonatomic,assign,readonly) CGFloat cellHeight;
/** 图片控件的 frame */
@property (nonatomic,assign,readonly)CGRect pictureViewFrame;
/** 图片是否太大 */
@property (nonatomic,assign,getter=isBigPicture)BOOL bigPicture;
/** 图片的下载进度 */
@property (nonatomic,assign) CGFloat pictureProgress;
/** 声音控件的 frame */
@property (nonatomic,assign,readonly)CGRect voiceViewFrame;
/** 视频控件的 frame */
@property (nonatomic,assign,readonly)CGRect  videoViewFrame;



@end
